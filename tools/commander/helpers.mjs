import _ from "lodash";
import shortid from "shortid";
import * as diff from "diff";
import { weaveTopics } from "topic-weaver";
import fs from "fs";
import WebSocket from "ws";

import {
  OAVP_OBJECT_PROPERTIES,
  OBJECT_NAME_AND_PROPERTIES_DELIMITER,
  OBJECT_NAME_AND_TAGS_DELIMITER,
  OVERRIDE_VALUES_DELIMITER,
  PROPERTY_VALUE_DELIMITER,
  SINGLE_LINE_PARAMETER_SET_DELIMITER,
  SKETCH_WEBSOCKET_SERVER_URL
} from "./constants.mjs";

import { conceptMaps } from "./concept-maps.mjs";

export const rand = (start, end, cacheId) => {
  if (!rand.cache) {
    rand.cache = {};
  }

  const generateRandomInteger = () =>
    Math.floor(Math.random() * (end - start + 1)) + start;

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
};

export const getOverridesFromParameterSet = (singleLineParameterSet) => {
  const [objectNameAndTags, valuesMapping] = singleLineParameterSet.split(
    OBJECT_NAME_AND_PROPERTIES_DELIMITER,
  );

  const [objectName, ...objectTags] = objectNameAndTags.split(
    OBJECT_NAME_AND_TAGS_DELIMITER,
  );

  const overrides = [];

  valuesMapping
    .split(OVERRIDE_VALUES_DELIMITER)
    .filter((value) => value.length > 0)
    .forEach((valueMapping) => {
      const [property, value] = valueMapping.split(PROPERTY_VALUE_DELIMITER);

      const objectProperty = _.find(OAVP_OBJECT_PROPERTIES, { id: property });

      if (objectProperty === null || objectProperty === undefined) {
        console.log(
          `[ oavp-commander:error ] Cannot match property: ${property}`,
        );
      } else {
        const isString =
          _.find(OAVP_OBJECT_PROPERTIES, { id: property }).type === "String";
        const overrideValue = isString ? value : eval(value);

        overrides.push({
          id: property,
          value: overrideValue,
          type:
            _.find(OAVP_OBJECT_PROPERTIES, { id: property }).type || "String",
        });
      }
    });

  return { overrides, objectName, objectTags };
};

export const splitString = (input) => {
  const regex = /,(?![^()]*\))/g;
  const result = input.split(regex);
  return result.map((item) => item.trim());
};

export const buildObjectString = (encodedParameters) => {
  const output = [];

  const singleLineParameterSets = encodedParameters.split(
    SINGLE_LINE_PARAMETER_SET_DELIMITER,
  );

  singleLineParameterSets.forEach((singleLineParameterSet, index) => {
    const { overrides, objectName, objectTags } = getOverridesFromParameterSet(
      singleLineParameterSet,
    );

    output.push(
      `objects.add("${objectName}${
        objectTags.length > 0 ? `_${objectTags.join("_")}` : ""
      }_${shortid.generate()}", "${objectName}")`,
    );

    OAVP_OBJECT_PROPERTIES.forEach(({ id, defaultValue, type }) => {
      const override = _.find(overrides, { id });

      const isString = type === "String";

      if (override) {
        output.push(
          `.set("${override.id}", ${
            isString ? `"${override.value}"` : override.value
          })`,
        );
      } else {
        output.push(
          `.set("${id}", ${isString ? `"${defaultValue}"` : defaultValue})`,
        );
      }
    });

    output.push(
      `;${index === singleLineParameterSets.length - 1 ? "" : "\n  "}`,
    );
  });

  return output.join("");
};

export const buildTemplatedSketch = ({ setupSketch }) => `void setupSketch() {
  ${setupSketch}
}

void setupSketchPostEditor() {}
void updateSketch() {}
void drawSketch() {}
`;

export const getAllEncodedParameters = () => {
  let allEncodedParameters = [];
  let allIssues = [];

  conceptMaps.forEach((conceptMap) => {
    const { topics: encodedParameters, issues } = weaveTopics(conceptMap, 1, {
      generatorOptions: { strictMode: true },
    });

    allEncodedParameters = [...allEncodedParameters, ...encodedParameters];
    allIssues = [...allIssues, ...issues];
  });

  if (allIssues.length > 0) {
    console.log(allIssues);
    process.exit(1);
  }

  return allEncodedParameters;
};

export const writeGeneratedSketchToFile = () => {
  const allEncodedParameters = getAllEncodedParameters();

  const setupSketch = [];

  allEncodedParameters.forEach((encodedParameters) => {
    const objectString = buildObjectString(encodedParameters);

    setupSketch.push(objectString);
  });

  const sketch = buildTemplatedSketch({
    setupSketch: setupSketch.join("\n  "),
  });

  console.log(
    `[ oavp-commander ] Exporting sketch.pde file at ../../src/sketch.pde`,
  );

  fs.writeFileSync("../../src/sketch.pde", sketch);
};

export const emitGeneratedSketchToServer = ({ ws, options = {} }) => {
  console.log(
    `[ oavp-commander ] Emitting generated sketch to ${SKETCH_WEBSOCKET_SERVER_URL}`,
  );

  const allEncodedParameters = getAllEncodedParameters();

  const objects = [];

  allEncodedParameters.forEach((encodedParameters) => {
    const singleLineParameterSets = encodedParameters.split(
      SINGLE_LINE_PARAMETER_SET_DELIMITER,
    );

    singleLineParameterSets.forEach((singleLineParameterSet) => {
      const { overrides, objectName, objectTags } =
        getOverridesFromParameterSet(singleLineParameterSet);

      objects.push({
        oavpObject: objectName,
        params: overrides,
        id: `${objectName}${
          objectTags.length > 0 ? `_${objectTags.join("_")}` : ""
        }_${shortid.generate()}`,
      });
    });
  });

  rand.cache = {};

  const message = {
    command: options.isFeelingLucky ? "feeling-lucky" : "write-objects",
    objects,
    seed: rand(0, 100),
  };

  const stringifiedMessage = JSON.stringify(message);

  ws.send(stringifiedMessage);
  console.log(`[ oavp-commander ] WebSocket command sent: ${message.command}`);
  return objects;
};

export const compareFiles = () => {
  if (!fs.existsSync("default.txt")) {
    console.log('Missing "default.txt" file');
    process.exit(1);
  }

  if (!fs.existsSync("target.txt")) {
    console.log('Missing "target.txt" file');
    process.exit(1);
  }

  const content1 = fs.readFileSync("default.txt", "utf-8").split("\n");
  const content2 = fs.readFileSync("target.txt", "utf-8").split("\n");

  const lineDiff = diff.diffArrays(content1, content2);

  let differentLines = lineDiff
    .filter((part) => part.added || part.removed)
    .map(
      (part) => (part.added ? "+ " : part.removed ? "- " : "  ") + part.value,
    );

  differentLines = differentLines
    .filter((part) => part[0] === "+")
    .map((part) => part.substring(1).trim());

  return differentLines;
};

export const wsServerBroadcast = ({ message, sender, wsClients }) => {
  wsClients.forEach((client) => {
    if (client !== sender && client.readyState === WebSocket.OPEN) {
      client.send(message);
    }
  });
};

export const countFiles = (directoryPath, filePattern) => {
  try {
    const files = fs.readdirSync(directoryPath);

    const sketchFiles = files.filter((file) => {
      return file.endsWith(filePattern);
    });

    return sketchFiles.length;
  } catch (err) {
    console.error(`Error counting files: ${err}`);
    return -1;
  }
};
