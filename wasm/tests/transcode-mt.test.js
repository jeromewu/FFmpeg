const base = require('./transcode-base');
base('mt','core');
base('mt','core.mp4-scale',(name) => name == 'mp4 scale');
base('mt','core.png-to-mp4',(name) => name == 'png to mp4');
