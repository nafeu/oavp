public class OavpEditor {
  private boolean isEditMode = false;
  private boolean isHelpMode = false;
  private boolean isCreateMode = false;
  private boolean isSelectModifierTypeMode = false;
  private OavpInput input;
  private OavpObjectManager objects;
  private OavpText text;
  private int activeTool = TOOL_MOVE;
  private int colorPaletteIndex = 0;
  private int colorIndex = 0;
  private color[] activePalette;
  private int createModeSelectionIndex = 0;
  private List<String> selectableObjects;
  private List<String> availableModifierFields;
  private List<String> availableModifierTypes;
  private int selectedModifierFieldIndex = 0;
  private int selectedModifierTypeIndex = 0;

  OavpEditor(OavpInput input, OavpObjectManager objects, OavpText text) {
    this.input = input;
    this.objects = objects;
    this.text = text;
    this.activePalette = palette.getPalette(colorPaletteIndex);
    this.selectableObjects = new ArrayList<String>();
    this.availableModifierFields = new ArrayList<String>();
    this.availableModifierTypes = new ArrayList<String>();
    for (String objectType : OBJECT_LIST) {
      selectableObjects.add(objectType);
    }
    for (String modifierField : MODIFIER_FIELDS) {
      availableModifierFields.add(modifierField);
    }
    for (String modifierType : MODIFIER_TYPES) {
      availableModifierTypes.add(modifierType);
    }
  }

  public void handleKeyInputs() {
    if (input.isPressed(KEY_E)) {
      toggleEditMode();
    }

    if (this.isEditMode) {
      if (this.isCreateMode) {
        handleCreateModeInputs();
      } else if (this.activeTool == TOOL_MOVE) {
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
      } else if (this.activeTool == TOOL_WEIGHT) {
        handleToolWeightInputs();
      } else if (this.activeTool == TOOL_MODIFIER) {
        handleToolModifierInputs();
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

      if (input.isPressed(KEY_B)) {
        this.activeTool = TOOL_WEIGHT;
      }

      if (input.isPressed(KEY_D)) {
        objects.duplicate();
      }

      if (input.isPressed(KEY_H)) {
        toggleCreateMode();
      }

      if (input.isPressed(KEY_X)) {
        objects.printObjectData();
      }

      if (input.isPressed(KEY_W)) {
        objects.remove();
      }

      if (input.isPressed(KEY_Z)) {
        if (this.activeTool == TOOL_MODIFIER) {
          this.isSelectModifierTypeMode = !this.isSelectModifierTypeMode;
        }
        this.activeTool = TOOL_MODIFIER;
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
      if (input.isHoldingShift) {
        objects.getActiveVariable().fillColor(this.activePalette[this.colorIndex]);
      } else {
        objects.getActiveVariable().strokeColor(this.activePalette[this.colorIndex]);
      }
    }

    if (input.isPressed(KEY_C)) {
      if (input.isHoldingShift) {
        objects.getActiveVariable().fillColor(0);
      }
      if (input.isHoldingControl) {
        objects.getActiveVariable().strokeColor(0);
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

  private void handleToolWeightInputs() {
    float delta = DELTA_WEIGHT;

    if (input.isHoldingShift) {
      delta = DELTA_WEIGHT_SHIFT;
    }

    if (input.isHoldingControl) {
      delta = DELTA_WEIGHT_CTRL;
    }

    if (input.isPressed(UP)) {
      objects.getActiveVariable().previewStrokeWeight(delta * -1).commitStrokeWeight();
    }

    if (input.isPressed(DOWN)) {
      objects.getActiveVariable().previewStrokeWeight(delta).commitStrokeWeight();
    }

    if (input.isMousePressed()) {
      objects.getActiveVariable().previewStrokeWeight(input.getYGridTicks() * delta);
    }

    if (input.isMouseReleased()) {
      objects.getActiveVariable().commitStrokeWeight();
      input.resetTicks();
    }

    if (input.isShiftReleased()) {

    }

    if (input.isControlReleased()) {

    }
  }

  private void handleCreateModeInputs() {
    if (input.isHoldingShift) {

    }

    if (input.isHoldingControl) {

    }

    if (input.isPressed(UP)) {
      if (this.createModeSelectionIndex - CREATE_MODE_COLUMN_COUNT >= 0) {
        this.createModeSelectionIndex -= CREATE_MODE_COLUMN_COUNT;
      }
    }

    if (input.isPressed(DOWN)) {
      if (this.createModeSelectionIndex + CREATE_MODE_COLUMN_COUNT < this.selectableObjects.size()) {
        this.createModeSelectionIndex += CREATE_MODE_COLUMN_COUNT;
      }
    }

    if (input.isPressed(RIGHT)) {
      if (this.createModeSelectionIndex + 1 < this.selectableObjects.size()) {
        this.createModeSelectionIndex += 1;
      }
    }

    if (input.isPressed(LEFT)) {
      if (this.createModeSelectionIndex - 1 >= 0) {
        this.createModeSelectionIndex -= 1;
      }
    }

    if (input.isPressed(ENTER)) {
      handleCreateModeSelection(this.createModeSelectionIndex);
    }

    if (input.isMousePressed()) {

    }

    if (input.isMouseReleased()) {
      handleCreateModeSelection(this.createModeSelectionIndex);
    }

    if (input.isShiftReleased()) {

    }

    if (input.isControlReleased()) {

    }
  }

  private void handleToolModifierInputs() {
    float delta = DELTA_MODIFIER;

    if (input.isHoldingShift) {
      delta = DELTA_MODIFIER_SHIFT;
    }

    if (input.isHoldingControl) {
      delta = DELTA_MODIFIER_CTRL;
    }

    if (input.isPressed(UP)) {
      if (this.isSelectModifierTypeMode) {
        if (this.selectedModifierTypeIndex - SELECT_MODIFIER_TYPE_MODE_COLUMN_COUNT >= 0) {
          this.selectedModifierTypeIndex -= SELECT_MODIFIER_TYPE_MODE_COLUMN_COUNT;
        }
      } else {
        this.setModifierValue(this.getModifierValue() + delta);
      }
    }

    if (input.isPressed(DOWN)) {
      if (this.isSelectModifierTypeMode) {
        if (this.selectedModifierTypeIndex + SELECT_MODIFIER_TYPE_MODE_COLUMN_COUNT < this.availableModifierTypes.size()) {
          this.selectedModifierTypeIndex += SELECT_MODIFIER_TYPE_MODE_COLUMN_COUNT;
        }
      } else {
        this.setModifierValue(this.getModifierValue() - delta);
      }
    }

    if (input.isPressed(RIGHT)) {
      if (this.isSelectModifierTypeMode) {
        if (this.selectedModifierTypeIndex + 1 < this.selectableObjects.size()) {
          this.selectedModifierTypeIndex += 1;
        }
      } else {
        if (this.selectedModifierFieldIndex < availableModifierFields.size() - 1) {
          this.selectedModifierFieldIndex += 1;
        }
      }
    }

    if (input.isPressed(LEFT)) {
      if (this.isSelectModifierTypeMode) {
        if (this.selectedModifierTypeIndex - 1 >= 0) {
          this.selectedModifierTypeIndex -= 1;
        }
      } else {
        if (this.selectedModifierFieldIndex > 0) {
          this.selectedModifierFieldIndex -= 1;
        }
      }
    }

    if (input.isPressed(ENTER)) {
      if (this.isSelectModifierTypeMode) {
        handleModifierTypeSelection(this.selectedModifierTypeIndex);
      }
    }

    if (input.isMouseReleased()) {
      if (this.isSelectModifierTypeMode) {
        handleModifierTypeSelection(this.selectedModifierTypeIndex);
      }
    }
  }

  private void handleCreateModeSelection(int index) {
    if (index < this.selectableObjects.size()) {
      this.isCreateMode = false;
      String className = this.selectableObjects.get(index);
      objects.add(className + "-" + UUID.randomUUID().toString(), className);
    }
  }

  private void handleModifierTypeSelection(int index) {
    if (index < this.availableModifierFields.size()) {
      this.isSelectModifierTypeMode = false;
      setModifierType(this.availableModifierTypes.get(selectedModifierTypeIndex));
    }
  }

  private void toggleEditMode() {
    if (objects.activeObjects.size() > 0 && !this.isCreateMode) {
      this.isEditMode = !this.isEditMode;
    }
  }

  private void toggleCreateMode() {
    if (this.isEditMode) {
      this.isCreateMode = !this.isCreateMode;
    }
  }

  public boolean isEditMode() {
    return this.isEditMode;
  }

  public void draw() {
    if (this.isCreateMode) {
      drawCreateMenu();
    } else {
      OavpVariable activeVariable = objects.getActiveVariable();
      drawToolMeta(activeVariable, this.activeTool);
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
    if (this.activeTool == TOOL_WEIGHT) {
      return "weight";
    }
    if (this.activeTool == TOOL_MODIFIER) {
      return "modifier";
    }
    return "";
  }

  public void drawIfEditMode() {
    if (this.isEditMode) {
      this.draw();
    }
  }

  public void drawToolMeta(OavpVariable activeVariable, int activeTool) {
    float toolMetaXPadding = oavp.width(0.05);
    float toolMetaYPadding = oavp.height(0.05);
    float toolMetaBoxW = 200;
    float toolMetaBoxH = 100;

    visualizers
      .create()
      .move(toolMetaXPadding, toolMetaYPadding)
      .noStrokeStyle()
      .fillColor(palette.flat.black)
      .draw.basicRectangle(toolMetaBoxW, toolMetaBoxH, 0, CORNER)
      .done();

    switch (activeTool) {
      case 0: // MOVE
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.blue)
          .noFillStyle()
          .strokeWeightStyle(2)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .draw.positionalLines(width)
          .draw.basicSquare(100)
          .draw.basicCircle(10)
          .done();

        text.create()
          .move(toolMetaXPadding + (toolMetaBoxW * 0.1), toolMetaYPadding + (toolMetaBoxH * 0.2))
          .fillColor(palette.flat.blue)
          .size(20)
          .moveDown(toolMetaBoxH * 0.2)
          .write("move\nx: " + activeVariable.x + "\ny: " + activeVariable.y)
          .done();
        break;

      case 1: // RESIZE
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.orange)
          .noFillStyle()
          .strokeWeightStyle(2)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .draw.basicRectangle(activeVariable.size, activeVariable.size, 50)
          .draw.basicSquare(25)
          .draw.basicCircle(5)
          .done();

        text.create()
          .move(toolMetaXPadding + (toolMetaBoxW * 0.1), toolMetaYPadding + (toolMetaBoxH * 0.2))
          .fillColor(palette.flat.orange)
          .size(20)
          .moveDown(toolMetaBoxH * 0.2)
          .write("resize\nsize: " + activeVariable.size)
          .done();
        break;

      case 2: // TRANSFORM
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.yellow)
          .noFillStyle()
          .strokeWeightStyle(2)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .rotate(activeVariable.xr, activeVariable.yr, activeVariable.zr)
          .draw.basicRectangle(activeVariable.w - 5, activeVariable.h - 5)
          .draw.basicCircle(10)
          .done();

        text.create()
          .move(toolMetaXPadding + (toolMetaBoxW * 0.1), toolMetaYPadding + (toolMetaBoxH * 0.2))
          .fillColor(palette.flat.yellow)
          .size(20)
          .moveDown(toolMetaBoxH * 0.2)
          .write("transform\nw: " + activeVariable.w + "\nh: " + activeVariable.h)
          .done();
        break;

      case 3: // ROTATE
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.green)
          .noFillStyle()
          .strokeWeightStyle(2)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .rotate(activeVariable.xr, activeVariable.yr, activeVariable.zr)
          .draw.positionalLines(width)
          .rotate(0, 0, 45)
          .draw.basicSquare(15)
          .done();

        text.create()
          .move(toolMetaXPadding + (toolMetaBoxW * 0.1), toolMetaYPadding + (toolMetaBoxH * 0.2))
          .fillColor(palette.flat.green)
          .size(20)
          .moveDown(toolMetaBoxH * 0.2)
          .write("rotate\nzr: " + activeVariable.zr)
          .done();
        break;

      case 4: // ARRANGE
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.teal)
          .noFillStyle()
          .strokeWeightStyle(2)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .draw.positionalLines(width)
          .draw.basicSquare(100)
          .draw.basicCircle(10)
          .done();

        text.create()
          .move(toolMetaXPadding + (toolMetaBoxW * 0.1), toolMetaYPadding + (toolMetaBoxH * 0.2))
          .fillColor(palette.flat.teal)
          .size(20)
          .moveDown(toolMetaBoxH * 0.2)
          .write("arrange\nz: " + activeVariable.z)
          .done();
        break;

      case 5: // TURN
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.darkTeal)
          .noFillStyle()
          .strokeWeightStyle(2)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .rotate(activeVariable.xr, activeVariable.yr, activeVariable.zr)
          .draw.positionalLines(width)
          .draw.basicRectangle(15, 15, 50)
          .done();

        text.create()
          .move(toolMetaXPadding + (toolMetaBoxW * 0.1), toolMetaYPadding + (toolMetaBoxH * 0.2))
          .fillColor(palette.flat.darkTeal)
          .size(20)
          .moveDown(toolMetaBoxH * 0.2)
          .write("turn\nxr: " + activeVariable.xr + "\nyr: " + activeVariable.yr)
          .done();
        break;

      case 6: // COLOR
        visualizers
          .create()
          .move(toolMetaXPadding + (toolMetaBoxW * 0.1), toolMetaYPadding + (toolMetaBoxH * 0.2))
          .strokeWeightStyle(2)
          .moveDown(toolMetaBoxH * 0.2);

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

      case 7: // WEIGHT
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.darkPrimary)
          .noFillStyle()
          .strokeWeightStyle(activeVariable.strokeWeight)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .draw.basicRectangle(50, 10)
          .done();

        text.create()
          .move(toolMetaXPadding + (toolMetaBoxW * 0.1), toolMetaYPadding + (toolMetaBoxH * 0.2))
          .fillColor(palette.flat.darkPrimary)
          .size(20)
          .moveDown(toolMetaBoxH * 0.2)
          .write("weight\nweight: " + activeVariable.strokeWeight)
          .done();

        break;

      case 8: // MODIFIER
        if (this.isSelectModifierTypeMode) {
          palette.reset(palette.flat.black, palette.flat.white, 2);

          float colWidth = oavp.width(0.8) / SELECT_MODIFIER_TYPE_MODE_COLUMN_COUNT;
          float rowHeight = oavp.height(0.8) / SELECT_MODIFIER_TYPE_MODE_ROW_COUNT;
          float xPadding = oavp.width(0.1);
          float yPadding = oavp.height(0.1);
          float xScreenDisplacement = (width - oavp.width(1)) / 2;
          float yScreenDisplacement = (height - oavp.height(1)) / 2;

          for (int i = 0; i < SELECT_MODIFIER_TYPE_MODE_COLUMN_COUNT; i++) {
            for (int j = 0; j < SELECT_MODIFIER_TYPE_MODE_ROW_COUNT; j++) {
              float x0 = (i * colWidth) + xPadding;
              float x1 = (i * colWidth) + colWidth + xPadding;
              float y0 = (j * rowHeight) + yPadding;
              float y1 = (j * rowHeight) + rowHeight + yPadding;

              boolean isWithinSelectionArea = (
                (mouseX >= (x0 + xScreenDisplacement) && mouseX < (x1 + xScreenDisplacement)) &&
                (mouseY >= (y0 + yScreenDisplacement) && mouseY < (y1 + yScreenDisplacement)) || this.selectedModifierTypeIndex == i + (j * SELECT_MODIFIER_TYPE_MODE_COLUMN_COUNT)
              );

              if (isWithinSelectionArea) {
                this.selectedModifierTypeIndex = i + (j * SELECT_MODIFIER_TYPE_MODE_COLUMN_COUNT);
              }

              int textIndex = i + (j * SELECT_MODIFIER_TYPE_MODE_COLUMN_COUNT);

              if (textIndex < this.availableModifierTypes.size()) {
                text
                  .create()
                  .move(x0, y0)
                  .moveRight(colWidth / 2)
                  .moveDown(rowHeight / 2)
                  .fillColor(palette.flat.white)
                  .size(14)
                  .alignCompleteCenter()
                  .write(this.availableModifierTypes.get(textIndex))
                  .done();
                  if (isWithinSelectionArea) {
                    visualizers
                      .create()
                      .move(x0, y0)
                      .moveRight(colWidth / 2)
                      .moveDown(rowHeight / 2)
                      .fillColor(palette.flat.white)
                      .moveDown(25)
                      .draw.basicRectangle(10, 10, 25)
                      .done();
                  }
              }
            }
          }
        } else {
          visualizers
            .create()
            .center().middle()
            .strokeColor(palette.flat.purple)
            .noFillStyle()
            .strokeWeightStyle(2)
            .move(activeVariable.x, activeVariable.y, activeVariable.z)
            .draw.basicRectangle(95, 95)
            .draw.basicCircle(5)
            .done();

          text.create()
            .move(toolMetaXPadding + (toolMetaBoxW * 0.1), toolMetaYPadding + (toolMetaBoxH * 0.2))
            .fillColor(palette.flat.purple)
            .size(20)
            .moveDown(toolMetaBoxH * 0.2)
            .write("modifier\n" + this.getActiveModifierField() + ": " + this.getModifierValue() + "\ntype: " + this.getModifierType())
            .done();
        }

        break;
    }
  }

  private String getActiveModifierField() {
    return this.availableModifierFields.get(this.selectedModifierFieldIndex);
  }

  private String getActiveModifierType() {
    return this.availableModifierTypes.get(this.selectedModifierTypeIndex);
  }

  private float getModifierValue() {
    OavpVariable activeVariable = objects.getActiveVariable();
    try {
      String fieldName = this.availableModifierFields.get(this.selectedModifierFieldIndex);
      Field field = activeVariable.getClass().getDeclaredField(fieldName);
      return (float) field.get(activeVariable);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return 0.0;
  }

  private float setModifierValue(float value) {
    OavpVariable activeVariable = objects.getActiveVariable();
    try {
      String fieldName = this.availableModifierFields.get(this.selectedModifierFieldIndex);
      Field field = activeVariable.getClass().getDeclaredField(fieldName);
      field.set(activeVariable, value);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return 0.0;
  }

  private String getModifierType() {
    OavpVariable activeVariable = objects.getActiveVariable();
    try {
      String fieldName = this.availableModifierFields.get(this.selectedModifierFieldIndex) + "Type";
      Field field = activeVariable.getClass().getDeclaredField(fieldName);
      return (String) field.get(activeVariable);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "none";
  }

  private float setModifierType(String type) {
    OavpVariable activeVariable = objects.getActiveVariable();
    try {
      String fieldName = this.availableModifierFields.get(this.selectedModifierFieldIndex) + "Type";
      Field field = activeVariable.getClass().getDeclaredField(fieldName);
      field.set(activeVariable, type);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return 0.0;
  }

  public void drawCreateMenu() {
    palette.reset(palette.flat.black, palette.flat.white, 2);

    float colWidth = oavp.width(0.8) / CREATE_MODE_COLUMN_COUNT;
    float rowHeight = oavp.height(0.8) / CREATE_MODE_ROW_COUNT;
    float xPadding = oavp.width(0.1);
    float yPadding = oavp.height(0.1);
    float xScreenDisplacement = (width - oavp.width(1)) / 2;
    float yScreenDisplacement = (height - oavp.height(1)) / 2;

    for (int i = 0; i < CREATE_MODE_COLUMN_COUNT; i++) {
      for (int j = 0; j < CREATE_MODE_ROW_COUNT; j++) {
        float x0 = (i * colWidth) + xPadding;
        float x1 = (i * colWidth) + colWidth + xPadding;
        float y0 = (j * rowHeight) + yPadding;
        float y1 = (j * rowHeight) + rowHeight + yPadding;

        boolean isWithinSelectionArea = (
          (mouseX >= (x0 + xScreenDisplacement) && mouseX < (x1 + xScreenDisplacement)) &&
          (mouseY >= (y0 + yScreenDisplacement) && mouseY < (y1 + yScreenDisplacement)) || this.createModeSelectionIndex == i + (j * CREATE_MODE_COLUMN_COUNT)
        );

        if (isWithinSelectionArea) {
          this.createModeSelectionIndex = i + (j * CREATE_MODE_COLUMN_COUNT);
        }

        int textIndex = i + (j * CREATE_MODE_COLUMN_COUNT);

        if (textIndex < this.selectableObjects.size()) {
          text
            .create()
            .move(x0, y0)
            .moveRight(colWidth / 2)
            .moveDown(rowHeight / 2)
            .fillColor(palette.flat.white)
            .size(14)
            .alignCompleteCenter()
            .write(this.selectableObjects.get(textIndex))
            .done();
            if (isWithinSelectionArea) {
              visualizers
                .create()
                .move(x0, y0)
                .moveRight(colWidth / 2)
                .moveDown(rowHeight / 2)
                .fillColor(palette.flat.white)
                .moveDown(25)
                .draw.basicRectangle(10, 10, 25)
                .done();
            }
        }
      }
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
int TOOL_WEIGHT = 7;
int TOOL_MODIFIER = 8;

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

float DELTA_WEIGHT = 2.0;
float DELTA_WEIGHT_SHIFT = 1.0;
float DELTA_WEIGHT_CTRL = 0.25;

float DELTA_MODIFIER = 50.0;
float DELTA_MODIFIER_SHIFT = 25.0;
float DELTA_MODIFIER_CTRL = 5.0;

int CREATE_MODE_COLUMN_COUNT = 3;
int CREATE_MODE_ROW_COUNT = 8;

int SELECT_MODIFIER_TYPE_MODE_COLUMN_COUNT = 3;
int SELECT_MODIFIER_TYPE_MODE_ROW_COUNT = 8;