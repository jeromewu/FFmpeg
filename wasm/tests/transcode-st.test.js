const base = require('./transcode-base');
base('st','core-st');
base('st','core-st.mp4-scale',(name) => name == 'mp4 scale');
base('st','core-st.png-to-mp4',(name) => name == 'png to mp4');
