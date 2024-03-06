import { getPrintSizeOptions } from './index.mjs'
import { EXAMPLE_SKETCH_DATA_OBJECT } from '../filewatch-event-handlers/constants.mjs'

describe('getPrintSizeOptions', () => {
  describe('given a valid sketchDataObject', () => {
    it('returns a valid encoded string of print size options (for package script)', () => {
      const result = getPrintSizeOptions(EXAMPLE_SKETCH_DATA_OBJECT);

      expect(result).toEqual(["1680", "2400", "2220", "2112", "2143", "2308"]);
    });
  })
});
