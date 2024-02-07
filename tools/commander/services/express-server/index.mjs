import express from "express";
import path from "path";
import { fileURLToPath } from "url";
import fs from 'fs/promises';

import { getSketchDataObjects } from "./helpers.mjs";
import { generateName } from "../name-generator/index.mjs";
import { getNamesByColorPalette } from "../color-palette-info/index.mjs";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

import { OAVP_OBJECT_PROPERTIES, WEBSERVER_PORT } from "../../constants.mjs";

import {
  emitGeneratedSketchToServer,
  writeGeneratedSketchToFile,
  loadSketchDataObjectToServer,
  reseedSketchOnServer,
} from "../../helpers.mjs";

const app = express();

const setupExpressServer = ws => {
  app.set("view engine", "ejs");
  app.use(express.json());
  app.use(express.static(path.join(__dirname, "../../public")));
  app.use(express.static(path.join(__dirname, "../../../../exports")));
  app.set("views", path.join(__dirname, "../../views"));

  app.locals.OAVP_OBJECT_PROPERTIES = JSON.stringify(OAVP_OBJECT_PROPERTIES);
  app.locals.SKETCH_DATA_OBJECTS = {};

  app.use((req, res, next) => {
    console.log(
      `[ oavp-commander ] Received ${req.method} request at ${
        req.url
      } : ${JSON.stringify(req.body).length}`,
    );
    next();
  });

  app.get("/", (req, res) => res.render("controls"));
  app.get("/viewer", async (req, res) => {
    try {
      app.locals.SKETCH_DATA_OBJECTS = (await getSketchDataObjects());
    } catch (err) {
      console.error(err);

      console.log(
        `[ oavp-commander:express-server ] Error getting export filenames...`,
      );
    }

    res.render("viewer");
  });

  app.get("/api", (req, res) => {
    res.sendStatus(200);
  });

  app.post("/api/command", (req, res) => {
    const {
      command,
      ...params
    } = req.body;

    if (command === "export") {
      writeGeneratedSketchToFile();
      res.json({
        status: "success",
        message: `Saved generated sketch to file sketch.pde`,
      });
    }

    else if (command === "generate") {
      const objects = emitGeneratedSketchToServer({ ws });
      res.json({
        status: "success",
        message: `Emitted generated sketch to server.`,
        data: objects,
      });
    }

    else if (command === "feeling-lucky") {
      const objects = emitGeneratedSketchToServer({
        ws,
        options: { isFeelingLucky: true },
      });
      res.json({
        status: "success",
        message: `Resetting previous sketch, generating a new sketch, randomize colors.`,
        data: objects,
      });
    }

    else if (command === "load") {
      const loadedSketch = loadSketchDataObjectToServer({ ws, sketchDataObject: params.sketchDataObject });
      res.json({
        status: "success",
        message: `Resetting previous sketch, loading sketchDataObject.`,
        data: loadedSketch,
      });
    }

    else if (command === "reseed") {
      const reseedObjects = reseedSketchOnServer({ ws, sketchDataObject: params.sketchDataObject });
      res.json({
        status: "success",
        message: `Re-seeded generated objects in active sketch.`,
        data: reseedObjects,
      });
    }

    else if (command === "reset") {
      ws.send(JSON.stringify({ command: "reset" }));
      res.json({
        status: "success",
        message: `Removed all objects from sketch.`,
      });
    }

    else {
      res.json({
        status: "failure",
        message: `Unrecognized command: ${command}`,
      });
    }
  });

  app.get("/api/name", (req, res) => {
    res.json({ name: generateName() })
  });

  app.post("/api/colors", (req, res) => {
    const { colors } = req.body;

    res.json({ colorNames: getNamesByColorPalette(colors) });
  });

  app.post("/api/save-sketch", async (req, res) => {
    const { filename, sketchDataObject } = req.body;

    try {
      await fs.writeFile(`../../exports/${filename}.json`, JSON.stringify(sketchDataObject, null, 2), 'utf-8');

      res.json({ message: `Saved ../../exports/${filename}.json successfully` });
    } catch (err) {
      console.error(err);

      res.json({ error: err });
    }
  })

  app.listen(WEBSERVER_PORT, () => {
    console.log(
      `[ oavp-commander:webserver ] Webserver is running at http://localhost:${WEBSERVER_PORT}`,
    );
  });
};

export default setupExpressServer;
