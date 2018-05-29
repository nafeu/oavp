float normalMouseX;
float normalMouseY;

float oscillate(float start, float end, float speed) {
  return map(sin(frameCount * speed), -1, 1, start, end);
}

float refinedNoise(float phase, float granularity) {
  return noise(phase * granularity);
}

int quantizedNoise(float phase, float granularity, int variance) {
  return int(noise(phase * granularity) * variance);
}

void updateHelpers() {
  normalMouseX = map(mouseX, 0, width, 0, 1);
  normalMouseY = map(mouseY, 0, height, 0, 1);
}