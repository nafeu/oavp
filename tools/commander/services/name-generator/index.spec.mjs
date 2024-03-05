import { generateName, getFormattedSketchName } from './index.mjs'

describe('generateName', () => {
  it('returns a valid name', () => {
    const result = generateName();

    expect(result).not.toBe('');
  })
});

describe('getFormattedSketchName', () => {
  it('returns a valid sketch name', () => {
    const result = getFormattedSketchName({ name: 'This is a lOnG naME' })

    expect(result).toEqual('this_is_a_long_name');
  });
});
