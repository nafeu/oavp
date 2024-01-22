import { buildSketchDataObject } from './helpers.mjs'
import {
  EXAMPLE_SKETCH_FILE,
  EXAMPLE_SKETCH_DATA_OBJECT
} from './constants.mjs'

const mockGetColorNameByHex = jest.fn().mockReturnValue('red');
const mockGenerateSketchName = jest.fn().mockReturnValue('Example Sketch Name');
const mockGetSketchId = jest.fn().mockReturnValue('00001');

describe('buildSketchDataObject', () => {
  describe('given a valid sketch file, upon building a sketch data object', () => {
    const sketchFileContent = EXAMPLE_SKETCH_FILE;

    const result = buildSketchDataObject({
      sketchFileContent,
      _generateSketchName: mockGenerateSketchName,
      _getColorNameByHex: mockGetColorNameByHex,
      _getSketchId: mockGetSketchId
    });

    // { name, date, seed, colors, tags, id, objects }

    it('returns a valid name', () => {
      expect(mockGenerateSketchName).toHaveBeenCalled();
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
      expect(mockGetSketchId).toHaveBeenCalled();
      expect(result.id).toEqual(EXAMPLE_SKETCH_DATA_OBJECT.id);
    });

    it('returns valid objects', () => {
      expect(result.objects).toEqual(EXAMPLE_SKETCH_DATA_OBJECT.objects);
    });

    it('returns valid colors', () => {
      expect(result.colors).toEqual(EXAMPLE_SKETCH_DATA_OBJECT.colors);
    });
  })
});
