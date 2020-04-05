public class OavpObjectManager {
  private HashMap<String, OavpObject> objectsStorage;
  private List<OavpObject> activeObjects;
  private int selectedObjectIndex = 0;
  private int selectionCounter = 0;

  OavpObjectManager() {
    objectsStorage = new HashMap<String, OavpObject>();
    activeObjects = new ArrayList();
    selectedObjectIndex = 0;
  }

  public OavpVariable add(String name, String className) {
    OavpObject object = createObject(className);
    object.setName(name);
    object.setup();
    objectsStorage.put(name, object);
    activeObjects.add(object);
    lastActiveVariable();
    return object.getVariable();
  }

  public OavpVariable add(String className) {
    String name = className + "-" + UUID.randomUUID().toString();
    OavpObject object = createObject(className);
    object.setName(name);
    object.setup();
    objectsStorage.put(name, object);
    activeObjects.add(object);
    lastActiveVariable();
    return object.getVariable();
  }

  public boolean has(String name) {
    return objectsStorage.containsKey(name);
  }

  public OavpObject get(String name) {
    return objectsStorage.get(name);
  }

  public int getCount() {
    return objectsStorage.size();
  }

  public List<String> getObjectsList() {
    List<String> output = new ArrayList<String>();

    for (OavpObject obj : this.activeObjects) {
      output.add(obj.getVariable().name);
    }

    return output;
  }

  public String getCloneName(String originalName) {
    String output;
    Set<String> nameSplit = new HashSet<String>(Arrays.asList(originalName.split("-")));
    Set<String> existingNames = objectsStorage.keySet();

    if (nameSplit.contains("copy")) {
      String lastItem = originalName.split("-")[originalName.split("-").length - 1];
      if (isNumber(lastItem)) {
        output = originalName.substring(0, originalName.length() - lastItem.length()) + str(int(lastItem) + 1);
      } else {
        output = originalName + "-1";
      }
    } else {
      output = originalName + "-copy";
    }

    if (existingNames.contains(output)) {
      return getCloneName(output);
    } else {
      return output;
    }
  }

  public OavpVariable duplicate() {
    String cloneName = getCloneName(this.getActiveVariable().name);
    OavpObject clone = this.getActiveObject().clone(cloneName);

    objectsStorage.put(cloneName, clone);
    activeObjects.add(clone);
    lastActiveVariable();
    return clone.getVariable();
  }

  public void remove() {
    String activeObjectName = this.getActiveVariable().name;

    if (activeObjectName != "background") {
      activeObjects.remove(this.getActiveObject());
      objectsStorage.remove(activeObjectName);
      lastActiveVariable();
    }
  }

  public void update() {
    for (HashMap.Entry<String, OavpObject> entry : objectsStorage.entrySet()) {
      entry.getValue().update();
    }
  }

  public void draw() {
    for (HashMap.Entry<String, OavpObject> entry : objectsStorage.entrySet()) {
      entry.getValue().draw();
    }
  }

  public OavpVariable getActiveVariable() {
    return activeObjects.get(this.selectedObjectIndex).getVariable();
  }

  public OavpObject getActiveObject() {
    return activeObjects.get(this.selectedObjectIndex);
  }

  public void nextActiveVariable() {
    if (this.selectedObjectIndex == this.activeObjects.size() - 1) {
      this.selectedObjectIndex = 0;
    } else {
      this.selectedObjectIndex += 1;
    }
    println("[" + (selectionCounter++) + "] - Selected Variable: " + getActiveVariable().name);
    editorVariableMeta.setLabel(objects.getActiveVariable().name);
    editor.updateOriginalValues();
  }

  public void lastActiveVariable() {
    this.selectedObjectIndex = this.activeObjects.size() - 1;
    println("[" + (selectionCounter++) + "] - Selected Variable: " + getActiveVariable().name);
    editorVariableMeta.setLabel(objects.getActiveVariable().name);
    if (loaded) {
      editor.updateOriginalValues();
    }
  }

  public void prevActiveVariable() {
    if (this.selectedObjectIndex == 0) {
      this.selectedObjectIndex = this.activeObjects.size() - 1;
    } else {
      this.selectedObjectIndex -= 1;
    }
    println("[" + (selectionCounter++) + "] - Selected Variable: " + getActiveVariable().name);
    editorVariableMeta.setLabel(objects.getActiveVariable().name);
    editor.updateOriginalValues();
  }

  public void setActiveVariable(int index) {
    this.selectedObjectIndex = index;
    println("[" + (selectionCounter++) + "] - Selected Variable: " + getActiveVariable().name);
    editorVariableMeta.setLabel(objects.getActiveVariable().name);
    editor.updateOriginalValues();
  }

  public String exportSketchData() {
    Date date = new Date();
    println("--- [ object data : " + date + " ] ---");
    StringBuilder objectData = new StringBuilder();
    for (HashMap.Entry<String, OavpObject> entry : objectsStorage.entrySet()) {
      OavpObject object = entry.getValue();
      String objectKey = entry.getKey();
      String objectClassName = extractOavpClassName(object.getClass().getName());
      OavpVariable variable = entry.getValue().getVariable();

      objectData.append("objects.add(\"" + objectKey + "\", \"" + objectClassName + "\")");

      if (variable.x != 0) { objectData.append(".set(\"x\"," + variable.x + ")"); }
      if (variable.xMod != 0) { objectData.append(".set(\"xMod\"," + variable.xMod + ")"); }
      if (variable.xModType != "") { objectData.append(".set(\"xModType\",\"" + variable.xModType + "\")"); }
      if (variable.xr != 0) { objectData.append(".set(\"xr\"," + variable.xr + ")"); }
      if (variable.xrMod != 0) { objectData.append(".set(\"xrMod\"," + variable.xrMod + ")"); }
      if (variable.xrModType != "") { objectData.append(".set(\"xrModType\",\"" + variable.xrModType + "\")"); }
      if (variable.y != 0) { objectData.append(".set(\"y\"," + variable.y + ")"); }
      if (variable.yMod != 0) { objectData.append(".set(\"yMod\"," + variable.yMod + ")"); }
      if (variable.yModType != "") { objectData.append(".set(\"yModType\",\"" + variable.yModType + "\")"); }
      if (variable.yr != 0) { objectData.append(".set(\"yr\"," + variable.yr + ")"); }
      if (variable.yrMod != 0) { objectData.append(".set(\"yrMod\"," + variable.yrMod + ")"); }
      if (variable.yrModType != "") { objectData.append(".set(\"yrModType\",\"" + variable.yrModType + "\")"); }
      if (variable.z != 0) { objectData.append(".set(\"z\"," + variable.z + ")"); }
      if (variable.zMod != 0) { objectData.append(".set(\"zMod\"," + variable.zMod + ")"); }
      if (variable.zModType != "") { objectData.append(".set(\"zModType\",\"" + variable.zModType + "\")"); }
      if (variable.zr != 0) { objectData.append(".set(\"zr\"," + variable.zr + ")"); }
      if (variable.zrMod != 0) { objectData.append(".set(\"zrMod\"," + variable.zrMod + ")"); }
      if (variable.zrModType != "") { objectData.append(".set(\"zrModType\",\"" + variable.zrModType + "\")"); }
      objectData.append(".set(\"w\"," + variable.w + ")");
      if (variable.wMod != 0) { objectData.append(".set(\"wMod\"," + variable.wMod + ")"); }
      if (variable.wModType != "") { objectData.append(".set(\"wModType\",\"" + variable.wModType + "\")"); }
      objectData.append(".set(\"h\"," + variable.h + ")");
      if (variable.hMod != 0) { objectData.append(".set(\"hMod\"," + variable.hMod + ")"); }
      if (variable.hModType != "") { objectData.append(".set(\"hModType\",\"" + variable.hModType + "\")"); }
      objectData.append(".set(\"l\"," + variable.l + ")");
      if (variable.lMod != 0) { objectData.append(".set(\"lMod\"," + variable.lMod + ")"); }
      if (variable.lModType != "") { objectData.append(".set(\"lModType\",\"" + variable.lModType + "\")"); }
      objectData.append(".set(\"size\"," + variable.size + ")");
      if (variable.sizeMod != 0) { objectData.append(".set(\"sizeMod\"," + variable.sizeMod + ")"); }
      if (variable.sizeModType != "") { objectData.append(".set(\"sizeModType\",\"" + variable.sizeModType + "\")"); }
      objectData.append(".set(\"strokeColor\"," + variable.strokeColor + ")");
      if (variable.strokeColorMod != 0) { objectData.append(".set(\"strokeColorMod\"," + variable.strokeColorMod + ")"); }
      if (variable.strokeColorModType != "") { objectData.append(".set(\"strokeColorModType\",\"" + variable.strokeColorModType + "\")"); }
      objectData.append(".set(\"strokeWeight\"," + variable.strokeWeight + ")");
      if (variable.strokeWeightMod != 0) { objectData.append(".set(\"strokeWeightMod\"," + variable.strokeWeightMod + ")"); }
      if (variable.strokeWeightModType != "") { objectData.append(".set(\"strokeWeightModType\",\"" + variable.strokeWeightModType + "\")"); }
      objectData.append(".set(\"fillColor\"," + variable.fillColor + ")");
      if (variable.fillColorMod != 0) { objectData.append(".set(\"fillColorMod\"," + variable.fillColorMod + ")"); }
      if (variable.fillColorModType != "") { objectData.append(".set(\"fillColorModType\",\"" + variable.fillColorModType + "\")"); }
      if (variable.variation != 0) { objectData.append(".set(\"variation\",\"" + variable.getVariation() + "\")"); }

      for (HashMap.Entry<String, Object> customAttrEntry : variable.customAttrs.entrySet()) {
        if (customAttrEntry.getValue().getClass() == Float.class) {
          objectData.append(".set(\"" + customAttrEntry.getKey() + "\", " + customAttrEntry.getValue() + ")");
        } else if (customAttrEntry.getValue().getClass() == String.class) {
          objectData.append(".set(\"" + customAttrEntry.getKey() + "\", \"" + customAttrEntry.getValue() + "\")");
        } else if (customAttrEntry.getValue().getClass() == Integer.class) {
          objectData.append(".set(\"" + customAttrEntry.getKey() + "\", " + customAttrEntry.getValue() + ")");
        }
      }

      objectData.append(";");
    }
    StringSelection stringSelection = new StringSelection(objectData.toString());
    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
    clipboard.setContents(stringSelection, null);
    return objectData.toString();
  }
}