const fs = require('fs');
const _ = require('lodash');
const shortid = require('shortid');
const WebSocket = require('ws');
const express = require('express');
const path = require('path');
const diff = require('diff');

const { weaveTopics } = require('topic-weaver');

const {
  OAVP_OBJECT_PROPERTIES,
  OAVP_AVAILABLE_SHAPES,
  SINGLE_LINE_PARAMETER_SET_DELIMITER,
  OBJECT_NAME_AND_PROPERTIES_DELIMITER,
  OBJECT_NAME_AND_TAGS_DELIMITER,
  SKETCH_WEBSOCKET_SERVER_URL,
  WEBSERVER_PORT,
  COMMANDER_WEBSOCKET_SERVER_PORT,
  DIRECTORY_PATH,
  TARGET_FILE_NAME,
  DUMP_FILE_PATH,
  EXPORT_FILE_NAME,
  EXPORT_FILE_DIR
} = require('./constants');
const { conceptMaps } = require('./concept-maps');

const app = express();

let ws;
let wsServer;
let presetOutput = '';
let processedDiff = [];
let presetCount = 0;

const wsClients = new Set();

function rand(start, end, cacheId) {
  if (!rand.cache) {
    rand.cache = {};
  }

  const generateRandomInteger = () => Math.floor(Math.random() * (end - start + 1)) + start;

  if (cacheId !== undefined) {
    if (rand.cache[cacheId] !== undefined) {
      return rand.cache[cacheId];
    } else {
      const randomValue = generateRandomInteger();

      rand.cache[cacheId] = randomValue;

      return randomValue;
    }
  } else {
    const randomValue = generateRandomInteger();
    return randomValue;
  }
}

const getOverridesFromParameterSet = singleLineParameterSet => {
  const [objectNameAndTags, valuesMapping] = singleLineParameterSet.split(OBJECT_NAME_AND_PROPERTIES_DELIMITER);

  const [objectName, ...objectTags] = objectNameAndTags.split(OBJECT_NAME_AND_TAGS_DELIMITER)

  const overrides = [];

  valuesMapping
    .split(';')
    .filter(value => value.length > 0)
    .forEach(valueMapping => {
      const [property, value] = valueMapping.split(':');

      const objectProperty = _.find(OAVP_OBJECT_PROPERTIES, { id: property });

      if (objectProperty === null || objectProperty === undefined) {
        console.log(`[ oavp-commander:error ] Cannot match property: ${property}`);
      } else {
        const isString = _.find(OAVP_OBJECT_PROPERTIES, { id: property }).type === 'String';
        const overrideValue = isString ? value : eval(value);

        overrides.push({
          id: property,
          value: overrideValue,
          type: _.find(OAVP_OBJECT_PROPERTIES, { id: property }).type || 'String'
        });
      }
  })

  return { overrides, objectName, objectTags };
}

const buildObjectString = encodedParameters => {
  const output = [];

  const singleLineParameterSets = encodedParameters.split(SINGLE_LINE_PARAMETER_SET_DELIMITER);

  singleLineParameterSets.forEach((singleLineParameterSet, index) => {
    const { overrides, objectName, objectTags } = getOverridesFromParameterSet(singleLineParameterSet);

    output.push(`objects.add("${objectName}${objectTags.length > 0 ? `_${objectTags.join('_')}` : ''}_${shortid.generate()}", "${objectName}")`)

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

const emitGeneratedSketchToServer = (options = {}) => {
  console.log(`[ oavp-commander ] Emitting generated sketch to ${SKETCH_WEBSOCKET_SERVER_URL}`);

  const allEncodedParameters = getAllEncodedParameters();

  const objects = [];

  allEncodedParameters.forEach(encodedParameters => {
    const singleLineParameterSets = encodedParameters.split(SINGLE_LINE_PARAMETER_SET_DELIMITER);

    singleLineParameterSets.forEach((singleLineParameterSet, index) => {
      const { overrides, objectName, objectTags } = getOverridesFromParameterSet(singleLineParameterSet);

      objects.push({
        oavpObject: objectName,
        params: overrides,
        id: `${objectName}${objectTags.length > 0 ? `_${objectTags.join('_')}` : ''}_${shortid.generate()}`
      });
    });
  });

  rand.cache = {};

  const message = JSON.stringify({ command: options.isFeelingLucky ? 'feeling-lucky' : 'write-objects', objects });
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

const wsServerBroadcast = (message, sender) => {
  wsClients.forEach((client) => {
    if (client !== sender && client.readyState === WebSocket.OPEN) {
      client.send(message);
    }
  });
}

const main = () => {
  /*
    Express Web Server (GUI & API)
  */
  app.set('view engine', 'ejs');
  app.use(express.json());

  app.use((req, res, next) => {
    console.log(`[ oavp-commander ] Received ${req.method} request at ${req.url} : ${JSON.stringify(req.body)}`);
    next();
  });

  app.get('/', (req, res) => {
    res.render('index', { OAVP_OBJECT_PROPERTIES: JSON.stringify(OAVP_OBJECT_PROPERTIES) });
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

    else if (command === 'feeling-lucky') {
      const objects = emitGeneratedSketchToServer({ isFeelingLucky: true });
      res.json({ status: 'success', message: `Resetting previous sketch, generating a new sketch, randomize colors.`, data: objects });
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
    console.log(`[ oavp-commander:webserver ] Webserver is running at http://localhost:${WEBSERVER_PORT}`);
  });

  /*
    Sketch Socket Connection
  */
  ws = new WebSocket(SKETCH_WEBSOCKET_SERVER_URL);

  ws.on('open', () => {
    console.log('[ oavp-commander:sketch-socket-connection ] WebSocket connection opened.');
  });

  ws.on('close', () => {
    console.log('[ oavp-commander:sketch-socket-connection ] WebSocket connection closed');
  });

  ws.on('error', (error) => {
    console.error(`[ oavp-commander:sketch-socket-connection ] WebSocket error (make sure oavp is running): ${error}`);
  });

  /*
    Commander WebSocket Server
  */
  const wsServer = new WebSocket.Server({ port: COMMANDER_WEBSOCKET_SERVER_PORT });

  console.log(`[ oavp-commander:websocket-server ] WebSocket server is running at ws://localhost:${COMMANDER_WEBSOCKET_SERVER_PORT}`);

  wsServer.on('connection', (socket) => {
    console.log('[ oavp-commander:websocket-server ] Client connected');
    wsClients.add(socket);

    socket.on('message', (message) => {
      console.log(`[ oavp-commander:websocket-server ] Received: ${message}`);
    });

    socket.on('close', () => {
      console.log('[ oavp-commander:websocket-server ] Client disconnected');
    });
  });

  /*
    Preset Builder
  */
  console.log(`[ oavp-commander:preset-builder ] Watching for changes to ${TARGET_FILE_NAME}`);
  console.log(`[ oavp-commander:preset-builder ] Watching for changes to ${EXPORT_FILE_NAME}`);
  console.log(`[ oavp-commander:preset-builder ] Dumping generated presets into to ${DUMP_FILE_PATH}`);
  console.log(`[ oavp-commander:preset-builder ] Saving exported sketches to ${EXPORT_FILE_DIR}`);
  const logStream = fs.createWriteStream(DUMP_FILE_PATH, { flags: 'a' });

  fs.watch(DIRECTORY_PATH, (eventType, filename) => {
    if (filename === TARGET_FILE_NAME) {
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
      wsServerBroadcast(JSON.stringify({ command: 'preset-builder-result', data: presetOutput }));
      logStream.write(`\n${presetOutput}`);
    }

    if (filename === EXPORT_FILE_NAME) {
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
      const newFileName = `${timestamp}_sketch.txt`;
      const destinationFilePath = path.join(EXPORT_FILE_DIR, newFileName);

      fs.readFile(EXPORT_FILE_NAME, 'utf8', (err, data) => {
        if (err) {
          console.error(`Error reading the source file: ${err}`);
          return;
        }

        fs.writeFile(destinationFilePath, data, 'utf8', (err) => {
          if (err) {
            console.error(`Error writing to the destination file: ${err}`);
            return;
          }

          console.log(`File copied successfully to ${destinationFilePath}`);
        });
      });
    }
  });
}

main();
