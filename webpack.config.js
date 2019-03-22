const path = require('path');

const env = process.env.NODE_ENV === 'production';

module.exports = {
  entry: {
    app: './src/app.bs.js'
  },
  mode: env ? 'production' : 'development',
  output: {
    path: path.join(__dirname, 'dist'),
    filename: '[name].js'
  }
};
