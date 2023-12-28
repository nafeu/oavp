const fs = require('fs');
const _ = require('lodash');
const shortid = require('shortid');

const { weaveTopics } = require('topic-weaver');

const { OAVP_AVAILABLE_SHAPES, OAVP_OBJECT_PROPERTIES } = require('./constants');
const { foregroundFocalPoint } = require('./concept-maps');

const { topics: allEncodedParameters, issues } = weaveTopics(foregroundFocalPoint, 1);

if (issues.length > 0) {
  console.log(issues);
  process.exit(1);
}

const buildObjectString = encodedParameters => {
  const output = [];

  const singleLineParameterSets = encodedParameters.split('+');

  singleLineParameterSets.forEach((singleLineParameterSet, index) => {
    const [shape, valuesMapping] = singleLineParameterSet.split('|');

    output.push(`objects.add("${shape}_${shortid.generate()}", "${shape}")`)

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
        output.push(`.set("${override.id}", ${override.value})`);
      } else {
        const isString = typeof defaultValue === 'string';

        const value = isString ? `"${defaultValue}"` : defaultValue;

        output.push(`.set("${id}", ${value})`);
      }
    });

    output.push(`;${index === singleLineParameterSets.length - 1 ? '' : '\n  '}`);
  });

  return output.join('');
}

const buildTemplatedSketch = ({ setupSketch }) => `void setupSketch() {
  ${setupSketch}
}

void setupSketchPostEditor() {}
void updateSketch() {}
void drawSketch() {}
`

const setupSketch = [];

allEncodedParameters.forEach(encodedParameters => {
  const objectString = buildObjectString(encodedParameters);

  setupSketch.push(objectString);
});

const sketch = buildTemplatedSketch({ setupSketch: setupSketch.join("\n  ") });

console.log(`[ generator ] Exporting sketch.pde file at ../../src/sketch.pde`);

fs.writeFileSync('../../src/sketch.pde', sketch);
