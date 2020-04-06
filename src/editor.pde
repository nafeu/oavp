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
        if (input.isPressed(KEY_M)) { this.switchTool(TOOL_MOVE); }
        if (input.isHoldingControl) {
          if (input.isPressed(KEY_S)) { this.lazySave(); println("Sketch saved to " + sketchPath("sketch.pde")); }
        } else {
          if (input.isPressed(KEY_S)) { this.switchTool(TOOL_RESIZE); }
        }
        if (input.isPressed(KEY_T)) { this.switchTool(TOOL_TRANSFORM); }
        if (input.isPressed(KEY_R)) { this.switchTool(TOOL_ROTATE); }
        if (input.isPressed(KEY_C)) { this.switchTool(TOOL_COLOR); }
        if (input.isPressed(KEY_B)) { this.switchTool(TOOL_WEIGHT); }
        if (input.isPressed(KEY_V)) { this.switchTool(TOOL_VARIATION); }
        if (input.isPressed(KEY_Z)) { this.switchTool(TOOL_MODIFIER); }
      }

      if (input.isPressed(KEY_D)) { objects.duplicate(); }
      if (input.isPressed(KEY_N)) { toggleCreateMode(); }
      if (input.isPressed(KEY_Q)) { toggleSnappingMode(); }
      if (input.isPressed(KEY_X)) { println(objects.exportSketchData()); }
      if (input.isPressed(KEY_W)) { objects.remove(); }
    }
  }

  public void lazySave() {
    saveStrings(
      sketchPath("sketch.pde"),
      new String[] {
        "void setupSketch() {",
        objects.exportSketchData(),
        "} /*--SETUP--*/",
        "",
        "void updateSketch() {",
        "} /*--UPDATE--*/",
        "",
        "void drawSketch() {",
        "} /*--DRAW--*/",
        ""
      }
    );
  }

  // public void saveSketch() {
  //   if (this.openedPath != "") {
  //     println("Saving file...");
  //   } else {
  //     promptFileSave();
  //   }
  // }

  // public void promptFileSave() {
  //   this.fileSaveModalOpen = true;
  // }

  public void switchTool(int toolId) {
    updateOriginalValues();
    deselectAllToolbarTools();
    switch (toolId) {
      case 0:
        this.activeTool = TOOL_MOVE;
        editorToolbar.changeItem(toolbarLabelMove, "selected", true);
        setHelpText(""
          + "[mouse or left/right] to edit x-axis position\n"
          + "[mouse or up/down] to edit y-axis position\n"
          + "[shift] + [mouse or up/down] to edit z-axis position\n"
        );
        break;
      case 1:
        this.activeTool = TOOL_RESIZE;
        setHelpText(""
          + "[mouse or up/down] to edit size\n"
          + "Note: size param unrelated to w, h and l\n"
        );
        editorToolbar.changeItem(toolbarLabelResize, "selected", true);
        break;
      case 2:
        this.activeTool = TOOL_TRANSFORM;
        setHelpText(""
          + "[mouse or left/right] to edit width (x-axis)\n"
          + "[mouse or up/down] to edit height (y-axis)\n"
          + "[shift] + [mouse or up/down] to edit length (z-axis)\n"
        );
        editorToolbar.changeItem(toolbarLabelTransform, "selected", true);
        break;
      case 3:
        this.activeTool = TOOL_ROTATE;
        setHelpText(""
          + "[mouse or left/right] to edit z-axis rotation\n"
          + "[mouse or up/down] to edit y-axis rotation\n"
          + "[shift] + [mouse or up/down] to edit x-axis rotation\n"
        );
        editorToolbar.changeItem(toolbarLabelRotate, "selected", true);
        break;
      case 4:
        this.activeTool = TOOL_COLOR;
        setHelpText(""
          + "[left/right] to change color selection\n"
          + "[up/down] to change palette\n"
          + "[enter] to assign selected color to stroke\n"
          + "[shift+enter] to assign selected color to fill\n"
        );
        editorToolbar.changeItem(toolbarLabelColor, "selected", true);
        editorColorButtons.show();
        break;
      case 5:
        this.activeTool = TOOL_WEIGHT;
        setHelpText(""
          + "[up/down] to edit stroke weight\n"
        );
        editorToolbar.changeItem(toolbarLabelWeight, "selected", true);
        break;
      case 6:
        this.activeTool = TOOL_MODIFIER;
        setHelpText(""
          + "[up/down] to select field to modify\n"
          + "[left/right] to edit intensity of modification\n"
          + "[enter] to select modifier type\n"
        );
        editorToolbar.changeItem(toolbarLabelModifier, "selected", true);
        editorModifiers.show();
        break;
      case 7:
        this.activeTool = TOOL_VARIATION;
        setHelpText(""
          + "[up/down] to select variation of object\n"
        );
        editorToolbar.changeItem(toolbarLabelVariation, "selected", true);
        editorVariations.show();
        break;
    }
  }

  public void updateOriginalValues() {
    if (objects.getActiveVariable() != null) {
      for (String rawFieldName : MODIFIER_FIELDS) {
        String fieldName = rawFieldName.split("Mod")[0];

        try {
          Field field = objects.getActiveVariable().getClass().getDeclaredField(fieldName);

          Object fieldValue = field.get(objects.getActiveVariable());

          originalValues.put(fieldName, fieldValue);
        } catch (Exception e) {
          e.printStackTrace();
        }
      }

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

  float DELTA_MODIFIER_PRECISE_KEYS = 5;
  float DELTA_MODIFIER_SNAP_KEYS = 50;

  private void handleToolModifierInputs() {
    float deltaKeys = DELTA_MODIFIER_PRECISE_KEYS;

    if (this.isSnappingEnabled) {
      deltaKeys = DELTA_MODIFIER_SNAP_KEYS;
    }

    if (this.isSelectModifierTypeMode) {
      if (input.isPressed(UP)) { this.setSelectedModifierTypeIndex(this.selectedModifierTypeIndex - 1); }
      if (input.isPressed(DOWN)) { this.setSelectedModifierTypeIndex(this.selectedModifierTypeIndex + 1); }
      if (input.isPressed(ENTER)) { handleModifierTypeSelection(this.selectedModifierTypeIndex); }
    } else {
      if (input.isPressed(UP)) { this.setSelectedModifierFieldIndex(this.selectedModifierFieldIndex - 1); }
      if (input.isPressed(DOWN)) { this.setSelectedModifierFieldIndex(this.selectedModifierFieldIndex + 1); }
      if (input.isPressed(ENTER)) { this.toggleSelectModifierTypeMode(); }
      if (input.isPressed(RIGHT)) { this.setModifierValue(this.getModifierValue() + deltaKeys); }
      if (input.isPressed(LEFT)) { this.setModifierValue(this.getModifierValue() - deltaKeys); }
    }

    updateEditorVariableMeta();
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

    updateEditorVariableMeta();
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
      editorHelp.show();
      editorCreateObject.hide();
    }
  }

  private void handleModifierTypeSelection(int index) {
    if (index < MODIFIER_TYPES.length) {
      setModifierType(this.availableModifierTypes.get(selectedModifierTypeIndex));
      updateEditorVariableMeta();
      this.toggleSelectModifierTypeMode();
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
        editorVariableMeta.show();
        editorHelp.show();
        this.switchTool(this.activeTool);
      } else {
        editorToolbar.hide();
        editorColorButtons.hide();
        editorToggleSnappingButton.hide();
        editorObjectsList.hide();
        editorObjectButtons.hide();
        editorVariableMeta.hide();
        editorHelp.hide();
        editorSelectModifier.hide();
        editorModifiers.hide();
        editorVariations.hide();
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
        editorHelp.hide();
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
        editorHelp.show();
      }
    }
  }

  public void toggleSelectModifierTypeMode() {
    this.isSelectModifierTypeMode = !this.isSelectModifierTypeMode;
    if (this.isSelectModifierTypeMode) {
      editorSelectModifier.show();
      editorCreateObject.hide();
      editorToolbar.hide();
      editorColorButtons.hide();
      editorToggleSnappingButton.hide();
      editorObjectsList.hide();
      editorObjectButtons.hide();
      editorVariableMeta.hide();
      editorHelp.hide();
      editorModifiers.hide();
      editorVariations.hide();
    } else {
      editorSelectModifier.hide();
      editorCreateObject.hide();
      editorToolbar.show();
      if (this.activeTool == TOOL_MODIFIER) {
        editorModifiers.show();
      }
      if (this.activeTool == TOOL_VARIATION) {
        editorVariations.show();
      }
      editorToggleSnappingButton.show();
      editorObjectsList.show();
      editorObjectButtons.show();
      editorVariableMeta.show();
      editorHelp.show();
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
          for (int i = 0; i < MODIFIER_FIELDS.length; i++) {
            boolean isWithinSelectionArea = (this.selectedModifierFieldIndex == i);
            if (isWithinSelectionArea && cp5.getGroup("editorModifiers").isOpen()) {
              visualizers
                .create()
                .move(22, 130)
                .moveDown(10 * (i - 1) + 5 * i)
                .strokeColor(palette.flat.purple)
                .draw.basicRectangle(255, 10, 0, CORNER)
                .done();
            }
          }
          visualizers
            .create()
            .center().middle()
            .strokeColor(palette.flat.purple)
            .noFillStyle()
            .strokeWeightStyle(0.5)
            .move(activeVariable.x, activeVariable.y, activeVariable.z)
            .draw.basicCircle(5)
            .draw.positionalLines(width)
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

  public void setSelectedModifierTypeIndex(int index) {
    if (index >= MODIFIER_TYPES.length) {
      this.selectedModifierTypeIndex = MODIFIER_TYPES.length - 1;
    } else if (index < 0) {
      this.selectedModifierTypeIndex = 0;
    } else {
      this.selectedModifierTypeIndex = index;
    }
  }

  public void setSelectedModifierFieldIndex(int index) {
    println(index);
    if (index >= MODIFIER_FIELDS.length) {
      this.selectedModifierFieldIndex = MODIFIER_FIELDS.length - 1;
    } else if (index < 0) {
      this.selectedModifierFieldIndex = 0;
    } else {
      this.selectedModifierFieldIndex = index;
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
Group editorModifiers;
Group editorVariations;
Group editorHelp;
Textlabel editorHelpText;
Bang strokeColorVarMetaButton;
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

  editorVariableMeta = cp5.addGroup("editorVariableMeta")
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

  editorModifiers = cp5.addGroup("editorModifiers")
    .setLabel("modifiers")
    .setColorBackground(COLOR_BLACK)
    .setPosition(10, 110)
    .setSize(300, 370)
    .setBackgroundColor(COLOR_BLACK)
    .hide()
    ;

  for (int i = 0; i < MODIFIER_FIELDS.length; i++) {
    cp5.addTextlabel(MODIFIER_FIELDS[i] + "Label")
      .setText(MODIFIER_FIELDS[i])
      .setPosition(10 * 1, 10 * (i + 1) + 5 * i)
      .setColorValue(COLOR_WHITE)
      .setGroup("editorModifiers");

    cp5.addNumberbox("modifierVal-" + MODIFIER_FIELDS[i])
      .setColorBackground(COLOR_BLACK)
      .setPosition(10 * 10, (10 * (i + 1) + 5 * i))
      .setLabel("")
      .setSize(50, 10)
      .setMultiplier(-5)
      .setSensitivity(100)
      .setValue(0)
      .setId(i)
      .setGroup("editorModifiers");

    cp5.addButton("modifierButton-" + MODIFIER_FIELDS[i])
      .setColorBackground(COLOR_BLACK)
      .setPosition(10 * 16 - 5, (10 * (i + 1) + 5 * i))
      .setValue(i)
      .setSize(110, 10)
      .setLabel("none")
      .setGroup("editorModifiers");
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

  editorVariations = cp5.addGroup("editorVariations")
    .setLabel("variations")
    .setColorBackground(COLOR_BLACK)
    .setPosition(10, 110)
    .setSize(150, 30)
    .setBackgroundColor(COLOR_BLACK)
    .hide()
    ;

  cp5.addScrollableList("editorVariationList")
    .setLabel("select variation")
    .setPosition(10, 10)
    .setColorBackground(COLOR_BLACK)
    .setGroup("editorVariations")
    .close()
    ;

  editorHelp = cp5.addGroup("editorHelp")
    .setLabel("help")
    .setColorBackground(COLOR_BLACK)
    .setPosition(10 + 300 + 5, 35)
    .setSize(250, 60)
    .setBackgroundColor(COLOR_BLACK)
    .hide()
    ;

  editorHelpText = cp5.addTextlabel("editorHelpText")
    .setPosition(10, 10)
    .setColorValue(COLOR_WHITE)
    .setGroup("editorHelp")
    ;

  cp5.addTextlabel("xVarMeta").setPosition(10 * 1, 10).setColorValue(COLOR_WHITE).setGroup("editorVariableMeta");
  cp5.addTextlabel("yVarMeta").setPosition(10 * 1, 20).setColorValue(COLOR_WHITE).setGroup("editorVariableMeta");
  cp5.addTextlabel("zVarMeta").setPosition(10 * 1, 30).setColorValue(COLOR_WHITE).setGroup("editorVariableMeta");
  cp5.addTextlabel("xrVarMeta").setPosition(10 * 6, 10).setColorValue(COLOR_WHITE).setGroup("editorVariableMeta");
  cp5.addTextlabel("yrVarMeta").setPosition(10 * 6, 20).setColorValue(COLOR_WHITE).setGroup("editorVariableMeta");
  cp5.addTextlabel("zrVarMeta").setPosition(10 * 6, 30).setColorValue(COLOR_WHITE).setGroup("editorVariableMeta");
  cp5.addTextlabel("wVarMeta").setPosition(10 * 11, 10).setColorValue(COLOR_WHITE).setGroup("editorVariableMeta");
  cp5.addTextlabel("hVarMeta").setPosition(10 * 11, 20).setColorValue(COLOR_WHITE).setGroup("editorVariableMeta");
  cp5.addTextlabel("lVarMeta").setPosition(10 * 11, 30).setColorValue(COLOR_WHITE).setGroup("editorVariableMeta");
  cp5.addTextlabel("sizeVarMeta").setPosition(10 * 11, 40).setColorValue(COLOR_WHITE).setGroup("editorVariableMeta");
  cp5.addTextlabel("strokeWeightVarMeta").setPosition(10 * 16, 10).setColorValue(COLOR_WHITE).setGroup("editorVariableMeta");
  cp5.addTextlabel("strokeColorVarMeta").setText("strokeColor: ").setPosition(10 * 16, 20).setColorValue(COLOR_WHITE).setGroup("editorVariableMeta");
  cp5.addTextlabel("fillColorVarMeta").setText("fillColor: ").setPosition(10 * 16, 30).setColorValue(COLOR_WHITE).setGroup("editorVariableMeta");

  strokeColorVarMetaButton = cp5.addBang("strokeColorButtonVarMeta").setPosition(10 * 16 + 60, 20 + 2).setSize(25, 10 - 4).setLabel("").setColorForeground(COLOR_BLACK).setGroup("editorVariableMeta");
  fillColorVarMetaButton = cp5.addBang("fillColorButtonVarMeta").setPosition(10 * 16 + 60, 30 + 2).setSize(25, 10 - 4).setLabel("").setColorForeground(COLOR_BLACK).setGroup("editorVariableMeta");
}

public void updateEditorVariableMeta() {
  OavpVariable activeVariable = objects.getActiveVariable();

  editorVariableMeta.setLabel(activeVariable.name + " (" + activeVariable.getVariation() + ")");

  cp5.get(Textlabel.class, "xVarMeta").setText("x: " + activeVariable.x);
  cp5.get(Textlabel.class, "yVarMeta").setText("y: " + activeVariable.y);
  cp5.get(Textlabel.class, "zVarMeta").setText("z: " + activeVariable.z);
  cp5.get(Textlabel.class, "xrVarMeta").setText("xr: " + activeVariable.xr);
  cp5.get(Textlabel.class, "yrVarMeta").setText("yr: " + activeVariable.yr);
  cp5.get(Textlabel.class, "zrVarMeta").setText("zr: " + activeVariable.zr);
  cp5.get(Textlabel.class, "wVarMeta").setText("w: " + activeVariable.w);
  cp5.get(Textlabel.class, "hVarMeta").setText("h: " + activeVariable.h);
  cp5.get(Textlabel.class, "lVarMeta").setText("l: " + activeVariable.l);
  cp5.get(Textlabel.class, "sizeVarMeta").setText("size: " + activeVariable.size);
  cp5.get(Textlabel.class, "strokeWeightVarMeta").setText("strokeWeight: " + activeVariable.strokeWeight);

  strokeColorVarMetaButton.setColorForeground(activeVariable.strokeColor);
  fillColorVarMetaButton.setColorForeground(activeVariable.fillColor);
  editorObjectsList.setItems(objects.getObjectsList()).setLabel(activeVariable.name);

  for (String modifierField : MODIFIER_FIELDS) {
    cp5.getController("modifierVal-" + modifierField).setBroadcast(false);
    cp5.getController("modifierVal-" + modifierField).setValue((float) activeVariable.get(modifierField));
    cp5.getController("modifierVal-" + modifierField).setBroadcast(true);
    cp5.getController("modifierButton-" + modifierField).setLabel((String) activeVariable.get(modifierField + "Type"));
  }

  cp5.get(ScrollableList.class, "editorVariationList")
    .setLabel(activeVariable.getVariation())
    .setItems(activeVariable.variations);
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
  editorModifiers.hide();
  editorVariations.hide();
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
          println(theEvent.getController().getName() + "--" + int(theEvent.getController().getValue()));
          editor.setSelectedModifierTypeIndex(int(theEvent.getController().getValue()));
          editor.handleModifierTypeSelection(editor.selectedModifierTypeIndex);
        }
        println("event from selectModifier " + theEvent.getController().getName());
      } else if (theEvent.getController().getName().contains("modifierVal")) {
        float val = theEvent.getController().getValue();
        String prop = theEvent.getController().getName().split("-")[1];
        int index = int(theEvent.getController().getId());
        editor.setSelectedModifierFieldIndex(index);
        objects.getActiveVariable().set(prop, val);
        println("event from modifierVal " + theEvent.getController().getName());
      } else if (theEvent.getController().getName().contains("modifierButton")) {
        int index = int(theEvent.getController().getValue());
        editor.setSelectedModifierFieldIndex(index);
        editor.toggleSelectModifierTypeMode();
        println("event from modifierButton " + theEvent.getController().getName());
      } else if (theEvent.getController().getName().contains("editorVariationList")) {
        println("event from editorVariationList " + theEvent.getController().getValue());
        int index = int(theEvent.getController().getValue());
        String val = (String) cp5.get(ScrollableList.class, "editorVariationList").getItem(index).get("name");
        objects.getActiveVariable().set("variation", val);
        updateEditorVariableMeta();
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

public void setHelpText(String text) {
  editorHelpText.setText(text);
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