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

// @question Do we want this to always run after an exception? If so then we
// can remove exit() call since that's handled by the entry function.
void debugError(Exception e) {
  try {
    StackTraceElement element = e.getStackTrace()[0];
    int lineNumber = element.getLineNumber();
    // @improve This can fail if the build-tmp folder doesn't exist. Maybe we
    // have to call sketchPath() outside of setup() to find the build location.
    // There may also be some Java function that returns this path.
    String[] source = loadStrings("../build-tmp/source/src.java");
    println(e.toString() + " @ " + element);
    if (element.getFileName() == "src.java") {
      println(lineNumber + ":" + source[lineNumber - 1]);
    }
  } catch (Exception bad) {
    println("[ oavp ] debugError() failed!");
  }
  println("---");
  exit();
}
