const { Worker } = require('worker_threads');
const path = require('path');

const getCore = async (corename) => {
  const resolves = {};
  let resolveExit = null;
  let _id = 0;
  const getID = () => _id++;
  const worker = new Worker(path.join(__dirname, 'worker.js'));
  const getHandler = (payload) => new Promise((resolve) => {
    const id = getID();
    worker.postMessage({ id, ...payload });
    resolves[id] = resolve;
  });
  
  worker.on('message', ({ id, data }) => {
    resolves[id](data);
  });

  worker.on('exit', () => {
    resolveExit();
  });

  await getHandler({ type: 'LOAD', corename });
  await getHandler({ type: 'INIT' });

  return {
    getHandler,
    exit: () => new Promise((resolve) => {
      worker.terminate();
      resolveExit = resolve;
    }),
    FS: ['mkdir', 'writeFile', 'readFile'].reduce((acc, cmd) => {
      acc[cmd] = (...args) => getHandler({ type: 'FS', cmd, args });
      return acc;
    }, {}),
  }
};

module.exports = {
  getCore,
  ffmpeg: ({ core, args }) => core.getHandler({ type: 'RUN', args }),
};
