import path from "path";
import ncpPackage from "ncp";

const { ncp } = ncpPackage;

import {
  EXPORT_FILE_DIR,
  EXPORT_FILE_NAME,
  EXPORT_IMAGE_NAME,
  FILE_COPY_TIMEOUT_DURATION,
  IMAGE_COPY_TIMEOUT_DURATION,
} from '../../constants.mjs';

import {
  wsServerBroadcast,
  compareFiles,
  splitString,
  countFiles
} from '../../helpers.mjs';

let presetOutput = "";
let processedDiff = [];
let imageCopyTimeout;
let fileCopyTimeout;

export const handlePresetEvent = ({ wsClients, logStream }) => {
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

  console.log(`[ oavp-commander:preset-event ] Added preset: ${presetOutput}`);
  wsServerBroadcast({
    message: JSON.stringify({
      command: "preset-builder-result",
      data: presetOutput,
    }),
    wsClients,
  });
  logStream.write(`\n${presetOutput}`);
};

export const handleExportFileEvent = () => {
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
};

export const handleExportImageEvent = () => {
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
};
