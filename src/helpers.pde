float oscillate(float start, float end, float speed) {
  return map(sin(frameCount * speed), -1, 1, start, end);
}

float refinedNoise(int index, float phase, float granularity) {
  return noise((index + phase) * granularity);
}

int quantizedNoise(int index, float phase, float granularity, int limit) {
  return int(noise((index + phase) * granularity) * limit);
}