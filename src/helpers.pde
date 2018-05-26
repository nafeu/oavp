float oscillate(float start, float end, float speed) {
  return map(sin(frameCount * speed), -1, 1, start, end);
}