import { promises as fs } from 'fs';

export async function readTemplate(template) {
  try {
    return(await fs.readFile(`templates/${template}/config.json`, 'utf8'));
  } catch (err) {
    console.log(err.message);
    process.exit(1);
  }
}