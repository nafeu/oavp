import { promises as fs, existsSync, mkdirSync, writeFileSync } from 'fs';
import { TEMPLATES_PATH, SKETCHES_PATH } from '../config';
import execa from 'execa';
import fuzzy from 'fuzzy';
import _ from 'lodash';

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
    return(await fs.readdir(`${TEMPLATES_PATH}/`));
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
  return `A sketch with the name '${name}' does not exist.`;
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
  if (String(value) === value) {
    return `public String ${name} = "${value}";`;
  } else if (isFloat(value) || _.includes(String(value), '.')) {
    return `public float ${name} = ${value};`;
  } else {
    return `public int ${name} = ${value};`;
  }
}

function isInt(n){
    return Number(n) === n && n % 1 === 0;
}

function isFloat(n){
    return Number(n) === n && n % 1 !== 0;
}