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
  .filter(file => extname(file) === '.txt' && !_.includes(['shared', 'default'], basename(file, '.txt')))
  .map(file => {
    const filePath = join(CONCEPT_MAPS_DIR, file);
    const data     = readFileSync(filePath, 'utf8');
    const mapName  = basename(file, '.txt');

    const [height, presence, subject] = mapName.split('-');

    const heightCodeMapping = {
      high: 'hi',
      medium: 'md',
      low: 'lo'
    }

    const presenceCodeMapping = {
      busy: 'bsy',
      minimal: 'min'
    }

    return {
      height: heightCodeMapping[height],
      presence: presenceCodeMapping[presence],
      subject,
      mapId: toCamelCase(mapName),
      prefabsCount: data.split(/\n\n+/).map(part => part.includes('\n') ? part : part + '\n').length - 1
    }
  }).sort((
    { subject: subjectA, presence: presenceA, height: heightA },
    { subject: subjectB, presence: presenceB, height: heightB }
  ) => {
    const heightOrder = { hi: 1, md: 2, lo: 3 };

    if (subjectA < subjectB) return -1;
    if (subjectA > subjectB) return 1;
    if (presenceA < presenceB) return -1;
    if (presenceA > presenceB) return 1;
    return heightOrder[heightA] - heightOrder[heightB];
  }).concat([{
    height: '',
    presence: '',
    subject: 'default',
    mapId: 'default',
    prefabsCount: 1
  }])
  .reduce((mapping, conceptMap) => {
    if (conceptMap.subject === 'background') {
      mapping['background'] = [...(mapping['background'] || []), conceptMap];
    }

    if (conceptMap.subject === 'celestial') {
      mapping['celestial'] = [...(mapping['celestial'] || []), conceptMap];
    }

    if (conceptMap.subject === 'sky') {
      mapping['sky'] = [...(mapping['sky'] || []), conceptMap];
    }

    if (conceptMap.subject === 'surrounding') {
      mapping['surrounding'] = [...(mapping['surrounding'] || []), conceptMap];
    }

    if (conceptMap.subject === 'foreground') {
      mapping['foreground'] = [...(mapping['foreground'] || []), conceptMap];
    }

    if (conceptMap.subject === 'default') {
      mapping['default'] = [...(mapping['default'] || []), conceptMap];
    }

    return mapping;
  }, {});
