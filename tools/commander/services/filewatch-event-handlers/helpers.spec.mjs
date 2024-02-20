import { buildSketchDataObject, getAnimationOverrides } from './helpers.mjs'
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
  })
});

describe('getAnimationOverrides', () => {
  describe('given a valid object name with one animation', () => {
    it('returns a valid set of animation overrides', () => {
      expect(getAnimationOverrides('Rectangle_anim^z^-^normal_1234')).toEqual([
        { property: 'zMod', value: -3000 },
        { property: 'zModType', value: 'b-roll' },
      ]);

      expect(getAnimationOverrides('Rectangle_anim^z^-^faster_1234')).toEqual([
        { property: 'zMod', value: -5000 },
        { property: 'zModType', value: 'b-roll' },
      ]);

      expect(getAnimationOverrides('Rectangle_anim^z^-^slower_1234')).toEqual([
        { property: 'zMod', value: -1000 },
        { property: 'zModType', value: 'b-roll' },
      ]);
    });
  });

  describe('given a valid object name with no animations', () => {
    it('returns a valid empty array', () => {
      expect(getAnimationOverrides('Rectangle_1234')).toEqual([])
    });
  });

  describe('given a valid object name with multiple animations', () => {
    it('returns a valid set of animation overrides', () => {
      expect(getAnimationOverrides('Rectangle_anim^z^-^normal_anim^x^+^slower_1234')).toEqual([
        { property: 'zMod', value: -3000 },
        { property: 'zModType', value: 'b-roll' },
        { property: 'xMod', value: 1000 },
        { property: 'xModType', value: 'b-roll' }
      ]);
    });
  });
});
