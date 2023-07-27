const fs = require('fs');
const path = require('path');
const { TIMEOUT } = require('./config');
const { getCore,ffmpeg } = require('./utils')('mt');
const IN_FILE_NAME = 'video-1s.avi';
const OUT_FILE_NAME = 'video.mkv';
const FILE_SIZE = 38372;
let aviData = null;

beforeAll(() => {
  aviData = Uint8Array.from(fs.readFileSync(path.join(__dirname, 'data', IN_FILE_NAME)));
});

/*
 * Cannot complete this test as transcoding is extremely slow.
 */
test.skip('transcode avi to av1', async () => {
  const core = await getCore('core');
  core.FS.writeFile(IN_FILE_NAME, aviData);
  const args = ['-i', IN_FILE_NAME, '-c:v', 'libaom-av1', '-crf', '48', '-b:v', '0' , '-strict', 'experimental', '-tiles', '2x2', '-row-mt', '1', OUT_FILE_NAME];
  await ffmpeg({core, args});
  const data = await core.FS.readFile(OUT_FILE_NAME);
  expect(data.length).toBe(FILE_SIZE);
}, TIMEOUT);
