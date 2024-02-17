import fs from "fs/promises";
import { exec } from "child_process";

import { EXPORT_FILE_DIR } from "../../constants.mjs";
import { buildSketchDataObject } from '../filewatch-event-handlers/helpers.mjs';

async function fileExists(filePath) {
  try {
    await fs.access(filePath, fs.constants.F_OK);
    return true; // File exists
  } catch (error) {
    if (error.code === 'ENOENT') {
      return false; // File does not exist
    } else {
      throw error; // Other errors are propagated
    }
  }
}

export const getSketchDataObjects = async () => {
  const files = await fs.readdir(EXPORT_FILE_DIR);

  const uniqueFileNames = new Set();
  files.forEach((file) => {
    const fileNameWithoutExtension = file.substring(0, file.lastIndexOf("."));
    uniqueFileNames.add(fileNameWithoutExtension);
  });

  const exportFilenames = [...uniqueFileNames].filter((name) => name !== "");

  async function readFilesToObject(filenames) {
    const sketchDataObjects = {};

    async function buildSketchDataObjectsFromFile({ filename, textFilePath, jsonFilePath }) {
      try {
        const jsonExists = await fileExists(jsonFilePath)

        if (jsonExists) {
          console.log(`[ oavp-commader:load-sketch-data-objects ] loading ${filename}.json`);
          const jsonContent = await fs.readFile(jsonFilePath, 'utf-8');
          const jsonData = JSON.parse(jsonContent);

          sketchDataObjects[filename] = jsonData;
        } else {
          console.log(`[ oavp-commader:load-sketch-data-objects ] ${filename}.json does not exist, constructing...`);
          const data = await fs.readFile(textFilePath, 'utf8');
          const jsonData = buildSketchDataObject(data);
          sketchDataObjects[filename] = jsonData;

          await fs.writeFile(jsonFilePath, JSON.stringify(jsonData), 'utf-8');
        }

        // TODO: Continue ~ add "save" button in viewer which will save changes to the appropriate sketchDataObject, it should just be in #_sketch.json
      } catch (err) {
        console.error(`[ oavp-commander:express-server ] Error building sketchDataObjects`, err);
      }
    }

    await Promise.all(
      filenames.map(
        (filename) => buildSketchDataObjectsFromFile({
          filename,
          textFilePath: `../../exports/${filename}.txt`,
          jsonFilePath: `../../exports/${filename}.json`
        })
      )
    );

    return sketchDataObjects;
  }

  try {
    const sketchDataObjects = await readFilesToObject(exportFilenames);

    return sketchDataObjects;
  } catch (error) {
    console.error('[ oavp-commander:express-server ] Error:', error);
  }

  return {}
};

export const runCommand = command => {
  return new Promise((resolve, reject) => {
    exec(command, (error, stdout, stderr) => {
      if (error) {
        console.error(`[ oavp:run-command ] error: ${error.message}`);
        reject('error');
        return;
      }
      if (stderr) {
        console.error(`[ oavp:run-command ] stderr: ${stderr}`);
        reject('error');
        return;
      }
      console.log(`[ oavp:run-command ] stdout: ${stdout}`);
      resolve(stdout);
    });
  });
}
