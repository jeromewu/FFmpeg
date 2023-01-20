/**
 *  Replace Moudle['quit'] to avoid process.exit();
 *
 *  @ref: https://github.com/Kagami/ffmpeg.js/blob/v4.2.9003/build/pre.js#L48
 */
Module['quit'] = function(status) {
  if (Module["onExit"]) Module["onExit"](status);
  throw new ExitStatus(status);
}