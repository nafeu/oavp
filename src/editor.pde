public class OavpEditor {
  private boolean isEditMode = false;
  private boolean isHelpMode = false;
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

      if (input.isPressed(KEY_L)) {
        objects.nextActiveVariable();
      }

      if (input.isPressed(KEY_J)) {
        objects.prevActiveVariable();
      }

      if (input.isPressed(KEY_T)) {
        this.activeTool = TOOL_TRANSFORM;
      }

      if (input.isPressed(KEY_S)) {
        this.activeTool = TOOL_RESIZE;
      }

      if (input.isPressed(KEY_M)) {
        this.activeTool = TOOL_MOVE;
      }

      if (input.isPressed(KEY_R)) {
        this.activeTool = TOOL_ROTATE;
      }

      if (input.isPressed(KEY_D)) {
        objects.duplicate();
      }

      if (input.isPressed(KEY_H)) {
        toggleHelpMode();
      }

      if (input.isPressed(KEY_X)) {
        objects.printObjectData();
      }

      if (input.isPressed(KEY_W)) {
        objects.remove();
      }
    }

  }

  private void handleToolMoveInputs() {
    int delta = DELTA_MOVEMENT;

    if (input.isHoldingShift) {
      delta = DELTA_MOVEMENT_SHIFT;
    }

    if (input.isHoldingControl) {
      delta = DELTA_MOVEMENT_CTRL;
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
    int delta = DELTA_RESIZE;

    if (input.isHoldingShift) {
      delta = DELTA_RESIZE_SHIFT;
    }

    if (input.isHoldingControl) {
      delta = DELTA_RESIZE_CTRL;
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
    int delta = DELTA_TRANSFORM;

    if (input.isHoldingShift) {
      delta = DELTA_TRANSFORM_SHIFT;
    }

    if (input.isHoldingControl) {
      delta = DELTA_TRANSFORM_CTRL;
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
    int delta = DELTA_ROTATE;

    if (input.isHoldingShift) {
      delta = DELTA_ROTATE_SHIFT;
    }

    if (input.isHoldingControl) {
      delta = DELTA_ROTATE_CTRL;
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

  private void toggleHelpMode() {
    this.isHelpMode = !this.isHelpMode;
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
    OavpVariable activeVariable = objects.getActiveVariable();

    drawToolMeta(activeVariable, this.activeTool);

    if (this.isHelpMode) {
      StringBuilder topBar = new StringBuilder("editing:");
      topBar.append(" " + activeVariable.name);
      topBar.append(" | tool: " + getActiveToolName());

      text.create()
        .colour(palette.flat.white)
        .size(12)
        .moveDown(oavp.height(0.05))
        .moveRight(oavp.width(0.05))
        .write(topBar.toString())
        .done();

      StringBuilder bottomBar = new StringBuilder("e: close edit mode | t: transform | s: resize | m: move | r: rotate\n");
      bottomBar.append("j: prev obj | l: next obj | d: duplicate");

      text.create()
        .colour(palette.flat.white)
        .size(10)
        .moveDown(oavp.height(0.95))
        .moveRight(oavp.width(0.05))
        .write(bottomBar.toString())
        .done();
    }

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

public void drawToolMeta(OavpVariable activeVariable, int activeTool) {
  switch (activeTool) {
    case 0: // MOVE
      visualizers
        .create()
        .center().middle()
        .strokeColor(palette.flat.blue)
        .strokeWeightStyle(2)
        .move(activeVariable.x, activeVariable.y, activeVariable.z)
        .draw.basicSquare(100)
        .draw.basicCircle(10)
        .done();

      text.create()
        .center().middle()
        .colour(palette.flat.blue)
        .size(10)
        .move(activeVariable.x, activeVariable.y, activeVariable.z)
        .moveDown(20)
        .write("x: " + activeVariable.x)
        .moveDown(10)
        .write("y: " + activeVariable.y)
        .done();
      break;

    case 1: // RESIZE
      visualizers
        .create()
        .center().middle()
        .strokeColor(palette.flat.orange)
        .strokeWeightStyle(2)
        .move(activeVariable.x, activeVariable.y, activeVariable.z)
        .draw.basicRectangle(activeVariable.size, activeVariable.size, 50)
        .draw.basicSquare(25)
        .draw.basicCircle(5)
        .done();

      text.create()
        .center().middle()
        .colour(palette.flat.orange)
        .size(10)
        .move(activeVariable.x, activeVariable.y, activeVariable.z)
        .moveDown(20)
        .write("size: " + activeVariable.size)
        .done();
      break;

    case 2: // TRANSFORM
      visualizers
        .create()
        .center().middle()
        .strokeColor(palette.flat.yellow)
        .strokeWeightStyle(2)
        .move(activeVariable.x, activeVariable.y, activeVariable.z)
        .rotate(activeVariable.xr, activeVariable.yr, activeVariable.zr)
        .draw.basicRectangle(activeVariable.w, activeVariable.h)
        .draw.basicCircle(10)
        .done();

      text.create()
        .center().middle()
        .colour(palette.flat.yellow)
        .size(10)
        .move(activeVariable.x, activeVariable.y, activeVariable.z)
        .moveDown(20)
        .write("w: " + activeVariable.w)
        .moveDown(10)
        .write("h: " + activeVariable.h)
        .done();
      break;

    case 3: // ROTATE
      visualizers
        .create()
        .center().middle()
        .strokeColor(palette.flat.green)
        .strokeWeightStyle(2)
        .move(activeVariable.x, activeVariable.y, activeVariable.z)
        .rotate(0, 0, 45)
        .draw.basicSquare(15)
        .done();

      text.create()
        .center().middle()
        .colour(palette.flat.green)
        .size(10)
        .move(activeVariable.x, activeVariable.y, activeVariable.z)
        .moveDown(20)
        .write("zr: " + activeVariable.zr)
        .done();
      break;
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

int DELTA_MOVEMENT = 10;
int DELTA_MOVEMENT_SHIFT = 5;
int DELTA_MOVEMENT_CTRL = 1;

int DELTA_RESIZE = 10;
int DELTA_RESIZE_SHIFT = 5;
int DELTA_RESIZE_CTRL = 1;

int DELTA_TRANSFORM = 10;
int DELTA_TRANSFORM_SHIFT = 5;
int DELTA_TRANSFORM_CTRL = 1;

int DELTA_ROTATE = 3;
int DELTA_ROTATE_SHIFT = 2;
int DELTA_ROTATE_CTRL = 1;