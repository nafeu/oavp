module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/*.spec.mjs'],
  transform: {
    '^.+\\.m?js$': 'babel-jest',
  }
};
