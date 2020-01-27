import inquirer from 'inquirer';
import inquirerAutocompletePrompt from 'inquirer-autocomplete-prompt';
import execa from 'execa';

import {
  checkSketchExists,
  validateSketchNameForBuild,
  searchSketches,
  openWithEditor,
  getPathToSketch,
} from '../../utils/helpers';

import { SRC_PATH } from '../../config';

inquirer.registerPrompt('autocomplete', inquirerAutocompletePrompt);

export async function handleOpenCommand(options) {
  await openSketchByName(options);
}

export async function openSketchByName(options) {
  if (options.sketch && !checkSketchExists(options.sketch)) {
    console.log(`[ oavp ] The sketch name '${options.sketch}' does not exist.`);
  }

  if (!options.sketch || !checkSketchExists(options.sketch)) {
    const answers = await inquirer
      .prompt([
        {
          type: 'autocomplete',
          name: 'sketch',
          suggestOnly: true,
          message: 'Select a sketch to open:',
          source: searchSketches,
          pageSize: 4,
          validate: validateSketchNameForBuild,
        }
      ]);
      return(await openWithEditor(getPathToSketch(answers.sketch)));
  }

  return(await openWithEditor(getPathToSketch(options.sketch)));
}