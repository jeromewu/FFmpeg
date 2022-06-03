const parseArgs = require('../parseArgs');
let resolve = null;

const ffmpeg = ({ core, args }) => new Promise((_resolve) => {
  core.ccall(
    'proxy_main',  // use emscripten_proxy_main if emscripten upgraded
    'number',
    ['number', 'number'],
    parseArgs(core, ['ffmpeg', '-hide_banner', '-nostdin', ...args]),
  );
  resolve = _resolve;

});

const getCore = (corename) => (
  require(`../../../packages/${corename}/dist/ffmpeg-core`)({
    printErr: () => {},
    print: (m) => {
      if (m.startsWith('FFMPEG_END')) {
        resolve();
      }
    },
  })
);

module.exports = {
  ffmpeg,
  getCore,
};
