public class OavpInput {
  private int pressedKey;
  private boolean isHoldingShift = false;
  private boolean isMousePressed = false;

  private float xStart = 0;
  private float xEnd = 0;
  private float yStart = 0;
  private float yEnd = 0;
  private float xDist = 0;
  private float yDist = 0;

  private int xGridTicks = 0;
  private int yGridTicks = 0;
  private float snapGrid = 0.05;

  OavpInput() {}

  void handleKeyPressed(int code) {
    if (code == SHIFT) {
      this.isHoldingShift = true;
    } else {
      this.pressedKey = code;
    }
  }

  void handleMousePressed() {
    noCursor();
    this.isMousePressed = true;
    this.xStart = normalMouseX;
    this.yStart = normalMouseY;
  }

  void update() {
    this.xEnd = normalMouseX;
    this.yEnd = normalMouseY;
    if (this.isMousePressed) {
      this.xGridTicks = floor((xEnd - xStart) / snapGrid);
      this.yGridTicks = floor((yEnd - yStart) / snapGrid);
    }
  }

  void handleMouseReleased() {
    cursor();
    this.xDist = xEnd - xStart;
    this.yDist = yEnd - yStart;
    this.xStart = 0;
    this.yStart = 0;
    this.xEnd = 0;
    this.yEnd = 0;
  }

  public int getXGridTicks() {
    return this.xGridTicks;
  }

  public int getYGridTicks() {
    return this.yGridTicks;
  }

  boolean isPressed(int code) {
    if (this.pressedKey == code) {
      this.pressedKey = 0;
      return true;
    }
    return false;
  }

  boolean isMouseReleased() {
    if (!mousePressed && this.isMousePressed) {
      this.isMousePressed = false;
      return true;
    }
    return false;
  }

  boolean isMousePressed() {
    return mousePressed;
  }

  public void resetTicks() {
    this.xGridTicks = 0;
    this.yGridTicks = 0;
  }
}