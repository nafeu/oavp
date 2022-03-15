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
Group editorParams;
Group editorHelp;
Textlabel editorHelpText;
Bang strokeColorVarMetaButton;
Bang fillColorVarMetaButton;
Textlabel framerate;
ControlFont cfModal;

String toolbarLabelMove = "[m] move";
String toolbarLabelResize = "[s] resize";
String toolbarLabelTransform = "[t] transform";
String toolbarLabelRotate = "[r] rotate";
String toolbarLabelColor = "[c] color";
String toolbarLabelWeight = "[b] weight";
String toolbarLabelModifier = "[z] modifiers";
String toolbarLabelVariation = "[v] variation";
String toolbarLabelParams = "[p] params";
String toolbarLabelModDelay = "[o] mod delay";

color COLOR_WHITE = color(255, 255, 255);
color COLOR_BLACK = color(0, 0, 0);
color COLOR_BLUE = color(41, 128, 185);
color COLOR_MIDNIGHT = color(44, 62, 80);
color COLOR_GRAY = color(52, 73, 94);
color COLOR_RED = color(192, 57, 43);
color COLOR_YELLOW = color(241, 196, 15);
color COLOR_GREEN = color(39, 174, 96);

public void setupEditorGui() {
  framerate = cp5.addFrameRate().setInterval(10).setPosition(width - 20, height - 15).hide();

  cfModal = new ControlFont(createFont("Arial", 20));

  editorToolbar = cp5.addButtonBar("editorToolbar")
     .setColorBackground(COLOR_BLACK)
     .setPosition(10, 10)
     .setSize(550, 10)
     .addItems(new String[] {
       toolbarLabelMove,
       toolbarLabelResize,
       toolbarLabelTransform,
       toolbarLabelRotate,
       toolbarLabelColor,
       toolbarLabelWeight,
       toolbarLabelModifier,
       toolbarLabelVariation,
       toolbarLabelParams,
       toolbarLabelModDelay
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

  editorParams = cp5.addGroup("editorParams")
    .setLabel("additional parameters")
    .setColorBackground(COLOR_BLACK)
    .setPosition(10, 110)
    .setSize(300, 370)
    .setBackgroundColor(COLOR_BLACK)
    .hide()
    ;

  for (int i = 0; i < PARAM_FIELDS.length; i++) {
    cp5.addTextlabel(PARAM_FIELDS[i] + "Label")
      .setText(PARAM_FIELDS[i])
      .setPosition(10 * 1, 10 * (i + 1) + 5 * i)
      .setColorValue(COLOR_WHITE)
      .setGroup("editorParams");

    cp5.addNumberbox("paramVal-" + PARAM_FIELDS[i])
      .setColorBackground(COLOR_BLACK)
      .setPosition(10 * 10, (10 * (i + 1) + 5 * i))
      .setLabel("")
      .setSize(50, 10)
      .setMultiplier(-5)
      .setSensitivity(100)
      .setValue(0)
      .setId(i)
      .setGroup("editorParams");
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

  cp5.addTextlabel("editorHelpText").setPosition(10, 10).setColorValue(COLOR_WHITE).setGroup("editorHelp");

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
  cp5.addTextlabel("modDelayVarMeta").setText("modDelay: ").setPosition(10 * 16, 40).setColorValue(COLOR_WHITE).setGroup("editorVariableMeta");

  strokeColorVarMetaButton = cp5.addBang("strokeColorButtonVarMeta").setPosition(10 * 16 + 60, 20 + 2).setSize(25, 10 - 4).setLabel("").setColorForeground(COLOR_BLACK).setGroup("editorVariableMeta");
  fillColorVarMetaButton = cp5.addBang("fillColorButtonVarMeta").setPosition(10 * 16 + 60, 30 + 2).setSize(25, 10 - 4).setLabel("").setColorForeground(COLOR_BLACK).setGroup("editorVariableMeta");
}

String[] activeModalOptions;

public void openModalGui() {
  activeModalOptions = editor.getModalOptions();
  String header = editor.getModalHeader();

  if (cp5.getGroup("editorModalBackground") != null) { cp5.getGroup("editorModalBackground").remove(); }
  if (cp5.getGroup("editorModalOptions") != null) { cp5.getGroup("editorModalOptions").remove(); }

  cp5.addGroup("editorModalBackground")
    .hideBar()
    .setColorBackground(COLOR_MIDNIGHT)
    .setBackgroundColor(COLOR_MIDNIGHT)
    .setPosition(0, 0)
    .setSize(width, height);

  cp5.addGroup("editorModalOptions")
    .hideBar()
    .setColorBackground(COLOR_GRAY)
    .setBackgroundColor(COLOR_GRAY)
    .setPosition(width / 4, height / 4)
    .setSize(width / 2, height / 2);

    cp5.addTextlabel("editorModalOptionHeader")
      .setPosition(10, 10)
      .setSize(80, 20)
      .setFont(cfModal)
      .setText(header)
      .setGroup("editorModalOptions");

    for (int i = 0; i < activeModalOptions.length; i++) {
      String option = activeModalOptions[i].split("=")[1].split(":")[0];
      String optionName = activeModalOptions[i].split("=")[0];

      cp5.addTextlabel("editorModalOption" + i)
        .setPosition(10, 20 + 30 + (35 * i))
        .setSize(width / 4, 30)
        .setText(optionName)
        .setFont(cfModal)
        .setGroup("editorModalOptions");

      if (option.contains("select")) {
        String[] items = activeModalOptions[i].split(":")[1].split(",");
        cp5.addScrollableList("editorModalValue" + i).setType(ControlP5.DROPDOWN)
          .setColorBackground(COLOR_BLACK)
          .setPosition(width / 4, 20 + 30 + (35 * i))
          .close()
          .setLabel(optionName)
          .setId(i)
          .setBarHeight(30)
          .setWidth((width / 4) - 10)
          .setItemHeight(30)
          .addItems(items)
          .addCallback(new CallbackListener() { public void controlEvent(CallbackEvent theEvent) {
            if (theEvent.getAction() == ControlP5.ACTION_CLICK) {
              ScrollableList component = cp5.get(ScrollableList.class, theEvent.getController().getName());
              component.bringToFront();
              String optionName = activeModalOptions[component.getId()].split("=")[0];
              editor.setModalValue(optionName, component.getItem(int(component.getValue())).get("name"));
            }
          }})
          .setGroup("editorModalOptions");
        editor.setModalValue(optionName, items[0]);
      } else if (option.contains("input")) {
        cp5.addTextfield("editorModalValue" + i)
          .setColorBackground(COLOR_BLACK)
          .setPosition(width / 4, 20 + 30 + (35 * i))
          .setId(i)
          .setLabel("")
          .setSize((width / 4) - 10, 30)
          .addCallback(new CallbackListener() { public void controlEvent(CallbackEvent theEvent) {
            if (theEvent.getAction() == ControlP5.ACTION_CLICK || theEvent.getAction() == ControlP5.ACTION_ENTER || theEvent.getAction() == ControlP5.ACTION_EXIT) {
              Textfield component = cp5.get(Textfield.class, theEvent.getController().getName());
              String optionName = activeModalOptions[component.getId()].split("=")[0];
              editor.setModalValue(optionName, component.getText());
            }
          }})
          .setGroup("editorModalOptions");
        editor.setModalValue(optionName, "");
      } else if (option.contains("slider")) {
        cp5.addSlider("editorModalValue" + i)
          .setColorBackground(COLOR_BLACK)
          .setPosition(width / 4, 20 + 30 + (35 * i))
          .setId(i)
          .setLabel("")
          .setSize((width / 4) - 10, 30)
          .setRange(1, 10)
          .setValue(1.0)
          .setNumberOfTickMarks(10)
          .setSliderMode(Slider.FLEXIBLE)
          .addCallback(new CallbackListener() { public void controlEvent(CallbackEvent theEvent) {
            if (theEvent.getAction() == ControlP5.ACTION_RELEASE_OUTSIDE || theEvent.getAction() == ControlP5.ACTION_RELEASE) {
              Slider component = cp5.get(Slider.class, theEvent.getController().getName());
              String optionName = activeModalOptions[component.getId()].split("=")[0];
              editor.setModalValue(optionName, component.getValue());
            }
          }})
          .setGroup("editorModalOptions");
        editor.setModalValue(optionName, 1.0);
      } else {
        cp5.addNumberbox("editorModalValue" + i)
          .setColorBackground(COLOR_BLACK)
          .setPosition(width / 4, 20 + 30 + (35 * i))
          .setId(i)
          .setLabel("")
          .setSize((width / 4) - 10, 30)
          .setMultiplier(-5)
          .setSensitivity(100)
          .setValue(10.0)
          .addCallback(new CallbackListener() { public void controlEvent(CallbackEvent theEvent) {
            if (theEvent.getAction() == ControlP5.ACTION_RELEASE_OUTSIDE || theEvent.getAction() == ControlP5.ACTION_RELEASE) {
              Numberbox component = cp5.get(Numberbox.class, theEvent.getController().getName());
              String optionName = activeModalOptions[component.getId()].split("=")[0];
              editor.setModalValue(optionName, component.getValue());
            }
          }})
          .setGroup("editorModalOptions");
        editor.setModalValue(optionName, 10.0);
      }
    }

    cp5.addButton("editorModalOptionConfirm")
      .setColorBackground(COLOR_BLACK)
      .setPosition(((width / 4) - ((80 + 10 + 80) / 2)), height / 2 - 30)
      .setSize(80, 20)
      .setLabel("confirm")
      .addCallback(new CallbackListener() { public void controlEvent(CallbackEvent theEvent) {
        if (theEvent.getAction() == ControlP5.ACTION_CLICK) {
          editor.confirmModal();
        }
      }})
      .setGroup("editorModalOptions");

    cp5.addButton("editorModalOptionCancel")
      .setColorBackground(COLOR_BLACK)
      .setPosition(((width / 4) - ((80 + 10 + 80) / 2)) + 80 + 10, height / 2 - 30)
      .setSize(80, 20)
      .setLabel("cancel")
      .addCallback(new CallbackListener() { public void controlEvent(CallbackEvent theEvent) {
        if (theEvent.getAction() == ControlP5.ACTION_CLICK) {
          editor.cancelModal();
        }
      }})
      .setGroup("editorModalOptions");
}

public void closeModalGui() {
  if (cp5.getGroup("editorModalBackground") != null) { cp5.getGroup("editorModalBackground").hide(); }
  if (cp5.getGroup("editorModalOptions") != null) { cp5.getGroup("editorModalOptions").hide(); }
}