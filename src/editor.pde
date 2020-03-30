public class OavpEditor {
  private boolean isEditMode = false;
  private boolean isHelpMode = false;
  private boolean isCreateMode = false;
  private boolean isSelectModifierTypeMode = false;
  private boolean isSnappingEnabled = true;
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
  private HashMap<String, Object> originalValues;


  OavpEditor(OavpInput input, OavpObjectManager objects, OavpText text) {
    this.input = input;
    this.objects = objects;
    this.text = text;
    this.activePalette = palette.getPalette(colorPaletteIndex);
    this.selectableObjects = new ArrayList<String>();
    this.availableModifierFields = new ArrayList<String>();
    this.availableModifierTypes = new ArrayList<String>();
    this.originalValues = new HashMap<String, Object>();

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

  public boolean isToolSwitchable() {
    // return this.isEditMode && !this.isCreateMode && !cp5.get(Textfield.class,"controlP5TestInput").isFocus();
    return this.isEditMode && !this.isCreateMode;
  }

  public boolean isEditable() {
    return this.isEditMode && !this.isCreateMode;
  }

  public boolean isCreateable() {
    return this.isEditMode && this.isCreateMode;
  }

  public void handleKeyInputs() {
    if (input.isPressed(KEY_E)) {
      toggleEditMode();
    }

    if (input.isPressed(KEY_O)) {
      println(cp5.get(Textfield.class,"controlP5TestInput").isFocus());
    }

    if (isEditable()) {
      if (this.activeTool == TOOL_MOVE) {
        handleToolMoveInputs();
      } else if (this.activeTool == TOOL_RESIZE) {
        handleToolResizeInputs();
      } else if (this.activeTool == TOOL_TRANSFORM) {
        handleToolTransformInputs();
      } else if (this.activeTool == TOOL_ROTATE) {
        handleToolRotateInputs();
      } else if (this.activeTool == TOOL_COLOR) {
        handleToolColorInputs();
      } else if (this.activeTool == TOOL_WEIGHT) {
        handleToolWeightInputs();
      } else if (this.activeTool == TOOL_MODIFIER) {
        handleToolModifierInputs();
      } else if (this.activeTool == TOOL_VARIATION) {
        handleToolVariationInputs();
      }
    }

    if (isCreateable()) {
      handleCreateModeInputs();
    }

    if (this.isEditMode) {
      if (input.isPressed(KEY_L)) {
        objects.nextActiveVariable();
        updateEditorVariableMeta();
      }

      if (input.isPressed(KEY_J)) {
        objects.prevActiveVariable();
        updateEditorVariableMeta();
      }

      if (isToolSwitchable()) {
        if (input.isPressed(KEY_M)) {
          this.switchTool(TOOL_MOVE);
        }

        if (input.isPressed(KEY_S)) {
          this.switchTool(TOOL_RESIZE);
        }

        if (input.isPressed(KEY_T)) {
          this.switchTool(TOOL_TRANSFORM);
        }

        if (input.isPressed(KEY_R)) {
          this.switchTool(TOOL_ROTATE);
        }

        if (input.isPressed(KEY_C)) {
          this.switchTool(TOOL_COLOR);
        }

        if (input.isPressed(KEY_B)) {
          this.switchTool(TOOL_WEIGHT);
        }

        if (input.isPressed(KEY_V)) {
          this.switchTool(TOOL_VARIATION);
        }

        if (input.isPressed(KEY_Z)) {
          this.switchTool(TOOL_MODIFIER);
        }
      }

      if (input.isPressed(KEY_D)) {
        objects.duplicate();
      }

      if (input.isPressed(KEY_H)) {
        toggleCreateMode();
      }

      if (input.isPressed(KEY_H)) {
        toggleCreateMode();
      }

      if (input.isPressed(KEY_Q)) {
        toggleSnappingMode();
      }

      if (input.isPressed(KEY_X)) {
        objects.printObjectData();
      }

      if (input.isPressed(KEY_W)) {
        objects.remove();
      }
    }
  }

  public void switchTool(int toolId) {
    deselectAllToolbarTools();
    switch (toolId) {
      case 0:
        this.activeTool = TOOL_MOVE;
        originalValues.put("x", objects.getActiveVariable().x);
        originalValues.put("y", objects.getActiveVariable().y);
        originalValues.put("z", objects.getActiveVariable().z);
        editorToolbar.changeItem(toolbarLabelMove, "selected", true);
        break;
      case 1:
        this.activeTool = TOOL_RESIZE;
        originalValues.put("size", objects.getActiveVariable().size);
        editorToolbar.changeItem(toolbarLabelResize, "selected", true);
        break;
      case 2:
        this.activeTool = TOOL_TRANSFORM;
        originalValues.put("w", objects.getActiveVariable().w);
        originalValues.put("h", objects.getActiveVariable().h);
        originalValues.put("l", objects.getActiveVariable().l);
        editorToolbar.changeItem(toolbarLabelTransform, "selected", true);
        break;
      case 3:
        this.activeTool = TOOL_ROTATE;
        originalValues.put("xr", objects.getActiveVariable().xr);
        originalValues.put("yr", objects.getActiveVariable().yr);
        originalValues.put("zr", objects.getActiveVariable().zr);
        editorToolbar.changeItem(toolbarLabelRotate, "selected", true);
        break;
      case 4:
        this.activeTool = TOOL_COLOR;
        originalValues.put("strokeColor", objects.getActiveVariable().strokeColor);
        originalValues.put("fillColor", objects.getActiveVariable().fillColor);
        editorToolbar.changeItem(toolbarLabelColor, "selected", true);
        break;
      case 5:
        this.activeTool = TOOL_WEIGHT;
        originalValues.put("strokeWeight", objects.getActiveVariable().strokeWeight);
        editorToolbar.changeItem(toolbarLabelWeight, "sebected", true);
        break;
      case 6:
        if (this.activeTool == TOOL_MODIFIER) {
          this.isSelectModifierTypeMode = !this.isSelectModifierTypeMode;
        }
        this.activeTool = TOOL_MODIFIER;
        editorToolbar.changeItem(toolbarLabelModifier, "selected", true);
        break;
      case 7:
        this.activeTool = TOOL_VARIATION;
        originalValues.put("variation", objects.getActiveVariable().variation);
        editorToolbar.changeItem(toolbarLabelVariation, "selected", true);
        break;
    }
  }

  private void previewEdit(String fieldName, Object value) {
    try {
      OavpVariable activeVariable = objects.getActiveVariable();
      Field field = activeVariable.getClass().getDeclaredField(fieldName);
      if (originalValues.get(fieldName).getClass() == Float.class) {
        field.set(activeVariable, (float) value + (float) originalValues.get(fieldName));
      } else if (originalValues.get(fieldName).getClass() == String.class) {
        field.set(activeVariable, (String) value);
      } else if (originalValues.get(fieldName).getClass() == Integer.class) {
        field.set(activeVariable, (int) value + (int) originalValues.get(fieldName));
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  private void commitEdit(String fieldName) {
    try {
      OavpVariable activeVariable = objects.getActiveVariable();
      Field field = activeVariable.getClass().getDeclaredField(fieldName);
      originalValues.replace(fieldName, field.get(activeVariable));
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  int DELTA_MOVEMENT_PRECISE_KEYS = 5;
  int DELTA_MOVEMENT_SNAP_KEYS = 50;
  int DELTA_MOVEMENT_PRECISE_MOUSE = 5;
  int DELTA_MOVEMENT_SNAP_MOUSE = 50;

  private void handleToolMoveInputs() {
    int deltaKeys = DELTA_MOVEMENT_PRECISE_KEYS;
    int deltaMouse = DELTA_MOVEMENT_PRECISE_MOUSE;

    if (this.isSnappingEnabled) {
      deltaKeys = DELTA_MOVEMENT_SNAP_KEYS;
      deltaMouse = DELTA_MOVEMENT_SNAP_MOUSE;
    }

    if (input.isHoldingShift) {
      if (input.isPressed(UP)) { previewEdit("z", deltaKeys * -1); commitEdit("z"); }
      if (input.isPressed(DOWN)) { previewEdit("z", deltaKeys); commitEdit("z"); }
      if (input.isMousePressed()) {
        previewEdit("z", snap(input.getYGridTicks(), deltaMouse));
      }
      if (input.isMouseReleased()) { commitEdit("z"); input.resetTicks(); }
    } else {
      if (input.isPressed(UP)) { previewEdit("y", deltaKeys * -1); commitEdit("y"); }
      if (input.isPressed(DOWN)) { previewEdit("y", deltaKeys); commitEdit("y"); }
      if (input.isMousePressed()) {
        previewEdit("x", snap(input.getXGridTicks(), deltaMouse));
        previewEdit("y", snap(input.getYGridTicks(), deltaMouse));
      }
      if (input.isMouseReleased()) { commitEdit("x"); commitEdit("y"); input.resetTicks(); }
    }

    if (input.isPressed(RIGHT)) { previewEdit("x", deltaKeys); commitEdit("x"); }
    if (input.isPressed(LEFT)) { previewEdit("x", deltaKeys * -1); commitEdit("x"); }

    if (input.isShiftReleased()) {}

    updateEditorVariableMeta();
  }

  float DELTA_RESIZE_PRECISE_KEYS = 5;
  float DELTA_RESIZE_SNAP_KEYS = 50;
  float DELTA_RESIZE_PRECISE_MOUSE = 5;
  float DELTA_RESIZE_SNAP_MOUSE = 50;

  private void handleToolResizeInputs() {
    float deltaKeys = DELTA_RESIZE_PRECISE_KEYS;
    float deltaMouse = DELTA_RESIZE_PRECISE_MOUSE;

    if (this.isSnappingEnabled) {
      deltaKeys = DELTA_RESIZE_SNAP_KEYS;
      deltaMouse = DELTA_RESIZE_SNAP_MOUSE;
    }

    if (input.isPressed(UP)) { previewEdit("size", deltaKeys); commitEdit("size"); }
    if (input.isPressed(DOWN)) { previewEdit("size", deltaKeys * -1); commitEdit("size"); }

    if (input.isMousePressed()) {
      previewEdit("size", snap(input.getYGridTicks() * -1, deltaMouse));
    }

    if (input.isMouseReleased()) {
      commitEdit("size");
      input.resetTicks();
    }

    if (input.isShiftReleased()) {}

    updateEditorVariableMeta();
  }

  float DELTA_TRANSFORM_PRECISE_KEYS = 5;
  float DELTA_TRANSFORM_SNAP_KEYS = 50;
  float DELTA_TRANSFORM_PRECISE_MOUSE = 5;
  float DELTA_TRANSFORM_SNAP_MOUSE = 50;

  private void handleToolTransformInputs() {
    float deltaKeys = DELTA_TRANSFORM_PRECISE_KEYS;
    float deltaMouse = DELTA_TRANSFORM_PRECISE_MOUSE;

    if (this.isSnappingEnabled) {
      deltaKeys = DELTA_TRANSFORM_SNAP_KEYS;
      deltaMouse = DELTA_TRANSFORM_SNAP_MOUSE;
    }

    if (input.isHoldingShift) {
      if (input.isPressed(UP)) { previewEdit("l", deltaKeys); commitEdit("l"); }
      if (input.isPressed(DOWN)) { previewEdit("l", deltaKeys * -1); commitEdit("l"); }
      if (input.isMousePressed()) {
        previewEdit("l", snap(input.getYGridTicks() * -1, deltaMouse));
      }
      if (input.isMouseReleased()) { commitEdit("l"); input.resetTicks(); }
    } else {
      if (input.isPressed(UP)) { previewEdit("h", deltaKeys); commitEdit("h"); }
      if (input.isPressed(DOWN)) { previewEdit("h", deltaKeys * -1); commitEdit("h"); }
      if (input.isMousePressed()) {
        previewEdit("w", snap(input.getXGridTicks(), deltaMouse));
        previewEdit("h", snap(input.getYGridTicks() * -1, deltaMouse));
      }
      if (input.isMouseReleased()) { commitEdit("w"); commitEdit("h"); input.resetTicks(); }
    }

    if (input.isPressed(RIGHT)) { previewEdit("w", deltaKeys); commitEdit("w"); }
    if (input.isPressed(LEFT)) { previewEdit("w", deltaKeys * -1); commitEdit("w"); }

    if (input.isShiftReleased()) {}

    updateEditorVariableMeta();
  }

  int DELTA_ROTATE_PRECISE_KEYS = 5;
  int DELTA_ROTATE_SNAP_KEYS = 15;
  int DELTA_ROTATE_PRECISE_MOUSE = 5;
  int DELTA_ROTATE_SNAP_MOUSE = 15;

  private void handleToolRotateInputs() {
    int deltaKeys = DELTA_ROTATE_PRECISE_KEYS;
    int deltaMouse = DELTA_ROTATE_PRECISE_MOUSE;

    if (this.isSnappingEnabled) {
      deltaKeys = DELTA_ROTATE_SNAP_KEYS;
      deltaMouse = DELTA_ROTATE_SNAP_MOUSE;
    }

    if (input.isHoldingShift) {
      if (input.isPressed(UP)) { previewEdit("xr", deltaKeys); commitEdit("xr"); }
      if (input.isPressed(DOWN)) { previewEdit("xr", deltaKeys * -1); commitEdit("xr"); }
      if (input.isPressed(RIGHT)) { previewEdit("yr", deltaKeys); commitEdit("yr"); }
      if (input.isPressed(LEFT)) { previewEdit("yr", deltaKeys * -1); commitEdit("yr"); }
      if (input.isMousePressed()) {
        previewEdit("xr", snap(input.getYGridTicks() * -1, deltaMouse));
        previewEdit("yr", snap(input.getXGridTicks(), deltaMouse));
      }
      if (input.isMouseReleased()) { commitEdit("xr"); commitEdit("yr"); input.resetTicks(); }
    } else {
      if (input.isPressed(RIGHT)) { previewEdit("zr", deltaKeys); commitEdit("zr"); }
      if (input.isPressed(LEFT)) { previewEdit("zr", deltaKeys * -1); commitEdit("zr"); }
      if (input.isMousePressed()) {
        previewEdit("zr", snap(input.getYGridTicks(), deltaMouse));
      }
      if (input.isMouseReleased()) { commitEdit("zr"); input.resetTicks(); }
    }

    if (input.isShiftReleased()) {}

    updateEditorVariableMeta();
  }

  private void handleToolColorInputs() {
    if (input.isHoldingShift) {

    }

    if (input.isHoldingControl) {

    }

    if (input.isPressed(LEFT)) {
      if (this.colorIndex == 0) {
        this.colorIndex = this.activePalette.length - 1;
      } else {
        this.colorIndex = (this.colorIndex - 1) % this.activePalette.length;
      }
    }

    if (input.isPressed(RIGHT)) {
      this.colorIndex = (this.colorIndex + 1) % this.activePalette.length;
    }

    if (input.isPressed(DOWN)) {
      this.colorPaletteIndex = (this.colorPaletteIndex + 1) % palette.table.length;
      this.activePalette = palette.getPalette(colorPaletteIndex);
      this.colorIndex = this.colorIndex % this.activePalette.length;
    }

    if (input.isPressed(UP)) {
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
  }

  float DELTA_WEIGHT_PRECISE_KEYS = 0.25;
  float DELTA_WEIGHT_SNAP_KEYS = 0.50;
  float DELTA_WEIGHT_PRECISE_MOUSE = 0.25;
  float DELTA_WEIGHT_SNAP_MOUSE = 0.50;

  private void handleToolWeightInputs() {
    float deltaKeys = DELTA_WEIGHT_PRECISE_KEYS;
    float deltaMouse = DELTA_WEIGHT_PRECISE_MOUSE;

    if (this.isSnappingEnabled) {
      deltaKeys = DELTA_WEIGHT_SNAP_KEYS;
      deltaMouse = DELTA_WEIGHT_SNAP_MOUSE;
    }

    if (input.isPressed(UP)) { previewEdit("strokeWeight", deltaKeys); commitEdit("strokeWeight"); }
    if (input.isPressed(DOWN)) { previewEdit("strokeWeight", deltaKeys * -1); commitEdit("strokeWeight"); }

    if (input.isMousePressed()) {
      previewEdit("strokeWeight", snap(input.getYGridTicks(), deltaMouse));
    }

    if (input.isMouseReleased()) {
      commitEdit("strokeWeight");
      input.resetTicks();
    }

    if (input.isShiftReleased()) {}

    updateEditorVariableMeta();
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

    if (input.isMouseReleased()) {
      handleCreateModeSelection(this.createModeSelectionIndex);
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

  private void handleToolVariationInputs() {
    OavpVariable activeVariable = objects.getActiveVariable();

    if (input.isPressed(UP)) {
      if (activeVariable.variation > 0) {
        activeVariable.variation -= 1;
      }
    }

    if (input.isPressed(DOWN)) {
      if (activeVariable.variation < activeVariable.variations.size() - 1) {
        activeVariable.variation += 1;
      }
    }
  }

  private void handleCreateModeSelection(int index) {
    if (index < this.selectableObjects.size()) {
      this.isCreateMode = false;
      String className = this.selectableObjects.get(index);
      objects.add(getNewObjectName(className, 1), className);
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
      if (this.isEditMode) {
        editorToolbar.show();
        editorToggleSnappingButton.show();
        updateEditorVariableMeta();
        editorVariableMeta.setLabel(objects.getActiveVariable().name);
        editorVariableMeta.show();
        this.switchTool(this.activeTool);
      } else {
        editorToolbar.hide();
        editorToggleSnappingButton.hide();
        editorVariableMeta.hide();
      }
    }
  }

  private void toggleSnappingMode() {
    this.isSnappingEnabled = !this.isSnappingEnabled;
    if (this.isSnappingEnabled) {
      editorToggleSnappingButton.setLabel("[q] disable snapping");
    } else {
      editorToggleSnappingButton.setLabel("[q] enable snapping");
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

  public void drawIfEditMode() {
    if (this.isEditMode) {
      this.draw();
    }
  }

  public void drawToolMeta(OavpVariable activeVariable, int activeTool) {
    float toolMetaXPadding = width * 0.025;
    float toolMetaYPadding = height * 0.0075;
    float toolMetaBoxW = width * 1.5;
    float toolMetaBoxH = height * 0.05;
    float toolMetaTextPosition = width * 0.17;

    switch (activeTool) {
      case 0: // MOVE
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.blue)
          .noFillStyle()
          .strokeWeightStyle(0.5)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .draw.positionalLines(width)
          .draw.basicSquare(100)
          .draw.basicCircle(10)
          .done();
        break;

      case 1: // RESIZE
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.orange)
          .noFillStyle()
          .strokeWeightStyle(0.5)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .draw.basicRectangle(activeVariable.size, activeVariable.size, 50)
          .draw.basicSquare(25)
          .draw.basicCircle(5)
          .done();
        break;

      case 2: // TRANSFORM
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.yellow)
          .noFillStyle()
          .strokeWeightStyle(0.5)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .rotate(activeVariable.xr, activeVariable.yr, activeVariable.zr)
          .draw.positionalLines(width)
          .draw.basicBox(activeVariable.w, activeVariable.h, activeVariable.l)
          .draw.basicCircle(10)
          .done();
        break;

      case 3: // ROTATE
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.green)
          .noFillStyle()
          .strokeWeightStyle(0.5)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .rotate(activeVariable.xr, activeVariable.yr, activeVariable.zr)
          .draw.positionalLines(width)
          .rotate(0, 0, 45)
          .draw.basicSquare(15)
          .done();
        break;

      case 4: // COLOR
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.grey)
          .noFillStyle()
          .strokeWeightStyle(0.5)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .rotate(activeVariable.xr, activeVariable.yr, activeVariable.zr)
          .draw.positionalLines(width)
          .done();

        text.create()
          .moveLeft(toolMetaTextPosition)
          .move(toolMetaXPadding, toolMetaYPadding)
          .fillColor(palette.flat.grey)
          .size(14)
          .moveDown(toolMetaBoxH * 0.2)
          .alignLeft()
          .write("color " + activeVariable.name)
          .done();

        visualizers
          .create()
          .moveLeft(toolMetaTextPosition - 15)
          .move(toolMetaXPadding, toolMetaYPadding)
          .strokeWeightStyle(2)
          .moveDown(toolMetaBoxH * 0.4);

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
          .moveDown(10)
          .moveLeft(20 * colorIndex);

        for (int i = 0; i < this.activePalette.length; i++) {
          visualizers
            .fillColor(this.activePalette[i])
            .draw.basicRectangle(20, 10)
            .moveRight(20);
        }

        visualizers
          .done();

        break;

      case 5: // WEIGHT
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
          .moveLeft(toolMetaTextPosition)
          .move(toolMetaXPadding, toolMetaYPadding)
          .fillColor(palette.flat.darkPrimary)
          .size(14)
          .moveDown(toolMetaBoxH * 0.2)
          .alignLeft()
          .write("weigh " + activeVariable.name + "\nweight: " + activeVariable.strokeWeight)
          .done();

        break;

      case 6: // MODIFIER
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
            .moveLeft(toolMetaTextPosition)
            .move(toolMetaXPadding, toolMetaYPadding)
            .fillColor(palette.flat.purple)
            .size(14)
            .moveDown(toolMetaBoxH * 0.2)
            .alignLeft()
            .write("modify " + activeVariable.name + "\n" + this.getActiveModifierField() + ": " + this.getModifierValue() + ", type: " + this.getModifierType())
            .done();
        }
        break;

      case 7: // VARIATION
        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.darkRed)
          .noFillStyle()
          .strokeWeightStyle(0.5)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .draw.positionalLines(width)
          .done();

        text.create()
          .moveLeft(toolMetaTextPosition)
          .move(toolMetaXPadding, toolMetaYPadding)
          .fillColor(palette.flat.darkRed)
          .size(14)
          .moveDown(toolMetaBoxH * 0.2)
          .alignLeft()
          .write("variation of " + activeVariable.name + "\ntype: " + activeVariable.getVariation())
          .done();
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
      return (String) field.get(activeVariable) == "" ? "none" : (String) field.get(activeVariable);
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

ButtonBar editorToolbar;
Button editorToggleSnappingButton;
Button editorClipboardButton;

Group editorVariableMeta;
Textlabel xVarMeta;
Textlabel yVarMeta;
Textlabel zVarMeta;
Textlabel xrVarMeta;
Textlabel yrVarMeta;
Textlabel zrVarMeta;
Textlabel wVarMeta;
Textlabel lVarMeta;
Textlabel hVarMeta;
Textlabel sizeVarMeta;

String toolbarLabelMove = "[m] move";
String toolbarLabelResize = "[s] resize";
String toolbarLabelTransform = "[t] transform";
String toolbarLabelRotate = "[r] rotate";
String toolbarLabelColor = "[c] color";
String toolbarLabelWeight = "[b] weight";
String toolbarLabelModifier = "[z] modifiers";
String toolbarLabelVariation = "[v] variation";
color COLOR_WHITE = color(255, 255, 255);
color COLOR_BLACK = color(0, 0, 0);

public void setupEditorGui() {

  editorToolbar = cp5.addButtonBar("editorToolbar")
     .setColorBackground(color(0, 0, 0))
     .setPosition(10, 10)
     .setSize(500, 10)
     .addItems(new String[] {
       toolbarLabelMove,
       toolbarLabelResize,
       toolbarLabelTransform,
       toolbarLabelRotate,
       toolbarLabelColor,
       toolbarLabelWeight,
       toolbarLabelModifier,
       toolbarLabelVariation
     })
     .hide()
     ;

  editorToggleSnappingButton = cp5.addButton("editorToggleSnappingButton")
     .setLabel("[q] disable snapping")
     .setPosition(10, height - 20)
     .setSize(100, 10)
     .hide()
     ;

  editorVariableMeta = cp5.addGroup("structure")
    .setLabel("selected variable")
    .setColorBackground(COLOR_BLACK)
    .setPosition(10, 40)
    .setBackgroundHeight(100)
    .setBackgroundColor(COLOR_BLACK)
    .hide()
    ;

  xVarMeta = cp5.addTextlabel("x").setPosition(10 * 1, 10).setColorValue(COLOR_WHITE).setGroup("structure");
  yVarMeta = cp5.addTextlabel("y").setPosition(10 * 1, 20).setColorValue(COLOR_WHITE).setGroup("structure");
  zVarMeta = cp5.addTextlabel("z").setPosition(10 * 1, 30).setColorValue(COLOR_WHITE).setGroup("structure");

  xrVarMeta = cp5.addTextlabel("xr").setPosition(10 * 4, 10).setColorValue(COLOR_WHITE).setGroup("structure");
  yrVarMeta = cp5.addTextlabel("yr").setPosition(10 * 4, 20).setColorValue(COLOR_WHITE).setGroup("structure");
  zrVarMeta = cp5.addTextlabel("zr").setPosition(10 * 4, 30).setColorValue(COLOR_WHITE).setGroup("structure");

  wVarMeta = cp5.addTextlabel("w").setPosition(10 * 8, 10).setColorValue(COLOR_WHITE).setGroup("structure");
  hVarMeta = cp5.addTextlabel("h").setPosition(10 * 8, 20).setColorValue(COLOR_WHITE).setGroup("structure");
  lVarMeta = cp5.addTextlabel("l").setPosition(10 * 8, 30).setColorValue(COLOR_WHITE).setGroup("structure");
  sizeVarMeta = cp5.addTextlabel("size").setPosition(10 * 8, 40).setColorValue(COLOR_WHITE).setGroup("structure");
}

public void updateEditorVariableMeta() {
  xVarMeta.setText("x: " + objects.getActiveVariable().x);
  yVarMeta.setText("y: " + objects.getActiveVariable().y);
  zVarMeta.setText("z: " + objects.getActiveVariable().z);
  xrVarMeta.setText("xr: " + objects.getActiveVariable().xr);
  yrVarMeta.setText("yr: " + objects.getActiveVariable().yr);
  zrVarMeta.setText("zr: " + objects.getActiveVariable().zr);
  wVarMeta.setText("w: " + objects.getActiveVariable().w);
  hVarMeta.setText("h: " + objects.getActiveVariable().h);
  lVarMeta.setText("l: " + objects.getActiveVariable().l);
  sizeVarMeta.setText("size: " + objects.getActiveVariable().size);
}

public void deselectAllToolbarTools() {
  editorToolbar.changeItem(toolbarLabelMove, "selected", false);
  editorToolbar.changeItem(toolbarLabelResize, "selected", false);
  editorToolbar.changeItem(toolbarLabelTransform, "selected", false);
  editorToolbar.changeItem(toolbarLabelRotate, "selected", false);
  editorToolbar.changeItem(toolbarLabelColor, "selected", false);
  editorToolbar.changeItem(toolbarLabelWeight, "sebected", false);
  editorToolbar.changeItem(toolbarLabelModifier, "selected", false);
  editorToolbar.changeItem(toolbarLabelVariation, "selected", false);
}

public void editorToolbar(int toolId) {
  editor.switchTool(toolId);
}

public void editorToggleSnappingButton() {
  editor.toggleSnappingMode();
}

public String getNewObjectName(String className, int increment) {
  if (!objects.has(className + "-" + increment)) {
    return className + "-" + increment;
  } else {
    return getNewObjectName(className, increment + 1);
  }
}

int TOOL_MOVE = 0;
int TOOL_RESIZE = 1;
int TOOL_TRANSFORM = 2;
int TOOL_ROTATE = 3;
int TOOL_COLOR = 4;
int TOOL_WEIGHT = 5;
int TOOL_MODIFIER = 6;
int TOOL_VARIATION = 7;

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

float DELTA_MODIFIER = 50.0;
float DELTA_MODIFIER_SHIFT = 25.0;
float DELTA_MODIFIER_CTRL = 5.0;

int CREATE_MODE_COLUMN_COUNT = 5;
int CREATE_MODE_ROW_COUNT = 10;

int SELECT_MODIFIER_TYPE_MODE_COLUMN_COUNT = 3;
int SELECT_MODIFIER_TYPE_MODE_ROW_COUNT = 10;