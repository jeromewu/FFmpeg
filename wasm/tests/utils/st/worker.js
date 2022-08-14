const { parentPort } = require('worker_threads');
const createFFmpegCore = require('../../../packages/core-st/dist/ffmpeg-core');
const parseArgs = require('../parseArgs');
let core = null;

parentPort.on('message', async ({ id, type, cmd, args }) => {
  switch(type) {
    case 'INIT':
      core = await createFFmpegCore({
        printErr: () => {},
        print: () => {},
      });
      parentPort.postMessage({ id, type: 'INIT' });
      break;
    case 'FS':
      const blocklist = ['mkdir']
      const data = core.FS[cmd](...args);
      parentPort.postMessage({ id, type: 'FS', data: !blocklist.includes(cmd) ? data : null});
      break;
    case 'RUN':
      try {
        core.ccall(
          'main',
          'number',
          ['number', 'number'],
          parseArgs(core, ['ffmpeg', '-hide_banner', '-nostdin', ...args]),
        )
      } catch(e) {}
      parentPort.postMessage({ id, type: 'RUN' });
      break;
    default:
      console.log('unknown message type: ', type);
  }
});
