import _ from 'lodash';
import fs from 'fs';

let approxTotalTimeMs = 0;

import {
  OAVP_OBJECT_DEFAULTS,
  OAVP_OBJECT_PROPERTIES,
  OAVP_PROPERTY_SNAP_LEVELS_MAPPING,
  OAVP_ITER_FUNCS,
  OAVP_MOD_TYPES,
  OAVP_AVAILABLE_SHAPE_INDEX_MAPPING
} from '../../constants.mjs';

import {
  IGNORED_PROPERTIES,
  SEQUENCE_TYPE_TIMELAPSE
} from './constants.mjs';

export const easingFunctions = {
  linear: t => t,
  easeInQuad: t => t * t,
  easeOutCubic: t => (--t) * t * t + 1
}

export const getInterpolatedAnimationValues = ({ frameCount, easing = easingFunctions.linear }) => {
  let values = [];

  for (let i = 0; i < frameCount; i++) {
    let t = i / (frameCount - 1);
    let easedValue = easing(t);
    values.push(easedValue);
  }

  return values;
}

export const getMinutesByMs = millis => {
  var minutes = Math.floor(millis / 60000);
  var seconds = ((millis % 60000) / 1000).toFixed(0);
  return minutes + ":" + (seconds < 10 ? '0' : '') + seconds;
}

export const getRandomMsDelay = delayType => {
  const FAST_EXPORT = true;

  const DELAY_TYPE_SHORT_MS_HIGH = 70;
  const DELAY_TYPE_SHORT_MS_LOW = 50;
  const DELAY_TYPE_LONG_MS_HIGH = 500;
  const DELAY_TYPE_LONG_MS_LOW = 450;

  let output = 0;

  if (delayType === 'short') {
    if (FAST_EXPORT) {
      output = 30;
    } else {
      output = Math.floor(Math.random() * (DELAY_TYPE_SHORT_MS_HIGH - DELAY_TYPE_SHORT_MS_LOW + 1)) + DELAY_TYPE_SHORT_MS_LOW;
    }
  } else if (delayType === 'loading') {
    output = 1250;
  } else if (delayType === 'ending') {
    output = 5000;
  } else {
    if (FAST_EXPORT) {
      output = 500;
    } else {
      output = Math.floor(Math.random() * (DELAY_TYPE_LONG_MS_HIGH - DELAY_TYPE_LONG_MS_LOW + 1)) + DELAY_TYPE_LONG_MS_LOW;
    }
  }

  approxTotalTimeMs += output;

  return output;
}

export const cleanConsecutiveDuplicates = sequence => {
  if (!Array.isArray(sequence)) {
    throw new Error('Input must be an array');
  }

  const cleanedSequence = [];

  for (let i = 0; i < sequence.length; i++) {
    if (i === 0 || sequence[i] !== sequence[i - 1]) {
        cleanedSequence.push(sequence[i]);
    }
  }

  return cleanedSequence;
}

export const getPalette = colors => _.keys(colors)
  .map(key => colors[key].int)

export const generateColorSequence = ({ from, palette, to }) => {
  const SEQUENCE_LENGTH_LOW = 3;
  const SEQUENCE_LENGTH_HIGH = 6;

  const sequenceLength = Math.floor(Math.random() * (SEQUENCE_LENGTH_LOW + 1))
    + (SEQUENCE_LENGTH_HIGH - SEQUENCE_LENGTH_LOW);

  const resultSequence = [];

  let previousItem = null;

  for (let i = 0; i < sequenceLength; i++) {
    let randomIndex;

    do {
      randomIndex = Math.floor(Math.random() * palette.length);
    } while (palette[randomIndex] === previousItem);

    previousItem = palette[randomIndex];
    resultSequence.push(previousItem);
  }

  return cleanConsecutiveDuplicates([from, ...resultSequence, to]);
}

export const generateIterFuncSequence = ({ from, to }) => {
  const SEQUENCE_LENGTH_LOW = 4;
  const SEQUENCE_LENGTH_HIGH = 7;

  const sequenceLength = Math.floor(Math.random() * (SEQUENCE_LENGTH_LOW + 1))
    + (SEQUENCE_LENGTH_HIGH - SEQUENCE_LENGTH_LOW);

  const resultSequence = [];

  let previousItem = null;

  for (let i = 0; i < sequenceLength; i++) {
    let randomIndex;

    do {
      randomIndex = Math.floor(Math.random() * OAVP_ITER_FUNCS.length);
    } while (OAVP_ITER_FUNCS[randomIndex] === previousItem);

    previousItem = OAVP_ITER_FUNCS[randomIndex];
    resultSequence.push(previousItem);
  }

  return cleanConsecutiveDuplicates([from, ...resultSequence, to]);
}

export const generateIterSequence = ({ from, to }) => {
  const SMALL_INCREMENT_THRESHOLD = 20;
  const LARGE_INCREMENT = 2;

  const resultArray = [];

  if (to <= SMALL_INCREMENT_THRESHOLD) {
    for (let i = from; i <= to; i++) {
      resultArray.push(i);
    }
  } else {
    for (let i = from; i <= to; i += LARGE_INCREMENT) {
      resultArray.push(i);
    }
  }

  return resultArray;
}

export const generateModTypeSequence = ({ from, to }) => {
  const SEQUENCE_LENGTH_LOW = 4;
  const SEQUENCE_LENGTH_HIGH = 7;

  const sequenceLength = Math.floor(Math.random() * (SEQUENCE_LENGTH_LOW + 1))
    + (SEQUENCE_LENGTH_HIGH - SEQUENCE_LENGTH_LOW);

  const resultSequence = [];

  let previousItem = null;

  for (let i = 0; i < sequenceLength; i++) {
    let randomIndex;

    do {
      randomIndex = Math.floor(Math.random() * OAVP_MOD_TYPES.length);
    } while (OAVP_MOD_TYPES[randomIndex] === previousItem);

    previousItem = OAVP_MOD_TYPES[randomIndex];
    resultSequence.push(previousItem);
  }

  return cleanConsecutiveDuplicates([from, ...resultSequence, to]);
}

/* eslint-disable */
export const generateTimelapse = sketchDataObject => {
  const { objects, colors } = sketchDataObject;

  const palette = getPalette(colors);

  const customizationSets = objects.map(object => ({
    name: object.name,
    shape: object.shape,
    animations: object.animations,
    customizations: getCustomizationsForOavpObject(object)
  }));

  const interpolatedSets = customizationSets.map(customizationSet => ({
    shape: customizationSet.shape,
    name: customizationSet.name,
    animations: customizationSet.animations,
    interpolations: customizationSet.customizations.map(customization => ({
      ...customization,
      sequence: getInterpolatedStepsForPropertyPair({ propertyPair: customization, palette })
    }))
  }))

  const stepsSortedByArtisticOrder = getStepsSortedByArtisticOrder(interpolatedSets);

  const macrosFromSortedSteps = getEditorMacrosFromSortedSteps({ stepsSortedByArtisticOrder, sketchDataObject });

  return macrosFromSortedSteps.join('\n');
}

export const generateSequence = ({ sketchDataObject, sequenceType = SEQUENCE_TYPE_TIMELAPSE }) => {
  if (sequenceType === SEQUENCE_TYPE_TIMELAPSE) {
    return generateTimelapse(sketchDataObject);
  }

  return [];
}

export const getCustomizationsForOavpObject = oavpObject => {
  const { name, shape, properties } = oavpObject;

  const defaultProperties = OAVP_OBJECT_PROPERTIES.map(({ property, defaultValue }) => {
    const value = _.find(OAVP_OBJECT_DEFAULTS[shape], { property })?.value || defaultValue

    return { property, value }
  });

  const customizations = defaultProperties.map(({ property, value }) => {
    const isDifferentThanDefault = _.find(properties, { property })?.value !== value

    if (isDifferentThanDefault) {
      return { property, from: value, to: _.find(properties, { property })?.value }
    }

    return { sameAsDefault: true }
  })
    .filter(({ sameAsDefault }) => sameAsDefault === null || sameAsDefault === undefined)
    .filter(({ property, value }) => {
      const isIgnoredPropertyWithUndefinedValue = _.includes(IGNORED_PROPERTIES, property) && value === undefined;

      return !isIgnoredPropertyWithUndefinedValue;
    });

  return customizations;
}

export const getInterpolatedStepsForPropertyPair = ({ propertyPair, palette }) => {
  const { property, from, to } = propertyPair;

  if (_.includes(['fillColor', 'strokeColor'], property)) {
    return generateColorSequence({ from, palette, to })
  }

  if (_.includes(property, 'IterFunc')) {
    return generateIterFuncSequence({ from, to })
  }

  if (property === 'i') {
    return generateIterSequence({ from, to })
  }

  if (property === 'variation') {
    return ['none', to];
  }

  const gridSnappingLevels = OAVP_PROPERTY_SNAP_LEVELS_MAPPING[property];

  const destination = to;

  let output = [];

  const MAX_LARGE_STEPS = 3;
  const LARGE_STEPS_THRESHOLD = 3000;
  const HESITATION_STEPS_THRESHOLD = 3;
  const HESITATION_FACTOR_HIGH = 0.2;
  const HESITATION_FACTOR_LOW = 0.1;
  const MAX_STEPS_HIGH = 15;
  const MAX_STEPS_LOW = 8;

  const maxSteps = Math.floor(Math.random() * (MAX_STEPS_HIGH - MAX_STEPS_LOW + 1))
    + MAX_STEPS_LOW;

  let currentPosition = 0;

  (function makeLargeSteps() {
    const shouldMakeLargeStep = () => (
      Math.abs(destination - currentPosition) > LARGE_STEPS_THRESHOLD
        && output.length < MAX_LARGE_STEPS
    )

    while (shouldMakeLargeStep()) {
      const largeStep = Math.min(LARGE_STEPS_THRESHOLD, Math.abs(destination - currentPosition));

      currentPosition += destination > currentPosition ? largeStep : -largeStep;
      output.push(currentPosition);
    }
  })();

  const remainingSteps = maxSteps - output.length;

  (function makeRegularSteps() {
    for (let i = 0; i < remainingSteps; i++) {
      let hesitantProgress = i / (remainingSteps - 1);

      if (i >= remainingSteps - HESITATION_STEPS_THRESHOLD) {
        hesitantProgress += Math.random() * HESITATION_FACTOR_HIGH - HESITATION_FACTOR_LOW;
      }

      const interpolatedPosition = currentPosition + hesitantProgress * (destination - currentPosition);

      const gridSnapIndex = Math.floor(Math.random() * Object.keys(gridSnappingLevels).length);
      const gridSnapKey = Object.keys(gridSnappingLevels)[gridSnapIndex];
      const gridSnapValue = gridSnappingLevels[gridSnapKey];
      const snappedPosition = Math.round(interpolatedPosition / gridSnapValue) * gridSnapValue;

      output.push(snappedPosition);
    }
  })();

  output = [from, ...output, to];

  return cleanConsecutiveDuplicates(output);
}

export const getStepsSortedByArtisticOrder = interpolatedSteps => {
  const output = [];

  const artisticSortOrder = (a, b) => {
    const order = [
      'i',
      'zIter',
      'z',
      'w',
      'h',
      'l',
      's',
      'x',
      'y',
      'xIter',
      'yIter'
    ].reduce((mapping, item, index) => {
      mapping[item] = index;

      return mapping;
    }, {})

    const propertyA = a.property;
    const propertyB = b.property;

    if (order.hasOwnProperty(propertyA) && order.hasOwnProperty(propertyB)) {
      return order[propertyA] - order[propertyB];
    }

    if (order.hasOwnProperty(propertyA)) {
      return -1;
    }

    if (order.hasOwnProperty(propertyB)) {
      return 1;
    }

    return 0;
  }

  interpolatedSteps
    .map(
      ({ interpolations, ...rest }) => ({ interpolations: interpolations.sort(artisticSortOrder), ...rest })
    )
    .forEach(({ shape, name, interpolations, animations }) => {
      const objectOutput = [];

      const isDefaultShape = _.includes(['background', 'camera'], name);

      if (isDefaultShape) {
        objectOutput.push({ macro: 'create-default', args: { name } });
      } else {
        objectOutput.push({ macro: 'create', args: { name: shape } });
      }

      objectOutput.push({ macro: 'delay', args: { ms: getRandomMsDelay('long') } })

      // TODO: Continue ~ verify this...
      animations.forEach(({ property, value }) => {
        objectOutput.push({ macro: 'set', args: { property, value }});
        objectOutput.push({ macro: 'delay', args: { ms: getRandomMsDelay('short') } })
      });

      interpolations.forEach(({ property, sequence }) => {
        objectOutput.push({ macro: 'switch-tool', args: { enum: _.find(OAVP_OBJECT_PROPERTIES, { property }).tool } });
        objectOutput.push({ macro: 'delay', args: { ms: getRandomMsDelay('long') } })

        sequence.forEach(value => {
          objectOutput.push({ macro: 'set', args: { property, value } })
          objectOutput.push({ macro: 'delay', args: { ms: getRandomMsDelay('short') } })
        });
      });

      output.push(objectOutput);
    });

  return output;
}

export const getEditorMacrosFromSortedSteps = ({ stepsSortedByArtisticOrder: sortedStepGroups, sketchDataObject }) => {
  const FRAMECOUNT = 300;

  const output = []

  sortedStepGroups.forEach((sortedSteps, index) => {
    output.push(`void queueGeneratedTimelapse${index}() {`);

    sortedSteps.forEach(({ macro, args }) => {
      if (macro === 'create-default') {
        output.push(`  println("[ oavp ] Timelapse: creating default object: ${args.name}");`);
        output.push(`  objects.add("${args.name}", "OavpObject");`);
      }

      if (macro === 'create') {
        output.push(`  println("[ oavp ] Timelapse: creating object: ${args.name}");`);
        output.push(`  editor.toggleCreateMode();`);
        output.push(`  delay(${getRandomMsDelay('long')});`);
        output.push(`  editor.setCreateModeSelectionIndex(${OAVP_AVAILABLE_SHAPE_INDEX_MAPPING[args.name]});`);
        output.push(`  delay(${getRandomMsDelay('long')});`);
        output.push(`  editor.handleExternalCreateModeSelection();`);
        // output.push(`  objects.add(getNewObjectName("${args.name}", 1), "${args.name}");`);
      }

      if (macro === 'switch-tool') {
        output.push(`  editor.switchTool(${args.enum});`);
      }

      if (macro === 'set') {
        const { type } = _.find(OAVP_OBJECT_PROPERTIES, { property: args.property })
        const isString = type === 'String';

        output.push(`  editor.externalDirectEdit("${args.property}", ${isString ? `"${args.value}"` : `(${type}) ${args.value}`});`);
      }

      if (macro === 'delay') {
        output.push(`  delay(${args.ms});`);
      }
    });

    output.push(`}`);
  })

  const setup = [
    `int brollIndex = 0; int brollInterpolationLength = ${FRAMECOUNT};`,
    `void setupSketch() { println("[ oavp ] Approx Recording Time: ${getMinutesByMs(approxTotalTimeMs)}"); setSketchSeed(${sketchDataObject.seed}); }`,
    `void setupSketchPostEditor() { thread("queueGeneratedTimelapse"); enableRecording(); startTimelapse(); }`,
    `void updateSketch() {`,
    `  if (isAnimatingBroll) {`,
    `    if (brollIndex < brollInterpolationLength - 1) { brollIndex += 1; setBrollValue(brollInterpolation[brollIndex]); }`,
    `    else { stopAnimatingBroll(); closeApplication(); }`,
    `  }`,
    `}`,
    `void drawSketch() {}`,
    ``,
    `void queueGeneratedTimelapse() {`,
    `  delay(${getRandomMsDelay('loading')});`,
    `  editor.toggleEditMode();`,
    `  delay(${getRandomMsDelay('loading')});`,
    ...(sortedStepGroups.map(
      (_, index) => `  println("[ oavp ] Queueing Timelapse Part ${index}"); queueGeneratedTimelapse${index}();`
    )),
    `  editor.toggleEditMode();`,
    `  delay(${getRandomMsDelay('ending')});`,
    `  startAnimatingBroll();`,
    `}`,
    ``
  ];

  // 5s @ 60FPS = 300 frames
  const brollInterpolation = [
    'float[] brollInterpolation = {',
    ...getInterpolatedAnimationValues({ frameCount: FRAMECOUNT })
      .map(value => `  ${value},`),
    '};'
  ];

  return [...setup, ...output, ...brollInterpolation];
}
