public class OavpEditor {
  private boolean isEditMode = false;
  private OavpInput input;
  private OavpObjectManager objects;
  private OavpText text;
  private int activeTool = TOOL_MOVE;

  OavpEditor(OavpInput input, OavpObjectManager objects, OavpText text) {
    this.input = input;
    this.objects = objects;
    this.text = text;
  }

  public void handleKeyInputs() {
    if (input.isPressed(KEY_E)) {
      toggleEditMode();
    }

    if (this.isEditMode) {
      if (this.activeTool == TOOL_MOVE) {
        handleToolMoveInputs();
      } else if (this.activeTool == TOOL_RESIZE) {
        handleToolResizeInputs();
      } else if (this.activeTool == TOOL_TRANSFORM) {
        handleToolTransformInputs();
      } else if (this.activeTool == TOOL_ROTATE) {
        handleToolRotateInputs();
      }

      if (input.isPressed(KEY_R)) {
        objects.cycleActiveVariable();
      }

      if (input.isPressed(KEY_T)) {
        cycleActiveTool();
      }
    }

  }

  private void handleToolMoveInputs() {
    int delta = 2;

    if (input.isHoldingShift) {
      delta = 5;
    }

    if (input.isHoldingControl) {
      delta = 1;
    }

    if (input.isPressed(UP)) {
      objects.getActiveVariable().previewY(delta * -1).commitY();
    }

    if (input.isPressed(DOWN)) {
      objects.getActiveVariable().previewY(delta).commitY();
    }

    if (input.isPressed(RIGHT)) {
      objects.getActiveVariable().previewX(delta).commitX();
    }

    if (input.isPressed(LEFT)) {
      objects.getActiveVariable().previewX(delta * -1).commitX();
    }

    if (input.isMousePressed()) {
      objects.getActiveVariable().previewY(input.getYGridTicks() * delta);
      objects.getActiveVariable().previewX(input.getXGridTicks() * delta);
    }

    if (input.isMouseReleased()) {
      objects.getActiveVariable().commitY();
      objects.getActiveVariable().commitX();
      input.resetTicks();
    }

    if (input.isShiftReleased()) {

    }

    if (input.isControlReleased()) {

    }
  }

  private void handleToolResizeInputs() {
    int delta = 2;

    if (input.isHoldingShift) {
      delta = 5;
    }

    if (input.isHoldingControl) {
      delta = 1;
    }

    if (input.isPressed(UP)) {
      objects.getActiveVariable().previewSize(delta * -1).commitSize();
    }

    if (input.isPressed(DOWN)) {
      objects.getActiveVariable().previewSize(delta).commitSize();
    }

    if (input.isMousePressed()) {
      objects.getActiveVariable().previewSize(input.getYGridTicks() * delta);
    }

    if (input.isMouseReleased()) {
      objects.getActiveVariable().commitSize();
      input.resetTicks();
    }

    if (input.isShiftReleased()) {

    }

    if (input.isControlReleased()) {

    }
  }

  private void handleToolTransformInputs() {
    int delta = 2;

    if (input.isHoldingShift) {
      delta = 5;
    }

    if (input.isHoldingControl) {
      delta = 1;
    }

    if (input.isPressed(RIGHT)) {
      objects.getActiveVariable().previewW(delta * -1).commitW();
    }

    if (input.isPressed(LEFT)) {
      objects.getActiveVariable().previewW(delta).commitW();
    }

    if (input.isPressed(UP)) {
      objects.getActiveVariable().previewH(delta * -1).commitH();
    }

    if (input.isPressed(DOWN)) {
      objects.getActiveVariable().previewH(delta).commitH();
    }

    if (input.isMousePressed()) {
      objects.getActiveVariable().previewW(input.getXGridTicks() * delta);
      objects.getActiveVariable().previewH(input.getYGridTicks() * delta);
    }

    if (input.isMouseReleased()) {
      objects.getActiveVariable().commitW();
      objects.getActiveVariable().commitH();
      input.resetTicks();
    }

    if (input.isShiftReleased()) {

    }

    if (input.isControlReleased()) {

    }
  }

  private void handleToolRotateInputs() {
    int delta = 2;

    if (input.isHoldingShift) {
      delta = 5;
    }

    if (input.isHoldingControl) {
      delta = 1;
    }

    if (input.isPressed(RIGHT)) {
      objects.getActiveVariable().previewZR(delta).commitZR();
    }

    if (input.isPressed(LEFT)) {
      objects.getActiveVariable().previewZR(delta * -1).commitZR();
    }

    if (input.isMousePressed()) {
      objects.getActiveVariable().previewZR(input.getYGridTicks() * delta);
    }

    if (input.isMouseReleased()) {
      objects.getActiveVariable().commitZR();
      input.resetTicks();
    }

    if (input.isShiftReleased()) {

    }

    if (input.isControlReleased()) {

    }
  }

  private void toggleEditMode() {
    if (objects.activeObjects.size() > 0) {
      this.isEditMode = !this.isEditMode;
    }
  }

  private void cycleActiveTool() {
    if (this.activeTool == TOOL_MOVE) {
      this.activeTool = TOOL_RESIZE;
    } else if (this.activeTool == TOOL_RESIZE) {
      this.activeTool = TOOL_TRANSFORM;
    } else if (this.activeTool == TOOL_TRANSFORM) {
      this.activeTool = TOOL_ROTATE;
    } else {
      this.activeTool = TOOL_MOVE;
    }
  }

  public boolean isEditMode() {
    return this.isEditMode;
  }

  public void draw() {
    StringBuilder msg = new StringBuilder("editing:");
    msg.append(" " + objects.getActiveVariable().name);
    msg.append(" | tool: " + getActiveToolName());

    text.create()
      .colour(palette.flat.white)
      .size(14)
      .moveDown(oavp.height(0.05))
      .moveRight(oavp.width(0.05))
      .write(msg.toString())
      .done();
  }

  private String getActiveToolName() {
    if (this.activeTool == TOOL_MOVE) {
      return "move";
    }
    if (this.activeTool == TOOL_RESIZE) {
      return "resize";
    }
    if (this.activeTool == TOOL_TRANSFORM) {
      return "transform";
    }
    if (this.activeTool == TOOL_ROTATE) {
      return "rotate";
    }
    return "";
  }

  public void drawIfEditMode() {
    if (this.isEditMode) {
      this.draw();
    }
  }
}

int TOOL_MOVE = 0;
int TOOL_RESIZE = 1;
int TOOL_TRANSFORM = 2;
int TOOL_ROTATE = 3;

// KEYS
int KEY_A = 65;
int KEY_B = 66;
int KEY_C = 67;
int KEY_D = 68;
int KEY_E = 69;
int KEY_F = 70;
int KEY_G = 71;
int KEY_H = 72;
int KEY_I = 73;
int KEY_J = 74;
int KEY_K = 75;
int KEY_L = 76;
int KEY_M = 77;
int KEY_N = 78;
int KEY_O = 79;
int KEY_P = 80;
int KEY_Q = 81;
int KEY_R = 82;
int KEY_S = 83;
int KEY_T = 84;
int KEY_U = 85;
int KEY_V = 86;
int KEY_W = 87;
int KEY_X = 88;
int KEY_Y = 89;
int KEY_Z = 90;
