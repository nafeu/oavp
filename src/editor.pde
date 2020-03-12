public class OavpEditor {
  private boolean isEditMode = false;
  private boolean isHelpMode = false;
  private OavpInput input;
  private OavpObjectManager objects;
  private OavpText text;
  private int activeTool = TOOL_MOVE;
  private int colorPaletteIndex = 0;
  private int colorIndex = 0;
  private color[] activePalette;

  OavpEditor(OavpInput input, OavpObjectManager objects, OavpText text) {
    this.input = input;
    this.objects = objects;
    this.text = text;
    this.activePalette = palette.getPalette(colorPaletteIndex);
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
      } else if (this.activeTool == TOOL_ARRANGE) {
        handleToolArrangeInputs();
      } else if (this.activeTool == TOOL_TURN) {
        handleToolTurnInputs();
      } else if (this.activeTool == TOOL_COLOR) {
        handleToolColorInputs();
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

      if (input.isPressed(KEY_N)) {
        this.activeTool = TOOL_ARRANGE;
      }

      if (input.isPressed(KEY_Y)) {
        this.activeTool = TOOL_TURN;
      }

      if (input.isPressed(KEY_C)) {
        this.activeTool = TOOL_COLOR;
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

  private void handleToolArrangeInputs() {
    int delta = DELTA_ARRANGE;

    if (input.isHoldingShift) {
      delta = DELTA_ARRANGE_SHIFT;
    }

    if (input.isHoldingControl) {
      delta = DELTA_ARRANGE_CTRL;
    }

    if (input.isPressed(UP)) {
      objects.getActiveVariable().previewZ(delta * -1).commitZ();
    }

    if (input.isPressed(DOWN)) {
      objects.getActiveVariable().previewZ(delta).commitZ();
    }

    if (input.isMousePressed()) {
      objects.getActiveVariable().previewZ(input.getYGridTicks() * delta);
    }

    if (input.isMouseReleased()) {
      objects.getActiveVariable().commitZ();
      input.resetTicks();
    }

    if (input.isShiftReleased()) {

    }

    if (input.isControlReleased()) {

    }
  }

  private void handleToolTurnInputs() {
    int delta = DELTA_TURN;

    if (input.isHoldingShift) {
      delta = DELTA_TURN_SHIFT;
    }

    if (input.isHoldingControl) {
      delta = DELTA_TURN_CTRL;
    }

    if (input.isPressed(UP)) {
      objects.getActiveVariable().previewXR(delta).commitXR();
    }

    if (input.isPressed(DOWN)) {
      objects.getActiveVariable().previewXR(delta * -1).commitXR();
    }

    if (input.isPressed(RIGHT)) {
      objects.getActiveVariable().previewYR(delta).commitYR();
    }

    if (input.isPressed(LEFT)) {
      objects.getActiveVariable().previewYR(delta * -1).commitYR();
    }

    if (input.isMousePressed()) {
      objects.getActiveVariable().previewXR(input.getYGridTicks() * delta * -1);
      objects.getActiveVariable().previewYR(input.getXGridTicks() * delta);
    }

    if (input.isMouseReleased()) {
      objects.getActiveVariable().commitYR();
      objects.getActiveVariable().commitXR();
      input.resetTicks();
    }

    if (input.isShiftReleased()) {

    }

    if (input.isControlReleased()) {

    }
  }

  private void handleToolColorInputs() {
    if (input.isHoldingShift) {

    }

    if (input.isHoldingControl) {

    }

    if (input.isPressed(UP)) {
      if (this.colorIndex == 0) {
        this.colorIndex = this.activePalette.length - 1;
      } else {
        this.colorIndex = (this.colorIndex - 1) % this.activePalette.length;
      }
    }

    if (input.isPressed(DOWN)) {
      this.colorIndex = (this.colorIndex + 1) % this.activePalette.length;
    }

    if (input.isPressed(RIGHT)) {
      this.colorPaletteIndex = (this.colorPaletteIndex + 1) % palette.table.length;
      this.activePalette = palette.getPalette(colorPaletteIndex);
      this.colorIndex = this.colorIndex % this.activePalette.length;
    }

    if (input.isPressed(LEFT)) {
      if (this.colorPaletteIndex == 0) {
        this.colorPaletteIndex = palette.table.length - 1;
      } else {
        this.colorPaletteIndex = (this.colorPaletteIndex - 1) % palette.table.length;
        this.activePalette = palette.getPalette(colorPaletteIndex);
        this.colorIndex = this.colorIndex % this.activePalette.length;
      }
    }

    if (input.isPressed(ENTER)) {
      if (input.isHoldingControl) {
        objects.getActiveVariable().fillColor(0);
        objects.getActiveVariable().strokeColor(0);
      } else if (input.isHoldingShift) {
        objects.getActiveVariable().fillColor(this.activePalette[this.colorIndex]);
      } else {
        objects.getActiveVariable().strokeColor(this.activePalette[this.colorIndex]);
      }
    }

    if (input.isMousePressed()) {
      // input.getYGridTicks();
      // input.getXGridTicks();
    }

    if (input.isMouseReleased()) {
      // objects.getActiveVariable().commitYR();
      // objects.getActiveVariable().commitXR();
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

  public boolean isEditMode() {
    return this.isEditMode;
  }

  public void draw() {
    OavpVariable activeVariable = objects.getActiveVariable();

    drawToolMeta(activeVariable, this.activeTool);

    if (this.isHelpMode) {
      text.create()
        .colour(palette.flat.white)
        .size(12)
        .moveDown(oavp.height(0.95))
        .moveRight(oavp.width(0.02))
        .write("e: edit | t: transform | s: resize | m: move | r: rotate\nj: prev | l: next | d: dupl")
        .done();
    }

  }

  private String getActiveToolName() {
    if (this.activeTool == TOOL_MOVE) {
      return "move";
    }
    if (this.activeTool == TOOL_ARRANGE) {
      return "arrange";
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
    if (this.activeTool == TOOL_TURN) {
      return "turn";
    }
    if (this.activeTool == TOOL_COLOR) {
      return "color";
    }
    return "";
  }

  public void drawIfEditMode() {
    if (this.isEditMode) {
      this.draw();
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

      case 4: // ARRANGE
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.teal)
          .strokeWeightStyle(2)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .draw.basicSquare(100)
          .draw.basicCircle(10)
          .done();

        text.create()
          .center().middle()
          .colour(palette.flat.teal)
          .size(10)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .moveDown(20)
          .write("z: " + activeVariable.z)
          .done();
        break;

      case 5: // TURN
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.darkTeal)
          .strokeWeightStyle(2)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .rotate(0, 0, 45)
          .draw.basicRectangle(15, 15, 50)
          .done();

        text.create()
          .center().middle()
          .colour(palette.flat.darkTeal)
          .size(10)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .moveDown(20)
          .write("xr: " + activeVariable.xr)
          .moveDown(10)
          .write("yr: " + activeVariable.yr)
          .done();
        break;

      case 6: // COLOR
        visualizers
          .create()
          .center().middle()
          .strokeWeightStyle(2)
          .move(activeVariable.x, activeVariable.y, activeVariable.z);

        if (input.isHoldingShift) {
          visualizers
            .strokeColor(palette.flat.black)
            .fillColor(this.activePalette[colorIndex]);
        } else {
          visualizers
            .strokeColor(this.activePalette[colorIndex])
            .fillColor(palette.flat.black);
        }

        visualizers
          .draw.basicRectangle(20, 10)
          .strokeColor(palette.flat.black)
          .moveRight(20)
          .moveUp(10 * colorIndex);

        for (int i = 0; i < this.activePalette.length; i++) {
          visualizers
            .fillColor(this.activePalette[i])
            .draw.basicRectangle(20, 10)
            .moveDown(10);
        }

        visualizers
          .done();

        break;
    }
  }
}


int TOOL_MOVE = 0;
int TOOL_RESIZE = 1;
int TOOL_TRANSFORM = 2;
int TOOL_ROTATE = 3;
int TOOL_ARRANGE = 4;
int TOOL_TURN = 5;
int TOOL_COLOR = 6;

// KEYS
int KEY_ENTER = 10;
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

int DELTA_ARRANGE = 10;
int DELTA_ARRANGE_SHIFT = 5;
int DELTA_ARRANGE_CTRL = 1;

int DELTA_TURN = 3;
int DELTA_TURN_SHIFT = 2;
int DELTA_TURN_CTRL = 1;