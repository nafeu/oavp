float normalMouseX;
float normalMouseY;
boolean newMovieFrame;

float globalSpeed = 0.01;

final float PHI = 1.618;

float oscillate(float start, float end, float speed) {
  return map(sin(frameCount * speed), -1, 1, start, end);
}

float modifierSine(float speed) {
  return map(sin(frameCount * speed), -1, 1, 0, 1);
}

float modifierSquare(float speed) {
  float x = frameCount * speed;

  x /= TWO_PI;
  x -= int(x);

  return x < .5? -1 : 1;
}

float modifierTriangle(float speed) {
  return map(sin(frameCount * speed), -1, 1, 0, 1);
}

float modifierSawtooth(float speed) {
  float x = frameCount * speed;

  x /= TWO_PI;
  x -= int(x);

  return x;
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

float getNormalX(float x) {
  return map(x, 0, width, 0, 1);
}

float getNormalY(float x) {
  return map(x, 0, height, 0, 1);
}

float arrayAverage(float... arr) {
  float sum = 0;
  for (float f: arr) sum += f;
  return sum/arr.length;
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

int snap(int x, int grid) {
  return x % grid == 0 ? x : x - (x % grid);
}

float snap(float x, float grid) {
  return x % grid == 0 ? x : x - (x % grid);
}

public boolean isNumber(String str){
  int i=0, len=str.length();
  boolean a=false,b=false,c=false, d=false;
  if(i<len && (str.charAt(i)=='+' || str.charAt(i)=='-')) i++;
  while( i<len && isDigit(str.charAt(i)) ){ i++; a=true; }
  if(i<len && (str.charAt(i)=='.')) i++;
  while( i<len && isDigit(str.charAt(i)) ){ i++; b=true; }
  if(i<len && (str.charAt(i)=='e' || str.charAt(i)=='E') && (a || b)){ i++; c=true; }
  if(i<len && (str.charAt(i)=='+' || str.charAt(i)=='-') && c) i++;
  while( i<len && isDigit(str.charAt(i)) ){ i++; d=true;}
  return i==len && (a||b) && (!c || (c && d));
}

boolean isDigit(char c){
  return c>='0' && c<='9';
}

// @question Do we want this to always run after an exception? If so then we
// can remove exit() call since that's handled by the entry function.
// @answer calling exit() prevents the Java Applet from hanging in the background
// after an exception is thrown, otherwise you have to manually end process
void debugError(Exception e) {
  StackTraceElement element = e.getStackTrace()[0];
  println(e.toString() + " @ " + element);
  /*
   * @improve This can fail if the build-tmp folder doesn't exist. Maybe we
   * have to call sketchPath() outside of setup() to find the build location.
   * There may also be some Java function that returns this path.
   *
   */
  // TODO: Improve stack trace and error handling
  // String[] source = loadStrings("../build-tmp/source/src.java");
  // int lineNumber = element.getLineNumber();
  // if (element.getFileName() == "src.java") {
  //   println(lineNumber + ":" + source[lineNumber - 1]);
  // }
  println("---");
  exit();
}

public static boolean inArray(String[] arr, String targetValue) {
  return Arrays.asList(arr).contains(targetValue);
}

int getRandomInt(int max) {
  return (int) random(max);
}

int coinFlip() {
  if (random(1) > .5) {
    return -1;
  }

  return 1;
}

boolean maybe() {
  return random(1) > .5;
}
