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

// float[] generateProgression(Object endValueObject, int n) {
//   float endValue = convertToFloat(endValueObject);

//   float[] progression = new float[n];
//   float increment = endValue / (n - 1);

//   for (int i = 0; i < n; i++) {
//     progression[i] = increment * i;
//     if (progression[i] % 2 != 0) {
//       progression[i]--; // Ensure the number is even
//     }
//   }

//   progression[n - 1] = endValue; // Set the last element to x

//   return progression;
// }

float[] generateProgression(Object inputStartingValue, Object inputEndingValue, int stepCount) {
  float startingValue = convertToFloat(inputStartingValue);
  float endingValue = convertToFloat(inputEndingValue);

  float[] progression = new float[stepCount];
  float increment = (endingValue - startingValue) / (stepCount - 1);

  for (int i = 0; i < stepCount; i++) {
    float linearValue = startingValue + (increment * i);
    float progressionValue;

    if (i < stepCount / 2) {
      progressionValue = linearValue;
    } else {
      float progressRatio = (float) i / (stepCount - 1);
      float ratioModifier = (float) Math.sin(Math.PI * progressRatio);
      progressionValue = linearValue + (increment * ratioModifier);
    }

    progression[i] = progressionValue;
  }

  return progression;
}

int[] generateRandomProgression(int x, int n) {
  int[] progression = new int[n];
  Random random = new Random();
  double increment = (double) x / (n - 1);

  for (int i = 0; i < n; i++) {
    progression[i] = (int)(increment * i);
    if (progression[i] % 2 != 0) {
      progression[i]--; // Ensure the number is even
    }
  }

  // Randomize the differences in the increments
  for (int i = 1; i < n - 1; i++) {
    int diff = random.nextInt(3) * 2; // Random even difference: 0, 2, or 4
    progression[i] += diff;
  }

  progression[n - 1] = x; // Set the last element to x
  return progression;
}

float convertToFloat(Object obj) {
  if (obj instanceof Float) {
    return (Float) obj;
  } else if (obj instanceof Integer) {
    return ((Integer) obj).floatValue();
  } else {
    throw new IllegalArgumentException("Unsupported type: " + obj.getClass());
  }
}

int convertToInt(Object obj) {
  if (obj instanceof Integer) {
    return (Integer) obj;
  } else if (obj instanceof Float) {
    return Math.round((Float) obj);
  } else {
    throw new IllegalArgumentException("Unsupported type: " + obj.getClass());
  }
}

int getRandomIntInRange(int min, int max) {
  Random random = new Random();
  return random.nextInt((max - min) + 1) + min;
}

void shuffleArray(int[] array) {
  for (int i = array.length - 1; i > 0; i--) {
    int index = floor(random(i + 1));
    int temp = array[i];
    array[i] = array[index];
    array[index] = temp;
  }
}

String[] colorsToHexStrings(color[] colorArray) {
  String[] hexStrings = new String[colorArray.length];

  for (int i = 0; i < colorArray.length; i++) {
    hexStrings[i] = "#" + hex(colorArray[i], 6);
  }

  return hexStrings;
}

boolean isColorsArrayEqual(String[] arrayA, String[] arrayB) {
  String[] sortedArrayA = new String[arrayA.length];
  String[] sortedArrayB = new String[arrayB.length];

  arrayCopy(arrayA, sortedArrayA);
  arrayCopy(arrayB, sortedArrayB);
  sortedArrayA = sort(sortedArrayA);
  sortedArrayB = sort(sortedArrayB);

  if (sortedArrayA.length != sortedArrayB.length) {
    return false;
  }

  for (int i = 0; i < sortedArrayA.length; i++) {
    if (!sortedArrayA[i].equals(sortedArrayB[i])) {
      return false;
    }
  }

  return true;
}

color getRandomColor(color[] colorArray) {
  if (colorArray.length > 0) {
    int randomIndex = int(random(colorArray.length));
    return colorArray[randomIndex];
  } else {
    return color(0);
  }
}

void setSketchSeed(int seedValue) {
  SEED = seedValue;
  randomSeed(seedValue);
  noiseSeed(seedValue);
  RANDOM_HUNDRED = getRandomNumbers(100);
}

void closeApplication() {
  shouldExit = true;
}

void enableRecording() {
  isRecording = true;
}
