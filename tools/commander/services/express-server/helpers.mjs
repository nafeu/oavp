import fs from "fs";

import { EXPORT_FILE_DIR } from "../../constants.mjs";

export const getExportFilenames = async () => {
  const files = await fs.promises.readdir(EXPORT_FILE_DIR);

  const uniqueFileNames = new Set();
  files.forEach((file) => {
    const fileNameWithoutExtension = file.substring(0, file.lastIndexOf("."));
    uniqueFileNames.add(fileNameWithoutExtension);
  });

  return [...uniqueFileNames].filter((name) => name !== "");
};
