const FileType = require('file-type');
const { CASES } = require('./config');
let mode = 'mt';
if (process.argv.length > 2) {
  mode = process.argv[2];
}

require('events').EventEmitter.defaultMaxListeners = 64;

const { getCore, ffmpeg } = require('./utils')(mode);

(async () => {
  for (let i = 0; i < CASES.length; i++) {
    const { name, args, dirs = [], input, output, st } = CASES[i];
    if (mode === 'st' && st === false) { continue; }
    const core = await getCore();
    for (let i = 0; i < dirs.length; i++) {
      await core.FS.mkdir(dirs[i]);
    }
    for (let i = 0; i < input.length; i++) {
      const { name, data } = input[i];
      await core.FS.writeFile(name, data);
    }
    await ffmpeg({ core, args });
    for (let i = 0; i < output.length; i++) {
      const data = await core.FS.readFile(output[i].name);
      const { mime } = await FileType.fromBuffer(data);
      console.log(name, mime);
    }
    try {
      await core.exit();
    } catch(e) {}
  }
})();
