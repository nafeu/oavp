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

float castBoolean(boolean bool, float valTrue, float valFalse) {
  if (bool) {
    return valTrue;
  }
  return valFalse;
}

void updateHelpers() {
  normalMouseX = map(mouseX, 0, width, 0, 1);
  normalMouseY = map(mouseY, 0, height, 0, 1);
}

float floorPosDiff(float pos) {
  float out = pos - floor(pos);
  return out;
}

float frameCount(float scale) {
  return frameCount * scale;
}

String getFileExtension(File file) {
    if (file == null) {
        return "";
    }
    String name = file.getName();
    int i = name.lastIndexOf('.');
    String ext = i > 0 ? name.substring(i + 1) : "";
    return ext;
}

color opacity(color c, float alpha) {
  color out = color(red(c), green(c), blue(c), alpha * 255);
  return out;
}