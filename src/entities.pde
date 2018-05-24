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
  float rhythm;
  Minim minim;

  OavpRhythm(Minim minim, float tempo, float rhythm) {
    this.minim = minim;
    this.rhythm = rhythm;
    beat = new BeatDetect();
    beat.setSensitivity(100);
    start(tempo);
  }

  void start(float tempo) {
    out = minim.getLineOut();
    out.setTempo( tempo );
    out.pauseNotes();
    for (int i = 0; i < 1000; ++i) {
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

  void setTempo(float tempo) {
    out = null;
    start(tempo);
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
  float duration;
  Easing easing;

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
    if (value % limit == 0) {
      increment();
      return true;
    }
    return false;
  }
}

public class OavpRotator {
  float value;
  List storage;
  float duration;
  Easing easing;
  int index;
  Ani ani;

  OavpRotator(){
    storage = new ArrayList();
  }

  OavpRotator add(float item) {
    storage.add(item);
    if (storage.size() == 0) {
      value = item;
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
    ani = Ani.to(this, duration, "value", (float) storage.get(currIndex), easing);
  }

  void rotate(float duration, Easing easing) {
    int currIndex = index % storage.size();
    index = index + 1 % storage.size();
    ani = Ani.to(this, duration, "value", (float) storage.get(currIndex), easing);
  }

  void randomize(float duration, Easing easing) {
    index = floor(random(0, storage.size())) % storage.size();
    ani = Ani.to(this, duration, "value", (float) storage.get(index), easing);
  }

  void rotateIf(boolean trigger) {
    if (trigger) {
      rotate(duration, easing);
    }
  }

  void rotateIf(boolean trigger, float duration, Easing easing) {
    if (trigger) {
      rotate(duration, easing);
    }
  }

  void randomizeIf(boolean trigger) {
    if (trigger) {
      randomize(duration, easing);
    }
  }

  void randomizeIf(boolean trigger, float duration, Easing easing) {
    if (trigger) {
      randomize(duration, easing);
    }
  }

  float getValue() {
    return value;
  }
}

public class OavpEntityManager {
  HashMap<String, PShape> svgs;
  HashMap<String, PImage> imgs;
  HashMap<String, OavpAmplitude> amplitudes;
  HashMap<String, OavpInterval> intervals;
  HashMap<String, OavpGridInterval> gridIntervals;
  HashMap<String, List> trackersStorage;
  HashMap<String, OavpRhythm> rhythms;
  HashMap<String, OavpCounter> counters;
  HashMap<String, OavpRotator> rotators;

  OavpEntityManager() {
    svgs = new HashMap<String, PShape>();
    imgs = new HashMap<String, PImage>();
    amplitudes = new HashMap<String, OavpAmplitude>();
    intervals = new HashMap<String, OavpInterval>();
    trackersStorage = new HashMap<String, List>();
    rhythms = new HashMap<String, OavpRhythm>();
    counters = new HashMap<String, OavpCounter>();
    rotators = new HashMap<String, OavpRotator>();
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

  void addRhythm(String name, Minim minim, float tempo, float rhythm) {
    rhythms.put(name, new OavpRhythm(minim, tempo, rhythm));
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

  void update() {
    updateRhythms();
    updateTrackers();
  }
}