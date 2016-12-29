const pathExists = require('path-exists');
const chalk = require('chalk');
const webpack = require('webpack');
const WebpackDevServer = require('webpack-dev-server');
const config = require('../config/webpack.config.dev');
const formatWebpackMessages = require('react-dev-utils/formatWebpackMessages');
const clearConsole = require('react-dev-utils/clearConsole');
const openBrowser = require('react-dev-utils/openBrowser');

process.env.NODE_ENV = 'development';

if (pathExists.sync('elm-package.json') === false) {
  console.log('Please, run the build script from project root directory');
  process.exit(0);
}

//console.log('DEBUG: Output path is ' + config.output.path );
//console.log('DEBUG: current PWD is ' + process.env.PWD);
//console.log('DEBUG: current TMPDIR is ' + process.env.TMPDIR);
if ('/code' == process.env.TMPDIR) {
  console.log('DEBUG: overriding $TMPDIR from /code to /tmp from start.js');
  process.env.TMPDIR = '/tmp';
  console.log('DEBUG: current TMPDIR is ' + process.env.TMPDIR);
}

// http://webpack.github.io/docs/node.js-api.html#the-long-way
var compiler = webpack(config);
var port = 2015;

compiler.plugin('invalid', function () {
  clearConsole();
  console.log('Compiling...');
});

compiler.plugin('done', function (stats) {
  clearConsole();

  var hasErrors = stats.hasErrors();
  var hasWarnings = stats.hasWarnings();

  if (!hasErrors && !hasWarnings) {

    console.log(chalk.green('Compiled successfully!'));
    console.log('\nThe app is running at:');
    console.log('\n    ' + chalk.cyan('http://localhost:' + port + '/'));
    console.log('\nTo create production build, run:');
    console.log('\n    elm-app build');
    return;
  }

  if (hasErrors) {
    console.log(chalk.red('Compilation failed.\n'));

    var json = formatWebpackMessages(stats.toJson({}, true));

    json.errors.forEach(function (message) {
      console.log(message);
      console.log();
    });
  }
});

const devServer = new WebpackDevServer(compiler, {
  hot: true,
  inline: true,
  publicPath: '/',
  quiet: true
});

// Launch WebpackDevServer.
devServer.listen(port, function (err) {
  if (err) {
    return console.log(err);
  }
});

openBrowser('http://localhost:' + port + '/');
