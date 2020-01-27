import inquirer from 'inquirer';
import inquirerAutocompletePrompt from 'inquirer-autocomplete-prompt';
import execa from 'execa';

import {
  readConfig,
  readSketch,
  checkSketchExists,
  validateSketchNameForBuild,
  searchSketches,
  writeToOavpConfigFile,
  writeToOavpSrcFile,
  writeToOavpSketchFile,
  getUpdatedJavaSrc,
  getUpdatedJavaConfig,
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

export async function getSketchByName(options) {
  if (options.sketch && !checkSketchExists(options.sketch)) {
    console.log(`[ oavp ] The sketch name '${options.sketch}' does not exist.`)
  }

  if (!options.sketch || !checkSketchExists(options.sketch)) {
    const answers = await inquirer
      .prompt([
        {
          type: 'autocomplete',
          name: 'name',
          suggestOnly: true,
          message: 'Select a sketch to build:',
          source: searchSketches,
          pageSize: 4,
          validate: validateSketchNameForBuild,
        }
      ]);
      return {
        sketch: await readSketch(answers.name),
        config: await readConfig(answers.name),
      };
  }

  return {
    sketch: await readSketch(options.name),
    config: await readConfig(options.name),
  };
}