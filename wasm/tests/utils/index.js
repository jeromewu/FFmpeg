const mt = require('./mt');
const st = require('./st');
const b64ToUint8Array = require('./b64ToUint8Array');

module.exports = (v) => {
  const pkg = v === 'st' ? st : mt;
  return {
    b64ToUint8Array,
    ...pkg,
  }
};
