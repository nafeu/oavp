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

  OavpInterval(int storageSize) {
    this.storageSize = storageSize;
    this.snapshotSize = 1;
    this.delay = 1;
    intervalData = new float[storageSize][snapshotSize];
  }

  void update(float[] snapshot, float averageWeight) {
    if (frameDelayCount == delay) {
      float[][] temp = new float[storageSize][snapshotSize];
      for (int i = 1; i < storageSize; i++) {
        temp[i] = intervalData[i - 1];
      }
      for (int j = 0; j < storageSize; j++) {
        temp[0][j] = average(snapshot[j], temp[1][j], averageWeight);
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