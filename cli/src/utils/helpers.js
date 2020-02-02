import inquirer from 'inquirer';
import { promises as fs, existsSync, mkdirSync, writeFileSync } from 'fs';
import {
  TEMPLATES_PATH,
  SKETCHES_PATH,
  SRC_PATH,
  PRESETS_PATH
} from '../config';
import execa from 'execa';
import fuzzy from 'fuzzy';
import _ from 'lodash';

import {
  DISPLAY_SETTINGS_PATTERN,
  DISPLAY_SETTINGS_MAPPING,
  CODE_SETUP_PATTERN,
  CODE_UPDATE_PATTERN,
  CODE_DRAW_PATTERN,
  CODE_KEY_PATTERN,
} from './constants';

export async function readTemplateConfig(template) {
  try {
    return(await fs.readFile(`${TEMPLATES_PATH}/${template}/config.oavp`, 'utf8'));
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
}

export async function readTemplateSketch(template) {
  try {
    return(await fs.readFile(`${TEMPLATES_PATH}/${template}/sketch.oavp`, 'utf8'));
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
}

export async function readOavpSrc(template) {
  try {
    return(await fs.readFile(`${SRC_PATH}/src.pde`, 'utf8'));
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
}

export async function readSketch(sketch) {
  try {
    return(await fs.readFile(`${SKETCHES_PATH}/${sketch}/sketch.oavp`, 'utf8'));
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
}

export async function readPreset(preset) {
  try {
    const data = await fs.readFile(`${PRESETS_PATH}/${preset}.oavp`, 'utf8');
    return {
      preset: data.split('---')[0],
      defaults: parsePresetDefaults(data.split('---')[1]),
      presetName: preset
    };
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
}

export async function readConfig(sketch) {
  try {
    return(JSON.parse(await fs.readFile(`${SKETCHES_PATH}/${sketch}/config.oavp`, 'utf8')));
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
}

export async function readBaseConfigTemplateStart(sketch) {
  try {
    return(await fs.readFile(`${TEMPLATES_PATH}/config-start.txt`, 'utf8'));
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
}

export async function readBaseConfigTemplateEnd(sketch) {
  try {
    return(await fs.readFile(`${TEMPLATES_PATH}/config-end.txt`, 'utf8'));
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
}

export async function getTemplates() {
  try {
    return(_.filter(await fs.readdir(`${TEMPLATES_PATH}/`), template => !_.includes(template, '.txt')));
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
}

export async function getSketches() {
  try {
    return(await fs.readdir(`${SKETCHES_PATH}/`));
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
}

export async function getPresets() {
  try {
    return(_.map(await fs.readdir(`${PRESETS_PATH}/`), item => item.split('.')[0]));
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
}

export function validateSketchName(name) {
  if (name.length < 1) {
    return 'Sketch name cannot be empty.';
  }
  if (existsSync(`${SKETCHES_PATH}/${name}`)) {
    return `A sketch with the name '${name}' already exists.`;
  }
  return true;
}

export function validateSketchNameForBuild(name) {
  if (name.length < 1) {
    return 'Sketch name cannot be empty.';
  }
  if (!existsSync(`${SKETCHES_PATH}/${name}`)) {
    return `A sketch with the name '${name}' does not exist.`;
  }
  return true;
}

export function validatePresetNameForUse(name) {
  if (name.length < 1) {
    return 'Preset name cannot be empty.';
  }
  if (!existsSync(`${PRESETS_PATH}/${name}.oavp`)) {
    return `A preset with the name '${name}' does not exist.`;
  }
  return true;
}

export function checkSketchExists(name) {
  if (existsSync(`${SKETCHES_PATH}/${name}`)) {
    return true;
  }
  return false;
}

export function checkPresetExists(name) {
  if (existsSync(`${PRESETS_PATH}/${name}.oavp`)) {
    return true;
  }
  return false;
}

export function createSketch({ name, config, sketch }) {
  const path = `${SKETCHES_PATH}/${name}`;
  mkdirSync(path);
  writeFileSync(`${path}/sketch.oavp`, sketch);
  writeFileSync(`${path}/config.oavp`, config);
  return path;
}

export async function openWithEditor(path) {
  try {
    const { stdout } = execa('subl', [path]);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
}

export function getPathToSketch(name) {
  return `${SKETCHES_PATH}/${name}`;
}

export function getPathToPreset(name) {
  return `${PRESETS_PATH}/${name}`;
}

export function searchSketches(answers, input) {
  input = input || '';
  return new Promise(async (resolve) => {
    const sketches = await getSketches();
    const fuzzyResult = fuzzy.filter(input, sketches);
    resolve(fuzzyResult.map(item => item.original));
  });
}

export function searchPresets(answers, input) {
  input = input || '';
  return new Promise(async (resolve) => {
    const presets = await getPresets();
    const fuzzyResult = fuzzy.filter(input, presets);
    resolve(fuzzyResult.map(item => item.original));
  });
}

export function parseJsConfigToJava(config) {
  const javaConfigItems = _.map(_.keys(config), key => {
    return getJavaDeclaration(key, config[key]);
  });
  return javaConfigItems.join('\n');
}

export function parsePresetDefaults(defaults) {
  return defaults;
}

export function getJavaDeclaration(name, value) {
  if (typeof value === 'boolean') {
    return `public boolean ${name} = ${value};`;
  } else if (String(value) === value) {
    return `public String ${name} = "${value}";`;
  } else if (isFloat(value) || _.includes(String(value), '.')) {
    return `public float ${name} = ${value};`;
  } else {
    return `public int ${name} = ${value};`;
  }
}

export function writeToOavpConfigFile(content) {
  writeFileSync(`${SRC_PATH}/config.pde`, content, {
    encoding: 'utf8',
    flag: 'w'
  });
}

export function writeToOavpSrcFile(content) {
  writeFileSync(`${SRC_PATH}/src.pde`, content, {
    encoding: 'utf8',
    flag: 'w'
  });
}

export function writeToOavpSketchFile(content) {
  writeFileSync(`${SRC_PATH}/sketch.pde`, content, {
    encoding: 'utf8',
    flag: 'w'
  });
}

export function writeToOavpSketch(sketch, content) {
  writeFileSync(`${SKETCHES_PATH}/${sketch}/sketch.oavp`, content, {
    encoding: 'utf8',
    flag: 'w'
  });
}

export async function getUpdatedJavaSrc(config) {
  const src = await readOavpSrc();
  return src.replace(DISPLAY_SETTINGS_PATTERN, getJavaDisplaySettings(config));
}

export async function getUpdatedJavaConfig(config) {
  const baseConfigStart = await readBaseConfigTemplateStart();
  const baseConfigEnd = await readBaseConfigTemplateEnd();
  return `${baseConfigStart}\n${parseJsConfigToJava(config)}\n${baseConfigEnd}`;
}

export function getJavaDisplaySettings({ DISPLAY_SETTINGS }) {
  return `DISPLAY_SETTINGS_START\n  ${DISPLAY_SETTINGS_MAPPING[DISPLAY_SETTINGS] ? DISPLAY_SETTINGS_MAPPING[DISPLAY_SETTINGS] : 'fullScreen(P3D, 1);'}\n  // DISPLAY_SETTINGS_END`;
}

export async function confirm(question, defaultValue) {
  const { confirmation } = await inquirer.prompt({
    type: 'confirm',
    name: 'confirmation',
    message: question,
    default: defaultValue,
  });
  return confirmation;
}

function isInt(n){
    return Number(n) === n && n % 1 === 0;
}

function isFloat(n){
    return Number(n) === n && n % 1 !== 0;
}

export function getFileSetupCode(text) {
  const results = new RegExp(CODE_SETUP_PATTERN).exec(text);
  return removeFirstAndLastChar(results ? results[1] : '');
}

export function getFileUpdateCode(text) {
  const results = new RegExp(CODE_UPDATE_PATTERN).exec(text);
  return removeFirstAndLastChar(results ? results[1] : '');
}

export function getFileDrawCode(text) {
  const results = new RegExp(CODE_DRAW_PATTERN).exec(text);
  return removeFirstAndLastChar(results ? results[1] : '');
}

export function getFileKeyCode(text) {
  const results = new RegExp(CODE_KEY_PATTERN).exec(text);
  return removeFirstAndLastChar(results ? results[1] : '');
}

export function removeLinebreaks(text) {
  return text.replace(/(\r\n|\n|\r)/gm, "");
}

export function removeFirstAndLastChar(text) {
  return text.length > 2 ? text.substring(1, text.length - 1) : '';
}

export function getDefaultsMapping(defaults) {
  const out = {};
  const delimiter = ': ';
  _.each(_.filter(defaults.split('\n'), item => item.length > 0), item => {
    const name = item.split(delimiter)[0];
    out[name] = item.substr(name.length + delimiter.length, item.length);
  });
  return out;
}

export async function getPresetByName(options) {
  if (options.preset && !checkPresetExists(options.preset)) {
    console.log(`[ oavp ] The preset '${options.preset}' does not exist.`)
  }

  if (!options.preset || !checkPresetExists(options.preset)) {
    const answers = await inquirer
      .prompt([
        {
          type: 'autocomplete',
          name: 'preset',
          suggestOnly: true,
          message: 'Select a preset to use:',
          source: searchPresets,
          pageSize: 4,
          validate: validatePresetNameForUse,
        }
      ]);
      return await readPreset(answers.preset);
  }

  return await readPreset(options.preset);
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
          name: 'sketch',
          suggestOnly: true,
          message: 'Select a sketch to build:',
          source: searchSketches,
          pageSize: 4,
          validate: validateSketchNameForBuild,
        }
      ]);
      return {
        sketch: await readSketch(answers.sketch),
        config: await readConfig(answers.sketch),
        sketchName: answers.sketch,
      };
  }

  return {
    sketch: await readSketch(options.sketch),
    config: await readConfig(options.sketch),
    sketchName: options.sketch,
  };
}

export function combineCodeBlocks({ main, append }) {
  return `\n${main}\n${append}\n`;
}

export function constructCodeBlock({ blockStart, content, blockEnd }) {
  return `${blockStart}${content}${blockEnd}`;
}

export function updateProcessedSketch({ original, results, content, blockStart, blockEnd }) {
  if (results[1] && results[1].trim().length > 0) {
    return original.replace(results[1], content);
  } else {
    return original.replace(results[0], constructCodeBlock({
      blockStart,
      content,
      blockEnd
    }));
  }
}