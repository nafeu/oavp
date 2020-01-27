import inquirer from 'inquirer';
import { promises as fs, existsSync, mkdirSync, writeFileSync } from 'fs';
import {
  TEMPLATES_PATH,
  SKETCHES_PATH,
  SRC_PATH,
} from '../config';
import execa from 'execa';
import fuzzy from 'fuzzy';
import _ from 'lodash';

const DISPLAY_SETTINGS_PATTERN = /(DISPLAY_SETTINGS_START[\s\S]+DISPLAY_SETTINGS_END)/g;
const DISPLAY_SETTINGS_MAPPING = {
  'fullscreen': 'fullScreen(P3D, 1);',
  'default': 'size(750, 750, P3D);',
  'instagram': 'size(810, 1440, P3D);'
}

export async function readTemplateConfig(template) {
  try {
    return(await fs.readFile(`${TEMPLATES_PATH}/${template}/config.oavp`, 'utf8'));
  } catch (err) {
    console.log(err.message);
    process.exit(1);
  }
}

export async function readTemplateSketch(template) {
  try {
    return(await fs.readFile(`${TEMPLATES_PATH}/${template}/sketch.oavp`, 'utf8'));
  } catch (err) {
    console.log(err.message);
    process.exit(1);
  }
}

export async function readOavpSrc(template) {
  try {
    return(await fs.readFile(`${SRC_PATH}/src.pde`, 'utf8'));
  } catch (err) {
    console.log(err.message);
    process.exit(1);
  }
}

export async function readSketch(sketch) {
  try {
    return(await fs.readFile(`${SKETCHES_PATH}/${sketch}/sketch.oavp`, 'utf8'));
  } catch (err) {
    console.log(err.message);
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
    console.log(err.message);
    process.exit(1);
  }
}

export async function getSketches() {
  try {
    return(await fs.readdir(`${SKETCHES_PATH}/`));
  } catch (err) {
    console.log(err.message);
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

export function checkSketchExists(name) {
  if (existsSync(`${SKETCHES_PATH}/${name}`)) {
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
    console.log(err.message);
    process.exit(1);
  }
}

export function getPathToSketch(name) {
  return `${SKETCHES_PATH}/${name}`;
}

export function searchSketches(answers, input) {
  input = input || '';
  return new Promise(async (resolve) => {
    const sketches = await getSketches();
    const fuzzyResult = fuzzy.filter(input, sketches);
    resolve(fuzzyResult.map(item => item.original));
  });
}

export function parseJsConfigToJava(config) {
  const javaConfigItems = _.map(_.keys(config), key => {
    return getJavaDeclaration(key, config[key]);
  });
  return javaConfigItems.join('\n');
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