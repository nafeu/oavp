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

      for (String rawFieldName : MODIFIER_FIELDS) {
        String fieldName = rawFieldName.split("Mod")[0];

        try {
          Field field = variable.getClass().getDeclaredField(fieldName);
          Field fieldMod = variable.getClass().getDeclaredField(fieldName + "Mod");
          Field fieldModType = variable.getClass().getDeclaredField(fieldName + "ModType");

          Object fieldValue = field.get(variable);
          Object fieldModValue = fieldMod.get(variable);
          Object fieldModTypeValue = fieldModType.get(variable);

          objectData.append(".set(\"" + fieldName + "\"," + fieldValue + ")");
          objectData.append(".set(\"" + fieldName + "Mod" + "\"," + fieldModValue + ")");
          objectData.append(".set(\"" + fieldName + "ModType" + "\",\"" + fieldModTypeValue + "\")");
        } catch (Exception e) {
          e.printStackTrace();
        }
      }

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

      objectData.append(";\n");
    }
    StringSelection stringSelection = new StringSelection(objectData.toString());
    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
    clipboard.setContents(stringSelection, null);
    return objectData.toString();
  }
}