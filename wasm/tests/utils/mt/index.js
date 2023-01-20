const parseArgs = require("../parseArgs");
let resolve = null;

const ffmpeg = ({ core, args }) =>
  new Promise((_resolve) => {
    core.ccall(
      "_emscripten_proxy_main",
      "number",
      ["number", "number"],
      parseArgs(core, ["ffmpeg", "-hide_banner", "-nostdin", ...args])
    );
    resolve = _resolve;
  });

const getCore = (corename) =>
  require(`../../../packages/${corename}/dist/ffmpeg-core`)({
    noExitRuntime: true,
    printErr: () => {},
    print: (m) => {
      if (m === "FFMPEG_END") {
        setTimeout(resolve,1000); // otherwise wasm will not close correctly when run with jest
      }
    },
  });

module.exports = {
  ffmpeg,
  getCore,
};
