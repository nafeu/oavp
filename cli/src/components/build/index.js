import inquirer from 'inquirer';
import inquirerAutocompletePrompt from 'inquirer-autocomplete-prompt';
import execa from 'execa';

import {
  writeToOavpConfigFile,
  writeToOavpSrcFile,
  writeToOavpSketchFile,
  getUpdatedJavaSrc,
  getUpdatedJavaConfig,
  getSketchByName,
} from '../../utils/helpers';

import { SRC_PATH } from '../../config';

inquirer.registerPrompt('autocomplete', inquirerAutocompletePrompt);

export async function handleBuildCommand(options) {
  const { config, sketch } = await getSketchByName(options);
  const updatedJavaConfig = await getUpdatedJavaConfig(config);
  const updatedJavaSrc = await getUpdatedJavaSrc(config);
  writeToOavpConfigFile(updatedJavaConfig);
  writeToOavpSketchFile(sketch);
  writeToOavpSrcFile(updatedJavaSrc);
  console.log(`[ oavp ] Building sketch...`);
  execa('processing-java', [`--sketch=${SRC_PATH}`, '--force', '--run']).stdout.pipe(process.stdout);
}
