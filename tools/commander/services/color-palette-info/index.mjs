import getColorName from 'color-namer';
import _ from 'lodash';

const COLOR_SETS = ['basic', 'html', 'ntc', 'pantone', 'x11'];

export const getNamesByColorPalette = colors => {
  const output = Object.keys(colors).map(color => {
    const colorNames = getColorName(colors[color].value);

    return colorNames[_.sample(COLOR_SETS)][0].name.toLowerCase();
  });

  return output;
}
