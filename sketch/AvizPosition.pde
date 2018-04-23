public class AvizPosition {
  public int x;
  public int y;
  private int startingX;
  private int startingY;
  public float scale;
  public int[] xRange = new int[2];
  public int[] yRange = new int[2];
  AvizPosition(int initialX, int initialY, float initialScale) {
    x = initialX;
    startingX = initialX;
    y = initialY;
    startingY = initialY;
    xRange[0] = x;
    xRange[1] = x;
    yRange[0] = y;
    yRange[1] = y;
    scale = initialScale;
  }
  float getScaledX() {
    return x * scale;
  }
  float getCenteredX() {
    return x * scale + (scale / 2);
  }
  float getScaledY() {
    return y * scale;
  }
  float getCenteredY() {
    return y * scale + (scale / 2);
  }
  int getLowerBoundX() {
    return xRange[0];
  }
  int getUpperBoundX() {
    return xRange[1];
  }
  int getLowerBoundY() {
    return yRange[0];
  }
  int getUpperBoundY() {
    return yRange[1];
  }
  void moveLeft() {
    x -= 1;
    if (x < xRange[0]) {
      xRange[0] = x;
    }
  }
  void moveRight() {
    x += 1;
    if (x > xRange[1]) {
      xRange[1] = x;
    }
  }
  void moveUp() {
    y -= 1;
    if (y < yRange[0]) {
      yRange[0] = y;
    }
  }
  void moveDown() {
    y += 1;
    if (y > yRange[1]) {
      yRange[0] = y;
    }
  }
  void moveToNextLine() {
    x = xRange[0];
    y += 1;
    if (y > yRange[1]) {
      yRange[1] = y;
    }
  }
  void moveToPrevLine() {
    x = xRange[1];
    y -= 1;
    if (y < yRange[0]) {
      yRange[0] = y;
    }
  }
  boolean moveLeft(int boundary) {
    if (x > boundary) {
      x -= 1;
      if (x < xRange[0]) {
        xRange[0] = x;
      }
      return true;
    }
    return false;
  }
  boolean moveRight(int boundary) {
    if (x < boundary) {
      x += 1;
      if (x > xRange[1]) {
        xRange[1] = x;
      }
      return true;
    }
    return false;
  }
  boolean moveUp(int boundary) {
    if (y > boundary) {
      y -= 1;
      if (y < yRange[0]) {
        yRange[0] = y;
      }
      return true;
    }
    return false;
  }
  boolean moveDown(int boundary) {
    if (y < boundary) {
      y += 1;
      if (y > yRange[1]) {
        yRange[0] = y;
      }
      return true;
    }
    return false;
  }
  boolean moveToNextLine(int boundary) {
    if (y < boundary) {
      x = xRange[0];
      y += 1;
      if (y > yRange[1]) {
        yRange[1] = y;
      }
      return true;
    }
    return false;
  }
  boolean moveToPrevLine(int boundary) {
    if (y > boundary) {
      x = xRange[1];
      y -= 1;
      if (y < yRange[0]) {
        yRange[0] = y;
      }
      return true;
    }
    return false;
  }
  void reset() {
    x = startingX;
    y = startingY;
  }
}