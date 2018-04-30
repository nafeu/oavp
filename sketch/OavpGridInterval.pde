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

  OavpGridInterval(int numRows) {
    this.numRows = numRows;
    this.numCols = numRows;
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