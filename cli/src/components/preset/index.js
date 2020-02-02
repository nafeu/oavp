import inquirer from 'inquirer';
import inquirerAutocompletePrompt from 'inquirer-autocomplete-prompt';
import execa from 'execa';
import _ from 'lodash';
import { capitalCase } from 'change-case';

import {
  writeToOavpSketch,
  getUpdatedJavaSrc,
  getUpdatedJavaConfig,
  getFileSetupCode,
  getFileDrawCode,
  getFileUpdateCode,
  getFileKeyCode,
  getDefaultsMapping,
  getPresetByName,
  getSketchByName,
  combineCodeBlocks,
  constructCodeBlock,
  updateProcessedSketch,
} from '../../utils/helpers';

import {
  CODE_SETUP_PATTERN,
  CODE_UPDATE_PATTERN,
  CODE_DRAW_PATTERN,
  CODE_KEY_PATTERN,
} from '../../utils/constants';

import {
  TEMPLATE_PATTERN
} from '../../utils/constants';

inquirer.registerPrompt('autocomplete', inquirerAutocompletePrompt);

export async function handlePresetCommand(options) {
  const { sketch, sketchName } = await getSketchByName(options);
  const { defaults, preset, presetName } = await getPresetByName(options);

  let defaultsMapping = {};
  let presetAnswers = {};
  let presetVariables;

  if (defaults) {
    defaultsMapping = getDefaultsMapping(defaults);
  }

  if (options.useDefaults) {
    presetAnswers = defaultsMapping;
  } else {
    presetVariables = _.uniq(_.map(preset.match(TEMPLATE_PATTERN), item => _.trim(item, '%')));

    const { useDefaults } = await inquirer.prompt({
      type: 'confirm',
      name: 'useDefaults',
      message: 'Use default preset values?',
      default: true
    });

    if (useDefaults) {
      presetAnswers = defaultsMapping;
    } else {
      const presetQuestions = [];

      _.forEach(presetVariables, item => {
        presetQuestions.push({
          type: 'input',
          name: item,
          message: `Enter ${capitalCase(item)}:`,
          default: defaultsMapping[item] ? defaultsMapping[item] : capitalCase(item),
        });
      });

      presetAnswers = await inquirer.prompt(presetQuestions);
    }
  }

  let processedPreset = preset;

  _.forEach(presetVariables, item => {
    processedPreset = processedPreset.replace(
      new RegExp(`%${item}%`, 'g'),
      presetAnswers[item]
    );
  });

  const appendedPresetSetupCode = combineCodeBlocks({
    main: getFileSetupCode(sketch),
    append: getFileSetupCode(processedPreset),
  });

  const appendedPresetUpdateCode = combineCodeBlocks({
    main: getFileUpdateCode(sketch),
    append: getFileUpdateCode(processedPreset),
  });

  const appendedPresetDrawCode = combineCodeBlocks({
    main: getFileDrawCode(sketch),
    append: getFileDrawCode(processedPreset),
  });

  const appendedPresetKeyCode = combineCodeBlocks({
    main: getFileKeyCode(sketch),
    append: getFileKeyCode(processedPreset),
  });

  let processedSketch = sketch;

  processedSketch = updateProcessedSketch({
    original: processedSketch,
    results: new RegExp(CODE_SETUP_PATTERN).exec(sketch),
    content: appendedPresetSetupCode,
    blockStart: 'void setupSketch() {',
    blockEnd: '} /*--SETUP--*/'
  });

  processedSketch = updateProcessedSketch({
    original: processedSketch,
    results: new RegExp(CODE_UPDATE_PATTERN).exec(sketch),
    content: appendedPresetUpdateCode,
    blockStart: 'void updateSketch() {',
    blockEnd: '} /*--UPDATE--*/'
  });

  processedSketch = updateProcessedSketch({
    original: processedSketch,
    results: new RegExp(CODE_DRAW_PATTERN).exec(sketch),
    content: appendedPresetDrawCode,
    blockStart: 'void drawSketch() {',
    blockEnd: '} /*--DRAW--*/'
  });

  processedSketch = updateProcessedSketch({
    original: processedSketch,
    results: new RegExp(CODE_KEY_PATTERN).exec(sketch),
    content: appendedPresetKeyCode,
    blockStart: 'void keyPressed() {',
    blockEnd: '} /*--KEY--*/'
  });

  writeToOavpSketch(sketchName, processedSketch);
  console.log(`[ oavp ] Added preset '${presetName}' to sketch '${sketchName}'`);
}

