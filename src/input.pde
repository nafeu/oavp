public class OavpInput {
  private int pressedKey;
  private boolean isHoldingShift = false;
  private boolean isHoldingControl = false;
  private boolean isMousePressed = false;

  private int xStart = 0;
  private int xEnd = 0;
  private int yStart = 0;
  private int yEnd = 0;
  private float xDist = 0;
  private float yDist = 0;

  private int xGridTicks = 0;
  private int yGridTicks = 0;

  OavpInput() {}

  void handleKeyPressed(int code) {
    if (code == SHIFT) {
      this.isHoldingShift = true;
    } else if (code == CONTROL) {
      this.isHoldingControl = true;
    } else {
      this.pressedKey = code;
    }
  }

  void handleMousePressed() {
    noCursor();
    this.isMousePressed = true;
    this.xStart = mouseX;
    this.yStart = mouseY;
  }

  void update() {
    this.xEnd = mouseX;
    this.yEnd = mouseY;
    if (this.isMousePressed) {
      this.xGridTicks = xEnd - xStart;
      this.yGridTicks = yEnd - yStart;
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

  boolean isShiftReleased() {
    if (this.isHoldingShift) {
      if (!keyPressed) {
        this.isHoldingShift = false;
        return true;
      } else if (keyPressed && keyCode != SHIFT) {
        return false;
      }
    }
    return false;
  }

  boolean isControlReleased() {
    if (this.isHoldingControl) {
      if (!keyPressed) {
        this.isHoldingControl = false;
        return true;
      } else if (keyPressed && keyCode != CONTROL) {
        return false;
      }
    }
    return false;
  }

  boolean isMousePressed() {
    return mousePressed;
  }

  boolean isShiftPressed() {
    return (keyPressed && keyCode == SHIFT);
  }

  boolean isControlPressed() {
    return (keyPressed && keyCode == CONTROL);
  }

  public void resetTicks() {
    this.xGridTicks = 0;
    this.yGridTicks = 0;
  }

  public void resetYTicks() {
    this.yGridTicks = 0;
  }

  public void resetXTicks() {
    this.xGridTicks = 0;
  }
}