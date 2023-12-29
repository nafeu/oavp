const fs = require('fs');
const _ = require('lodash');
const shortid = require('shortid');
const WebSocket = require('ws');
const yargs = require('yargs');

const { weaveTopics } = require('topic-weaver');

const { OAVP_AVAILABLE_SHAPES, OAVP_OBJECT_PROPERTIES } = require('./constants');
const {
  foregroundObjects,
  surroundingObjects
} = require('./concept-maps');

const WEBSOCKET_SERVER_URL = 'ws://localhost:3000/commands';

let ws;

const argv = yargs
  .option('export', {
    alias: 'e',
    description: 'Execute code for export',
    type: 'boolean',
  })
  .help()
  .alias('help', 'h').argv;

const getOverridesFromParameterSet = singleLineParameterSet => {
  const [shape, valuesMapping] = singleLineParameterSet.split('|');

  const overrides = [];

  valuesMapping
    .split(';')
    .filter(value => value.length > 0)
    .forEach(valueMapping => {
      const [property, value] = valueMapping.split(':');

      const isString = value.includes('"');

      overrides.push({
        id: property,
        value: isString ? value : Number(value),
        type: _.find(OAVP_OBJECT_PROPERTIES, { id: property }).type || 'String'
      });
  })

  return { overrides, shape };
}

const buildObjectString = encodedParameters => {
  const output = [];

  const singleLineParameterSets = encodedParameters.split('+');

  singleLineParameterSets.forEach((singleLineParameterSet, index) => {
    const { overrides, shape } = getOverridesFromParameterSet(singleLineParameterSet);

    output.push(`objects.add("${shape}_${shortid.generate()}", "${shape}")`)

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

const getAllEncodedParameters = () => {
  let allEncodedParameters, allIssues;

  const randomForegroundObjects = weaveTopics(foregroundObjects, 1);
  const randomSurroundingObjects = weaveTopics(surroundingObjects, 1);

  allEncodedParameters = [
    ...randomForegroundObjects.topics,
    ...randomSurroundingObjects.topics
  ];

  allIssues = [
    ...randomForegroundObjects.issues,
    ...randomSurroundingObjects.issues
  ];

  if (allIssues.length > 0) { console.log(issues); process.exit(1); }

  return allEncodedParameters;
}

const writeGeneratedSketchToFile = () => {
  const allEncodedParameters = getAllEncodedParameters();

  const setupSketch = [];

  allEncodedParameters.forEach(encodedParameters => {
    const objectString = buildObjectString(encodedParameters);

    setupSketch.push(objectString);
  });

  const sketch = buildTemplatedSketch({ setupSketch: setupSketch.join("\n  ") });

  console.log(`[ generator ] Exporting sketch.pde file at ../../src/sketch.pde`);

  fs.writeFileSync('../../src/sketch.pde', sketch);
}

const emitGeneratedSketchToServer = () => {
  console.log(`[ generator ] Emitting generated sketch to ${WEBSOCKET_SERVER_URL}`);

  const allEncodedParameters = getAllEncodedParameters();

  const objects = [];

  allEncodedParameters.forEach(encodedParameters => {
    const singleLineParameterSets = encodedParameters.split('+');

    singleLineParameterSets.forEach((singleLineParameterSet, index) => {
      const { overrides, shape } = getOverridesFromParameterSet(singleLineParameterSet);

      objects.push({ oavpObject: shape, params: overrides, id: `${shape}_${shortid.generate()}` });
    });
  });

  const message = JSON.stringify(objects);
  ws.send(message);
  console.log(`[ generator ] WebSocket message sent: ${message}`);
}

if (argv.export) {
  writeGeneratedSketchToFile();
} else {
  ws = new WebSocket(WEBSOCKET_SERVER_URL);

  ws.on('open', () => {
    console.log('[ generator ] WebSocket connection opened.');

    emitGeneratedSketchToServer();

    ws.close();
  });

  ws.on('close', () => {
    console.log('[ generator ] WebSocket connection closed');
  });

  ws.on('error', (error) => {
    console.error(`[ generator ] WebSocket error: ${error}`);
  });
}

