public class OavpPosition {
  public int x;
  public int y;
  private int startingX;
  private int startingY;
  public float scale;
  public int[] xRange = new int[2];
  public int[] yRange = new int[2];
  OavpPosition(int initialX, int initialY, float initialScale) {
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
  public float getScaledX() {
    return x * scale;
  }
  public float getCenteredX() {
    return x * scale + (scale / 2);
  }
  public float getScaledY() {
    return y * scale;
  }
  public float getCenteredY() {
    return y * scale + (scale / 2);
  }
  public int getLowerBoundX() {
    return xRange[0];
  }
  public int getUpperBoundX() {
    return xRange[1];
  }
  public int getLowerBoundY() {
    return yRange[0];
  }
  public int getUpperBoundY() {
    return yRange[1];
  }
  public void moveLeft() {
    x -= 1;
    if (x < xRange[0]) {
      xRange[0] = x;
    }
  }
  public void moveRight() {
    x += 1;
    if (x > xRange[1]) {
      xRange[1] = x;
    }
  }
  public void moveUp() {
    y -= 1;
    if (y < yRange[0]) {
      yRange[0] = y;
    }
  }
  public void moveDown() {
    y += 1;
    if (y > yRange[1]) {
      yRange[0] = y;
    }
  }
  public void moveToNextLine() {
    x = xRange[0];
    y += 1;
    if (y > yRange[1]) {
      yRange[1] = y;
    }
  }
  public void moveToPrevLine() {
    x = xRange[1];
    y -= 1;
    if (y < yRange[0]) {
      yRange[0] = y;
    }
  }
  public boolean moveLeft(int boundary) {
    if (x > boundary) {
      x -= 1;
      if (x < xRange[0]) {
        xRange[0] = x;
      }
      return true;
    }
    return false;
  }
  public boolean moveRight(int boundary) {
    if (x < boundary) {
      x += 1;
      if (x > xRange[1]) {
        xRange[1] = x;
      }
      return true;
    }
    return false;
  }
  public boolean moveUp(int boundary) {
    if (y > boundary) {
      y -= 1;
      if (y < yRange[0]) {
        yRange[0] = y;
      }
      return true;
    }
    return false;
  }
  public boolean moveDown(int boundary) {
    if (y < boundary) {
      y += 1;
      if (y > yRange[1]) {
        yRange[0] = y;
      }
      return true;
    }
    return false;
  }
  public boolean moveToNextLine(int boundary) {
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
  public boolean moveToPrevLine(int boundary) {
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
  public void reset() {
    x = startingX;
    y = startingY;
  }
}