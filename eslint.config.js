/** @type {import('eslint').Linter.Config} */
module.exports = [
    {
      languageOptions: {
        parserOptions: {
          ecmaVersion: 2018,
        },
        globals: {
          // กำหนด global variables ถ้ามี
          // ตัวอย่าง:
          // myGlobalVar: "readonly",
        },
      },
      plugins: {
        // ใส่ plugin ที่ต้องการใช้งานในรูปแบบนี้
        // ตัวอย่าง:
        // myplugin: require('eslint-plugin-myplugin'),
      },
      rules: {
        "no-restricted-globals": ["error", "name", "length"],
        "prefer-arrow-callback": "error",
        "quotes": ["error", "double", { "allowTemplateLiterals": true }],
        "max-len": ["error", { "code": 80 }],
      },
    },
    {
      files: ["**/*.spec.*"],
      languageOptions: {
        globals: {
          mocha: "readonly",
        },
      },
      rules: {},
    },
  ];
  