module.exports = {
  env: {
    browser: true,
    es2020: true,
    jquery: true,
    jest: true,
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
    '@typescript-eslint/no-unused-vars': 'error',
    'arrow-body-style': ['warn', 'always'],
    'arrow-parens': ['warn', 'as-needed'],
    camelcase: 'warn',
    'comma-dangle': ['warn', 'always-multiline'],
    'dot-notation': 'warn',
    'import/extensions': 'off',
    'import/no-unresolved': 'off',
    'lines-between-class-members': ['warn', 'always', { exceptAfterSingleLine: true }],
    'max-len': 'warn',
    'no-use-before-define': 'warn',
    'no-unused-vars': 'off',
    'object-curly-newline': ['warn', { multiline: true }],
    'object-shorthand': 'warn',
    'prefer-destructuring': 'warn',
  },
};
