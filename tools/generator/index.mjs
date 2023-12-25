import _ from 'lodash';
import { weaveTopics } from 'topic-weaver';

import { OAVP_AVAILABLE_SHAPES, OAVP_OBJECT_PROPERTIES } from './constants.mjs';

const conceptMap = `
#root
[object]

#object
[rectangle]

#rectangle
Rectangle|w:[dim];h:[dim]

#dim
100
200
300
400
`

const getRandomObject = () => {
  const { topics, issues } = weaveTopics(conceptMap, 1);

  if (issues.length > 0) {
    throw new Error(issues[0]);
  }

  return topics[0];
}

let sketch = [];
let counter = 0;

const addRandomObject = () => {
  const [shape, valuesMapping] = getRandomObject().split('|');

  sketch.push(`objects.add("shape_${++counter}", "${shape}")`)

  const overrides = [];

  valuesMapping.split(';').forEach(valueMapping => {
    const [property, value] = valueMapping.split(':');

    overrides.push({ id: property, value: value === 'none' ? 'none' : Number(value) });
  })

  OAVP_OBJECT_PROPERTIES.forEach(({ id, defaultValue }) => {
    const override = _.find(overrides, { id });

    if (override) {
      sketch.push(`.set("${override.id}", ${override.value})`);
    } else {
      const isString = typeof defaultValue === 'string';

      const value = isString ? `"${defaultValue}"` : defaultValue;

      sketch.push(`.set("${id}", ${value})`);
    }
  });

  sketch.push(';');
}

addRandomObject();

sketch = `${sketch.join('')}`;

console.log(sketch);
