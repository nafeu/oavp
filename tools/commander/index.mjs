import fs from "fs";
import WebSocket, { WebSocketServer } from "ws";
import express from "express";
import path from "path";
import ncpPackage from "ncp";

const { ncp } = ncpPackage;

import {
  COMMANDER_WEBSOCKET_SERVER_PORT,
  DIRECTORY_PATH,
  DUMP_FILE_PATH,
  EXPORT_FILE_DIR,
  EXPORT_FILE_NAME,
  EXPORT_IMAGE_NAME,
  FILE_COPY_TIMEOUT_DURATION,
  IMAGE_COPY_TIMEOUT_DURATION,
  OAVP_OBJECT_PROPERTIES,
  SKETCH_WEBSOCKET_SERVER_URL,
  TARGET_FILE_NAME,
  WEBSERVER_PORT,
} from "./constants.mjs";

import {
  compareFiles,
  countFiles,
  emitGeneratedSketchToServer,
  splitString,
  writeGeneratedSketchToFile,
  wsServerBroadcast,
} from "./helpers.mjs";

const app = express();

let ws;
let presetOutput = "";
let processedDiff = [];
let imageCopyTimeout;
let fileCopyTimeout;

const wsClients = new Set();

const main = () => {
  /*
    Express Web Server (GUI & API)
  */
  app.set("view engine", "ejs");
  app.use(express.json());

  app.use((req, res, next) => {
    console.log(
      `[ oavp-commander ] Received ${req.method} request at ${
        req.url
      } : ${JSON.stringify(req.body)}`,
    );
    next();
  });

  app.get("/", (req, res) => {
    res.render("index", {
      OAVP_OBJECT_PROPERTIES: JSON.stringify(OAVP_OBJECT_PROPERTIES),
    });
  });

  app.get("/api", (req, res) => {
    res.sendStatus(200);
  });

  app.post("/api/command", (req, res) => {
    const {
      command,
      // ...params
    } = req.body;

    if (command === "export") {
      writeGeneratedSketchToFile();
      res.json({
        status: "success",
        message: `Saved generated sketch to file sketch.pde`,
      });
    } else if (command === "generate") {
      const objects = emitGeneratedSketchToServer({ ws });
      res.json({
        status: "success",
        message: `Emitted generated sketch to server.`,
        data: objects,
      });
    } else if (command === "feeling-lucky") {
      const objects = emitGeneratedSketchToServer({
        ws,
        options: { isFeelingLucky: true },
      });
      res.json({
        status: "success",
        message: `Resetting previous sketch, generating a new sketch, randomize colors.`,
        data: objects,
      });
    } else if (command === "reset") {
      ws.send(JSON.stringify({ command: "reset" }));
      res.json({
        status: "success",
        message: `Removed all objects from sketch.`,
      });
    } else {
      res.json({
        status: "failure",
        message: `Unrecognized command: ${command}`,
      });
    }
  });

  app.listen(WEBSERVER_PORT, () => {
    console.log(
      `[ oavp-commander:webserver ] Webserver is running at http://localhost:${WEBSERVER_PORT}`,
    );
  });

  /*
    Sketch Socket Connection
  */
  ws = new WebSocket(SKETCH_WEBSOCKET_SERVER_URL);

  ws.on("open", () => {
    console.log(
      "[ oavp-commander:sketch-socket-connection ] WebSocket connection opened.",
    );
  });

  ws.on("close", () => {
    console.log(
      "[ oavp-commander:sketch-socket-connection ] WebSocket connection closed",
    );
  });

  ws.on("error", (error) => {
    console.error(
      `[ oavp-commander:sketch-socket-connection ] WebSocket error (make sure oavp is running): ${error}`,
    );
  });

  /*
    Commander WebSocket Server
  */
  const wsServer = new WebSocketServer({
    port: COMMANDER_WEBSOCKET_SERVER_PORT,
  });

  console.log(
    `[ oavp-commander:websocket-server ] WebSocket server is running at ws://localhost:${COMMANDER_WEBSOCKET_SERVER_PORT}`,
  );

  wsServer.on("connection", (socket) => {
    console.log("[ oavp-commander:websocket-server ] Client connected");
    wsClients.add(socket);

    socket.on("message", (message) => {
      console.log(`[ oavp-commander:websocket-server ] Received: ${message}`);
    });

    socket.on("close", () => {
      console.log("[ oavp-commander:websocket-server ] Client disconnected");
    });
  });

  /*
    Preset Builder
  */
  console.log(
    `[ oavp-commander:preset-builder ] Watching for changes to ${TARGET_FILE_NAME}`,
  );
  console.log(
    `[ oavp-commander:preset-builder ] Watching for changes to ${EXPORT_FILE_NAME}`,
  );
  console.log(
    `[ oavp-commander:preset-builder ] Dumping generated presets into to ${DUMP_FILE_PATH}`,
  );
  console.log(
    `[ oavp-commander:preset-builder ] Saving exported sketches to ${EXPORT_FILE_DIR}`,
  );
  const logStream = fs.createWriteStream(DUMP_FILE_PATH, { flags: "a" });

  fs.watch(DIRECTORY_PATH, (eventType, filename) => {
    console.log(`[ oavp-commander:watch-dir ] ${eventType} : ${filename}`);

    if (filename === TARGET_FILE_NAME) {
      presetOutput = "";
      processedDiff = [];

      compareFiles().forEach((line) => {
        processedDiff = [...processedDiff, ...splitString(line)];
      });

      processedDiff.forEach((line) => {
        const isAddition = line.includes(".add(");

        if (isAddition) {
          const objectName = line.match(/\.add\("[^"]+","([^"]+)"\)/)[1];

          presetOutput = `${objectName}|`;
        } else {
          const regex = /\.set\("([^"]+)",\s*([^)]+)\)/g;

          let match;

          while ((match = regex.exec(line)) !== null) {
            const property = match[1].trim();
            const value = match[2].trim().replace(/["']/g, "");
            presetOutput += `${property}:${value};`;
          }
        }
      });

      console.log(`[ oavp-commander ] Added preset: ${presetOutput}`);
      wsServerBroadcast({
        message: JSON.stringify({
          command: "preset-builder-result",
          data: presetOutput,
        }),
        wsClients,
      });
      logStream.write(`\n${presetOutput}`);
    }

    if (filename === EXPORT_FILE_NAME) {
      if (fileCopyTimeout) {
        clearTimeout(fileCopyTimeout);
      }

      fileCopyTimeout = setTimeout(() => {
        const newFileName = `${
          countFiles(path.resolve(EXPORT_FILE_DIR), "_sketch.txt") + 1
        }_sketch.txt`;
        const destinationFilePath = path.join(EXPORT_FILE_DIR, newFileName);

        ncp(EXPORT_FILE_NAME, destinationFilePath, function (err) {
          if (err) {
            console.error(
              `[ oavp-commander:file-copy ] Error writing to the destination file: ${err}`,
            );
          }
          console.log(
            `[ oavp-commander:file-copy ] File copied successfully to ${destinationFilePath}`,
          );
        });

        fileCopyTimeout = null;
      }, FILE_COPY_TIMEOUT_DURATION);
    }

    if (filename === EXPORT_IMAGE_NAME) {
      if (imageCopyTimeout) {
        clearTimeout(imageCopyTimeout);
      }

      imageCopyTimeout = setTimeout(() => {
        const newFileName = `${
          countFiles(path.resolve(EXPORT_FILE_DIR), "_sketch.png") + 1
        }_sketch.png`;
        const destinationFilePath = path.join(EXPORT_FILE_DIR, newFileName);

        ncp(EXPORT_IMAGE_NAME, destinationFilePath, function (err) {
          if (err) {
            console.error(
              `[ oavp-commander:image-copy ] Error writing to the destination file: ${err}`,
            );
          }
          console.log(
            `[ oavp-commander:image-copy ] Image copied successfully to ${destinationFilePath}`,
          );
        });

        imageCopyTimeout = null;
      }, IMAGE_COPY_TIMEOUT_DURATION);
    }
  });
};

main();
