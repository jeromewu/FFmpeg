# Optimization Flags

Statistics of using different flags to optimize code:

| flags | build time | execution time | ffmpeg-core.js size | ffmpeg-core.wasm size | ffmpeg.worker.js size |
| ----- | ---------- | ---------------| ------------------- | --------------------- | --------------------- |
| N/A                   | 6m 19s  | 7.5s | 584,269 bytes | 30,406,730 bytes | 9,048 bytes |
| -Oz                   | 7m 40s  | 6s   | 295,674 bytes | 14,919,062 bytes | 3,363 bytes |
| -O3                   | 8m 36s  | 5s   | 295,676 bytes | 17,746,341 bytes | 3,363 bytes |
| -O3 --closure=1       | 10m 20s | 5s   | 142,076 bytes | 17,746,766 bytes | 3,624 bytes |
| -O3 --closure=1 -flto | 12m 36s | 5s   | 141,516 bytes | 18,960,830 bytes | 3,624 bytes |

The best one to use in case of performance is `-O3 --closure=1`.
