import { buildSketchDataObject, getBrollAnimationOverrides } from './helpers.mjs'
import {
  EXAMPLE_SKETCH_FILE,
  EXAMPLE_SKETCH_DATA_OBJECT
} from './constants.mjs'

describe('buildSketchDataObject', () => {
  describe('given a valid sketch file, upon building a sketch data object', () => {
    const sketchFileContent = EXAMPLE_SKETCH_FILE;

    const result = buildSketchDataObject(sketchFileContent);

    it('returns a valid name', () => {
      expect(result.name).toEqual(EXAMPLE_SKETCH_DATA_OBJECT.name);
    });

    it('returns a valid date', () => {
      expect(result.date).toEqual(EXAMPLE_SKETCH_DATA_OBJECT.date);
    });

    it('returns a valid seed', () => {
      expect(result.seed).toEqual(EXAMPLE_SKETCH_DATA_OBJECT.seed);
    });

    it('returns valid tags', () => {
      expect(result.tags).toEqual(EXAMPLE_SKETCH_DATA_OBJECT.tags);
    });

    it('returns a valid id', () => {
      expect(result.id).toEqual(EXAMPLE_SKETCH_DATA_OBJECT.id);
    });

    it('returns valid colors', () => {
      expect(result.colors).toEqual(EXAMPLE_SKETCH_DATA_OBJECT.colors);
    });

    it('returns valid objects', () => {
      expect(result.objects).toEqual(EXAMPLE_SKETCH_DATA_OBJECT.objects);
    });

    it('returns a valid generatorObject', () => {
      expect(result.generatorObject).toEqual(EXAMPLE_SKETCH_DATA_OBJECT.generatorObject);
    });

    it('returns valid printOffsets', () => {
      expect(result["print-offset-2x3"]).toEqual(2400);
      expect(result["print-offset-3x4"]).toEqual(2220);
      expect(result["print-offset-4x5"]).toEqual(2112);
      expect(result["print-offset-11x14"]).toEqual(2143);
      expect(result["print-offset-international"]).toEqual(2308);
    });
  });
});

describe('getBrollAnimationOverrides', () => {
  describe('given a camera object', () => {
    it('returns a valid set of animation overrides', () => {
      expect(getBrollAnimationOverrides('camera')).toEqual([
        {
          "cameraPresetName": "Stationary",
          "easing": "linear",
          "orientation": "forward",
          "zModValue": 0
        },
        {
          "cameraPresetName": "FixedForward",
          "easing": "linear",
          "orientation": "forward",
          "zModValue": -2000
        },
        {
          "cameraPresetName": "FastestBackward",
          "easing": "linear",
          "orientation": "backward",
          "zModValue": -10000
        },
        {
          "cameraPresetName": "SlowerForward",
          "easing": "linear",
          "orientation": "forward",
          "zModValue": -1000
        },
        {
          "cameraPresetName": "EaseInFasterBackward",
          "easing": "easeInQuad",
          "orientation": "backward",
          "zModValue": -6000
        }
      ]);
    });
  });

  describe('given a valid object name with one animation', () => {
    it('returns a valid set of animation overrides', () => {
      expect(getBrollAnimationOverrides('Rectangle_camera^fixed_1234')).toEqual([
        {
          "cameraPresetName": "Stationary",
          "easing": "linear",
          "orientation": "forward",
          "zModValue": 0
        },
        {
          "cameraPresetName": "FixedForward",
          "easing": "linear",
          "orientation": "forward",
          "zModValue": -2000
        },
        {
          "cameraPresetName": "FastestBackward",
          "easing": "linear",
          "orientation": "backward",
          "zModValue": -10000
        },
        {
          "cameraPresetName": "SlowerForward",
          "easing": "linear",
          "orientation": "forward",
          "zModValue": -1000
        },
        {
          "cameraPresetName": "EaseInFasterBackward",
          "easing": "easeInQuad",
          "orientation": "backward",
          "zModValue": -6000
        }
      ]);
    });
  });

  describe('given a valid object name with no animations', () => {
    it('returns a valid empty array', () => {
      expect(getBrollAnimationOverrides('Rectangle_1234')).toEqual([])
    });
  });
});
