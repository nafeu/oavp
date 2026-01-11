import express from "express";
import path from "path";
import { fileURLToPath } from "url";
import fs from 'fs/promises';
import { spawn } from 'child_process';

import { getSketchDataObjects } from "./helpers.mjs";
import { generateName, getFormattedSketchName } from "../name-generator/index.mjs";
import { getNamesByColorPalette } from "../color-palette-info/index.mjs";
import { getPrintSizeOptions } from "../print-size-info/index.mjs";
import { generateTimelapse } from '../editor-sequence-generator/index.mjs';
import { getConceptMapMeta } from '../concept-maps/index.mjs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

import { OAVP_OBJECT_PROPERTIES, WEBSERVER_PORT } from "../../constants.mjs";

import {
  emitGeneratedSketchToServer,
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
  app.locals.CONCEPT_MAP_META = getConceptMapMeta();

  app.use((req, res, next) => {
    console.log(
      `[ oavp-commander ] Received ${req.method} request at ${req.url
      } : ${JSON.stringify(req.body).length}`,
    );
    next();
  });

  app.get("/", (req, res) => res.render("controls", { query: req.query }));
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
  app.get("/prefab-editor", (req, res) => res.render("prefab-editor"));

  app.get("/api", (req, res) => {
    res.sendStatus(200);
  });

  app.post("/api/command", (req, res) => {
    const {
      command,
      ...params
    } = req.body;

    if (command === "refresh") {
      const objects = emitGeneratedSketchToServer({
        ws,
        options: { conceptMaps: params.conceptMaps || [] }
      });

      res.json({
        status: "success",
        message: `Emitted generated sketch to server.`,
        data: objects,
      });
    }

    else if (command === "regenerate") {
      const objects = emitGeneratedSketchToServer({
        ws,
        options: {
          isFeelingLucky: true,
          conceptMaps: params.conceptMaps || []
        },
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

  app.get("/api/preset-dump", async (req, res) => {
    try {
      const presetDumpPath = path.join(__dirname, "../../preset-dump.txt");
      const content = await fs.readFile(presetDumpPath, 'utf-8');
      res.json({ content });
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Failed to read preset-dump.txt' });
    }
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

  app.post("/api/package", async (req, res) => {
    const { sketchDataObject, exportId } = req.body;

    console.log(`[ oavp-commander:package ] Generating timelapse code...`);
    const timelapse = generateTimelapse(sketchDataObject);

    console.log(`[ oavp-commander:package ] Overwriting src/sketch.pde...`);
    await fs.writeFile(`../../src/sketch.pde`, timelapse);

    // res.json({ 'success': 'early short' }); return;

    console.log(`[ oavp-commander:package ] Exporting social.txt for ${sketchDataObject.id}...`);
    await fs.writeFile(`../../package-export-files/${sketchDataObject.id}_social.txt`, sketchDataObject.socialMediaTextContent);


    const child = spawn('bash', [
      './package.sh',
      sketchDataObject.id,
      exportId,
      getFormattedSketchName(sketchDataObject),
      ...getPrintSizeOptions(sketchDataObject)
    ]);

    child.stdout.on('data', (data) => {
      console.log(data.toString());
    });

    child.stderr.on('data', (data) => {
      console.log(data.toString());
    });

    child.on('error', (error) => {
      console.error(`[ oavp-commander:package ] Failed to run package.sh: ${error}`);
      res.status(500).json({ message: 'Failed to run package.sh.' });
    });

    child.on('close', (code) => {
      console.log(`[ oavp-commander:package ] Package creation concluded.`);
      if (code === 0) {
        res.json({ message: 'package.sh script executed successfully.' });
      } else {
        res.status(500).json({ message: 'package.sh script execution failed.' });
      }
    });
  })

  const server = app.listen(WEBSERVER_PORT, () => {
    console.log(
      `[ oavp-commander:webserver ] Webserver is running at http://localhost:${WEBSERVER_PORT}`,
    );
  });

  server.setTimeout(900000);
};

export default setupExpressServer;
