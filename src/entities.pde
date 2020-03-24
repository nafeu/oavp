public class OavpPulser {
  private float value = 0;
  private float duration = 1;
  private Easing easing = Ani.QUAD_IN_OUT;
  private Ani ani;

  OavpPulser() {}

  public OavpPulser duration(float duration) {
    this.duration = duration;
    return this;
  }

  public OavpPulser easing(Easing easing) {
    this.easing = easing;
    return this;
  }

  public float getValue() {
    return value;
  }

  public void pulse() {
    value = 1;
    ani = Ani.to(this, duration, "value", 0, easing);
  }

  public void pulseIf(boolean trigger) {
    if (trigger) {
      pulse();
    }
  }
}

public class OavpInterval {
  private float[][] intervalData;
  private int storageSize;
  private int snapshotSize;
  private int frameDelayCount = 0;
  private int delay = 1;
  private float averageWeight = 1;

  OavpInterval(int storageSize, int snapshotSize) {
    this.storageSize = storageSize;
    this.snapshotSize = snapshotSize;
    intervalData = new float[storageSize][snapshotSize];
  }

  public OavpInterval delay(int delay) {
    this.delay = delay;
    return this;
  }

  public OavpInterval averageWeight(float averageWeight) {
    this.averageWeight = averageWeight;
    return this;
  }

  public void update(float[] snapshot) {
    if (frameDelayCount == delay) {
      float[][] temp = new float[storageSize][snapshotSize];
      for (int i = 1; i < storageSize; i++) {
        temp[i] = intervalData[i - 1];
      }
      for (int j = 0; j < snapshotSize; j++) {
        temp[0][j] = snapshot[j];
      }
      intervalData = temp;
      frameDelayCount = 0;
    } else {
      frameDelayCount++;
    }
  }

  public void update(float snapshot) {
    if (frameDelayCount == delay) {
      float[][] temp = new float[storageSize][snapshotSize];
      for (int i = 1; i < storageSize; i++) {
        temp[i] = intervalData[i - 1];
      }
      temp[0][0] = average(snapshot, temp[1][0], averageWeight);
      intervalData = temp;
      frameDelayCount = 0;
    } else {
      frameDelayCount++;
    }
  }

  public void update(boolean rawSnapshot) {
    float snapshot;
    if (rawSnapshot) {
      snapshot = 1.0;
    } else {
      snapshot = 0.0;
    }
    if (frameDelayCount == delay) {
      float[][] temp = new float[storageSize][snapshotSize];
      for (int i = 1; i < storageSize; i++) {
        temp[i] = intervalData[i - 1];
      }
      temp[0][0] = snapshot;
      intervalData = temp;
      frameDelayCount = 0;
    } else {
      frameDelayCount++;
    }
  }

  public float[] getIntervalData(int i) {
    return intervalData[i];
  }

  public int getIntervalSize() {
    return intervalData.length;
  }

  private float average(float a, float b, float weight) {
    return (a + (weight * b)) / (1 + weight);
  }

  private float average(float a, float b) {
    return (a + b) / 2;
  }
}

public class OavpGridInterval {
  private float[][] data;
  private int numRows;
  private int numCols;
  private int frameDelayCount = 0;
  private int delay = 1;
  private float averageWeight = 1;

  OavpGridInterval(int numRows, int numCols) {
    this.numRows = numRows;
    this.numCols = numCols;
    data = new float[numRows][numCols];
  }

  public OavpGridInterval delay(int delay) {
    this.delay = delay;
    return this;
  }

  public OavpGridInterval averageWeight(float averageWeight) {
    this.averageWeight = averageWeight;
    return this;
  }

  public void update(float value) {
    if (frameDelayCount == delay) {
      float[][] temp = new float[numRows][numCols];
      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < numCols; j++) {
          if (i == 0 && j == 0) {
            temp[i][j] = average(value, data[i][j + 1], averageWeight);
          }
          else if (j == 0) {
            temp[i][j] = data[i - 1][numCols - 1];
          }
          else {
            temp[i][j] = data[i][j - 1];
          }
        }
      }
      data = temp;
      frameDelayCount = 0;
    } else {
      frameDelayCount++;
    }
  }

  public void updateDiagonal(float value) {
    if (frameDelayCount == delay) {
      float[][] temp = new float[numRows][numCols];
      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < numCols; j++) {
          if (i == 0 && j == 0) {
            temp[i][j] = average(value, data[i][j + 1], averageWeight);
          }
          else {
            if (i < j) {
              temp[i][j] = data[i][j - 1];
            } else if (i > j) {
              temp[i][j] = data[i - 1][j];
            } else {
              // This one can be in either direction
              temp[i][j] = data[i][j - 1];
            }
          }
        }
      }
      data = temp;
      frameDelayCount = 0;
    } else {
      frameDelayCount++;
    }
  }

  public void updateDimensional(float value) {
    if (frameDelayCount == delay) {
      float[][] temp = new float[numRows][numCols];
      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < numCols; j++) {
          if (j == 0) {
            temp[i][j] = average(value, data[i][j], averageWeight);
          } else {
            temp[i][j] = data[i][j - 1];
          }
        }
      }
      data = temp;
      frameDelayCount = 0;
    } else {
      frameDelayCount++;
    }
  }

  public float getData(int i, int j) {
    return data[i][j];
  }

  public int getNumCols() {
    return numCols;
  }

  public int getNumRows() {
    return numRows;
  }

  private float average(float a, float b, float weight) {
    return (a + (weight * b)) / (1 + weight);
  }
}

public class OavpEmission {
  public float value = 0;
  private final float target = 1;
  public float[] payload;
  public boolean isDead = false;

  OavpEmission(float duration, Easing easing) {
    start(duration, easing);
  }

  OavpEmission(float duration, Easing easing, float[] payload) {
    this.payload = payload;
    start(duration, easing);
  }

  private void start(float duration, Easing easing) {
    Ani.to(this, duration, "value", target, easing);
  }

  public void update() {
    if (value == target) {
      isDead = true;
    }
  }
}

public class OavpRhythm {
  private AudioOutput out;
  private BeatDetect beat;
  private boolean isPlaying;
  private float tempo = 60;
  private float rhythm = 1;
  private int limit = 1000;
  private int sensitivity = 100;
  private Minim minim;

  OavpRhythm(Minim minim) {
    this.minim = minim;
    this.rhythm = rhythm;
    beat = new BeatDetect();
    beat.setSensitivity(sensitivity);
  }

  public OavpRhythm duration(float duration) {
    this.tempo = 60 / duration;
    return this;
  }

  public OavpRhythm tempo(float tempo) {
    this.tempo = tempo;
    return this;
  }

  public OavpRhythm rhythm(float rhythm) {
    this.rhythm = rhythm;
    return this;
  }

  public OavpRhythm limit(int limit) {
    this.limit = limit;
    return this;
  }

  public OavpRhythm sensitivity(int sensitivity) {
    this.sensitivity = sensitivity;
    return this;
  }

  public void start() {
    out = minim.getLineOut();
    out.setTempo(tempo);
    out.pauseNotes();
    for (int i = 0; i < limit; ++i) {
      out.playNote(i * rhythm, 0.25, "C3");
    }
    out.resumeNotes();
    isPlaying = true;
    out.mute();
  }

  public void update() {
    beat.detect(out.mix);
  }

  public void toggleNotes() {
    if (isPlaying) {
      out.pauseNotes();
      isPlaying = false;
    } else {
      out.resumeNotes();
      isPlaying = true;
    }
  }

  public boolean onRhythm() {
    return beat.isOnset();
  }

  public void toggleMute() {
    if (out.isMuted()) {
      out.unmute();
    } else {
      out.mute();
    }
  }
}

public class OavpCounter {
  private float value = 0;
  private int count = 0;
  private int limit = 0;
  private Ani ani;
  private float duration = 1;
  private Easing easing = Ani.QUAD_IN_OUT;

  OavpCounter(){}

  public OavpCounter duration(float duration) {
    this.duration = duration;
    return this;
  }

  public OavpCounter easing(Easing easing) {
    this.easing = easing;
    return this;
  }

  public OavpCounter limit(int limit) {
    this.limit = limit;
    return this;
  }

  public void increment() {
    count++;
    ani = Ani.to(this, duration, "value", count, easing);
  }

  public void increment(float duration, Easing easing) {
    count++;
    ani = Ani.to(this, duration, "value", count, easing);
  }

  public void incrementIf(Boolean trigger) {
    if (trigger) {
      increment();
    }
  }

  public void incrementIf(Boolean trigger, float duration, Easing easing) {
    if (trigger) {
      increment(duration, easing);
    }
  }

  public float getValue() {
    return value;
  }

  public int getCount() {
    return count;
  }

  boolean hasFinished() {
    if (count % limit == 0) {
      increment();
      return true;
    }
    return false;
  }
}

public class OavpRotator {
  private float x = 0;
  private float y = 0;
  private float z = 0;
  private List storage;
  private float duration = 1;
  private Easing easing = Ani.QUAD_IN_OUT;
  private int index;
  private Ani aniX;
  private Ani aniY;
  private Ani aniZ;

  OavpRotator(){
    storage = new ArrayList();
  }

  public OavpRotator add(float x) {
    float[] values = new float[3];
    values[0] = x;
    storage.add(values);
    return this;
  }

  public OavpRotator add(float x, float y) {
    float[] values = new float[3];
    values[0] = x;
    values[1] = y;
    storage.add(values);
    return this;
  }

  public OavpRotator add(float x, float y, float z) {
    float[] values = new float[3];
    values[0] = x;
    values[1] = y;
    values[2] = z;
    storage.add(values);
    return this;
  }

  public OavpRotator addCombinations(float start, float end, int granularity) {
    float interpolation = (end - start) / max((granularity - 1), 1);
    for (int i = 0; i < max(granularity, 2); i++) {
      for (int j = 0; j < max(granularity, 2); j++) {
        float values[] = new float[]{i * interpolation, j * interpolation, 0};
        storage.add(values);
      }
    }
    return this;
  }

  public OavpRotator duration(float duration) {
    this.duration = duration;
    return this;
  }

  public OavpRotator easing(Easing easing) {
    this.easing = easing;
    return this;
  }

  public void rotate() {
    int currIndex = index % storage.size();
    index = index + 1 % storage.size();
    float[] values = (float[]) storage.get(currIndex);
    aniX = Ani.to(this, duration, "x", values[0], easing);
    aniY = Ani.to(this, duration, "y", values[1], easing);
    aniZ = Ani.to(this, duration, "z", values[2], easing);
  }

  public void randomize() {
    index = floor(random(0, storage.size())) % storage.size();
    float[] values = (float[]) storage.get(index);
    aniX = Ani.to(this, duration, "x", values[0], easing);
    aniY = Ani.to(this, duration, "y", values[1], easing);
    aniZ = Ani.to(this, duration, "z", values[2], easing);
  }

  public void rotateIf(boolean trigger) {
    if (trigger) {
      rotate();
    }
  }

  public void randomizeIf(boolean trigger) {
    if (trigger) {
      randomize();
    }
  }

  public float getX() {
    return x;
  }

  public float getY() {
    return y;
  }

  public float getZ() {
    return z;
  }
}

public class OavpColorRotator {
  private float value = 0;
  private List storage;
  private color colorA;
  private color colorB;
  private float duration = 1;
  private Easing easing = Ani.QUAD_IN_OUT;
  private int index;
  private Ani ani;

  OavpColorRotator(){
    storage = new ArrayList();
  }

  public OavpColorRotator add(color value) {
    storage.add(value);
    return this;
  }

  public OavpColorRotator add(OavpPalette palette) {
    HashMap<String, color[]> paletteStorage = palette.getStorage();
    for (HashMap.Entry<String, color[]> entry : paletteStorage.entrySet())
    {
      storage.add(entry.getValue()[0]);
    }
    return this;
  }

  public OavpColorRotator displace(int distance) {
    Collections.rotate(storage, distance);
    return this;
  }

  public OavpColorRotator duration(float duration) {
    this.duration = duration;
    return this;
  }

  public OavpColorRotator easing(Easing easing) {
    this.easing = easing;
    return this;
  }

  public void rotate() {
    colorA = (color) storage.get(index % storage.size());
    index = index + 1 % storage.size();
    colorB = (color) storage.get(index % storage.size());
    animate();
  }

  public void randomize() {
    colorA = (color) storage.get(index % storage.size());
    index = floor(random(0, storage.size())) % storage.size();
    colorB = (color) storage.get(index % storage.size());
    animate();
  }

  private void animate() {
    value = 0;
    ani = Ani.to(this, duration, "value", 1, easing);
  }

  public void rotateIf(boolean trigger) {
    if (trigger) {
      rotate();
    }
  }

  public void randomizeIf(boolean trigger) {
    if (trigger) {
      randomize();
    }
  }

  public color getColor() {
    return lerpColor(colorA, colorB, value);
  }
}

public class OavpOscillator {
  private float duration = 1;
  private Easing easing = Ani.QUAD_IN_OUT;
  private Ani ani;
  private float value = 0;

  OavpOscillator(){}

  public OavpOscillator duration(float duration) {
    this.duration = duration;
    return this;
  }

  public OavpOscillator easing(Easing easing) {
    this.easing = easing;
    return this;
  }

  public void start() {
    loop();
  }

  private void loop() {
    if (value == 0) {
      ani = Ani.to(this, duration, "value", 1, easing, "onEnd:loop");
    } else {
      ani = Ani.to(this, duration, "value", 0, easing, "onEnd:loop");
    }
  }

  private void restart() {
    value = 0;
    ani = Ani.to(this, duration, "value", 1, easing, "onEnd:loop");
  }

  public float getValue() {
    return value;
  }

  public float getValue(float start, float end) {
    return map(value, 0, 1, start, end);
  }
}

public class OavpTerrain {
  private float[] values;
  private int[] structures;
  private int size = 10000;
  private float granularity = 0.01;

  OavpTerrain() {
    values = new float[size];
    structures = new int[size];
    generate();
  }

  public OavpTerrain generate() {
    for (int i = 0; i < size; ++i) {
      values[i] = refinedNoise(i, granularity);
    }
    for (int i = 0; i < size; ++i) {
      structures[i] = floor(random(0, 20));
    }
    return this;
  }

  public OavpTerrain granularity(float granularity) {
    this.granularity = granularity;
    return this;
  }

  public OavpTerrain size(int size) {
    this.size = size;
    return this;
  }

  public float[] getValues(float position, int windowSize, int shift) {
    int index = floor(position);
    float[] out = new float[windowSize];
    if (index + windowSize + shift <= size) {
      for (int i = 0; i < windowSize; ++i) {
        out[i] = values[i + index + shift];
      }
      return out;
    } else {
      for (int i = 0; i < windowSize; i++) {
        out[(windowSize - 1) - i] = values[(size - 1) - i];
      }
      return out;
    }
  }

  public float[] getStructures(float position, int windowSize, int shift) {
    int index = floor(position);
    float[] out = new float[windowSize];
    if (index + windowSize + shift <= size) {
      for (int i = 0; i < windowSize; ++i) {
        out[i] = structures[i + index + shift];
      }
      return out;
    } else {
      for (int i = 0; i < windowSize; i++) {
        out[(windowSize - 1) - i] = structures[(size - 1) - i];
      }
      return out;
    }
  }

  public float[][] getWindow(float position, int windowSize, int shift) {
    int index = floor(position);
    float[] valuesWindow = new float[windowSize];
    float[] structuresWindow = new float[windowSize];
    float[][] out = new float[2][windowSize];
    if (index + windowSize + shift <= size) {
      for (int i = 0; i < windowSize; ++i) {
        valuesWindow[i] = values[i + index + shift];
        structuresWindow[i] = structures[i + index + shift];
      }
      out[0] = valuesWindow;
      out[1] = structuresWindow;
      return out;
    } else {
      for (int i = 0; i < windowSize; i++) {
        valuesWindow[(windowSize - 1) - i] = values[(size - 1) - i];
        structuresWindow[(windowSize - 1) - i] = structures[(size - 1) - i];
      }
      out[0] = valuesWindow;
      out[1] = structuresWindow;
      return out;
    }
  }
}

public class OavpToggle {
  private float duration = 1;
  private Easing easing = Ani.QUAD_IN_OUT;
  private Ani ani;
  private float value = 0;
  private float target = 1;

  OavpToggle(){}

  public OavpToggle duration(float duration) {
    this.duration = duration;
    return this;
  }

  public OavpToggle easing(Easing easing) {
    this.easing = easing;
    return this;
  }

  public void softToggle() {
    if (target == 1) {
      ani = Ani.to(this, duration, "value", target, easing);
      target = 0;
    } else {
      ani = Ani.to(this, duration, "value", target, easing);
      target = 1;
    }
  }

  public void toggle() {
    if (target == 1) {
      value = 1;
      target = 0;
    } else {
      value = 0;
      target = 1;
    }
  }

  public void softToggleIf(boolean trigger) {
    if (trigger) {
      softToggle();
    }
  }

  public void toggleIf(boolean trigger) {
    if (trigger) {
      toggle();
    }
  }

  public float getValue() {
    return value;
  }

  public float getInvertedValue() {
    return 1.0 - value;
  }
}

public class OavpVariable {
  public int x = 0;
  public float xMod = 0;
  public String xModType = "";
  public int xOrig = 0;
  public int xr = 0;
  public float xrMod = 0;
  public String xrModType = "";
  public int xrOrig = 0;
  public int y = 0;
  public float yMod = 0;
  public String yModType = "";
  public int yOrig = 0;
  public int yr = 0;
  public float yrMod = 0;
  public String yrModType = "";
  public int yrOrig = 0;
  public int z = 0;
  public float zMod = 0;
  public String zModType = "";
  public int zOrig = 0;
  public int zr = 0;
  public float zrMod = 0;
  public String zrModType = "";
  public int zrOrig = 0;
  public float w = 100;
  public float wMod = 0;
  public String wModType = "";
  public float wOrig = 100;
  public float h = 100;
  public float hMod = 0;
  public String hModType = "";
  public float hOrig = 100;
  public float l = 100;
  public float lMod = 0;
  public String lModType = "";
  public float lOrig = 100;
  public float size = 100;
  public float sizeMod = 0;
  public String sizeModType = "";
  public float sizeOrig = 100;
  public int gridScale = 5;
  public color strokeColor;
  public float strokeColorMod = 0;
  public String strokeColorModType = "";
  public color fillColor;
  public float fillColorMod = 0;
  public String fillColorModType = "";
  public float strokeWeight = 2;
  public float strokeWeightMod = 0;
  public String strokeWeightModType = "";
  public float strokeWeightOrig = 2;
  public String name = "";
  public HashMap<String, Float> customFloatAttrs;
  public HashMap<String, Integer> customIntAttrs;
  public HashMap<String, String> customStringAttrs;
  public List<String> variations;
  public int variation = 0;

  OavpVariable() {
    this.customFloatAttrs = new HashMap<String, Float>();
    this.customIntAttrs = new HashMap<String, Integer>();
    this.customStringAttrs = new HashMap<String, String>();
    this.variations = new ArrayList();
    this.variations("default");
  }

  OavpVariable(String name) {
    this.name = name;
    this.customFloatAttrs = new HashMap<String, Float>();
    this.customIntAttrs = new HashMap<String, Integer>();
    this.customStringAttrs = new HashMap<String, String>();
    this.variations = new ArrayList();
    this.variations("default");
  }

  public OavpVariable set(String prop, int input) {
    switch (prop) {
      case "x":
        this.x(input);
        break;
      case "xr":
        this.xr(input);
        break;
      case "y":
        this.y(input);
        break;
      case "yr":
        this.yr(input);
        break;
      case "z":
        this.z(input);
        break;
      case "zr":
        this.zr(input);
        break;
      case "strokeColor":
        this.strokeColor(input);
        break;
      case "strokeWeight":
        this.strokeWeight(input);
        break;
      case "fillColor":
        this.fillColor(input);
        break;
      default:
        this.customIntAttrs.put(prop, input);
    }
    return this;
  }

  public OavpVariable set(String prop, float input) {
    switch (prop) {
      case "xMod":
        this.xMod(input);
        break;
      case "xrMod":
        this.xrMod(input);
        break;
      case "yMod":
        this.yMod(input);
        break;
      case "yrMod":
        this.yrMod(input);
        break;
      case "zMod":
        this.zMod(input);
        break;
      case "zrMod":
        this.zrMod(input);
        break;
      case "strokeColorMod":
        this.strokeColorMod(input);
        break;
      case "strokeWeightMod":
        this.strokeWeightMod(input);
        break;
      case "fillColorMod":
        this.fillColorMod(input);
        break;
      case "w":
        this.w(input);
        break;
      case "wMod":
        this.wMod(input);
        break;
      case "h":
        this.h(input);
        break;
      case "hMod":
        this.hMod(input);
        break;
      case "l":
        this.l(input);
        break;
      case "lMod":
        this.lMod(input);
        break;
      case "size":
        this.size(input);
        break;
      case "sizeMod":
        this.sizeMod(input);
        break;
      default:
        this.customFloatAttrs.put(prop, input);
    }
    return this;
  }

  public OavpVariable set(String prop, String input) {
    switch(prop) {
      case "xModType":
        this.xModType(input);
        break;
      case "xrModType":
        this.xrModType(input);
        break;
      case "yModType":
        this.yModType(input);
        break;
      case "yrModType":
        this.yrModType(input);
        break;
      case "zModType":
        this.zModType(input);
        break;
      case "zrModType":
        this.zrModType(input);
        break;
      case "wModType":
        this.wModType(input);
        break;
      case "hModType":
        this.hModType(input);
        break;
      case "lModType":
        this.lModType(input);
        break;
      case "sizeModType":
        this.sizeModType(input);
        break;
      case "strokeColorModType":
        this.strokeColorModType(input);
        break;
      case "strokeWeightModType":
        this.xModType(input);
        break;
      case "fillColorModType":
        this.fillColorModType(input);
        break;
      case "variation":
        this.variation(input);
        break;
      default:
        this.customStringAttrs.put(prop, input);
    }
    return this;
  }

  public OavpVariable variation(String option) {
    if (variations.contains(option)) {
      this.variation = variations.indexOf(option);
    } else {
      this.variation = 0;
    }
    return this;
  }

  public OavpVariable variations(String ...options) {
    for (String option: options) {
      this.variations.add(option);
    }
    return this;
  }

  public OavpVariable size(float input) {
    this.size = input;
    this.sizeOrig = input;
    return this;
  }

  public OavpVariable sizeMod(float input) {
    this.sizeMod = input;
    return this;
  }

  public OavpVariable sizeModType(String input) {
    this.sizeModType = input;
    return this;
  }

  public OavpVariable previewSize(int multiplier) {
    this.size = this.sizeOrig + ((multiplier * -1) * gridScale);
    return this;
  }

  public OavpVariable commitSize() {
    this.sizeOrig = this.size;
    return this;
  }

  public OavpVariable strokeWeight(float input) {
    this.strokeWeight = input;
    this.strokeWeightOrig = input;
    return this;
  }

  public OavpVariable strokeWeightMod(float input) {
    this.strokeWeightMod = input;
    return this;
  }

  public OavpVariable strokeWeightModType(String input) {
    this.strokeWeightModType = input;
    return this;
  }

  public OavpVariable previewStrokeWeight(float multiplier) {
    this.strokeWeight = this.strokeWeightOrig + (multiplier * -1);
    return this;
  }

  public OavpVariable commitStrokeWeight() {
    this.strokeWeightOrig = this.strokeWeight;
    return this;
  }

  public OavpVariable w(float input) {
    this.w = input;
    this.wOrig = input;
    return this;
  }

  public OavpVariable wMod(float input) {
    this.wMod = input;
    return this;
  }

  public OavpVariable wModType(String input) {
    this.wModType = input;
    return this;
  }

  public OavpVariable previewW(int multiplier) {
    this.w = this.wOrig + ((multiplier * -1) * gridScale);
    return this;
  }

  public OavpVariable commitW() {
    this.wOrig = this.w;
    return this;
  }

  public OavpVariable h(float input) {
    this.h = input;
    this.hOrig = input;
    return this;
  }

  public OavpVariable hMod(float input) {
    this.hMod = input;
    return this;
  }

  public OavpVariable hModType(String input) {
    this.hModType = input;
    return this;
  }

  public OavpVariable previewH(int multiplier) {
    this.h = this.hOrig + ((multiplier * -1) * gridScale);
    return this;
  }

  public OavpVariable commitH() {
    this.hOrig = this.h;
    return this;
  }

  public OavpVariable l(float input) {
    this.l = input;
    this.lOrig = input;
    return this;
  }

  public OavpVariable lMod(float input) {
    this.lMod = input;
    return this;
  }

  public OavpVariable lModType(String input) {
    this.lModType = input;
    return this;
  }

  public OavpVariable previewL(int multiplier) {
    this.l = this.lOrig + ((multiplier * -1) * gridScale);
    return this;
  }

  public OavpVariable commitL() {
    this.lOrig = this.l;
    return this;
  }

  public OavpVariable x(int input) {
    this.x = input;
    return this;
  }

  public OavpVariable xMod(float input) {
    this.xMod = input;
    return this;
  }

  public OavpVariable xModType(String input) {
    this.xModType = input;
    return this;
  }

  public OavpVariable previewX(int multiplier) {
    this.x = this.xOrig + (multiplier * gridScale);
    return this;
  }

  public OavpVariable commitX() {
    this.xOrig = this.x;
    return this;
  }

  public OavpVariable xr(int input) {
    this.xr = input;
    return this;
  }

  public OavpVariable xrMod(float input) {
    this.xrMod = input;
    return this;
  }

  public OavpVariable xrModType(String input) {
    this.xrModType = input;
    return this;
  }

  public OavpVariable previewXR(int multiplier) {
    this.xr = this.xrOrig + (multiplier * gridScale);
    return this;
  }

  public OavpVariable commitXR() {
    this.xrOrig = this.xr;
    return this;
  }

  public OavpVariable y(int input) {
    this.y = input;
    return this;
  }

  public OavpVariable yMod(float input) {
    this.yMod = input;
    return this;
  }

  public OavpVariable yModType(String input) {
    this.yModType = input;
    return this;
  }

  public OavpVariable previewY(int multiplier) {
    this.y = this.yOrig + (multiplier * gridScale);
    return this;
  }

  public OavpVariable commitY() {
    this.yOrig = this.y;
    return this;
  }

  public OavpVariable yr(int input) {
    this.yr = input;
    return this;
  }

  public OavpVariable yrMod(float input) {
    this.yrMod = input;
    return this;
  }

  public OavpVariable yrModType(String input) {
    this.yrModType = input;
    return this;
  }

  public OavpVariable previewYR(int multiplier) {
    this.yr = this.yrOrig + (multiplier * gridScale);
    return this;
  }

  public OavpVariable commitYR() {
    this.yrOrig = this.yr;
    return this;
  }

  public OavpVariable z(int input) {
    this.z = input;
    return this;
  }

  public OavpVariable zMod(float input) {
    this.zMod = input;
    return this;
  }

  public OavpVariable zModType(String input) {
    this.zModType = input;
    return this;
  }

  public OavpVariable previewZ(int multiplier) {
    this.z = this.zOrig + (multiplier * gridScale);
    return this;
  }

  public OavpVariable commitZ() {
    this.zOrig = this.z;
    return this;
  }

  public OavpVariable zr(int input) {
    this.zr = input;
    return this;
  }

  public OavpVariable zrMod(float input) {
    this.zrMod = input;
    return this;
  }

  public OavpVariable zrModType(String input) {
    this.zrModType = input;
    return this;
  }

  public OavpVariable previewZR(int multiplier) {
    this.zr = this.zrOrig + (multiplier * gridScale);
    return this;
  }

  public OavpVariable commitZR() {
    this.zrOrig = this.zr;
    return this;
  }

  public OavpVariable gridScale(int input) {
    this.gridScale = input;
    return this;
  }

  public OavpVariable strokeColor(color input) {
    this.strokeColor = input;
    return this;
  }

  public OavpVariable strokeColorMod(float input) {
    this.strokeColorMod = input;
    return this;
  }

  public OavpVariable strokeColorModType(String input) {
    this.strokeColorModType = input;
    return this;
  }

  public OavpVariable fillColor(color input) {
    this.fillColor = input;
    return this;
  }

  public OavpVariable fillColorMod(float input) {
    this.fillColorMod = input;
    return this;
  }

  public OavpVariable fillColorModType(String input) {
    this.fillColorModType = input;
    return this;
  }

  public String getVariation() {
    return this.variations.get(this.variation);
  }

  public boolean ofVariation(String input) {
    return (input == this.variations.get(this.variation));
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();

    Class<?> thisClass = null;
    try {
        thisClass = Class.forName(this.getClass().getName());

        Field[] aClassFields = thisClass.getDeclaredFields();
        sb.append(this.getClass().getSimpleName() + " [ ");
        for(Field f : aClassFields){
            String fName = f.getName();
            sb.append("(" + f.getType() + ") " + fName + " = " + f.get(this) + ", ");
        }
        sb.append("]");
    } catch (Exception e) {
        e.printStackTrace();
    }

    return sb.toString();
  }
}

public class OavpEntityManager {
  private PApplet context;
  private Minim minim;
  private HashMap<String, PShape> svgs;
  private HashMap<String, PImage> imgs;
  private HashMap<String, Movie> movies;
  private HashMap<String, OavpPulser> pulsers;
  private HashMap<String, OavpInterval> intervals;
  private HashMap<String, OavpGridInterval> gridIntervals;
  private HashMap<String, List> emissionsStorage;
  private HashMap<String, OavpRhythm> rhythms;
  private HashMap<String, OavpCounter> counters;
  private HashMap<String, OavpRotator> rotators;
  private HashMap<String, OavpColorRotator> colorRotators;
  private HashMap<String, OavpOscillator> oscillators;
  private HashMap<String, OavpTerrain> terrains;
  private HashMap<String, OavpCamera> cameras;
  private HashMap<String, OavpToggle> toggles;
  private HashMap<String, OavpVariable> variables;
  private List<OavpVariable> activeVariables;
  private int selectedVariableIndex = 0;
  public String selectedVariable = "";

  OavpEntityManager(PApplet context, Minim minim) {
    this.context = context;
    this.minim = minim;
    svgs = new HashMap<String, PShape>();
    imgs = new HashMap<String, PImage>();
    movies = new HashMap<String, Movie>();
    pulsers = new HashMap<String, OavpPulser>();
    intervals = new HashMap<String, OavpInterval>();
    gridIntervals = new HashMap<String, OavpGridInterval>();
    emissionsStorage = new HashMap<String, List>();
    rhythms = new HashMap<String, OavpRhythm>();
    counters = new HashMap<String, OavpCounter>();
    rotators = new HashMap<String, OavpRotator>();
    colorRotators = new HashMap<String, OavpColorRotator>();
    oscillators = new HashMap<String, OavpOscillator>();
    terrains = new HashMap<String, OavpTerrain>();
    cameras = new HashMap<String, OavpCamera>();
    toggles = new HashMap<String, OavpToggle>();
    variables = new HashMap<String, OavpVariable>();
    activeVariables = new ArrayList();
    selectedVariableIndex = 0;
  }

  public float mouseX(float start, float end) {
    return map(mouseX, 0, width, start, end);
  }

  public float mouseY(float start, float end) {
    return map(mouseY, 0, height, start, end);
  }

  public void addSvg(String filename) {
    String[] fn = filename.split("\\.");
    svgs.put(fn[0], loadShape(filename));
  }

  public PShape getSvg(String name) {
    return svgs.get(name);
  }

  public void addImg(String filename) {
    String[] fn = filename.split("\\.");
    imgs.put(fn[0], loadImage(filename));
  }

  public PImage getImg(String name) {
    return imgs.get(name);
  }

  public void addMovie(String filename) {
    String[] fn = filename.split("\\.");
    movies.put(fn[0], new Movie(context, filename));
    movies.get(fn[0]).loop();
  }

  public Movie getMovie(String name) {
    return movies.get(name);
  }

  public OavpPulser addPulser(String name) {
    pulsers.put(name, new OavpPulser());
    return pulsers.get(name);
  }

  public OavpEntityManager addPulsers(String... names) {
    for (String name : names) {
      pulsers.put(name, new OavpPulser());
    }
    return this;
  }

  public OavpPulser getPulser(String name) {
    return pulsers.get(name);
  }

  public void addInterval(String name, int storageSize, int snapshotSize) {
    intervals.put(name, new OavpInterval(storageSize, snapshotSize));
  }

  public OavpInterval getInterval(String name) {
    return intervals.get(name);
  }

  public OavpGridInterval addGridInterval(String name, int numRows, int numCols) {
    gridIntervals.put(name, new OavpGridInterval(numRows, numCols));
    return gridIntervals.get(name);
  }

  public OavpGridInterval getGridInterval(String name) {
    return gridIntervals.get(name);
  }

  public void addEmissions(String name) {
    emissionsStorage.put(name, new ArrayList());
  }

  public OavpEntityManager addEmissions(String... names) {
    for (String name : names) {
      emissionsStorage.put(name, new ArrayList());
    }
    return this;
  }

  public void updateEmissions() {
    for (HashMap.Entry<String, List> entry : emissionsStorage.entrySet())
    {
      Iterator<OavpEmission> i = entry.getValue().iterator();
      while(i.hasNext()) {
        OavpEmission item = i.next();
        item.update();
        if (item.isDead) {
          i.remove();
        }
      }
    }
  }

  public List getEmissions(String name) {
    return emissionsStorage.get(name);
  }

  public OavpRhythm addRhythm(String name) {
    rhythms.put(name, new OavpRhythm(minim));
    return rhythms.get(name);
  }

  public OavpEntityManager addRhythms(String... names) {
    for (String name : names) {
      rhythms.put(name, new OavpRhythm(minim));
    }
    return this;
  }

  public void updateRhythms() {
    for (HashMap.Entry<String, OavpRhythm> entry : rhythms.entrySet())
    {
      entry.getValue().update();
    }
  }

  public boolean onRhythm(String name) {
    return rhythms.get(name).onRhythm();
  }

  public OavpRhythm getRhythm(String name) {
    return rhythms.get(name);
  }

  public OavpCounter addCounter(String name) {
    counters.put(name, new OavpCounter());
    return counters.get(name);
  }

  public OavpEntityManager addCounters(String... names) {
    for (String name : names) {
      counters.put(name, new OavpCounter());
    }
    return this;
  }

  public void incrementCounterIf(String name, Boolean trigger) {
    counters.get(name).incrementIf(trigger);
  }

  public void incrementCounter(String name) {
    counters.get(name).increment();
  }

  public boolean checkCounter(String name) {
    return counters.get(name).hasFinished();
  }

  public OavpCounter getCounter(String name) {
    return counters.get(name);
  }

  public OavpRotator addRotator(String name) {
    rotators.put(name, new OavpRotator());
    return rotators.get(name);
  }

  public OavpEntityManager addRotators(String... names) {
    for (String name : names) {
      rotators.put(name, new OavpRotator());
    }
    return this;
  }

  public OavpRotator getRotator(String name) {
    return rotators.get(name);
  }

  public void rotateRotator(String name) {
    rotators.get(name).rotate();
  }

  public void rotateRotatorIf(String name, boolean trigger) {
    rotators.get(name).rotateIf(trigger);
  }

  public void randomizeRotator(String name) {
    rotators.get(name).randomize();
  }

  public void randomizeRotatorIf(String name, boolean trigger) {
    rotators.get(name).randomizeIf(trigger);
  }

  public OavpColorRotator addColorRotator(String name) {
    colorRotators.put(name, new OavpColorRotator());
    return colorRotators.get(name);
  }

  public OavpEntityManager addColorRotators(String... names) {
    for (String name : names) {
      colorRotators.put(name, new OavpColorRotator());
    }
    return this;
  }

  public OavpColorRotator getColorRotator(String name) {
    return colorRotators.get(name);
  }

  public void rotateColorRotator(String name) {
    colorRotators.get(name).rotate();
  }

  public void rotateColorRotatorIf(String name, boolean trigger) {
    colorRotators.get(name).rotateIf(trigger);
  }

  public void randomizeColorRotator(String name) {
    colorRotators.get(name).randomize();
  }

  public void randomizeColorRotatorIf(String name, boolean trigger) {
    colorRotators.get(name).randomizeIf(trigger);
  }

  public OavpOscillator addOscillator(String name) {
    oscillators.put(name, new OavpOscillator());
    return oscillators.get(name);
  }

  public OavpEntityManager addOscillators(String... names) {
    for (String name : names) {
      oscillators.put(name, new OavpOscillator());
    }
    return this;
  }

  public OavpOscillator getOscillator(String name) {
    return oscillators.get(name);
  }

  public OavpTerrain addTerrain(String name) {
    terrains.put(name, new OavpTerrain());
    return terrains.get(name);
  }

  public OavpEntityManager addTerrains(String... names) {
    for (String name : names) {
      terrains.put(name, new OavpTerrain());
    }
    return this;
  }

  public OavpTerrain getTerrain(String name) {
    return terrains.get(name);
  }

  public OavpCamera addCamera(String name) {
    cameras.put(name, new OavpCamera());
    return cameras.get(name);
  }

  public OavpEntityManager addCameras(String... names) {
    for (String name : names) {
      cameras.put(name, new OavpCamera());
    }
    return this;
  }

  public OavpCamera getCamera(String name) {
    return cameras.get(name);
  }

  public void useCamera(String name) {
    cameras.get(name).view();
  }

  public OavpToggle addToggle(String name) {
    toggles.put(name, new OavpToggle());
    return toggles.get(name);
  }

  public OavpEntityManager addToggles(String... names) {
    for (String name : names) {
      toggles.put(name, new OavpToggle());
    }
    return this;
  }

  public OavpToggle getToggle(String name) {
    return toggles.get(name);
  }

  public OavpVariable addVariable(String name) {
    OavpVariable variable = new OavpVariable(name);
    variables.put(name, variable);
    activeVariables.add(variable);
    return variable;
  }

  public OavpVariable getVariable(String name) {
    return variables.get(name);
  }

  public OavpVariable getActiveVariable() {
    return activeVariables.get(this.selectedVariableIndex);
  }

  public void cycleActiveVariable() {
    if (this.selectedVariableIndex == this.activeVariables.size() - 1) {
      this.selectedVariableIndex = 0;
    } else {
      this.selectedVariableIndex += 1;
    }
  }

  public void update() {
    updateRhythms();
    updateEmissions();
  }
}

public class OavpObjectManager {
  private HashMap<String, OavpObject> objectsStorage;
  private List<OavpObject> activeObjects;
  private int selectedObjectIndex = 0;
  private int selectionCounter = 0;

  OavpObjectManager() {
    objectsStorage = new HashMap<String, OavpObject>();
    activeObjects = new ArrayList();
    selectedObjectIndex = 0;
  }

  public OavpVariable add(String name, String className) {
    OavpObject object = createObject(className);
    object.setName(name);
    object.setup();
    objectsStorage.put(name, object);
    activeObjects.add(object);
    lastActiveVariable();
    return object.getVariable();
  }

  public OavpVariable add(String className) {
    String name = className + "-" + UUID.randomUUID().toString();
    OavpObject object = createObject(className);
    object.setName(name);
    object.setup();
    objectsStorage.put(name, object);
    activeObjects.add(object);
    lastActiveVariable();
    return object.getVariable();
  }

  public boolean has(String name) {
    return objectsStorage.containsKey(name);
  }

  public OavpObject get(String name) {
    return objectsStorage.get(name);
  }

  public int getCount() {
    return objectsStorage.size();
  }

  public String getCloneName(String originalName) {
    String output;
    Set<String> nameSplit = new HashSet<String>(Arrays.asList(originalName.split("-")));
    Set<String> existingNames = objectsStorage.keySet();

    if (nameSplit.contains("copy")) {
      String lastItem = originalName.split("-")[originalName.split("-").length - 1];
      if (isNumber(lastItem)) {
        output = originalName.substring(0, originalName.length() - lastItem.length()) + str(int(lastItem) + 1);
      } else {
        output = originalName + "-1";
      }
    } else {
      output = originalName + "-copy";
    }

    if (existingNames.contains(output)) {
      return getCloneName(output);
    } else {
      return output;
    }
  }

  public OavpVariable duplicate() {
    String cloneName = getCloneName(this.getActiveVariable().name);
    OavpObject clone = this.getActiveObject().clone(cloneName);

    objectsStorage.put(cloneName, clone);
    activeObjects.add(clone);
    lastActiveVariable();
    return clone.getVariable();
  }

  public void remove() {
    String activeObjectName = this.getActiveVariable().name;

    if (activeObjectName != "background") {
      activeObjects.remove(this.getActiveObject());
      objectsStorage.remove(activeObjectName);
      lastActiveVariable();
    }
  }

  public void update() {
    for (HashMap.Entry<String, OavpObject> entry : objectsStorage.entrySet()) {
      entry.getValue().update();
    }
  }

  public void draw() {
    for (HashMap.Entry<String, OavpObject> entry : objectsStorage.entrySet()) {
      entry.getValue().draw();
    }
  }

  public OavpVariable getActiveVariable() {
    return activeObjects.get(this.selectedObjectIndex).getVariable();
  }

  public OavpObject getActiveObject() {
    return activeObjects.get(this.selectedObjectIndex);
  }

  public void nextActiveVariable() {
    if (this.selectedObjectIndex == this.activeObjects.size() - 1) {
      this.selectedObjectIndex = 0;
    } else {
      this.selectedObjectIndex += 1;
    }
    println("[" + (selectionCounter++) + "] - Selected Variable: " + getActiveVariable().name);
  }

  public void lastActiveVariable() {
    this.selectedObjectIndex = this.activeObjects.size() - 1;
    println("[" + (selectionCounter++) + "] - Selected Variable: " + getActiveVariable().name);
  }

  public void prevActiveVariable() {
    if (this.selectedObjectIndex == 0) {
      this.selectedObjectIndex = this.activeObjects.size() - 1;
    } else {
      this.selectedObjectIndex -= 1;
    }
    println("[" + (selectionCounter++) + "] - Selected Variable: " + getActiveVariable().name);
  }

  public void printObjectData() {
    Date date = new Date();
    println("--- [ object data : " + date + " ] ---");
    StringBuilder objectData = new StringBuilder();
    for (HashMap.Entry<String, OavpObject> entry : objectsStorage.entrySet()) {
      OavpObject object = entry.getValue();
      String objectKey = entry.getKey();
      String objectClassName = extractOavpClassName(object.getClass().getName());
      OavpVariable variable = entry.getValue().getVariable();

      objectData.append("\n  objects.add(\"" + objectKey + "\", \"" + objectClassName + "\")");

      if (variable.x != 0) { objectData.append(".set(\"x\"," + variable.x + ")"); }
      if (variable.xMod != 0) { objectData.append(".set(\"xMod\"," + variable.xMod + ")"); }
      if (variable.xModType != "") { objectData.append(".set(\"xModType\",\"" + variable.xModType + "\")"); }
      if (variable.xr != 0) { objectData.append(".set(\"xr\"," + variable.xr + ")"); }
      if (variable.xrMod != 0) { objectData.append(".set(\"xrMod\"," + variable.xrMod + ")"); }
      if (variable.xrModType != "") { objectData.append(".set(\"xrModType\",\"" + variable.xrModType + "\")"); }
      if (variable.y != 0) { objectData.append(".set(\"y\"," + variable.y + ")"); }
      if (variable.yMod != 0) { objectData.append(".set(\"yMod\"," + variable.yMod + ")"); }
      if (variable.yModType != "") { objectData.append(".set(\"yModType\",\"" + variable.yModType + "\")"); }
      if (variable.yr != 0) { objectData.append(".set(\"yr\"," + variable.yr + ")"); }
      if (variable.yrMod != 0) { objectData.append(".set(\"yrMod\"," + variable.yrMod + ")"); }
      if (variable.yrModType != "") { objectData.append(".set(\"yrModType\",\"" + variable.yrModType + "\")"); }
      if (variable.z != 0) { objectData.append(".set(\"z\"," + variable.z + ")"); }
      if (variable.zMod != 0) { objectData.append(".set(\"zMod\"," + variable.zMod + ")"); }
      if (variable.zModType != "") { objectData.append(".set(\"zModType\",\"" + variable.zModType + "\")"); }
      if (variable.zr != 0) { objectData.append(".set(\"zr\"," + variable.zr + ")"); }
      if (variable.zrMod != 0) { objectData.append(".set(\"zrMod\"," + variable.zrMod + ")"); }
      if (variable.zrModType != "") { objectData.append(".set(\"zrModType\",\"" + variable.zrModType + "\")"); }
      objectData.append(".set(\"w\"," + variable.w + ")");
      if (variable.wMod != 0) { objectData.append(".set(\"wMod\"," + variable.wMod + ")"); }
      if (variable.wModType != "") { objectData.append(".set(\"wModType\",\"" + variable.wModType + "\")"); }
      objectData.append(".set(\"h\"," + variable.h + ")");
      if (variable.hMod != 0) { objectData.append(".set(\"hMod\"," + variable.hMod + ")"); }
      if (variable.hModType != "") { objectData.append(".set(\"hModType\",\"" + variable.hModType + "\")"); }
      objectData.append(".set(\"l\"," + variable.l + ")");
      if (variable.lMod != 0) { objectData.append(".set(\"lMod\"," + variable.lMod + ")"); }
      if (variable.lModType != "") { objectData.append(".set(\"lModType\",\"" + variable.lModType + "\")"); }
      objectData.append(".set(\"size\"," + variable.size + ")");
      if (variable.sizeMod != 0) { objectData.append(".set(\"sizeMod\"," + variable.sizeMod + ")"); }
      if (variable.sizeModType != "") { objectData.append(".set(\"sizeModType\",\"" + variable.sizeModType + "\")"); }
      objectData.append(".set(\"strokeColor\"," + variable.strokeColor + ")");
      if (variable.strokeColorMod != 0) { objectData.append(".set(\"strokeColorMod\"," + variable.strokeColorMod + ")"); }
      if (variable.strokeColorModType != "") { objectData.append(".set(\"strokeColorModType\",\"" + variable.strokeColorModType + "\")"); }
      objectData.append(".set(\"strokeWeight\"," + variable.strokeWeight + ")");
      if (variable.strokeWeightMod != 0) { objectData.append(".set(\"strokeWeightMod\"," + variable.strokeWeightMod + ")"); }
      if (variable.strokeWeightModType != "") { objectData.append(".set(\"strokeWeightModType\",\"" + variable.strokeWeightModType + "\")"); }
      objectData.append(".set(\"fillColor\"," + variable.fillColor + ")");
      if (variable.fillColorMod != 0) { objectData.append(".set(\"fillColorMod\"," + variable.fillColorMod + ")"); }
      if (variable.fillColorModType != "") { objectData.append(".set(\"fillColorModType\",\"" + variable.fillColorModType + "\")"); }
      if (variable.variation != 0) { objectData.append(".set(\"variation\",\"" + variable.getVariation() + "\")"); }

      for (HashMap.Entry<String, Float> customAttrEntry : variable.customFloatAttrs.entrySet()) {
        objectData.append(".set(\"" + customAttrEntry.getKey() + "\", " + customAttrEntry.getValue() + ")");
      }

      for (HashMap.Entry<String, Integer> customAttrEntry : variable.customIntAttrs.entrySet()) {
        objectData.append(".set(\"" + customAttrEntry.getKey() + "\", " + customAttrEntry.getValue() + ")");
      }

      for (HashMap.Entry<String, String> customAttrEntry : variable.customStringAttrs.entrySet()) {
        objectData.append(".set(\"" + customAttrEntry.getKey() + "\", \"" + customAttrEntry.getValue() + "\")");
      }

      objectData.append(";");
    }
    StringSelection stringSelection = new StringSelection(objectData.toString());
    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
    clipboard.setContents(stringSelection, null);
    println(objectData.toString());
  }
}

public class OavpObject {
  public OavpVariable variable;

  OavpObject() {
    this.variable = new OavpVariable();
  }

  public OavpVariable getVariable() {
    return this.variable;
  }

  public void setName(String name) {
    this.variable.name = name;
  }

  public OavpObject clone(String cloneName) {
    String rawClassName = this.getClass().getName();
    String className = rawClassName.split("OavpObj")[1];
    OavpObject clone = createObject(className);
    OavpVariable cloneVariable = clone.getVariable();

    clone.setName(cloneName);
    clone.setup();

    cloneVariable.name = cloneName;
    cloneVariable.x = this.variable.x;
    cloneVariable.xMod = this.variable.xMod;
    cloneVariable.xModType = this.variable.xModType;
    cloneVariable.xOrig = this.variable.xOrig;
    cloneVariable.xr = this.variable.xr;
    cloneVariable.xrMod = this.variable.xrMod;
    cloneVariable.xrModType = this.variable.xrModType;
    cloneVariable.xrOrig = this.variable.xrOrig;
    cloneVariable.y = this.variable.y;
    cloneVariable.yMod = this.variable.yMod;
    cloneVariable.yModType = this.variable.yModType;
    cloneVariable.yOrig = this.variable.yOrig;
    cloneVariable.yr = this.variable.yr;
    cloneVariable.yrMod = this.variable.yrMod;
    cloneVariable.yrModType = this.variable.yrModType;
    cloneVariable.yrOrig = this.variable.yrOrig;
    cloneVariable.z = this.variable.z;
    cloneVariable.zMod = this.variable.zMod;
    cloneVariable.zModType = this.variable.zModType;
    cloneVariable.zOrig = this.variable.zOrig;
    cloneVariable.zr = this.variable.zr;
    cloneVariable.zrMod = this.variable.zrMod;
    cloneVariable.zrModType = this.variable.zrModType;
    cloneVariable.zrOrig = this.variable.zrOrig;
    cloneVariable.w = this.variable.w;
    cloneVariable.wMod = this.variable.wMod;
    cloneVariable.wModType = this.variable.wModType;
    cloneVariable.wOrig = this.variable.wOrig;
    cloneVariable.h = this.variable.h;
    cloneVariable.hMod = this.variable.hMod;
    cloneVariable.hModType = this.variable.hModType;
    cloneVariable.hOrig = this.variable.hOrig;
    cloneVariable.l = this.variable.l;
    cloneVariable.lMod = this.variable.lMod;
    cloneVariable.lModType = this.variable.lModType;
    cloneVariable.lOrig = this.variable.lOrig;
    cloneVariable.size = this.variable.size;
    cloneVariable.sizeMod = this.variable.sizeMod;
    cloneVariable.sizeModType = this.variable.sizeModType;
    cloneVariable.sizeOrig = this.variable.sizeOrig;
    cloneVariable.strokeColor = this.variable.strokeColor;
    cloneVariable.strokeColorMod = this.variable.strokeColorMod;
    cloneVariable.strokeColorModType = this.variable.strokeColorModType;
    cloneVariable.strokeWeight = this.variable.strokeWeight;
    cloneVariable.strokeWeightMod = this.variable.strokeWeightMod;
    cloneVariable.strokeWeightModType = this.variable.strokeWeightModType;
    cloneVariable.strokeWeightOrig = this.variable.strokeWeightOrig;
    cloneVariable.fillColor = this.variable.fillColor;
    cloneVariable.fillColorMod = this.variable.fillColorMod;
    cloneVariable.fillColorModType = this.variable.fillColorModType;
    cloneVariable.variation = this.variable.variation;

    for (HashMap.Entry<String, Float> entry : this.variable.customFloatAttrs.entrySet()) {
      cloneVariable.set(entry.getKey(), (float) entry.getValue());
    }

    for (HashMap.Entry<String, Integer> entry : this.variable.customIntAttrs.entrySet()) {
      cloneVariable.set(entry.getKey(), (int) entry.getValue());
    }

    for (HashMap.Entry<String, String> entry : this.variable.customStringAttrs.entrySet()) {
      cloneVariable.set(entry.getKey(), (String) entry.getValue());
    }

    return clone;
  }

  public void setup() {}
  public void draw() {}
  public void update() {}
}

public String extractOavpClassName(String rawName) {
  if (rawName == "src$OavpObject") {
    return "OavpObject";
  }
  return rawName.split("OavpObj")[1];
}

String[] MODIFIER_FIELDS = {
  "xMod",
  "xrMod",
  "yMod",
  "yrMod",
  "zMod",
  "zrMod",
  "wMod",
  "hMod",
  "lMod",
  "sizeMod",
  "strokeColorMod",
  "strokeWeightMod",
  "fillColorMod"
};

String[] MODIFIER_TYPES = {
  "none",
  "level",
  "osc-fast",
  "osc-normal",
  "osc-slow",
  "lows",
  "mid-lows",
  "mid-highs",
  "highs",
  "beat-pulser",
  "beat-toggle-hard",
  "beat-toggle-soft",
  "beat-counter",
  "quantized-pulser",
  "quantized-toggle-hard",
  "quantized-toggle-soft",
  "quantized-counter"
};

public float getMod(String type) {
  float out;
  switch(type) {
    case "level":
      out = analysis.getLevel();
      break;
    case "osc-fast":
      out = oscillate(-1, 1, 0.05);
      break;
    case "osc-normal":
      out = oscillate(-1, 1, 0.01);
      break;
    case "osc-slow":
      out = oscillate(-1, 1, 0.005);
      break;
    case "lows":
      out = map(analysis.getSpectrumChunkAvg(0), -20, 20, 0, 1);
      break;
    case "mid-lows":
      out = map(analysis.getSpectrumChunkAvg(1), -20, 20, 0, 1);
      break;
    case "mid-highs":
      out = map(analysis.getSpectrumChunkAvg(2), -25, 15, 0, 1);
      break;
    case "highs":
      out = map(analysis.getSpectrumChunkAvg(3), -30, 10, 0, 1);
      break;
    case "beat-pulser":
      out = entities.getPulser("beat-pulser").getValue();
      break;
    case "beat-toggle-hard":
      out = entities.getToggle("beat-toggle-hard").getValue();
      break;
    case "beat-toggle-soft":
      out = entities.getToggle("beat-toggle-soft").getValue();
      break;
    case "beat-counter":
      out = entities.getCounter("beat-counter").getValue();
      break;
    case "quantized-pulser":
      out = entities.getPulser("quantized-pulser").getValue();
      break;
    case "quantized-toggle-hard":
      out = entities.getToggle("quantized-toggle-hard").getValue();
      break;
    case "quantized-toggle-soft":
      out = entities.getToggle("quantized-toggle-soft").getValue();
      break;
    case "quantized-counter":
      out = entities.getCounter("quantized-counter").getValue();
      break;
    default:
      out = 0;
  }
  return out;
}