public class OavpInput {
  private int pressedKey;
  private boolean isHoldingShift = false;

  OavpInput() {}

  void handleKeyPressed(int code) {
    if (code == SHIFT) {
      this.isHoldingShift = true;
    } else {
      this.pressedKey = code;
    }
  }

  boolean isPressed(int code) {
    if (this.pressedKey == code) {
      this.pressedKey = 0;
      return true;
    }
    return false;
  }
}