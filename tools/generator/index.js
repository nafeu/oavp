const _ = require('lodash');
const { weaveTopics } = require('topic-weaver');

const { OAVP_AVAILABLE_SHAPES, OAVP_OBJECT_PROPERTIES } = require('./constants');

const conceptMap = `
#root
[object]

#object
[arc]

#rectangle
Rectangle|y:40;yIter:-5.0;zIter:45.0;zrIter:4.0;w:100;wIter:5.0;h:100;hIter:5.0;strokeWeight:2.0;fillColor:0;i:21;

#arc
Arc|zMod:-250.0;zModType:"osc-normal";zIter:35.0;zrIter:5.0;w:100.0;h:100.0;s:100.0;paramB:180.0;fillColor:0;i:21;

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

  valuesMapping
    .split(';')
    .filter(value => value.length > 0)
    .forEach(valueMapping => {
      const [property, value] = valueMapping.split(':');

      const isString = value.includes('"');

      overrides.push({
        id: property,
        value: isString ? value : Number(value)
      });
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
