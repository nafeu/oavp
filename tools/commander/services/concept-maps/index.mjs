import { readdirSync, readFileSync } from 'fs';
import { resolve, join, basename, extname } from 'path';
import _ from 'lodash';

import { CONCEPT_MAPS_DIR, SHARED_VALUES_FILE } from '../../constants.mjs';
import { toCamelCase } from '../../helpers.mjs';

export const getConceptMaps = () => {
  try {
    const sharedValues = readFileSync(resolve(SHARED_VALUES_FILE), 'utf8');

    const files = readdirSync(resolve(CONCEPT_MAPS_DIR));
    const output = {};

    files.forEach(file => {
      if (extname(file) === '.txt' && !_.includes(['shared'], basename(file, '.txt'))) {
        const filePath = join(CONCEPT_MAPS_DIR, file);
        const key = toCamelCase(basename(file, '.txt'));
        const data = readFileSync(filePath, 'utf8');

        if (data.length > 0) {
          output[key] = `${data}\n${sharedValues}`;
        }
      }
    });

    return output;
  } catch (err) {
    console.error('Error processing the directory:', err);
  }
}

export const getConceptMapMeta = () => readdirSync(resolve(CONCEPT_MAPS_DIR))
  .filter(file => extname(file) === '.txt' && !_.includes(['shared'], basename(file, '.txt')))
  .map(file => {
    const filePath = join(CONCEPT_MAPS_DIR, file);
    const data     = readFileSync(filePath, 'utf8');
    const mapName  = basename(file, '.txt');

    const [height, presence, subject] = mapName.split('-');

    return {
      height: height || 'default',
      presence: presence || 'default',
      subject: subject || 'default',
      mapId: toCamelCase(mapName),
      prefabsCount: data.split(/\n\n+/).map(part => part.includes('\n') ? part : part + '\n').length - 1
    }
  })
  .filter(map => map.prefabsCount > 0);
