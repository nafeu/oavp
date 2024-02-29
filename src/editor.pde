int TOOL_MOVE = 0;
int TOOL_RESIZE = 1;
int TOOL_TRANSFORM = 2;
int TOOL_ROTATE = 3;
int TOOL_COLOR = 4;
int TOOL_WEIGHT = 5;
int TOOL_MODIFIER = 6;
int TOOL_VARIATION = 7;
int TOOL_PARAMS = 8;
int TOOL_MOD_DELAY = 9;
int TOOL_ITERATION = 10;
int TOOL_ITERATION_COUNT = 11;

// KEYS
int KEY_1 = 49;
int KEY_2 = 50;
int KEY_3 = 51;
int KEY_4 = 52;
int KEY_5 = 53;
int KEY_6 = 54;
int KEY_7 = 55;
int KEY_8 = 56;
int KEY_9 = 57;
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
int KEY_PLUS = 61;
int KEY_COMMA = 44;
int KEY_MINUS = 45;
int KEY_RIGHT_BRACKET = 93;
int KEY_LEFT_BRACKET = 91;
int KEY_BACKSLASH = 92;

public class OavpEditor {
  private boolean isEditMode = false;
  private boolean isHelpMode = false;
  private boolean isCreateMode = false;
  private boolean isSelectModifierTypeMode = false;
  private boolean isSelectIterationFuncMode = false;
  private int snapIntensity = 2;
  private boolean isModalOpen = false;
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
  private List<String> availableIterationFields;
  private List<String> availableIterationFuncs;
  private int selectedModifierFieldIndex = 0;
  private int selectedModifierTypeIndex = 0;
  private int selectedIterationFieldIndex = 0;
  private int selectedIterationFuncIndex = 0;
  private int selectedParamIndex = 0;
  private HashMap<String, Object> originalValues;
  private HashMap<String, String[]> modalOptions;
  private HashMap<String, Object> modalValues;
  private String modalHeader;
  private int queuedObjectToCreate = 0;
  private color backgroundColor = #FFFFFF;
  private color accentA = #000000;
  private color accentB = #E74C3C;
  private color accentC = #2ECC71;
  private color accentD = #3498DB;
  private color[] shuffledPalette = new color[5];

  OavpEditor(OavpInput input, OavpObjectManager objects, OavpText text) {
    this.input = input;
    this.objects = objects;
    this.text = text;
    this.activePalette = palette.getPalette(colorPaletteIndex);
    this.selectableObjects = new ArrayList<String>();
    this.availableModifierFields = new ArrayList<String>();
    this.availableModifierTypes = new ArrayList<String>();
    this.availableIterationFields = new ArrayList<String>();
    this.availableIterationFuncs = new ArrayList<String>();
    this.originalValues = new HashMap<String, Object>();
    this.modalOptions = new HashMap<String, String[]>();
    this.modalValues = new HashMap<String, Object>();
    this.modalHeader = "default modal header";

    for (String objectType : OBJECT_LIST) {
      selectableObjects.add(objectType);
    }
    for (String modifierField : MODIFIER_FIELDS) {
      availableModifierFields.add(modifierField);
    }
    for (String modifierType : MODIFIER_TYPES) {
      availableModifierTypes.add(modifierType);
    }
    for (String iterationField : ITERATION_FIELDS) {
      availableIterationFields.add(iterationField);
    }
    for (String iterationFunc : ITERATION_FUNCS) {
      availableIterationFuncs.add(iterationFunc);
    }
  }

  public void addModalOption(String name, String optionType, String values) {
    this.modalOptions.put(name, new String[] { optionType, values });
  }

  public void addModalOption(String name, String optionType) {
    this.modalOptions.put(name, new String[] { optionType, "" });
  }

  public void setModalValue(String name, Object value) {
    this.modalValues.put(name, value);
  }

  public void setModalHeader(String header) {
    this.modalHeader = header;
  }

  public Object getModalValue(String name) {
    return this.modalValues.get(name);
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

  public void openModal() {
    if (this.isModalOpen == false) {
      this.isModalOpen = true;
      this.modalValues.clear();
      openModalGui();
    }
  }

  public void confirmModal() {
    this.finalizeCreation();
    this.closeModal();
  }

  public void cancelModal() {
    this.cancelCreation();
    this.closeModal();
  }

  public void closeModal() {
    if (this.isModalOpen == true) {
      this.isModalOpen = false;
      this.modalOptions.clear();
      closeModalGui();
    }
  }

  public void handleKeyInputs() {
    if (this.isModalOpen) {
      handleModalInputs();
      return;
    }

    if (input.isPressed(KEY_E)) {
      toggleEditMode();
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
      } else if (this.activeTool == TOOL_PARAMS) {
        handleToolParamsInputs();
      } else if (this.activeTool == TOOL_MOD_DELAY) {
        handleToolModDelayInputs();
      } else if (this.activeTool == TOOL_ITERATION) {
        handleToolIterationInputs();
      } else if (this.activeTool == TOOL_ITERATION_COUNT) {
        handleToolIterationCountInputs();
      }
    }

    if (isCreateable()) {
      handleCreateModeInputs();
    }

    if (this.isEditMode) {
      if (input.isPressed(KEY_RIGHT_BRACKET)) {
        objects.nextActiveVariable();
        updateEditorVariableMeta();
      }

      if (input.isPressed(KEY_LEFT_BRACKET)) {
        objects.prevActiveVariable();
        updateEditorVariableMeta();
      }

      if (isToolSwitchable()) {
        if (input.isPressed(KEY_M)) { this.switchTool(TOOL_MOVE); }
        if (input.isHoldingControl) {
          if (input.isPressed(KEY_S)) { this.exportSketchToFile(); }

          if (input.isPressed(KEY_1)) { presetOne(); }
          if (input.isPressed(KEY_2)) { presetTwo(); }
          if (input.isPressed(KEY_3)) { presetThree(); }
          if (input.isPressed(KEY_4)) { presetFour(); }
          if (input.isPressed(KEY_5)) { presetFive(); }
          if (input.isPressed(KEY_6)) { presetSix(); }
          if (input.isPressed(KEY_7)) { presetSeven(); }
          if (input.isPressed(KEY_8)) { presetEight(); }
          if (input.isPressed(KEY_9)) { presetNine(); }
        } else {
          if (input.isPressed(KEY_S)) { this.switchTool(TOOL_RESIZE); }
        }
        if (input.isPressed(KEY_T)) { this.switchTool(TOOL_TRANSFORM); }
        if (input.isPressed(KEY_R)) { this.switchTool(TOOL_ROTATE); }
        if (input.isPressed(KEY_C)) { this.switchTool(TOOL_COLOR); }
        if (input.isPressed(KEY_B)) { this.switchTool(TOOL_WEIGHT); }
        if (input.isPressed(KEY_V)) { this.switchTool(TOOL_VARIATION); }
        if (input.isPressed(KEY_Z)) { this.switchTool(TOOL_MODIFIER); }
        if (input.isPressed(KEY_P)) { this.switchTool(TOOL_PARAMS); }
        if (input.isPressed(KEY_O)) { this.switchTool(TOOL_MOD_DELAY); }
        if (input.isPressed(KEY_I)) { this.switchTool(TOOL_ITERATION); }
        if (input.isPressed(KEY_A)) { this.switchTool(TOOL_ITERATION_COUNT); }
      }

      if (input.isPressed(KEY_D)) { objects.duplicate(); }
      if (input.isPressed(KEY_N)) { toggleCreateMode(); }
      if (input.isPressed(KEY_Q)) { toggleSnapIntensity(); }
      if (input.isPressed(KEY_X)) {
        Date date = new Date();
        println("--- [ sketch data : " + date + " ] ---");
        println(objects.exportAllObjectData());
      }
      if (input.isPressed(KEY_COMMA)) {
        Date date = new Date();
        println("--- [ object data : " + date + " ] ---");
        println(objects.exportObjectData());
      }
      if (input.isPressed(KEY_W)) { objects.remove(); }
    }
  }

  public void handleModalInputs() {
    if (input.isPressed(ESC)) {
      cancelModal();
    }

    if (input.isPressed(ENTER)) {
      confirmModal();
    }
  }

  public void queueExportSketchToFile() {
    EXPORT_SKETCH = true;
  }

  public void exportSketchToFile() {
    println("[ oavp ] Exporting sketch to file...");

    Date date = new Date();

    String paletteArrayString = palette.getFormattedPaletteString(colorPaletteIndex);

    saveStrings(
      sketchPath("../tools/commander/export.txt"),
      new String[] {
        "//DATE:" + date,
        "//PALETTE:" + paletteArrayString,
        "//SEED:" + SEED,
        "void setupSketch() {",
        "setSketchSeed(" + SEED + ");",
        objects.exportAllObjectData() + "}",
        "void setupSketchPostEditor() {",
        "editor.setPaletteByArrayString(\"" + paletteArrayString + "\");",
        "editor.setBackgroundColor(" + str(this.backgroundColor) + ");",
        "editor.setAccentA(" + str(this.accentA) + ");",
        "editor.setAccentB(" + str(this.accentB) + ");",
        "editor.setAccentC(" + str(this.accentC) + ");",
        "editor.setAccentD(" + str(this.accentD) + ");",
        "}",
        "void updateSketch() {}",
        "void drawSketch() {}",
      }
    );
    save(sketchPath("../tools/commander/export.png"));
  }

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
          + "[backslash] to select random palette\n"
          + "[shift+backslash] to assign random colors\n"
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
        editorToolbar.changeItem(toolbarLabelModifiers, "selected", true);
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
      case 8:
        this.activeTool = TOOL_PARAMS;
        setHelpText(""
          + "[up/down] to select param of object\n"
          + "[left/right] to edit value of parameter\n"
        );
        editorToolbar.changeItem(toolbarLabelParams, "selected", true);
        editorParams.show();
        break;
      case 9:
        this.activeTool = TOOL_MOD_DELAY;
        setHelpText(""
          + "[mouse or up/down] to edit mod delay\n"
        );
        editorToolbar.changeItem(toolbarLabelModDelay, "selected", true);
        break;
      case 10:
        this.activeTool = TOOL_ITERATION;
        setHelpText(""
          + "[up/down] to select field to modify\n"
          + "[left/right] to edit intensity of iteration\n"
          + "[enter] to select iteration func\n"
        );
        editorToolbar.changeItem(toolbarLabelIterations, "selected", true);
        editorIterations.show();
        break;
      case 11:
        this.activeTool = TOOL_ITERATION_COUNT;
        setHelpText(""
          + "[mouse or up/down] to edit iteration count\n"
        );
        editorToolbar.changeItem(toolbarLabelIterationCount, "selected", true);
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

      for (String rawFieldName : NON_MODIFIER_FIELDS) {
        try {
          Field field = objects.getActiveVariable().getClass().getDeclaredField(rawFieldName);

          Object fieldValue = field.get(objects.getActiveVariable());

          originalValues.put(rawFieldName, fieldValue);
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

  private void directEdit(String fieldName, Object value) {
    println("[ oavp ] Direct editing: " + fieldName + ", " + value);

    try {
      OavpVariable activeVariable = objects.getActiveVariable();
      Field field = activeVariable.getClass().getDeclaredField(fieldName);

      if (originalValues.get(fieldName).getClass() == Float.class) {
        field.set(activeVariable, (float) value);
      } else if (originalValues.get(fieldName).getClass() == String.class) {
        field.set(activeVariable, (String) value);
      } else if (originalValues.get(fieldName).getClass() == Integer.class) {
        if (value instanceof Float) {
          field.set(activeVariable, int((float) value));
        } else {
          field.set(activeVariable, (int) value);
        }
      }

      originalValues.replace(fieldName, field.get(activeVariable));
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  private void externalDirectEdit(String fieldName, Object value) {
    // Note: does not reference "original values", use this for editing from eternal source
    try {
      OavpVariable activeVariable = objects.getActiveVariable();
      Field field = activeVariable.getClass().getDeclaredField(fieldName);

      // Note: this handles the case where variation is an index which references a mutable List<String>
      //       but the value comes in as a string, ie: "none" or "trees"
      if (fieldName.equals("variation")) {
        field.set(activeVariable, activeVariable.getVariationIndex((String) value));
      } else if (activeVariable.get(fieldName).getClass() == Float.class) {
        field.set(activeVariable, (float) value);
      } else if (activeVariable.get(fieldName).getClass() == String.class) {
        field.set(activeVariable, (String) value);
      } else if (activeVariable.get(fieldName).getClass() == Integer.class) {
        if (value instanceof Float) {
          field.set(activeVariable, int((float) value));
        } else {
          field.set(activeVariable, (int) value);
        }
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

  int[] DELTA_MOVEMENT_SNAP_CONFIGS_KEYS  = { 1, 5, 50, 200 };
  int[] DELTA_MOVEMENT_SNAP_CONFIGS_MOUSE = { 1, 5, 50, 200 };

  private void handleToolMoveInputs() {
    int deltaKeys  = DELTA_MOVEMENT_SNAP_CONFIGS_KEYS[this.snapIntensity];
    int deltaMouse = DELTA_MOVEMENT_SNAP_CONFIGS_KEYS[this.snapIntensity];

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

  float[] DELTA_RESIZE_SNAP_CONFIGS_KEYS  = { 1, 5, 50, 200 };
  float[] DELTA_RESIZE_SNAP_CONFIGS_MOUSE = { 1, 5, 50, 200 };

  private void handleToolResizeInputs() {
    float deltaKeys  = DELTA_RESIZE_SNAP_CONFIGS_KEYS[this.snapIntensity];
    float deltaMouse = DELTA_RESIZE_SNAP_CONFIGS_MOUSE[this.snapIntensity];

    if (input.isPressed(UP)) { previewEdit("s", deltaKeys); commitEdit("s"); }
    if (input.isPressed(DOWN)) { previewEdit("s", deltaKeys * -1); commitEdit("s"); }

    if (input.isMousePressed()) {
      previewEdit("s", snap(input.getYGridTicks() * -1, deltaMouse));
    }

    if (input.isMouseReleased()) {
      commitEdit("s");
      input.resetTicks();
    }

    if (input.isShiftReleased()) {}

    updateEditorVariableMeta();
  }

  float[] DELTA_TRANSFORM_SNAP_CONFIGS_KEYS  = { 1, 5, 50, 200 };
  float[] DELTA_TRANSFORM_SNAP_CONFIGS_MOUSE = { 1, 5, 50, 200 };

  private void handleToolTransformInputs() {
    float deltaKeys  = DELTA_TRANSFORM_SNAP_CONFIGS_KEYS[this.snapIntensity];
    float deltaMouse = DELTA_TRANSFORM_SNAP_CONFIGS_MOUSE[this.snapIntensity];

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

  int[] DELTA_ROTATE_SNAP_CONFIGS_KEYS  = { 1, 5, 15, 30 };
  int[] DELTA_ROTATE_SNAP_CONFIGS_MOUSE = { 1, 5, 15, 30 };

  private void handleToolRotateInputs() {
    int deltaKeys  = DELTA_ROTATE_SNAP_CONFIGS_KEYS[this.snapIntensity];
    int deltaMouse = DELTA_ROTATE_SNAP_CONFIGS_MOUSE[this.snapIntensity];

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
      if (input.isPressed(KEY_BACKSLASH)) { this.randomAssignment(); };
    } else {
      if (input.isPressed(ENTER)) { this.assignActiveStrokeColor(); }
      if (input.isPressed(BACKSPACE)) { this.resetStrokeColor(); }
      if (input.isPressed(KEY_BACKSLASH)) { this.randomPalette(); };
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
    this.colorPaletteIndex = (this.colorPaletteIndex + 1) % palette.table.size();
    this.activePalette = palette.getPalette(colorPaletteIndex);
    this.colorIndex = this.colorIndex % this.activePalette.length;
  }

  public void previousPalette() {
    if (this.colorPaletteIndex == 0) {
      this.colorPaletteIndex = palette.table.size() - 1;
    } else {
      this.colorPaletteIndex = (this.colorPaletteIndex - 1) % palette.table.size();
      this.activePalette = palette.getPalette(colorPaletteIndex);
      this.colorIndex = this.colorIndex % this.activePalette.length;
    }
  }

  public void shuffleAccents() {
    arrayCopy(this.activePalette, this.shuffledPalette);
    shuffleArray(this.shuffledPalette);
    this.backgroundColor = this.shuffledPalette[0];
    this.accentA = this.shuffledPalette[1];
    this.accentB = this.shuffledPalette[2];
    this.accentC = this.shuffledPalette[3];
    this.accentD = this.shuffledPalette[4];
  }

  public void randomPalette() {
    int randomPalette = (int) random(0, palette.table.size());
    palette.moveToFront(randomPalette);
    this.activePalette = palette.getPalette(0);
    this.colorIndex = this.colorIndex % this.activePalette.length;
    shuffleAccents();
  }

  public void setPaletteByArrayString(String colorsArrayString) {
    this.activePalette = palette.getPalette(palette.getPaletteIndexByColorValuesList(colorsArrayString));
    this.colorIndex = this.colorIndex % this.activePalette.length;
  }

  public void assignActiveFillColor() {
    objects.getActiveVariable().fillColor(this.activePalette[this.colorIndex]);
  }

  public void assignActiveStrokeColor() {
    objects.getActiveVariable().strokeColor(this.activePalette[this.colorIndex]);
  }

  public void randomAssignment() {
    // Background is always at 0th index, ie. it is selected first
    OavpVariable activeVariable = objects.getActiveVariable();

    if (activeVariable.name.contains("nofill")) {
      activeVariable.fillColor(0);
    }
    else if (activeVariable.name.contains("notbackgroundfill")) {
      activeVariable.fillColor(getRandomPaletteColorWithExclusion("backgroundColor"));
    }
    else if (activeVariable.name.contains("notaccentafill")) {
      activeVariable.fillColor(getRandomPaletteColorWithExclusion("accentA"));
    }
    else if (activeVariable.name.contains("notaccentbfill")) {
      activeVariable.fillColor(getRandomPaletteColorWithExclusion("accentB"));
    }
    else if (activeVariable.name.contains("notaccentcfill")) {
      activeVariable.fillColor(getRandomPaletteColorWithExclusion("accentC"));
    }
    else if (activeVariable.name.contains("notaccentdfill")) {
      activeVariable.fillColor(getRandomPaletteColorWithExclusion("accentD"));
    }
    else if (activeVariable.name.equals("background") || activeVariable.name.contains("backgroundfill")) {
      activeVariable.fillColor(this.backgroundColor);
    }
    else if (activeVariable.name.contains("accentafill")) {
      activeVariable.fillColor(this.accentA);
    }
    else if (activeVariable.name.contains("accentbfill")) {
      activeVariable.fillColor(this.accentB);
    }
    else if (activeVariable.name.contains("accentcfill")) {
      activeVariable.fillColor(this.accentC);
    }
    else if (activeVariable.name.contains("accentdfill")) {
      activeVariable.fillColor(this.accentD);
    }
    else if (
      !activeVariable.name.contains("Arc")
        && !activeVariable.name.contains("CurvedLine")
    ) {
      activeVariable.fillColor(
        this.activePalette[
          (int) random(0, this.activePalette.length)
        ]
      );
    }

    if (activeVariable.name.contains("nostroke")) {
      activeVariable.strokeColor(0);
    }
    else if (activeVariable.name.contains("notbackgroundstroke")) {
      activeVariable.strokeColor(getRandomPaletteColorWithExclusion("backgroundColor"));
    }
    else if (activeVariable.name.contains("notaccentastroke")) {
      activeVariable.strokeColor(getRandomPaletteColorWithExclusion("accentA"));
    }
    else if (activeVariable.name.contains("notaccentbstroke")) {
      activeVariable.strokeColor(getRandomPaletteColorWithExclusion("accentB"));
    }
    else if (activeVariable.name.contains("notaccentcstroke")) {
      activeVariable.strokeColor(getRandomPaletteColorWithExclusion("accentC"));
    }
    else if (activeVariable.name.contains("notaccentdstroke")) {
      activeVariable.strokeColor(getRandomPaletteColorWithExclusion("accentD"));
    }
    else if (activeVariable.name.contains("backgroundstroke")) {
      activeVariable.strokeColor(this.backgroundColor);
    }
    else if (activeVariable.name.contains("accentastroke")) {
      activeVariable.strokeColor(this.accentA);
    }
    else if (activeVariable.name.contains("accentbstroke")) {
      activeVariable.strokeColor(this.accentB);
    }
    else if (activeVariable.name.contains("accentcstroke")) {
      activeVariable.strokeColor(this.accentC);
    }
    else if (activeVariable.name.contains("accentdstroke")) {
      activeVariable.strokeColor(this.accentD);
    }
    else {
      activeVariable.strokeColor(
        this.activePalette[
          (int) random(0, this.activePalette.length)
        ]
      );
    }
  }

  public color getRandomPaletteColorWithExclusion(String excludedColor) {
    color[] notBackground = { this.accentA, this.accentB, this.accentC, this.accentD };
    color[] notAccentA = { this.backgroundColor, this.accentB, this.accentC, this.accentD };
    color[] notAccentB = { this.backgroundColor, this.accentC, this.accentD, this.accentA };
    color[] notAccentC = { this.backgroundColor, this.accentD, this.accentA, this.accentB };
    color[] notAccentD = { this.backgroundColor, this.accentA, this.accentB, this.accentC };

    if (excludedColor.equals("backgroundColor")) { return getRandomColor(notBackground); }
    if (excludedColor.equals("accentA")) { return getRandomColor(notAccentA); }
    if (excludedColor.equals("accentB")) { return getRandomColor(notAccentB); }
    if (excludedColor.equals("accentC")) { return getRandomColor(notAccentC); }
    if (excludedColor.equals("accentD")) { return getRandomColor(notAccentD); }

    return this.backgroundColor;
  }

  public void resetFillColor() {
    objects.getActiveVariable().fillColor(0);
  }

  public void resetStrokeColor() {
    objects.getActiveVariable().strokeColor(0);
  }

  float[] DELTA_WEIGHT_SNAP_CONFIGS_KEYS  = { 0.25, 0.50, 1.0, 2.0 };
  float[] DELTA_WEIGHT_SNAP_CONFIGS_MOUSE = { 0.25, 0.50, 1.0, 2.0 };

  private void handleToolWeightInputs() {
    float deltaKeys  = DELTA_WEIGHT_SNAP_CONFIGS_KEYS[this.snapIntensity];
    float deltaMouse = DELTA_WEIGHT_SNAP_CONFIGS_MOUSE[this.snapIntensity];

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

  float[] DELTA_MODIFIER_SNAP_CONFIGS_KEYS = { 1, 5, 50, 200 };

  private void handleToolModifierInputs() {
    float deltaKeys = DELTA_MODIFIER_SNAP_CONFIGS_KEYS[this.snapIntensity];

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

  float[] DELTA_PARAMS_SNAP_CONFIGS_KEYS = { 1, 5, 50, 200 };

  private void handleToolParamsInputs() {
    float deltaKeys = DELTA_PARAMS_SNAP_CONFIGS_KEYS[this.snapIntensity];

    if (input.isPressed(UP)) { this.setSelectedParamIndex(this.selectedParamIndex - 1); }
    if (input.isPressed(DOWN)) { this.setSelectedParamIndex(this.selectedParamIndex + 1); }
    if (input.isPressed(RIGHT)) { this.setParamValue(this.getParamValue() + deltaKeys); }
    if (input.isPressed(LEFT)) { this.setParamValue(this.getParamValue() - deltaKeys); }

    updateEditorVariableMeta();
  }

  int[] DELTA_MOD_DELAY_SNAP_CONFIGS_KEYS  = { 1, 5, 10, 25 };
  int[] DELTA_MOD_DELAY_SNAP_CONFIGS_MOUSE = { 1, 5, 10, 25 };

  private void handleToolModDelayInputs() {
    int deltaKeys  = DELTA_MOD_DELAY_SNAP_CONFIGS_KEYS[this.snapIntensity];
    int deltaMouse = DELTA_MOD_DELAY_SNAP_CONFIGS_MOUSE[this.snapIntensity];

    if (input.isPressed(UP)) { previewEdit("modDelay", deltaKeys); commitEdit("modDelay"); }
    if (input.isPressed(DOWN)) { previewEdit("modDelay", deltaKeys * -1); commitEdit("modDelay"); }

    if (input.isMousePressed()) {
      previewEdit("modDelay", snap(input.getYGridTicks() * -1, deltaMouse));
    }

    if (input.isMouseReleased()) {
      commitEdit("modDelay");
      input.resetTicks();
    }

    if (input.isShiftReleased()) {}

    updateEditorVariableMeta();
  }

  int[] DELTA_ITERATION_COUNT_SNAP_CONFIGS_KEYS  = { 1, 5, 10, 25 };
  int[] DELTA_ITERATION_COUNT_SNAP_CONFIGS_MOUSE = { 1, 5, 10, 25 };

  private void handleToolIterationCountInputs() {
    int deltaKeys = DELTA_ITERATION_COUNT_SNAP_CONFIGS_KEYS[this.snapIntensity];
    int deltaMouse = DELTA_ITERATION_COUNT_SNAP_CONFIGS_MOUSE[this.snapIntensity];

    if (input.isPressed(UP)) { previewEdit("i", deltaKeys); commitEdit("i"); }
    if (input.isPressed(DOWN)) { previewEdit("i", deltaKeys * -1); commitEdit("i"); }

    if (input.isMousePressed()) {
      previewEdit("i", snap(input.getYGridTicks() * -1, deltaMouse));
    }

    if (input.isMouseReleased()) {
      commitEdit("i");
      input.resetTicks();
    }

    if (input.isShiftReleased()) {}

    updateEditorVariableMeta();
  }

  float[] DELTA_ITERATION_SNAP_CONFIGS_KEYS = { 1, 5, 50, 200 };

  private void handleToolIterationInputs() {
    float deltaKeys = DELTA_ITERATION_SNAP_CONFIGS_KEYS[this.snapIntensity];

    if (this.isSelectIterationFuncMode) {
      if (input.isPressed(UP)) { this.setSelectedIterationFuncIndex(this.selectedIterationFuncIndex - 1); }
      if (input.isPressed(DOWN)) { this.setSelectedIterationFuncIndex(this.selectedIterationFuncIndex + 1); }
      if (input.isPressed(ENTER)) { handleIterationFuncSelection(this.selectedIterationFuncIndex); }
    } else {
      if (input.isPressed(UP)) { this.setSelectedIterationFieldIndex(this.selectedIterationFieldIndex - 1); }
      if (input.isPressed(DOWN)) { this.setSelectedIterationFieldIndex(this.selectedIterationFieldIndex + 1); }
      if (input.isPressed(ENTER)) { this.toggleSelectIterationFuncMode(); }
      if (input.isPressed(RIGHT)) { this.setIterationValue(this.getIterationValue() + deltaKeys); }
      if (input.isPressed(LEFT)) { this.setIterationValue(this.getIterationValue() - deltaKeys); }
    }

    updateEditorVariableMeta();
  }

  private void handleCreateModeSelection(int index) {
    this.queuedObjectToCreate = index;
    this.isCreateMode = false;
    objects.useOptions(this.selectableObjects.get(index));
    if (this.modalOptions.size() == 0) {
      this.finalizeCreation();
    } else {
      this.openModal();
    }
  }

  public void handleExternalCreateModeSelection() {
    int index = this.createModeSelectionIndex;
    this.queuedObjectToCreate = index;
    this.isCreateMode = false;
    objects.useOptions(this.selectableObjects.get(index));
    if (this.modalOptions.size() == 0) {
      this.finalizeCreation();
    } else {
      this.openModal();
    }
  }

  public void handleExternalCreateModeSelection(String name) {
    int index = this.createModeSelectionIndex;
    this.queuedObjectToCreate = index;
    this.isCreateMode = false;
    objects.useOptions(this.selectableObjects.get(index));
    if (this.modalOptions.size() == 0) {
      this.finalizeCreation(name);
    } else {
      this.openModal();
    }
  }

  private void finalizeCreation() {
    if (this.queuedObjectToCreate < this.selectableObjects.size()) {
      String className = this.selectableObjects.get(this.queuedObjectToCreate);
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

  private void finalizeCreation(String name) {
    if (this.queuedObjectToCreate < this.selectableObjects.size()) {
      String className = this.selectableObjects.get(this.queuedObjectToCreate);
      objects.add(name, className);
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

  private void cancelCreation() {
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

  private void handleModifierTypeSelection(int index) {
    if (index < MODIFIER_TYPES.length) {
      setModifierType(this.availableModifierTypes.get(selectedModifierTypeIndex));
      updateEditorVariableMeta();
      this.toggleSelectModifierTypeMode();
    }
  }

  private void handleIterationFuncSelection(int index) {
    if (index < ITERATION_FUNCS.length) {
      setIterationFunc(this.availableIterationFuncs.get(selectedIterationFuncIndex));
      updateEditorVariableMeta();
      this.toggleSelectIterationFuncMode();
    }
  }

  private void toggleEditMode() {
    if (objects.activeObjects.size() > 0 && !this.isCreateMode) {
      this.isEditMode = !this.isEditMode;
      if (this.isEditMode) {
        framerate.show();
        editorToolbar.show();
        editorToggleSnappingButton.show();
        editorObjectsList.show();
        editorObjectButtons.show();
        updateEditorVariableMeta();
        editorVariableMeta.show();
        editorHelp.show();
        this.switchTool(this.activeTool);
      } else {
        framerate.hide();
        editorToolbar.hide();
        editorColorButtons.hide();
        editorToggleSnappingButton.hide();
        editorObjectsList.hide();
        editorObjectButtons.hide();
        editorVariableMeta.hide();
        editorHelp.hide();
        editorSelectModifier.hide();
        editorSelectIteration.hide();
        editorModifiers.hide();
        editorIterations.hide();
        editorVariations.hide();
        editorParams.hide();
      }
    }
  }

  private void toggleSnapIntensity() {
    this.snapIntensity = (this.snapIntensity + 1) % 4;
    if (this.snapIntensity == 0) {
      editorToggleSnappingButton.setLabel("[q] toggle snap intensity - disabled");
    }
    else if (this.snapIntensity == 1) {
      editorToggleSnappingButton.setLabel("[q] toggle snap intensity - low");
    }
    else if (this.snapIntensity == 2) {
      editorToggleSnappingButton.setLabel("[q] toggle snap intensity - medium");
    }
    else if (this.snapIntensity == 3) {
      editorToggleSnappingButton.setLabel("[q] toggle snap intensity - high");
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
      editorSelectIteration.hide();
      editorCreateObject.hide();
      editorToolbar.hide();
      editorColorButtons.hide();
      editorToggleSnappingButton.hide();
      editorObjectsList.hide();
      editorObjectButtons.hide();
      editorVariableMeta.hide();
      editorHelp.hide();
      editorModifiers.hide();
      editorIterations.hide();
      editorVariations.hide();
      editorParams.hide();
    } else {
      editorSelectModifier.hide();
      editorCreateObject.hide();
      editorToolbar.show();
      if (this.activeTool == TOOL_MODIFIER) {
        editorModifiers.show();
      }
      if (this.activeTool == TOOL_ITERATION) {
        editorIterations.show();
      }
      if (this.activeTool == TOOL_VARIATION) {
        editorVariations.show();
      }
      if (this.activeTool == TOOL_PARAMS) {
        editorParams.show();
      }
      editorToggleSnappingButton.show();
      editorObjectsList.show();
      editorObjectButtons.show();
      editorVariableMeta.show();
      editorHelp.show();
    }
  }

  public void toggleSelectIterationFuncMode() {
    this.isSelectIterationFuncMode = !this.isSelectIterationFuncMode;
    if (this.isSelectIterationFuncMode) {
      editorSelectModifier.hide();
      editorSelectIteration.show();
      editorCreateObject.hide();
      editorToolbar.hide();
      editorColorButtons.hide();
      editorToggleSnappingButton.hide();
      editorObjectsList.hide();
      editorObjectButtons.hide();
      editorVariableMeta.hide();
      editorHelp.hide();
      editorModifiers.hide();
      editorIterations.hide();
      editorVariations.hide();
      editorParams.hide();
    } else {
      editorSelectIteration.hide();
      editorCreateObject.hide();
      editorToolbar.show();
      if (this.activeTool == TOOL_MODIFIER) {
        editorModifiers.show();
      }
      if (this.activeTool == TOOL_ITERATION) {
        editorIterations.show();
      }
      if (this.activeTool == TOOL_VARIATION) {
        editorVariations.show();
      }
      if (this.activeTool == TOOL_PARAMS) {
        editorParams.show();
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
      beginCamera();
      camera();
      this.draw();
      cp5.draw();
      endCamera();
    }
  }

  public void drawToolMeta(OavpVariable activeVariable, int activeTool) {
    if (this.isModalOpen) { return; }

    float toolMetaXPadding = width * 0.025;
    float toolMetaYPadding = height * 0.0075;
    float toolMetaBoxW = width * 1.5;
    float toolMetaBoxH = height * 0.05;
    float toolMetaTextPosition = width * 0.17;
    color toolColor = palette.flat.white;
    boolean drawMouseIndicators = true;

    switch (activeTool) {
      case 0: // MOVE
        toolColor = palette.flat.blue;
        visualizers
          .create()
          .center().middle()
          .strokeColor(toolColor)
          .noFillStyle()
          .strokeWeightStyle(0.5)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .draw.positionalLines(width)
          .draw.basicSquare(100)
          .draw.basicCircle(10)
          .done();
        break;

      case 1: // RESIZE
        toolColor = palette.flat.orange;
        visualizers
          .create()
          .center().middle()
          .strokeColor(toolColor)
          .noFillStyle()
          .strokeWeightStyle(0.5)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .draw.basicRectangle(activeVariable.s, activeVariable.s, 50)
          .draw.basicSquare(25)
          .draw.basicCircle(5)
          .done();
        break;

      case 2: // TRANSFORM
        toolColor = palette.flat.yellow;
        visualizers
          .create()
          .center().middle()
          .strokeColor(toolColor)
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
        toolColor = palette.flat.green;
        visualizers
          .create()
          .center().middle()
          .strokeColor(toolColor)
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
        drawMouseIndicators = false;

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
        toolColor = palette.flat.darkPrimary;
        visualizers
          .create()
          .center().middle()
          .strokeColor(toolColor)
          .noFillStyle()
          .strokeWeightStyle(activeVariable.strokeWeight)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .draw.basicRectangle(50, 10)
          .done();
        break;

      case 6: // MODIFIER
        drawMouseIndicators = false;

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
        drawMouseIndicators = false;

        visualizers
          .create()
          .center().middle()
          .strokeColor(palette.flat.red)
          .noFillStyle()
          .strokeWeightStyle(0.5)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .draw.positionalLines(width)
          .done();
        break;

      case 8: // PARAMS
        drawMouseIndicators = false;

        for (int i = 0; i < PARAM_FIELDS.length; i++) {
          boolean isWithinSelectionArea = (this.selectedParamIndex == i);
          if (isWithinSelectionArea && cp5.getGroup("editorParams").isOpen()) {
            visualizers
              .create()
              .move(22, 130)
              .moveDown(10 * (i - 1) + 5 * i)
              .strokeColor(palette.flat.darkRed)
              .draw.basicRectangle(255, 10, 0, CORNER)
              .done();
          }
        }

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

      case 9: // MOD_DELAY
        toolColor = palette.flat.darkGreen;
        visualizers
          .create()
          .center().middle()
          .strokeColor(toolColor)
          .noFillStyle()
          .strokeWeightStyle(0.5)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .draw.basicRectangle(activeVariable.modDelay, activeVariable.modDelay, 50)
          .draw.basicSquare(25)
          .draw.basicCircle(5)
          .done();
        break;

      case 10: // ITERATION
        drawMouseIndicators = false;

        if (this.isSelectIterationFuncMode) {
          palette.reset(palette.flat.black, palette.flat.white, 2);

          for (int i = 0; i < ITERATION_FUNCS.length; i++) {
            boolean isWithinSelectionArea = (this.selectedIterationFuncIndex == i);
            if (isWithinSelectionArea) {
              visualizers
                .create()
                .move(width / 4, height / 4)
                .moveDown(20 * i)
                .strokeColor(palette.flat.darkBlue)
                .draw.basicRectangle(width / 2, 20, 0, CORNER)
                .done();
            }
          }
        } else {
          for (int i = 0; i < ITERATION_FIELDS.length; i++) {
            boolean isWithinSelectionArea = (this.selectedIterationFieldIndex == i);
            if (isWithinSelectionArea && cp5.getGroup("editorIterations").isOpen()) {
              visualizers
                .create()
                .move(22, 130)
                .moveDown(10 * (i - 1) + 5 * i)
                .strokeColor(palette.flat.darkBlue)
                .draw.basicRectangle(255, 10, 0, CORNER)
                .done();
            }
          }
          visualizers
            .create()
            .center().middle()
            .strokeColor(palette.flat.darkBlue)
            .noFillStyle()
            .strokeWeightStyle(0.5)
            .move(activeVariable.x, activeVariable.y, activeVariable.z)
            .draw.basicCircle(5)
            .draw.positionalLines(width)
            .done();
        }
        break;

      case 11: // ITERATION_COUNT
        toolColor = palette.flat.darkSecondary;
        visualizers
          .create()
          .center().middle()
          .strokeColor(toolColor)
          .noFillStyle()
          .strokeWeightStyle(0.5)
          .move(activeVariable.x, activeVariable.y, activeVariable.z)
          .draw.basicRectangle(activeVariable.i, activeVariable.i, 50)
          .draw.basicSquare(25)
          .draw.basicCircle(5)
          .done();
        break;
    }

    if (drawMouseIndicators && input.isMousePressed()) {
      if (input.isHoldingShift) {
        visualizers
          .create()
          .strokeColor(toolColor)
          .move(mouseX, mouseY)
          .rotateClockwise(45)
          .draw.basicSquare(input.getYGridTicks() * 0.1)
          .done();
      } else {
        visualizers
          .create()
          .strokeColor(toolColor)
          .move(mouseX, mouseY)
          .draw.basicCircle(input.getXGridTicks() * 0.1)
          .draw.basicSquare(input.getYGridTicks() * 0.1)
          .done();
      }
    }
  }

  public void setCreateModeSelectionIndex(int index) {
    this.createModeSelectionIndex = index;
  }

  private String getActiveModifierField() {
    return this.availableModifierFields.get(this.selectedModifierFieldIndex);
  }

  private String getActiveModifierType() {
    return this.availableModifierTypes.get(this.selectedModifierTypeIndex);
  }

  private String getActiveIterationField() {
    return this.availableIterationFields.get(this.selectedIterationFieldIndex);
  }

  private String getActiveIterationFunc() {
    return this.availableIterationFuncs.get(this.selectedIterationFuncIndex);
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

  private float getParamValue() {
    OavpVariable activeVariable = objects.getActiveVariable();
    try {
      String fieldName = PARAM_FIELDS[this.selectedParamIndex];
      Field field = activeVariable.getClass().getDeclaredField(fieldName);
      return (float) field.get(activeVariable);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return 0.0;
  }

  private float setParamValue(float value) {
    OavpVariable activeVariable = objects.getActiveVariable();
    try {
      String fieldName = PARAM_FIELDS[this.selectedParamIndex];
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

  private float getIterationValue() {
    OavpVariable activeVariable = objects.getActiveVariable();
    try {
      String fieldName = this.availableIterationFields.get(this.selectedIterationFieldIndex);
      Field field = activeVariable.getClass().getDeclaredField(fieldName);
      return (float) field.get(activeVariable);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return 0.0;
  }

  private float setIterationValue(float value) {
    OavpVariable activeVariable = objects.getActiveVariable();
    try {
      String fieldName = this.availableIterationFields.get(this.selectedIterationFieldIndex);
      Field field = activeVariable.getClass().getDeclaredField(fieldName);
      field.set(activeVariable, value);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return 0.0;
  }

  private String getIterationFunc() {
    OavpVariable activeVariable = objects.getActiveVariable();
    try {
      String fieldName = this.availableIterationFields.get(this.selectedIterationFieldIndex) + "Func";
      Field field = activeVariable.getClass().getDeclaredField(fieldName);
      return (String) field.get(activeVariable) == "" ? "none" : (String) field.get(activeVariable);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "none";
  }

  private float setIterationFunc(String type) {
    OavpVariable activeVariable = objects.getActiveVariable();
    try {
      String fieldName = this.availableIterationFields.get(this.selectedIterationFieldIndex) + "Func";
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
    if (index >= MODIFIER_FIELDS.length) {
      this.selectedModifierFieldIndex = MODIFIER_FIELDS.length - 1;
    } else if (index < 0) {
      this.selectedModifierFieldIndex = 0;
    } else {
      this.selectedModifierFieldIndex = index;
    }
  }

  public void setSelectedIterationFuncIndex(int index) {
    if (index >= ITERATION_FUNCS.length) {
      this.selectedIterationFuncIndex = ITERATION_FUNCS.length - 1;
    } else if (index < 0) {
      this.selectedIterationFuncIndex = 0;
    } else {
      this.selectedIterationFuncIndex = index;
    }
  }

  public void setSelectedIterationFieldIndex(int index) {
    if (index >= ITERATION_FIELDS.length) {
      this.selectedIterationFieldIndex = ITERATION_FIELDS.length - 1;
    } else if (index < 0) {
      this.selectedIterationFieldIndex = 0;
    } else {
      this.selectedIterationFieldIndex = index;
    }
  }

  public void setSelectedParamIndex(int index) {
    if (index >= PARAM_FIELDS.length) {
      this.selectedParamIndex = PARAM_FIELDS.length - 1;
    } else if (index < 0) {
      this.selectedParamIndex = 0;
    } else {
      this.selectedParamIndex = index;
    }
  }

  public String[] getModalOptions() {
    if (this.modalOptions.size() < 1) {
      return new String[] {};
    }

    String[] options = new String[this.modalOptions.size()];

    List<String> keyList = new ArrayList<String>(this.modalOptions.keySet());

    for (int i = 0; i < keyList.size(); i++) {
      String optionKey = keyList.get(i);
      String[] values = this.modalOptions.get(optionKey);

      String optionType = values[0];
      String optionValue = values[1];

      options[i] = optionKey + "=" + optionType + ":" + optionValue;
    }

    return options;
  }

  public void setModalOption(String optionKey, String optionType, String optionValue) {
    String[] values = new String[] { optionType, optionValue };
    modalOptions.put(optionKey, values);
  }

  public void resetModalOptions() {
    modalOptions.clear();
  }

  public String getModalHeader() {
    return this.modalHeader;
  }

  public void setBackgroundColor(color updatedColor) {
    this.backgroundColor = updatedColor;
  }

  public void setAccentA(color updatedColor) {
    this.accentA = updatedColor;
  }

  public void setAccentB(color updatedColor) {
    this.accentB = updatedColor;
  }

  public void setAccentC(color updatedColor) {
    this.accentC = updatedColor;
  }

  public void setAccentD(color updatedColor) {
    this.accentD = updatedColor;
  }
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
  cp5.get(Textlabel.class, "sVarMeta").setText("s: " + activeVariable.s);
  cp5.get(Textlabel.class, "strokeWeightVarMeta").setText("strokeWeight: " + activeVariable.strokeWeight);
  cp5.get(Textlabel.class, "modDelayVarMeta").setText("modDelay: " + activeVariable.modDelay);
  cp5.get(Textlabel.class, "iVarMeta").setText("i: " + activeVariable.i);

  strokeColorVarMetaButton.setColorForeground(activeVariable.strokeColor);
  fillColorVarMetaButton.setColorForeground(activeVariable.fillColor);
  editorObjectsList.setItems(objects.getObjectsList()).setLabel(activeVariable.name);

  for (String modifierField : MODIFIER_FIELDS) {
    cp5.getController("modifierVal-" + modifierField).setBroadcast(false);
    cp5.getController("modifierVal-" + modifierField).setValue((float) activeVariable.get(modifierField));
    cp5.getController("modifierVal-" + modifierField).setBroadcast(true);
    cp5.getController("modifierButton-" + modifierField).setLabel((String) activeVariable.get(modifierField + "Type"));
  }

  for (String iterationField : ITERATION_FIELDS) {
    cp5.getController("iterationVal-" + iterationField).setBroadcast(false);
    cp5.getController("iterationVal-" + iterationField).setValue((float) activeVariable.get(iterationField));
    cp5.getController("iterationVal-" + iterationField).setBroadcast(true);
    cp5.getController("iterationButton-" + iterationField).setLabel((String) activeVariable.get(iterationField + "Func"));
  }

  for (String paramField : PARAM_FIELDS) {
    cp5.getController("paramVal-" + paramField).setBroadcast(false);
    cp5.getController("paramVal-" + paramField).setValue((float) activeVariable.get(paramField));
    cp5.getController("paramVal-" + paramField).setBroadcast(true);

    cp5.get(Textlabel.class, paramField + "Label").setText(activeVariable.getParamLabel(paramField));
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
  editorToolbar.changeItem(toolbarLabelModifiers, "selected", false);
  editorToolbar.changeItem(toolbarLabelIterations, "selected", false);
  editorToolbar.changeItem(toolbarLabelVariation, "selected", false);
  editorToolbar.changeItem(toolbarLabelParams, "selected", false);
  editorToolbar.changeItem(toolbarLabelModDelay, "selected", false);
  editorToolbar.changeItem(toolbarLabelIterationCount, "selected", false);
  editorColorButtons.hide();
  editorModifiers.hide();
  editorIterations.hide();
  editorVariations.hide();
  editorParams.hide();
}

void controlEvent(ControlEvent theEvent) {
  if (loaded) {
    if (theEvent.isGroup()) {
      // println("event from group " + theEvent.getGroup().getName());
    } else if (theEvent.isController()) {
      if (theEvent.getController().getName().contains("createObject")) {
        if (!editor.isModalOpen) {
          editor.handleCreateModeSelection(int(theEvent.getController().getValue()));
        }
      } else if (theEvent.getController().getName().contains("selectModifier")) {
        if (editor.isSelectModifierTypeMode) {
          println(theEvent.getController().getName() + "--" + int(theEvent.getController().getValue()));
          editor.setSelectedModifierTypeIndex(int(theEvent.getController().getValue()));
          editor.handleModifierTypeSelection(editor.selectedModifierTypeIndex);
        }
        // println("event from selectModifier " + theEvent.getController().getName());
      } else if (theEvent.getController().getName().contains("modifierVal")) {
        float val = theEvent.getController().getValue();
        String prop = theEvent.getController().getName().split("-")[1];
        int index = int(theEvent.getController().getId());
        editor.setSelectedModifierFieldIndex(index);
        objects.getActiveVariable().set(prop, val);
        // println("event from modifierVal " + theEvent.getController().getName());
      } else if (theEvent.getController().getName().contains("selectIteration")) {
        if (editor.isSelectIterationFuncMode) {
          println(theEvent.getController().getName() + "--" + int(theEvent.getController().getValue()));
          editor.setSelectedIterationFuncIndex(int(theEvent.getController().getValue()));
          editor.handleIterationFuncSelection(editor.selectedIterationFuncIndex);
        }
        // println("event from selectIteration " + theEvent.getController().getName());
      } else if (theEvent.getController().getName().contains("iterationVal")) {
        float val = theEvent.getController().getValue();
        String prop = theEvent.getController().getName().split("-")[1];
        int index = int(theEvent.getController().getId());
        editor.setSelectedIterationFieldIndex(index);
        objects.getActiveVariable().set(prop, val);
        // println("event from iterationVal " + theEvent.getController().getName());
      } else if (theEvent.getController().getName().contains("paramVal")) {
        float val = theEvent.getController().getValue();
        String prop = theEvent.getController().getName().split("-")[1];
        int index = int(theEvent.getController().getId());
        editor.setSelectedParamIndex(index);
        objects.getActiveVariable().set(prop, val);
        // println("event from paramVal " + theEvent.getController().getName());
      } else if (theEvent.getController().getName().contains("modifierButton")) {
        int index = int(theEvent.getController().getValue());
        editor.setSelectedModifierFieldIndex(index);
        editor.toggleSelectModifierTypeMode();
        // println("event from modifierButton " + theEvent.getController().getName());
      } else if (theEvent.getController().getName().contains("iterationButton")) {
        int index = int(theEvent.getController().getValue());
        editor.setSelectedIterationFieldIndex(index);
        editor.toggleSelectIterationFuncMode();
        // println("event from iterationButton " + theEvent.getController().getName());
      } else if (theEvent.getController().getName().contains("editorVariationList")) {
        // println("event from editorVariationList " + theEvent.getController().getValue());
        int index = int(theEvent.getController().getValue());
        String val = (String) cp5.get(ScrollableList.class, "editorVariationList").getItem(index).get("name");
        objects.getActiveVariable().set("variation", val);
        updateEditorVariableMeta();
      } else {
        // Do nothing
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
public void editorToggleSnappingButton() { editor.toggleSnapIntensity(); }

public String getNewObjectName(String className, int increment) {
  if (!objects.has(className + "-" + increment)) {
    return className + "-" + increment;
  } else {
    return getNewObjectName(className, increment + 1);
  }
}

public void setHelpText(String text) {
  cp5.get(Textlabel.class, "editorHelpText").setText(text);
}

public Object getModalValue(String name) {
  return editor.getModalValue(name);
}
