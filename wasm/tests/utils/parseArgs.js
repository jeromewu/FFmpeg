module.exports = (core, args) => {
  const argsPtr = core._malloc(args.length * Uint32Array.BYTES_PER_ELEMENT);
  args.forEach((s, idx) => {
    const buf = core._malloc(s.length + 1);
    core.writeAsciiToMemory(s, buf);
    core.setValue(argsPtr + (Uint32Array.BYTES_PER_ELEMENT * idx), buf, 'i32');
  });
  return [args.length, argsPtr];
};
