import { getNamesByColorPalette } from './index.mjs'

describe('getNamesByColorPalette', () => {
  describe('given a valid color palette', () => {
    const exampleColors = {
      "background": {
        "int": -10564128,
        "value": "#5ECDE0"
      },
      "accentA": {
        "int": -3866679,
        "value": "#C4FFC9"
      },
      "accentB": {
        "int": -6381922,
        "value": "#9E9E9E"
      },
      "accentC": {
        "int": -2039584,
        "value": "#E0E0E0"
      },
      "accentD": {
        "int": -16711694,
        "value": "#00FFF2"
      }
    }

    const validNames = [
      'aqua',
      'aquamarine',
      'beige',
      'cyan / aqua',
      'cyan',
      'darkgray',
      'darkgrey',
      'gainsboro',
      'granny smith apple',
      'gray',
      'madang',
      'mercury',
      'robin egg blue',
      'sky blue',
      'skyblue',
      'star dust',
      'timberwolf',
      'turquoise',
      'viking',
      'white'
    ]

    const result = getNamesByColorPalette(exampleColors);

    it('returns a set of valid color names', () => {
      expect(result.every(item => validNames.includes(item))).toBe(true);
      expect(result.sort()).toEqual(validNames.filter(item => result.includes(item)).sort());
    });
  })
});
