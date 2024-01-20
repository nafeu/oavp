import express from "express";

import {
  OAVP_OBJECT_PROPERTIES,
  WEBSERVER_PORT,
} from '../../constants.mjs';

import {
  emitGeneratedSketchToServer,
  writeGeneratedSketchToFile
} from '../../helpers.mjs';

const app = express();

const setupExpressServer = ws => {
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
}

export default setupExpressServer;
