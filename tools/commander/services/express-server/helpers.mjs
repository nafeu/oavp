import fs from "fs/promises";

import { EXPORT_FILE_DIR } from "../../constants.mjs";
import { buildSketchDataObject } from '../filewatch-event-handlers/helpers.mjs';

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

    async function buildSketchDataObjectsFromFile({ filename, filepath }) {
      try {
        const data = await fs.readFile(filepath, 'utf8');
        sketchDataObjects[filename] = buildSketchDataObject({ sketchFileContent: data });
      } catch (err) {
        console.error(`Error reading ${filepath}:`, err);
      }
    }

    await Promise.all(
      filenames.map(
        (filename) => buildSketchDataObjectsFromFile({
          filename,
          filepath: `../../exports/${filename}.txt`
        })
      )
    );

    return sketchDataObjects;
  }

  try {
    const sketchDataObjects = await readFilesToObject(exportFilenames);

    return { exportFilenames, sketchDataObjects };
  } catch (error) {
    console.error('Error:', error);
  }
};
