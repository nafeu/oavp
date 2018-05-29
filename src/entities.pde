public class OavpAmplitude {
  float value = 0;
  float duration;
  Easing easing;
  Ani ani;

  OavpAmplitude(float duration, Easing easing) {
    this.duration = duration;
    this.easing = easing;
  }

  float getValue() {
    return value;
  }

  void update(Boolean trigger) {
    if (trigger) {
      value = 1;
      ani = Ani.to(this, duration, "value", 0, easing);
    }
  }
}

public class OavpInterval {
  float[][] intervalData;
  int storageSize;
  int snapshotSize;
  int frameDelayCount = 0;
  int delay;

  OavpInterval(int storageSize, int snapshotSize) {
    this.storageSize = storageSize;
    this.snapshotSize = snapshotSize;
    this.delay = 1;
    intervalData = new float[storageSize][snapshotSize];
  }

  void update(float[] snapshot) {
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

  void update(float snapshot, float averageWeight) {
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

  void update(boolean rawSnapshot) {
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

  float[] getIntervalData(int i) {
    return intervalData[i];
  }

  int getIntervalSize() {
    return intervalData.length;
  }

  void setDelay(int delay) {
    this.delay = delay;
  }

  float average(float a, float b, float weight) {
    return (a + (weight * b)) / (1 + weight);
  }

  float average(float a, float b) {
    return (a + b) / 2;
  }
}

public class OavpGridInterval {
  float[][] data;
  public int numRows;
  public int numCols;
  int frameDelayCount = 0;
  int delay;

  OavpGridInterval(int numRows, int numCols) {
    this.numRows = numRows;
    this.numCols = numCols;
    this.delay = 1;
    data = new float[numRows][numCols];
  }

  void update(float value, float averageWeight) {
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

  void updateDiagonal(float value, float averageWeight) {
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

  void updateDimensional(float value, float averageWeight) {
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

  float castBoolean(boolean bool) {
    if (bool) {
      return 1.0;
    }
    return 0.0;
  }

  float getData(int i, int j) {
    return data[i][j];
  }

  void setDelay(int delay) {
    this.delay = delay;
  }

  float average(float a, float b, float weight) {
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

public class OavpNoise {
  HashMap<String, float[]> terrains;
  HashMap<String, int[]> structures;
  int numPoints = 100;
  float granularity = 0.01;
  int variance = 10;

  OavpNoise() {
    terrains = new HashMap<String, float[]>();
    structures = new HashMap<String, int[]>();
  }

  OavpNoise generate(String name) {
    terrains.put(name, new float[numPoints]);
    structures.put(name, new int[numPoints]);
    return this;
  }

  OavpNoise granularity(float granularity) {
    this.granularity = granularity;
    return this;
  }

  OavpNoise variance(int variance) {
    this.variance = variance;
    return this;
  }

  OavpNoise numPoints(int numPoints) {
    this.numPoints = numPoints;
    return this;
  }

  void update(String name, float phase) {
    for (int i = 0; i < numPoints; i++) {
      float point = refinedNoise(i + phase, granularity);
      terrains.get(name)[i] = point;
      structures.get(name)[i] = int(point * variance);
    }
  }

  float[] getTerrain(String name) {
    return terrains.get(name);
  }

  float[] getTerrain(float phase, float granularity) {
    float[] out = new float[numPoints];
    for (int i = 0; i < numPoints; i++) {
      out[i] = refinedNoise(i + phase, granularity);
    }
    return out;
  }

  int[] getStructure(String name) {
    return structures.get(name);
  }

  int[] getStructure(float phase, float granularity, int variance) {
    int[] out = new int[numPoints];
    for (int i = 0; i < numPoints; i++) {
      out[i] = quantizedNoise(i + phase, granularity, variance);
    }
    return out;
  }

  float getNoise(float phase) {
    return refinedNoise(phase, granularity);
  }

  int getQuantizedNoise(float phase, int variance) {
    return quantizedNoise(phase, granularity, variance);
  }
}

public class OavpEntityManager {
  Minim minim;
  HashMap<String, PShape> svgs;
  HashMap<String, PImage> imgs;
  HashMap<String, OavpAmplitude> amplitudes;
  HashMap<String, OavpInterval> intervals;
  HashMap<String, OavpGridInterval> gridIntervals;
  HashMap<String, List> trackersStorage;
  HashMap<String, OavpRhythm> rhythms;
  HashMap<String, OavpCounter> counters;
  HashMap<String, OavpRotator> rotators;
  HashMap<String, OavpColorRotator> colorRotators;
  HashMap<String, OavpOscillator> oscillators;
  HashMap<String, OavpNoise> noises;

  OavpEntityManager(Minim minim) {
    this.minim = minim;
    svgs = new HashMap<String, PShape>();
    imgs = new HashMap<String, PImage>();
    amplitudes = new HashMap<String, OavpAmplitude>();
    intervals = new HashMap<String, OavpInterval>();
    trackersStorage = new HashMap<String, List>();
    rhythms = new HashMap<String, OavpRhythm>();
    counters = new HashMap<String, OavpCounter>();
    rotators = new HashMap<String, OavpRotator>();
    colorRotators = new HashMap<String, OavpColorRotator>();
    oscillators = new HashMap<String, OavpOscillator>();
    noises = new HashMap<String, OavpNoise>();
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

  void addAmplitude(String name, float duration, Easing easing) {
    amplitudes.put(name, new OavpAmplitude(duration, easing));
  }

  OavpAmplitude getAmplitude(String name) {
    return amplitudes.get(name);
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

  OavpNoise addNoise(String name) {
    noises.put(name, new OavpNoise());
    return noises.get(name);
  }

  OavpNoise getNoise(String name) {
    return noises.get(name);
  }

  void updateNoise(String name, String instance, float phase) {
    noises.get(name).update(instance, phase);
  }

  void update() {
    updateRhythms();
    updateTrackers();
  }
}