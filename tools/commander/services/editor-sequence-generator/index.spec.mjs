import seedRandom from 'seedRandom';

jest.setTimeout(5000);

import { generateSequence, getCustomizationsForOavpObject, getInterpolatedStepsForPropertyPair } from './index.mjs'

import {
  EXAMPLE_COLOR_PROPERTY_PAIR,
  EXAMPLE_CUSTOMIZATIONS,
  EXAMPLE_SEQUENCE,
  EXAMPLE_ITER_FUNC_PROPERTY_PAIR,
  EXAMPLE_ITER_FUNC_SEQUENCE,
  EXAMPLE_PALETTE,
  EXAMPLE_PALETTE_SEQUENCE,
  EXAMPLE_SKETCH_DATA_OBJECT
} from './constants.mjs'

import testSketchDataObject from './test-sketch-data-obj.json';

describe.only('generateSequence', () => {
  beforeEach(() => {
    Math.random = seedRandom('test');
  });

  describe('given a valid sketch file, upon building a sketch data object', () => {
    it('returns valid objects', () => {
      const result = generateSequence({ sketchDataObject: testSketchDataObject });

      expect(result.length).not.toEqual(0);
    });
  })
});

describe('getCustomizationsForOavpObject', () => {
  beforeEach(() => {
    Math.random = seedRandom('test');
  });

  const exampleOavpObject = EXAMPLE_SKETCH_DATA_OBJECT.objects[0];

  it('returns a valid set of customizations for an OavpObject', () => {
    const result = getCustomizationsForOavpObject(exampleOavpObject);

    expect(result).toEqual(EXAMPLE_CUSTOMIZATIONS)
  });
});

describe('getInterpolatedStepsForPropertyPair', () => {
  beforeEach(() => {
    Math.random = seedRandom('test');
  });

  it('returns a valid array of interpolated steps for a property pair', () => {
    const result = getInterpolatedStepsForPropertyPair({ propertyPair: EXAMPLE_CUSTOMIZATIONS[0], palette: EXAMPLE_PALETTE });

    expect(result).toEqual(EXAMPLE_SEQUENCE)
  });

  it('returns a valid array of interpolated steps for a property pair for colors', () => {
    const result = getInterpolatedStepsForPropertyPair({ propertyPair: EXAMPLE_COLOR_PROPERTY_PAIR, palette: EXAMPLE_PALETTE });

    expect(result).toEqual(EXAMPLE_PALETTE_SEQUENCE)
  });

  it('returns a valid array of interpolated steps for a property pair for iter funcs', () => {
    const result = getInterpolatedStepsForPropertyPair({ propertyPair: EXAMPLE_ITER_FUNC_PROPERTY_PAIR, palette: EXAMPLE_PALETTE });

    expect(result).toEqual(EXAMPLE_ITER_FUNC_SEQUENCE)
  });
});
