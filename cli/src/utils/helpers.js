import { promises as fs } from 'fs';
import { TEMPLATES_PATH } from '../config';

export async function readTemplate(template) {
  try {
    return(await fs.readFile(`${TEMPLATES_PATH}/${template}/config.oavp`, 'utf8'));
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