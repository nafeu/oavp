public class OavpPulser {
  private float value = 0;
  private float duration = 1;
  private Easing easing = Ani.LINEAR;
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

public class OavpTracker {
  float value = 0;
  float target = 1;
  float[] payload;
  boolean isDead = false;

  OavpTracker(float duration, Easing easing) {
    start(duration, easing);
  }

  OavpTracker(float duration, Easing easing, float[] payload) {
    this.payload = payload;
    start(duration, easing);
  }

  void start(float duration, Easing easing) {
    Ani.to(this, duration, "value", target, easing);
  }

  void update() {
    if (value == target) {
      isDead = true;
    }
  }
}

public class OavpRhythm {
  AudioOutput out;
  BeatDetect beat;
  boolean isPlaying;
  float tempo = 60;
  float rhythm = 1;
  int limit = 1000;
  Minim minim;

  OavpRhythm(Minim minim) {
    this.minim = minim;
    this.rhythm = rhythm;
    beat = new BeatDetect();
    beat.setSensitivity(100);
  }

  OavpRhythm duration(float duration) {
    this.tempo = 60 / duration;
    return this;
  }

  OavpRhythm tempo(float tempo) {
    this.tempo = tempo;
    return this;
  }

  OavpRhythm rhythm(float rhythm) {
    this.rhythm = rhythm;
    return this;
  }

  OavpRhythm limit(int limit) {
    this.limit = limit;
    return this;
  }

  void start() {
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

  void update() {
    beat.detect(out.mix);
  }

  void toggleNotes() {
    if (isPlaying) {
      out.pauseNotes();
      isPlaying = false;
    } else {
      out.resumeNotes();
      isPlaying = true;
    }
  }

  boolean onRhythm() {
    return beat.isOnset();
  }

  void toggleMute() {
    if (out.isMuted()) {
      out.unmute();
    } else {
      out.mute();
    }
  }
}

public class OavpCounter {
  float value = 0;
  int count = 0;
  int limit = 0;
  Ani ani;
  float duration = 1;
  Easing easing = Ani.LINEAR;

  OavpCounter(){}

  OavpCounter duration(float duration) {
    this.duration = duration;
    return this;
  }

  OavpCounter easing(Easing easing) {
    this.easing = easing;
    return this;
  }

  OavpCounter limit(int limit) {
    this.limit = limit;
    return this;
  }

  void increment() {
    count++;
    ani = Ani.to(this, duration, "value", count, easing);
  }

  void increment(float duration, Easing easing) {
    count++;
    ani = Ani.to(this, duration, "value", count, easing);
  }

  void incrementIf(Boolean trigger) {
    if (trigger) {
      increment();
    }
  }

  void incrementIf(Boolean trigger, float duration, Easing easing) {
    if (trigger) {
      increment(duration, easing);
    }
  }

  float getValue() {
    return value;
  }

  int getCount() {
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
  float x = 0;
  float y = 0;
  float z = 0;
  List storage;
  float duration = 1;
  Easing easing = Ani.LINEAR;
  int index;
  Ani aniX;
  Ani aniY;
  Ani aniZ;

  OavpRotator(){
    storage = new ArrayList();
  }

  OavpRotator add(float x) {
    float[] values = new float[3];
    values[0] = x;
    storage.add(values);
    return this;
  }

  OavpRotator add(float x, float y) {
    float[] values = new float[3];
    values[0] = x;
    values[1] = y;
    storage.add(values);
    return this;
  }

  OavpRotator add(float x, float y, float z) {
    float[] values = new float[3];
    values[0] = x;
    values[1] = y;
    values[2] = z;
    storage.add(values);
    return this;
  }

  OavpRotator addCombinations(float start, float end, int granularity) {
    float interpolation = (end - start) / max((granularity - 1), 1);
    for (int i = 0; i < max(granularity, 2); i++) {
      for (int j = 0; j < max(granularity, 2); j++) {
        float values[] = new float[]{i * interpolation, j * interpolation, 0};
        storage.add(values);
      }
    }
    return this;
  }

  OavpRotator duration(float duration) {
    this.duration = duration;
    return this;
  }

  OavpRotator easing(Easing easing) {
    this.easing = easing;
    return this;
  }

  void rotate() {
    int currIndex = index % storage.size();
    index = index + 1 % storage.size();
    float[] values = (float[]) storage.get(currIndex);
    aniX = Ani.to(this, duration, "x", values[0], easing);
    aniY = Ani.to(this, duration, "y", values[1], easing);
    aniZ = Ani.to(this, duration, "z", values[2], easing);
  }

  void randomize() {
    index = floor(random(0, storage.size())) % storage.size();
    float[] values = (float[]) storage.get(index);
    aniX = Ani.to(this, duration, "x", values[0], easing);
    aniY = Ani.to(this, duration, "y", values[1], easing);
    aniZ = Ani.to(this, duration, "z", values[2], easing);
  }

  void rotateIf(boolean trigger) {
    if (trigger) {
      rotate();
    }
  }

  void randomizeIf(boolean trigger) {
    if (trigger) {
      randomize();
    }
  }

  float getX() {
    return x;
  }

  float getY() {
    return y;
  }

  float getZ() {
    return z;
  }
}

public class OavpColorRotator {
  float value = 0;
  List storage;
  color colorA;
  color colorB;
  float duration = 1;
  Easing easing = Ani.LINEAR;
  int index;
  Ani ani;

  OavpColorRotator(){
    storage = new ArrayList();
  }

  OavpColorRotator add(color value) {
    storage.add(value);
    return this;
  }

  OavpColorRotator duration(float duration) {
    this.duration = duration;
    return this;
  }

  OavpColorRotator easing(Easing easing) {
    this.easing = easing;
    return this;
  }

  void rotate() {
    colorA = (color) storage.get(index % storage.size());
    index = index + 1 % storage.size();
    colorB = (color) storage.get(index % storage.size());
    animate();
  }

  void randomize() {
    colorA = (color) storage.get(index % storage.size());
    index = floor(random(0, storage.size())) % storage.size();
    colorB = (color) storage.get(index % storage.size());
    animate();
  }

  void animate() {
    value = 0;
    ani = Ani.to(this, duration, "value", 1, easing);
  }

  void rotateIf(boolean trigger) {
    if (trigger) {
      rotate();
    }
  }

  void randomizeIf(boolean trigger) {
    if (trigger) {
      randomize();
    }
  }

  color getColor() {
    return lerpColor(colorA, colorB, value);
  }
}

public class OavpOscillator {
  float duration = 1;
  Easing easing = Ani.LINEAR;
  Ani ani;
  float value = 0;

  OavpOscillator duration(float duration) {
    this.duration = duration;
    return this;
  }

  OavpOscillator easing(Easing easing) {
    this.easing = easing;
    return this;
  }

  OavpOscillator(){}

  void start() {
    loop();
  }

  void loop() {
    if (value == 0) {
      ani = Ani.to(this, duration, "value", 1, easing, "onEnd:loop");
    } else {
      ani = Ani.to(this, duration, "value", 0, easing, "onEnd:loop");
    }
  }

  float getValue() {
    return value;
  }

  float getValue(float start, float end) {
    return map(value, 0, 1, start, end);
  }
}

public class OavpNoiseInterval {
  HashMap<String, float[]> storage;
  int numPoints = 100;
  float granularity = 0.01;

  OavpNoiseInterval() {
    storage = new HashMap<String, float[]>();
  }

  OavpNoiseInterval generate(String name) {
    storage.put(name, new float[numPoints]);
    return this;
  }

  OavpNoiseInterval granularity(float granularity) {
    this.granularity = granularity;
    return this;
  }

  OavpNoiseInterval numPoints(int numPoints) {
    this.numPoints = numPoints;
    return this;
  }

  void update(String name, float phase) {
    for (int i = 0; i < numPoints; i++) {
      float point = refinedNoise(i + phase, granularity);
      storage.get(name)[i] = point;
    }
  }

  float[] getValues(String name) {
    return storage.get(name);
  }

  float[] getValues(float phase, float granularity) {
    float[] out = new float[numPoints];
    for (int i = 0; i < numPoints; i++) {
      out[i] = refinedNoise(i + phase, granularity);
    }
    return out;
  }

  float getNoise(float phase) {
    return refinedNoise(phase, granularity);
  }
}

public class OavpTerrain {
  float[] values;
  int[] structures;
  int size = 10000;
  float granularity = 0.01;

  OavpTerrain() {
    values = new float[size];
    structures = new int[size];
    generate();
  }

  OavpTerrain generate() {
    for (int i = 0; i < size; ++i) {
      values[i] = refinedNoise(i, granularity);
    }
    for (int i = 0; i < size; ++i) {
      structures[i] = floor(random(0, 20));
    }
    return this;
  }

  OavpTerrain granularity(float granularity) {
    this.granularity = granularity;
    return this;
  }

  OavpTerrain size(int size) {
    this.size = size;
    return this;
  }

  float[] getValues(float position, int windowSize, int shift) {
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

  float[] getStructures(float position, int windowSize, int shift) {
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

  float[][] getWindow(float position, int windowSize, int shift) {
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

public class OavpEntityManager {
  Minim minim;
  HashMap<String, PShape> svgs;
  HashMap<String, PImage> imgs;
  HashMap<String, OavpPulser> pulsers;
  HashMap<String, OavpInterval> intervals;
  HashMap<String, OavpGridInterval> gridIntervals;
  HashMap<String, List> trackersStorage;
  HashMap<String, OavpRhythm> rhythms;
  HashMap<String, OavpCounter> counters;
  HashMap<String, OavpRotator> rotators;
  HashMap<String, OavpColorRotator> colorRotators;
  HashMap<String, OavpOscillator> oscillators;
  HashMap<String, OavpNoiseInterval> noiseIntervals;
  HashMap<String, OavpTerrain> terrains;
  HashMap<String, OavpCamera> cameras;

  OavpEntityManager(Minim minim) {
    this.minim = minim;
    svgs = new HashMap<String, PShape>();
    imgs = new HashMap<String, PImage>();
    pulsers = new HashMap<String, OavpPulser>();
    intervals = new HashMap<String, OavpInterval>();
    gridIntervals = new HashMap<String, OavpGridInterval>();
    trackersStorage = new HashMap<String, List>();
    rhythms = new HashMap<String, OavpRhythm>();
    counters = new HashMap<String, OavpCounter>();
    rotators = new HashMap<String, OavpRotator>();
    colorRotators = new HashMap<String, OavpColorRotator>();
    oscillators = new HashMap<String, OavpOscillator>();
    noiseIntervals = new HashMap<String, OavpNoiseInterval>();
    terrains = new HashMap<String, OavpTerrain>();
    cameras = new HashMap<String, OavpCamera>();
  }

  float mouseX(float start, float end) {
    return map(mouseX, 0, width, start, end);
  }

  float mouseY(float start, float end) {
    return map(mouseY, 0, height, start, end);
  }

  void addSvg(String filename) {
    String[] fn = filename.split("\\.");
    svgs.put(fn[0], loadShape(filename));
  }

  PShape getSvg(String name) {
    return svgs.get(name);
  }

  void addImg(String filename) {
    String[] fn = filename.split("\\.");
    imgs.put(fn[0], loadImage(filename));
  }

  PImage getImg(String name) {
    return imgs.get(name);
  }

  OavpPulser addPulser(String name) {
    pulsers.put(name, new OavpPulser());
    return pulsers.get(name);
  }

  OavpPulser getPulser(String name) {
    return pulsers.get(name);
  }

  void addInterval(String name, int storageSize, int snapshotSize) {
    intervals.put(name, new OavpInterval(storageSize, snapshotSize));
  }

  OavpInterval getInterval(String name) {
    return intervals.get(name);
  }

  void addGridInterval(String name, int numRows, int numCols) {
    gridIntervals.put(name, new OavpGridInterval(numRows, numCols));
  }

  OavpGridInterval getGridInterval(String name) {
    return gridIntervals.get(name);
  }

  void addTrackers(String name) {
    trackersStorage.put(name, new ArrayList());
  }

  void updateTrackers() {
    for (HashMap.Entry<String, List> entry : trackersStorage.entrySet())
    {
      Iterator<OavpTracker> i = entry.getValue().iterator();
      while(i.hasNext()) {
        OavpTracker item = i.next();
        item.update();
        if (item.isDead) {
          i.remove();
        }
      }
    }
  }

  List getTrackers(String name) {
    return trackersStorage.get(name);
  }

  OavpRhythm addRhythm(String name) {
    rhythms.put(name, new OavpRhythm(minim));
    return rhythms.get(name);
  }

  void updateRhythms() {
    for (HashMap.Entry<String, OavpRhythm> entry : rhythms.entrySet())
    {
      entry.getValue().update();
    }
  }

  boolean onRhythm(String name) {
    return rhythms.get(name).onRhythm();
  }

  OavpRhythm getRhythm(String name) {
    return rhythms.get(name);
  }

  OavpCounter addCounter(String name) {
    counters.put(name, new OavpCounter());
    return counters.get(name);
  }

  void incrementCounterIf(String name, Boolean trigger) {
    counters.get(name).incrementIf(trigger);
  }

  void incrementCounter(String name) {
    counters.get(name).increment();
  }

  boolean checkCounter(String name) {
    return counters.get(name).hasFinished();
  }

  OavpCounter getCounter(String name) {
    return counters.get(name);
  }

  OavpRotator addRotator(String name) {
    rotators.put(name, new OavpRotator());
    return rotators.get(name);
  }

  OavpRotator getRotator(String name) {
    return rotators.get(name);
  }

  void rotateRotator(String name) {
    rotators.get(name).rotate();
  }

  void rotateRotatorIf(String name, boolean trigger) {
    rotators.get(name).rotateIf(trigger);
  }

  void randomizeRotator(String name) {
    rotators.get(name).randomize();
  }

  void randomizeRotatorIf(String name, boolean trigger) {
    rotators.get(name).randomizeIf(trigger);
  }

  OavpColorRotator addColorRotator(String name) {
    colorRotators.put(name, new OavpColorRotator());
    return colorRotators.get(name);
  }

  OavpColorRotator getColorRotator(String name) {
    return colorRotators.get(name);
  }

  void rotateColorRotator(String name) {
    colorRotators.get(name).rotate();
  }

  void rotateColorRotatorIf(String name, boolean trigger) {
    colorRotators.get(name).rotateIf(trigger);
  }

  void randomizeColorRotator(String name) {
    colorRotators.get(name).randomize();
  }

  void randomizeColorRotatorIf(String name, boolean trigger) {
    colorRotators.get(name).randomizeIf(trigger);
  }

  OavpOscillator addOscillator(String name) {
    oscillators.put(name, new OavpOscillator());
    return oscillators.get(name);
  }

  OavpOscillator getOscillator(String name) {
    return oscillators.get(name);
  }

  OavpNoiseInterval addNoiseIntervals(String name) {
    noiseIntervals.put(name, new OavpNoiseInterval());
    return noiseIntervals.get(name);
  }

  OavpNoiseInterval getNoiseIntervals(String name) {
    return noiseIntervals.get(name);
  }

  void updateNoiseIntervals(String name, String instance, float phase) {
    noiseIntervals.get(name).update(instance, phase);
  }

  OavpTerrain addTerrain(String name) {
    terrains.put(name, new OavpTerrain());
    return terrains.get(name);
  }

  OavpTerrain getTerrain(String name) {
    return terrains.get(name);
  }

  OavpCamera addCamera(String name) {
    cameras.put(name, new OavpCamera());
    return cameras.get(name);
  }

  OavpCamera getCamera(String name) {
    return cameras.get(name);
  }

  void useCamera(String name) {
    cameras.get(name).view();
  }

  void update() {
    updateRhythms();
    updateTrackers();
  }
}