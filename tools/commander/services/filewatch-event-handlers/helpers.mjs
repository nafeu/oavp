import path from "path";
import ncpPackage from "ncp";
import _ from "lodash";
import fs from "fs";
import { weaveTopics } from "topic-weaver";

const { ncp } = ncpPackage;

import {
  COLOR_EXTRACTION_REGEX,
  EXPORT_FILE_DIR,
  EXPORT_FILE_NAME,
  EXPORT_IMAGE_NAME,
  SANDBOX_CONCEPT_MAPS_FILE_NAME,
  SINGLE_LINE_PARAMETER_SET_DELIMITER,
  GENOBJ_FILE_NAME,
  FILE_COPY_TIMEOUT_DURATION,
  IMAGE_COPY_TIMEOUT_DURATION,
  INVALID_TAGS,
  OAVP_OBJECT_PROPERTIES,
  OBJECT_NAME_AND_SHAPE_REGEX,
  OBJECT_NAME_REGEX,
  OBJECT_PROPERTIES_REGEX,
  OBJECT_PROPERTY_KEY_AND_VALUE_REGEX,
  ANIMATION_SPEED_MULTIPLIER,
  BROLL_CAMERA_PRESETS
} from '../../constants.mjs';

import { conceptMaps } from '../../concept-maps.mjs';

import {
  wsServerBroadcast,
  compareFiles,
  splitString,
  countFiles,
  getOverridesFromParameterSet,
  clearCache,
  removeTrailingWhitespaceAndNewlines
} from '../../helpers.mjs';

let presetOutput = "";
let processedDiff = [];
let imageCopyTimeout;
let fileCopyTimeout;

export const handlePresetEvent = ({ wsClients, logStream }) => {
  presetOutput = "";
  processedDiff = [];

  compareFiles().forEach((line) => {
    processedDiff = [...processedDiff, ...splitString(line)];
  });

  processedDiff.forEach((line) => {
    const isAddition = line.includes(".add(");

    if (isAddition) {
      const objectName = line.match(OBJECT_NAME_REGEX)[1];

      presetOutput = `${objectName}|`;
    } else {
      const regex = OBJECT_PROPERTIES_REGEX;

      let match;

      while ((match = regex.exec(line)) !== null) {
        const property = match[1].trim();
        const value = match[2].trim().replace(/["']/g, "");
        presetOutput += `${property}:${value};`;
      }
    }
  });

  console.log(`[ oavp-commander:preset-event ] Added preset: ${presetOutput}`);
  wsServerBroadcast({
    message: JSON.stringify({
      command: "preset-builder-result",
      data: presetOutput,
    }),
    wsClients,
  });
  logStream.write(`\n${presetOutput}`);
};

export const handleExportFileEvent = () => {
  if (fileCopyTimeout) {
    clearTimeout(fileCopyTimeout);
  }

  fileCopyTimeout = setTimeout(() => {
    const newFileName = `${
      countFiles(path.resolve(EXPORT_FILE_DIR), "_sketch.txt") + 1
    }_sketch.txt`;
    const destinationFilePath = path.join(EXPORT_FILE_DIR, newFileName);

    const genObjContent = fs.readFileSync(GENOBJ_FILE_NAME, 'utf8');
    const exportedSketchContent = fs.readFileSync(EXPORT_FILE_NAME, 'utf8');

    const finalContent = `//GENOBJ:${genObjContent}\n${exportedSketchContent}`;

    try {
      fs.writeFileSync(destinationFilePath, finalContent);

      console.log(
        `[ oavp-commander:file-copy ] File copied with genObj successfully to ${destinationFilePath}`,
      );
    } catch (err) {
      console.error(
        `[ oavp-commander:file-copy ] Error writing to the destination file: ${err}`,
      );
    }

    fileCopyTimeout = null;
  }, FILE_COPY_TIMEOUT_DURATION);
};

export const handleExportImageEvent = () => {
  if (imageCopyTimeout) {
    clearTimeout(imageCopyTimeout);
  }

  imageCopyTimeout = setTimeout(() => {
    const newFileName = `${
      countFiles(path.resolve(EXPORT_FILE_DIR), "_sketch.png") + 1
    }_sketch.png`;
    const destinationFilePath = path.join(EXPORT_FILE_DIR, newFileName);

    ncp(EXPORT_IMAGE_NAME, destinationFilePath, function (err) {
      if (err) {
        console.error(
          `[ oavp-commander:image-copy ] Error writing to the destination file: ${err}`,
        );
      }
      console.log(
        `[ oavp-commander:image-copy ] Image copied successfully to ${destinationFilePath}`,
      );
    });

    imageCopyTimeout = null;
  }, IMAGE_COPY_TIMEOUT_DURATION);
};

export const getValidTags = () => {
  let output = [];

  _.each(conceptMaps, conceptMap => {
    conceptMap.split('\n').forEach(line => {
      if (line.includes('|')) {
        output.push(line);
      }
    });
  });

  output = _.chain(output.map(line => line.split('|')[0].split('_')))
    .flatten()
    .map(line => _.lowerCase(line))
    .uniq()
    .difference(INVALID_TAGS)
    .value()

  return output;
}

const getHexAlphaColorByInt = integerColor => {
  const alpha = (integerColor >> 24) & 0xFF;
  const red = (integerColor >> 16) & 0xFF;
  const green = (integerColor >> 8) & 0xFF;
  const blue = integerColor & 0xFF;

  const alphaHex = alpha.toString(16).padStart(2, '0');
  const redHex = red.toString(16).padStart(2, '0');
  const greenHex = green.toString(16).padStart(2, '0');
  const blueHex = blue.toString(16).padStart(2, '0');

  const hexColor = `#${redHex}${greenHex}${blueHex}${alphaHex}`;

  return hexColor;
}

const getHexColorByInt = integerColor => {
  return getHexAlphaColorByInt(integerColor).substring(0, 7).toUpperCase();
}

export const getBrollAnimationOverrides = nameWithTags => {
  const output = BROLL_CAMERA_PRESETS.map(({
    cameraPresetName,
    modValue,
    orientation,
    easing
  }) => {
    if (nameWithTags === 'camera') {
      return {
        cameraPresetName,
        orientation,
        easing,
        zModValue: modValue
      }
    }

    const animations = nameWithTags.split('_').filter(item => item.includes('camera^'));

    if (animations.length === 0) {
      return null;
    }

    const multiplier = ANIMATION_SPEED_MULTIPLIER[animations[0].split('^')[1]];

    return {
      cameraPresetName,
      easing,
      orientation,
      zModValue: modValue * multiplier
    }
  });

  return _.compact(output).length === 0 ? [] : output;
}

export const buildSketchDataObject = sketchFileContent => {
  const output = {}

  const allSketchFileLines = sketchFileContent
    .split('\n')
    .filter(line => line !== '')

  allSketchFileLines.forEach(line => {
    const isMetaData = _.includes(line, '//');
    const isObjectDeclaration = _.includes(line, 'objects.add');
    const isEditorColorAction = _.includes(
      [
        'editor.setBackgroundColor',
        'editor.setAccentA',
        'editor.setAccentB',
        'editor.setAccentC',
        'editor.setAccentD'
      ],
      line.split('(')[0],
    );

    if (isMetaData) {
      const regex = /\/\/([^:]+):(.*)/;

      const match = line.match(regex);

      if (match) {
        const [, key, value] = match;

        const formattedKey = _.lowerCase(key);

        if (formattedKey === 'genobj') {
          output.generatorObject = JSON.parse(value);
        } else {
          output[formattedKey] = formattedKey === 'seed' ? Number(value) : value
        }
      }
    }

    if (isObjectDeclaration) {
      const [nameAndShape, ...allProperties] = line.split('.set')

      const [, objectName, objectShape] = nameAndShape.match(OBJECT_NAME_AND_SHAPE_REGEX);

      const properties = allProperties.map(keyValuePair => {
        const [, propertyKey, propertyValue] = keyValuePair.match(OBJECT_PROPERTY_KEY_AND_VALUE_REGEX);

        const isString = _.find(OAVP_OBJECT_PROPERTIES, { property: propertyKey }).type === "String";

        return {
          property: propertyKey,
          value: isString ? propertyValue : Number(propertyValue)
        }
      });

      output.objects = [
        ...(output.objects || []),
        {
          name: objectName,
          shape: objectShape,
          properties,
          animations: getBrollAnimationOverrides(objectName)
        }
      ]

      const allTags = objectName.split('_');

      output.tags = _.sortBy(_.uniq([
        ...(output.tags || []),
        ...allTags.filter(tag => _.includes(getValidTags(), tag))
      ]))
    }

    if (isEditorColorAction) {
      let colorObjectKey;

      if (line.includes('AccentA')) { colorObjectKey = 'accentA' }
      else if (line.includes('AccentB')) { colorObjectKey = 'accentB' }
      else if (line.includes('AccentC')) { colorObjectKey = 'accentC' }
      else if (line.includes('AccentD')) { colorObjectKey = 'accentD' }
      else { colorObjectKey = 'background' }

      const colorInt = Number(line.match(COLOR_EXTRACTION_REGEX)[1]);
      const colorHex = getHexColorByInt(colorInt);
      const colorObjectValue = { int: colorInt, value: colorHex }

      output.colors = { ...output.colors, [colorObjectKey]: colorObjectValue }
    }

    const PRINT_OFFSETS = {
      "print-offset-1x1": 1680,
      "print-offset-2x3": 2400,
      "print-offset-3x4": 2220,
      "print-offset-4x5": 2112,
      "print-offset-11x14": 2143,
      "print-offset-international": 2308
    }

    _.keys(PRINT_OFFSETS).forEach(key => {
      output[key] = PRINT_OFFSETS[key]
    });
  });

  return output
}

export const handleSandboxConceptMapsFileEvent = wsClients => {
  const conceptMap = removeTrailingWhitespaceAndNewlines(
    fs.readFileSync(SANDBOX_CONCEPT_MAPS_FILE_NAME, 'utf8')
  );

  const { topics: encodedParameters, issues } = weaveTopics(conceptMap, 1, {
    generatorOptions: { strictMode: true },
  });

  if (issues.length > 0) {
    console.log(`[ oavp-commander:filewatch-event-handlers ] Issues in sandbox concept map:`)
    console.log(JSON.stringify(issues, null, 2));
  }

  const objects = [];

  const singleLineParameterSets = encodedParameters[0].split(
    SINGLE_LINE_PARAMETER_SET_DELIMITER,
  );

  singleLineParameterSets.forEach((singleLineParameterSet, index) => {
    const { overrides, objectName, objectTags } =
      getOverridesFromParameterSet(singleLineParameterSet);

    objects.push({
      oavpObject: objectName,
      params: overrides,
      id: `${objectName}_sandbox_${
        objectTags.length > 0 ? `_${objectTags.join("_")}` : ""
      }_${index}`,
    });
  });

  console.log(`[ oavp-commander:sandbox-event ] Emitting sandbox update...`);
  wsServerBroadcast({
    message: JSON.stringify({
      command: "sandbox",
      objects
    }),
    wsClients: [wsClients]
  });

  clearCache();
};
