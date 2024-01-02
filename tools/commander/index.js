const fs = require('fs');
const _ = require('lodash');
const shortid = require('shortid');
const WebSocket = require('ws');
const express = require('express');
const path = require('path');
const diff = require('diff');

const { weaveTopics } = require('topic-weaver');

const { OAVP_AVAILABLE_SHAPES, OAVP_OBJECT_PROPERTIES } = require('./constants');
const { conceptMaps } = require('./concept-maps');

const WEBSOCKET_SERVER_URL = 'ws://localhost:3000/commands';
const WEBSERVER_PORT = 3001;
const DIRECTORY_PATH = './';
const TARGET_FILE_NAME = 'target.txt';
const DUMP_FILE_PATH = 'preset-dump.txt';

const app = express();

let ws;
let presetOutput = '';
let processedDiff = [];
let presetCount = 0;

const getOverridesFromParameterSet = singleLineParameterSet => {
  const [shape, valuesMapping] = singleLineParameterSet.split('|');

  const overrides = [];

  valuesMapping
    .split(';')
    .filter(value => value.length > 0)
    .forEach(valueMapping => {
      const [property, value] = valueMapping.split(':');

      const isString = _.find(OAVP_OBJECT_PROPERTIES, { id: property }).type === 'String';

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

    OAVP_OBJECT_PROPERTIES.forEach(({ id, defaultValue, type }) => {
      const override = _.find(overrides, { id });

      const isString = type === 'String';

      if (override) {
        output.push(`.set("${override.id}", ${isString ? `"${override.value}"` : override.value})`);
      } else {
        output.push(`.set("${id}", ${isString ? `"${defaultValue}"` : defaultValue})`);
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
  let allEncodedParameters = [];
  let allIssues = [];

  conceptMaps.forEach(conceptMap => {
    const { topics: encodedParameters, issues } = weaveTopics(conceptMap, 1, {
      generatorOptions: { strictMode: true }
    });

    allEncodedParameters = [...allEncodedParameters, ...encodedParameters];
    allIssues = [...allIssues, ...issues];
  });

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

  console.log(`[ oavp-commander ] Exporting sketch.pde file at ../../src/sketch.pde`);

  fs.writeFileSync('../../src/sketch.pde', sketch);
}

const emitGeneratedSketchToServer = () => {
  console.log(`[ oavp-commander ] Emitting generated sketch to ${WEBSOCKET_SERVER_URL}`);

  const allEncodedParameters = getAllEncodedParameters();

  const objects = [];

  allEncodedParameters.forEach(encodedParameters => {
    const singleLineParameterSets = encodedParameters.split('+');

    singleLineParameterSets.forEach((singleLineParameterSet, index) => {
      const { overrides, shape } = getOverridesFromParameterSet(singleLineParameterSet);

      objects.push({ oavpObject: shape, params: overrides, id: `${shape}_${shortid.generate()}` });
    });
  });

  const message = JSON.stringify({ command: 'write-objects', objects });
  ws.send(message);
  return objects;
  console.log(`[ oavp-commander ] WebSocket message sent: ${message}`);
}

const compareFiles = () => {
  if (!fs.existsSync('default.txt')) {
    console.log('Missing "default.txt" file'); process.exit(1);
  }

  if (!fs.existsSync('target.txt')) {
    console.log('Missing "target.txt" file'); process.exit(1);
  }

  const content1 = fs.readFileSync('default.txt', 'utf-8').split('\n');
  const content2 = fs.readFileSync('target.txt', 'utf-8').split('\n');

  const lineDiff = diff.diffArrays(content1, content2);

  let differentLines = lineDiff
    .filter(part => part.added || part.removed)
    .map(part => (part.added ? '+ ' : part.removed ? '- ' : '  ') + part.value)

  differentLines = differentLines
    .filter(part => part[0] === '+')
    .map(part => part.substring(1).trim());

  return differentLines;
}

const splitString = input => {
  const regex = /,(?![^()]*\))/g;
  const result = input.split(regex);
  return result.map(item => item.trim());
}

const main = () => {
  app.use(express.json());

  app.use((req, res, next) => {
    console.log(`[ oavp-commander ] Received ${req.method} request at ${req.url} : ${JSON.stringify(req.body)}`);
    next();
  });

  app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
  });

  app.get('/api', (req, res) => {
    res.sendStatus(200);
  });

  app.post('/api/command', (req, res) => {
    const { command, ...params } = req.body;

    if (command === 'export') {
      writeGeneratedSketchToFile();
      res.json({ status: 'success', message: `Saved generated sketch to file sketch.pde` });
    }

    else if (command === 'generate') {
      const objects = emitGeneratedSketchToServer();
      res.json({ status: 'success', message: `Emitted generated sketch to server.`, data: objects });
    }

    else if (command === 'reset') {
      ws.send(JSON.stringify({ command: 'reset' }));
      res.json({ status: 'success', message: `Removed all objects from sketch.` });
    }

    else {
      res.json({ status: 'failure', message: `Unrecognized command: ${command}` });
    }
  });

  app.listen(WEBSERVER_PORT, () => {
    console.log(`[ oavp-commander ] Webserver is running at http://localhost:${WEBSERVER_PORT}`);
  });

  ws = new WebSocket(WEBSOCKET_SERVER_URL);

  ws.on('open', () => {
    console.log('[ oavp-commander ] WebSocket connection opened.');
  });

  ws.on('close', () => {
    console.log('[ oavp-commander ] WebSocket connection closed');
  });

  ws.on('error', (error) => {
    console.error(`[ oavp-commander ] WebSocket error (make sure oavp is running): ${error}`);
  });

  console.log(`[ oavp-commander ] Watching for changes to ${TARGET_FILE_NAME}`);
  console.log(`[ oavp-commander ] Dumping generated presets into to ${DUMP_FILE_PATH}`);

  const logStream = fs.createWriteStream(DUMP_FILE_PATH, { flags: 'a' });

  fs.watch(DIRECTORY_PATH, (eventType, filename) => {
    if (filename !== TARGET_FILE_NAME) { return };

    presetOutput = '';
    processedDiff = [];

    compareFiles().forEach(line => {
      processedDiff = [...processedDiff, ...splitString(line)];
    });

    processedDiff.forEach(line => {
      const isAddition = line.includes('.add(');

      if (isAddition) {
        const objectName = line.match(/\.add\("[^"]+","([^"]+)"\)/)[1];

        presetOutput = `${objectName}|`;
      } else {
        const regex = /\.set\("([^"]+)",\s*([^)]+)\)/g;

        while ((match = regex.exec(line)) !== null) {
          const property = match[1].trim();
          const value = match[2].trim().replace(/["']/g, '');
          presetOutput += `${property}:${value};`;
        }
      }
    });

    console.log(`[ oavp-commander ] Added preset: ${presetOutput}`);
    logStream.write(`\n${presetOutput}`);
  });
}

main();
