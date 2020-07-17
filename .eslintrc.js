module.exports = {
  env: {
    browser: true,
    es2020: true,
    jquery: true,
  },
  extends: [
    'airbnb-base',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 11,
    sourceType: 'module',
  },
  plugins: [
    '@typescript-eslint',
  ],
  rules: {
    'arrow-body-style': ['warn', 'always'],
    'arrow-parens': ['warn', 'as-needed'],
    camelcase: 'warn',
    'comma-dangle': ['warn', 'always-multiline'],
    'dot-notation': 'warn',
    'import/extensions': 'warn',
    'import/no-unresolved': 'warn',
    'max-len': 'warn',
    'no-use-before-define': 'warn',
    'object-curly-newline': ['warn', { multiline: true }],
    'object-shorthand': 'warn',
  },
};
