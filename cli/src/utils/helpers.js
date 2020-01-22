import { promises as fs, existsSync, mkdirSync, writeFileSync } from 'fs';
import { TEMPLATES_PATH, SKETCHES_PATH } from '../config';
import execa from 'execa';

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

export async function getTemplates() {
  try {
    return(await fs.readdir(`${TEMPLATES_PATH}/`));
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