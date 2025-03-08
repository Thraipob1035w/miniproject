module.exports = {
  env: {
    es6: true,
    node: true,
  },
  parserOptions: {
    ecmaVersion: 2018,
  },
  extends: [
    'eslint:recommended',
    'google',
  ],
  rules: {
    'no-restricted-globals': ['error', 'name', 'length'],
    'prefer-arrow-callback': 'error',
    'quotes': ['error', 'double', { 'allowTemplateLiterals': true }],
    'object-curly-spacing': ['error', 'always'],  // แก้ไขให้มีช่องว่างภายใน { }
    'max-len': ['error', { 'code': 80 }],  // จำกัดความยาวบรรทัดไม่เกิน 80 ตัวอักษร
  },
  overrides: [
    {
      files: ['**/*.spec.*'],
      env: {
        mocha: true,
      },
      rules: {},
    },
  ],
  globals: {},
};
