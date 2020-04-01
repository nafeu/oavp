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

      if (input.isPressed(KEY_N)) {
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
    updateOriginalValues();
    deselectAllToolbarTools();
    switch (toolId) {
      case 0:
        this.activeTool = TOOL_MOVE;
        editorToolbar.changeItem(toolbarLabelMove, "selected", true);
        break;
      case 1:
        this.activeTool = TOOL_RESIZE;
        editorToolbar.changeItem(toolbarLabelResize, "selected", true);
        break;
      case 2:
        this.activeTool = TOOL_TRANSFORM;
        editorToolbar.changeItem(toolbarLabelTransform, "selected", true);
        break;
      case 3:
        this.activeTool = TOOL_ROTATE;
        editorToolbar.changeItem(toolbarLabelRotate, "selected", true);
        break;
      case 4:
        this.activeTool = TOOL_COLOR;
        editorToolbar.changeItem(toolbarLabelColor, "selected", true);
        editorColorButtons.show();
        break;
      case 5:
        this.activeTool = TOOL_WEIGHT;
        editorToolbar.changeItem(toolbarLabelWeight, "sebected", true);
        break;
      case 6:
        if (this.activeTool == TOOL_MODIFIER) {
          this.isSelectModifierTypeMode = !this.isSelectModifierTypeMode;
          if (this.isSelectModifierTypeMode) {
            editorSelectModifier.show();
          } else {
            editorSelectModifier.hide();
          }
        }
        this.activeTool = TOOL_MODIFIER;
        editorToolbar.changeItem(toolbarLabelModifier, "selected", true);
        break;
      case 7:
        this.activeTool = TOOL_VARIATION;
        editorToolbar.changeItem(toolbarLabelVariation, "selected", true);
        break;
    }
  }

  public void updateOriginalValues() {
    if (objects.getActiveVariable() != null) {
      originalValues.put("x", objects.getActiveVariable().x);
      originalValues.put("y", objects.getActiveVariable().y);
      originalValues.put("z", objects.getActiveVariable().z);
      originalValues.put("size", objects.getActiveVariable().size);
      originalValues.put("w", objects.getActiveVariable().w);
      originalValues.put("h", objects.getActiveVariable().h);
      originalValues.put("l", objects.getActiveVariable().l);
      originalValues.put("xr", objects.getActiveVariable().xr);
      originalValues.put("yr", objects.getActiveVariable().yr);
      originalValues.put("zr", objects.getActiveVariable().zr);
      originalValues.put("strokeColor", objects.getActiveVariable().strokeColor);
      originalValues.put("fillColor", objects.getActiveVariable().fillColor);
      originalValues.put("strokeWeight", objects.getActiveVariable().strokeWeight);
      originalValues.put("variation", objects.getActiveVariable().variation);
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
    if (input.isHoldingControl) {
      if (input.isPressed(ENTER)) { this.assignActiveFillColor(); this.assignActiveStrokeColor(); }
      if (input.isPressed(BACKSPACE)) { this.resetFillColor(); this.resetStrokeColor(); }
    } else if (input.isHoldingShift) {
      if (input.isPressed(ENTER)) { this.assignActiveFillColor(); }
      if (input.isPressed(BACKSPACE)) { this.resetFillColor(); }
    } else {
      if (input.isPressed(ENTER)) { this.assignActiveStrokeColor(); }
      if (input.isPressed(BACKSPACE)) { this.resetStrokeColor(); }
    }

    if (input.isPressed(LEFT)) { this.previousActiveColor(); }
    if (input.isPressed(RIGHT)) { this.nextActiveColor(); }
    if (input.isPressed(DOWN)) { this.nextPalette(); }
    if (input.isPressed(UP)) { this.previousPalette(); }

    if (input.isShiftReleased()) {}
    if (input.isControlReleased()) {}

    updateEditorVariableMeta();
  }

  public void nextActiveColor() {
    this.colorIndex = (this.colorIndex + 1) % this.activePalette.length;
  }

  public void previousActiveColor() {
    if (this.colorIndex == 0) {
      this.colorIndex = this.activePalette.length - 1;
    } else {
      this.colorIndex = (this.colorIndex - 1) % this.activePalette.length;
    }
  }

  public void nextPalette() {
    this.colorPaletteIndex = (this.colorPaletteIndex + 1) % palette.table.length;
    this.activePalette = palette.getPalette(colorPaletteIndex);
    this.colorIndex = this.colorIndex % this.activePalette.length;
  }

  public void previousPalette() {
    if (this.colorPaletteIndex == 0) {
      this.colorPaletteIndex = palette.table.length - 1;
    } else {
      this.colorPaletteIndex = (this.colorPaletteIndex - 1) % palette.table.length;
      this.activePalette = palette.getPalette(colorPaletteIndex);
      this.colorIndex = this.colorIndex % this.activePalette.length;
    }
  }

  public void assignActiveFillColor() {
    objects.getActiveVariable().fillColor(this.activePalette[this.colorIndex]);
  }

  public void assignActiveStrokeColor() {
    objects.getActiveVariable().strokeColor(this.activePalette[this.colorIndex]);
  }

  public void resetFillColor() {
    objects.getActiveVariable().fillColor(0);
  }

  public void resetStrokeColor() {
    objects.getActiveVariable().strokeColor(0);
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
    if (input.isPressed(UP)) {
      if (this.createModeSelectionIndex > 0) {
        this.createModeSelectionIndex -= 1;
      }
    }

    if (input.isPressed(DOWN)) {
      if (this.createModeSelectionIndex < OBJECT_LIST.length - 1) {
        this.createModeSelectionIndex += 1;
      }
    }

    if (input.isPressed(ENTER)) {
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
        if (this.selectedModifierTypeIndex > 0) {
          this.selectedModifierTypeIndex -= 1;
        }
      } else {
        this.setModifierValue(this.getModifierValue() + delta);
      }
    }

    if (input.isPressed(DOWN)) {
      if (this.isSelectModifierTypeMode) {
        if (this.selectedModifierTypeIndex < MODIFIER_TYPES.length - 1) {
          this.selectedModifierTypeIndex += 1;
        }
      } else {
        this.setModifierValue(this.getModifierValue() - delta);
      }
    }

    if (input.isPressed(ENTER)) {
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
      editorToolbar.show();
      if (this.activeTool == TOOL_COLOR) {
        editorColorButtons.show();
      }
      editorToggleSnappingButton.show();
      editorObjectsList.show();
      editorObjectButtons.show();
      editorVariableMeta.show();
      editorCreateObject.hide();
    }
  }

  private void handleModifierTypeSelection(int index) {
    if (index < this.availableModifierFields.size()) {
      this.isSelectModifierTypeMode = false;
      setModifierType(this.availableModifierTypes.get(selectedModifierTypeIndex));
      editorSelectModifier.hide();
    }
  }

  private void toggleEditMode() {
    if (objects.activeObjects.size() > 0 && !this.isCreateMode) {
      this.isEditMode = !this.isEditMode;
      if (this.isEditMode) {
        editorToolbar.show();
        editorToggleSnappingButton.show();
        editorObjectsList.show();
        editorObjectButtons.show();
        updateEditorVariableMeta();
        editorVariableMeta.setLabel(objects.getActiveVariable().name);
        editorVariableMeta.show();
        this.switchTool(this.activeTool);
      } else {
        editorToolbar.hide();
        editorColorButtons.hide();
        editorToggleSnappingButton.hide();
        editorObjectsList.hide();
        editorObjectButtons.hide();
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
      if (this.isCreateMode) {
        editorCreateObject.show();
        editorToolbar.hide();
        editorColorButtons.hide();
        editorToggleSnappingButton.hide();
        editorObjectsList.hide();
        editorObjectButtons.hide();
        editorVariableMeta.hide();
      } else {
        editorCreateObject.hide();
        editorToolbar.show();
        if (this.activeTool == TOOL_COLOR) {
          editorColorButtons.show();
        }
        editorToggleSnappingButton.show();
        editorObjectsList.show();
        editorObjectButtons.show();
        editorVariableMeta.show();
      }
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

        visualizers
          .create()
          .move(21, 105)
          .strokeWeightStyle(2);

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
        break;

      case 6: // MODIFIER
        if (this.isSelectModifierTypeMode) {
          palette.reset(palette.flat.black, palette.flat.white, 2);

          for (int i = 0; i < MODIFIER_TYPES.length; i++) {
            boolean isWithinSelectionArea = (this.selectedModifierTypeIndex == i);
            if (isWithinSelectionArea) {
              visualizers
                .create()
                .move(width / 4, height / 4)
                .moveDown(20 * i)
                .strokeColor(palette.flat.purple)
                .draw.basicRectangle(width / 2, 20, 0, CORNER)
                .done();
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
            // .write("modify " + activeVariable.name + "\n" + this.getActiveModifierField() + ": " + this.getModifierValue() + ", type: " + this.getModifierType())
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

    for (int i = 0; i < OBJECT_LIST.length; i++) {
      boolean isWithinSelectionArea = (this.createModeSelectionIndex == i);
      if (isWithinSelectionArea) {
        visualizers
          .create()
          .move(width / 4, height / 4)
          .moveDown(20 * i)
          .strokeColor(palette.flat.red)
          .draw.basicRectangle(width / 2, 20, 0, CORNER)
          .done();
      }
    }
  }
}

ButtonBar editorToolbar;
Button editorToggleSnappingButton;
Button editorClipboardButton;
ScrollableList editorObjectsList;
Group editorColorButtons;
Group editorVariableMeta;
Group editorObjectButtons;
Group editorCreateObject;
Group editorSelectModifier;
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
Textlabel strokeWeightVarMeta;
Textlabel strokeColorVarMeta;
Bang strokeColorVarMetaButton;
Textlabel fillColorVarMeta;
Bang fillColorVarMetaButton;

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
     .setColorBackground(COLOR_BLACK)
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

  editorColorButtons = cp5.addGroup("editorColorButtons")
    .setPosition(10, 125)
    .hideBar()
    .hide();

  cp5.addButton("editorColorButtonPrev").setColorBackground(COLOR_BLACK).setSize(80, 10).setGroup("editorColorButtons")
    .setPosition(80 * 0 + 5 * 0, 0).setLabel("[left] prev");
  cp5.addButton("editorColorButtonNext").setColorBackground(COLOR_BLACK).setSize(80, 10).setGroup("editorColorButtons")
    .setPosition(80 * 1 + 5 * 1, 0).setLabel("[right] next");
  cp5.addButton("editorColorButtonStroke").setColorBackground(COLOR_BLACK).setSize(80, 10).setGroup("editorColorButtons")
    .setPosition(80 * 2 + 5 * 2, 0).setLabel("[entr] stroke");
  cp5.addButton("editorColorButtonFill").setColorBackground(COLOR_BLACK).setSize(80, 10).setGroup("editorColorButtons")
    .setPosition(80 * 3 + 5 * 3, 0).setLabel("[shft+entr] fill");
  cp5.addButton("editorColorButtonBoth").setColorBackground(COLOR_BLACK).setSize(80, 10).setGroup("editorColorButtons")
    .setPosition(80 * 0 + 5 * 0, 10).setLabel("[ctrl+entr] both");
  cp5.addButton("editorColorButtonNoStroke").setColorBackground(COLOR_BLACK).setSize(80, 10).setGroup("editorColorButtons")
    .setPosition(80 * 1 + 5 * 1, 10).setLabel("[del] no stroke");
  cp5.addButton("editorColorButtonNoFill").setColorBackground(COLOR_BLACK).setSize(80, 10).setGroup("editorColorButtons")
    .setPosition(80 * 2 + 5 * 2, 10).setLabel("[shft+del] no fill");
  cp5.addButton("editorColorButtonReset").setColorBackground(COLOR_BLACK).setSize(80, 10).setGroup("editorColorButtons")
    .setPosition(80 * 3 + 5 * 3, 10).setLabel("[ctrl+del] reset");

  editorObjectButtons = cp5.addGroup("editorObjectButtons")
    .setPosition(width - 150, 25)
    .hideBar()
    .hide();

  cp5.addButton("editorObjectButtonPrev").setColorBackground(COLOR_BLACK).setSize(70, 10).setGroup("editorObjectButtons")
    .setPosition(70 * 0, 10 * 0).setLabel("[j] prev");
  cp5.addButton("editorObjectButtonNext").setColorBackground(COLOR_BLACK).setSize(70, 10).setGroup("editorObjectButtons")
    .setPosition(70 * 1, 10 * 0).setLabel("[l] next");
  cp5.addButton("editorObjectButtonDuplicate").setColorBackground(COLOR_BLACK).setSize(70, 10).setGroup("editorObjectButtons")
    .setPosition(70 * 0, 10 * 1).setLabel("[d] dupl");
  cp5.addButton("editorObjectButtonCreate").setColorBackground(COLOR_BLACK).setSize(70, 10).setGroup("editorObjectButtons")
    .setPosition(70 * 1, 10 * 1).setLabel("[n] create");
  cp5.addButton("editorObjectButtonDelete").setColorBackground(COLOR_BLACK).setSize(140, 10).setGroup("editorObjectButtons")
    .setPosition(0, 10 * 2 + 5 * 1).setLabel("[w] delete object");

  editorObjectsList = cp5.addScrollableList("editorObjectsList")
    .setPosition(width - 150, 65)
    .setLabel("select object")
    .setColorBackground(COLOR_BLACK)
    .setSize(140, 500)
    .setBarHeight(10)
    .setItemHeight(10)
    .hide();

  editorVariableMeta = cp5.addGroup("variableMeta")
    .setLabel("selected variable")
    .setColorBackground(COLOR_BLACK)
    .setPosition(10, 35)
    .setSize(300, 60)
    .setBackgroundColor(COLOR_BLACK)
    .hide()
    ;

  editorCreateObject = cp5.addGroup("editorCreateObject")
    .setColorBackground(COLOR_BLACK)
    .setPosition(width * 0.25, height * 0.25)
    .setSize(int(width / 2), 20 * OBJECT_LIST.length)
    .hideBar()
    .hide();

  for (int i = 0; i < OBJECT_LIST.length; i++) {
    cp5.addButton("createObject" + OBJECT_LIST[i]).setColorBackground(COLOR_BLACK).setGroup("editorCreateObject")
      .setPosition(0, 20 * i)
      .setValue(i)
      .setSize(int(width / 2), 20)
      .setLabel(OBJECT_LIST[i]);
  }

  editorSelectModifier = cp5.addGroup("editorSelectModifier")
    .setColorBackground(COLOR_BLACK)
    .setPosition(width * 0.25, height * 0.25)
    .setSize(int(width / 2), 20 * MODIFIER_TYPES.length)
    .hideBar()
    .hide();

  for (int i = 0; i < MODIFIER_TYPES.length; i++) {
    cp5.addButton("selectModifier" + MODIFIER_TYPES[i]).setColorBackground(COLOR_BLACK).setGroup("editorSelectModifier")
      .setPosition(0, 20 * i)
      .setValue(i)
      .setSize(int(width / 2), 20)
      .setLabel(MODIFIER_TYPES[i]);
  }

  xVarMeta = cp5.addTextlabel("x").setPosition(10 * 1, 10).setColorValue(COLOR_WHITE).setGroup("variableMeta");
  yVarMeta = cp5.addTextlabel("y").setPosition(10 * 1, 20).setColorValue(COLOR_WHITE).setGroup("variableMeta");
  zVarMeta = cp5.addTextlabel("z").setPosition(10 * 1, 30).setColorValue(COLOR_WHITE).setGroup("variableMeta");

  xrVarMeta = cp5.addTextlabel("xr").setPosition(10 * 6, 10).setColorValue(COLOR_WHITE).setGroup("variableMeta");
  yrVarMeta = cp5.addTextlabel("yr").setPosition(10 * 6, 20).setColorValue(COLOR_WHITE).setGroup("variableMeta");
  zrVarMeta = cp5.addTextlabel("zr").setPosition(10 * 6, 30).setColorValue(COLOR_WHITE).setGroup("variableMeta");

  wVarMeta = cp5.addTextlabel("w").setPosition(10 * 11, 10).setColorValue(COLOR_WHITE).setGroup("variableMeta");
  hVarMeta = cp5.addTextlabel("h").setPosition(10 * 11, 20).setColorValue(COLOR_WHITE).setGroup("variableMeta");
  lVarMeta = cp5.addTextlabel("l").setPosition(10 * 11, 30).setColorValue(COLOR_WHITE).setGroup("variableMeta");
  sizeVarMeta = cp5.addTextlabel("size").setPosition(10 * 11, 40).setColorValue(COLOR_WHITE).setGroup("variableMeta");

  strokeWeightVarMeta = cp5.addTextlabel("strokeWeight").setPosition(10 * 16, 10).setColorValue(COLOR_WHITE).setGroup("variableMeta");
  strokeColorVarMeta = cp5.addTextlabel("strokeColor").setText("strokeColor: ").setPosition(10 * 16, 20).setColorValue(COLOR_WHITE).setGroup("variableMeta");
  strokeColorVarMetaButton = cp5.addBang("strokeColorButton").setPosition(10 * 16 + 60, 20 + 2).setSize(25, 10 - 4).setLabel("").setColorForeground(COLOR_BLACK).setGroup("variableMeta");
  fillColorVarMeta = cp5.addTextlabel("fillColor").setText("fillColor: ").setPosition(10 * 16, 30).setColorValue(COLOR_WHITE).setGroup("variableMeta");
  fillColorVarMetaButton = cp5.addBang("fillColorButton").setPosition(10 * 16 + 60, 30 + 2).setSize(25, 10 - 4).setLabel("").setColorForeground(COLOR_BLACK).setGroup("variableMeta");
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
  strokeWeightVarMeta.setText("strokeWeight: " + objects.getActiveVariable().strokeWeight);
  strokeColorVarMetaButton.setColorForeground(objects.getActiveVariable().strokeColor);
  fillColorVarMetaButton.setColorForeground(objects.getActiveVariable().fillColor);
  editorObjectsList.setItems(objects.getObjectsList()).setLabel(objects.getActiveVariable().name);
}

public void deselectAllToolbarTools() {
  editorToolbar.changeItem(toolbarLabelMove, "selected", false);
  editorToolbar.changeItem(toolbarLabelResize, "selected", false);
  editorToolbar.changeItem(toolbarLabelTransform, "selected", false);
  editorToolbar.changeItem(toolbarLabelRotate, "selected", false);
  editorToolbar.changeItem(toolbarLabelColor, "selected", false);
  editorToolbar.changeItem(toolbarLabelWeight, "selected", false);
  editorToolbar.changeItem(toolbarLabelModifier, "selected", false);
  editorToolbar.changeItem(toolbarLabelVariation, "selected", false);
  editorColorButtons.hide();
}

void controlEvent(ControlEvent theEvent) {
  if (loaded) {
    if (theEvent.isGroup()) {
      println("event from group " + theEvent.getGroup().getName());
    } else if (theEvent.isController()) {
      if (theEvent.getController().getName().contains("createObject")) {
        editor.handleCreateModeSelection(int(theEvent.getController().getValue()));
      } else if (theEvent.getController().getName().contains("selectModifier")) {
        if (editor.isSelectModifierTypeMode) {
          editor.handleModifierTypeSelection(editor.selectedModifierTypeIndex);
        }
      } else {
        println("event from controller " + theEvent.getController().getName());
      }
    }
  }
}

public void editorToolbar(int toolId) { editor.switchTool(toolId); }
public void strokeColorButton() { editor.switchTool(TOOL_COLOR); }
public void fillColorButton() { editor.switchTool(TOOL_COLOR); }
public void editorColorButtonPrev() { editor.previousActiveColor(); }
public void editorColorButtonNext() { editor.nextActiveColor(); }
public void editorColorButtonStroke() { editor.assignActiveStrokeColor(); }
public void editorColorButtonFill() { editor.assignActiveFillColor(); }
public void editorColorButtonNoStroke() { editor.resetStrokeColor(); }
public void editorColorButtonNoFill() { editor.resetFillColor(); }
public void editorColorButtonBoth() { editor.assignActiveFillColor(); editor.assignActiveStrokeColor(); }
public void editorColorButtonReset() { editor.resetFillColor(); editor.resetStrokeColor(); }
public void editorObjectButtonPrev() { objects.prevActiveVariable(); updateEditorVariableMeta(); }
public void editorObjectButtonNext() { objects.nextActiveVariable(); updateEditorVariableMeta(); }
public void editorObjectButtonDuplicate() { objects.duplicate(); }
public void editorObjectButtonCreate() { editor.toggleCreateMode(); }
public void editorObjectButtonDelete() { objects.remove(); }
public void editorObjectsList(int objectIndex) { objects.setActiveVariable(objectIndex); }
public void editorToggleSnappingButton() { editor.toggleSnappingMode(); }

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