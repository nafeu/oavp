import inquirer from 'inquirer';
import inquirerAutocompletePrompt from 'inquirer-autocomplete-prompt';

import {
  readTemplateConfig,
  readTemplateSketch,
  readBaseConfigTemplateStart,
  readBaseConfigTemplateEnd,
  readConfig,
  readSketch,
  checkSketchExists,
  openWithEditor,
  getSketches,
  validateSketchNameForBuild,
  searchSketches,
  parseJsConfigToJava,
} from '../../utils/helpers';

inquirer.registerPrompt('autocomplete', inquirerAutocompletePrompt);

export async function handleBuildCommand(options) {
  const { config, sketch } = await getSketchByName(options);
  const baseConfigStart = await readBaseConfigTemplateStart();
  const baseConfigEnd = await readBaseConfigTemplateEnd();
  const finalConfig = `${baseConfigStart}\n${parseJsConfigToJava(config)}\n${baseConfigEnd}`;
  console.log(finalConfig);
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