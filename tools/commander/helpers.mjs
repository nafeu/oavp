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
  SKETCH_WEBSOCKET_SERVER_URL,
  GENOBJ_FILE_NAME
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

      const objectProperty = _.find(OAVP_OBJECT_PROPERTIES, { property });

      if (objectProperty === null || objectProperty === undefined) {
        console.log(
          `[ oavp-commander:error ] Cannot match property: ${property}`,
        );
      } else {
        const isString =
          _.find(OAVP_OBJECT_PROPERTIES, { property }).type === "String";
        const overrideValue = isString ? value : eval(value);

        overrides.push({
          property,
          value: overrideValue,
          eval: value,
          type:
            _.find(OAVP_OBJECT_PROPERTIES, { property }).type || "String",
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

    OAVP_OBJECT_PROPERTIES.forEach(({ property, defaultValue, type }) => {
      const override = _.find(overrides, { property });

      const isString = type === "String";

      if (override) {
        output.push(
          `.set("${override.property}", ${
            isString ? `"${override.value}"` : override.value
          })`,
        );
      } else {
        output.push(
          `.set("${property}", ${isString ? `"${defaultValue}"` : defaultValue})`,
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

export const getAllEncodedParameters = options => {
  let allEncodedParameters = [];
  let allIssues = [];

  const hasConceptMapFilters = options?.conceptMaps?.length > 0;

  const selectedConceptMaps = _.filter(conceptMaps, (_, conceptMapName) => {
    const noConceptMapFilters = !hasConceptMapFilters;

    if (noConceptMapFilters) {
      return true;
    }

    const containsConceptMap = options.conceptMaps.includes(conceptMapName);

    return containsConceptMap;
  })

  _.each(selectedConceptMaps, (conceptMap) => {
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

export const emitGeneratedSketchToServer = ({ ws, options = {} }) => {
  console.log(
    `[ oavp-commander ] Emitting generated sketch to ${SKETCH_WEBSOCKET_SERVER_URL}`,
  );

  const allEncodedParameters = getAllEncodedParameters(options);

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

  fs.writeFileSync(GENOBJ_FILE_NAME, JSON.stringify(objects));

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

export const loadSketchDataObjectToServer = ({ ws, sketchDataObject }) => {
  console.log(
    `[ oavp-commander ] Loading sketchDataObject to ${SKETCH_WEBSOCKET_SERVER_URL}`,
  );

  const objects = sketchDataObject.objects.map(({ shape, name, properties }) => {
    const overrides = properties.map(({ property, value }) => {
      const type = _.find(OAVP_OBJECT_PROPERTIES, { property }).type;

      return { property, type, value }
    }).filter(({ property, value }) => {
      const { defaultValue } = _.find(OAVP_OBJECT_PROPERTIES, { property });

      return value !== defaultValue;
    });

    return {
      oavpObject: shape,
      id: name,
      params: overrides
    }
  });

  const colors = Object.keys(sketchDataObject.colors).reduce((mapping, key) => {
    const { int } = sketchDataObject.colors[key];

    mapping[key] = int;

    return mapping;
  }, {});

  const paletteArrayString = Object.keys(sketchDataObject.colors).map(
    key => sketchDataObject.colors[key].value
  ).sort().join(',');

  const seed = sketchDataObject.seed;

  const message = {
    command: "load",
    seed,
    objects,
    colors,
    paletteArrayString
  };

  const stringifiedMessage = JSON.stringify(message);

  ws.send(stringifiedMessage);
  console.log(`[ oavp-commander ] WebSocket command sent: ${message.command}`);
  return objects;
};

export const reseedSketchOnServer = ({ ws, sketchDataObject }) => {
  console.log(
    `[ oavp-commander ] Re-seeding sketchDataObject to ${SKETCH_WEBSOCKET_SERVER_URL}`,
  );

  const reseedObjects = sketchDataObject.generatorObject.map(({ oavpObject, params, id }) => {
    const evaluatedParams = params
      .filter(
        ({ type, ...attributes }) => (type === 'int' || type === 'float') && attributes.eval.includes("rand")
      )
      .map(({ property, type, ...attributes }) => {
        const value = eval(attributes.eval);

        return { property, type, value }
      });

    return {
      oavpObject,
      id,
      params: evaluatedParams
    }
  });

  rand.cache = {};

  const message = {
    command: "reseed",
    seed: rand(0, 100),
    reseedObjects
  };

  const stringifiedMessage = JSON.stringify(message);

  ws.send(stringifiedMessage);
  console.log(`[ oavp-commander ] WebSocket command sent: ${message.command}`);
  return reseedObjects;
}

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

    const sketchFileNumbers = files.filter((file) => {
      return file.endsWith(filePattern);
    }).map(file => Number(file.split('_')[0]));

    return Math.max(...[...sketchFileNumbers, 0]);
  } catch (err) {
    console.error(`Error counting files: ${err}`);
    return -1;
  }
};
