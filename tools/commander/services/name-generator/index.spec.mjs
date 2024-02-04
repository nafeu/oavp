import { generateName } from './index.mjs'

describe('generateName', () => {
  it('returns a valid name', () => {
    const result = generateName();

    expect(result).not.toBe('');
  })
});
