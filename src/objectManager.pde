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

  public void useOptions(String className) {
    OavpObject object = createObject(className);
    object.useOptions();
    object = null;
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

    if (
      !activeObjectName.equals("background")
      && !activeObjectName.equals("camera")
    ) {
      println("[" + (selectionCounter++) + "] - Removing variable: " + activeObjectName);
      activeObjects.remove(this.getActiveObject());
      objectsStorage.remove(activeObjectName);
      lastActiveVariable();
    }
  }

  public void removeAll() {
    while (activeObjects.size() > 2 && objectsStorage.size() > 2) {
      String activeObjectName = this.getActiveVariable().name;

      while(activeObjectName.equals("background") || activeObjectName.equals("camera")) {
        nextActiveVariable();
        activeObjectName = this.getActiveVariable().name;
      }
      this.remove();
    }
  }

  public void removeAll(String subString) {
    int MAX_ATTEMPTS = 400;
    int attempts = 0;

    while (activeObjects.size() > 2 && objectsStorage.size() > 2 && attempts < MAX_ATTEMPTS) {
      String activeObjectName = this.getActiveVariable().name;

      while(activeObjectName.equals("background") || activeObjectName.equals("camera")) {
        nextActiveVariable();
        activeObjectName = this.getActiveVariable().name;
        attempts += 1;
      }

      if (activeObjectName.contains(subString)) {
        this.remove();
      }

      attempts += 1;
    }
  }

  public void update() {
    for (HashMap.Entry<String, OavpObject> entry : objectsStorage.entrySet()) {
      entry.getValue().update();
    }
  }

  public void draw() {
    if (!editor.isModalOpen) {
      for (HashMap.Entry<String, OavpObject> entry : objectsStorage.entrySet()) {
        for (int iteration = 0; iteration < entry.getValue().getVariable().i; iteration++) {
          entry.getValue().draw(iteration);
        }
      }
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

  public String exportAllObjectData() {
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
          Field fieldIter = variable.getClass().getDeclaredField(fieldName + "Iter");
          Field fieldIterFunc = variable.getClass().getDeclaredField(fieldName + "IterFunc");

          Object fieldValue = field.get(variable);
          Object fieldModValue = fieldMod.get(variable);
          Object fieldModTypeValue = fieldModType.get(variable);
          Object fieldIterValue = fieldIter.get(variable);
          Object fieldIterFuncValue = fieldIterFunc.get(variable);

          objectData.append(".set(\"" + fieldName + "\"," + fieldValue + ")");
          objectData.append(".set(\"" + fieldName + "Mod" + "\"," + fieldModValue + ")");
          objectData.append(".set(\"" + fieldName + "ModType" + "\",\"" + fieldModTypeValue + "\")");
          objectData.append(".set(\"" + fieldName + "Iter" + "\"," + fieldIterValue + ")");
          objectData.append(".set(\"" + fieldName + "IterFunc" + "\",\"" + fieldIterFuncValue + "\")");
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

      objectData.append(".set(\"modDelay\"," + variable.modDelay + ")");
      objectData.append(".set(\"i\"," + variable.i + ")");

      objectData.append(";\n");
    }
    StringSelection stringSelection = new StringSelection(objectData.toString());
    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
    clipboard.setContents(stringSelection, null);
    return objectData.toString();
  }

  public String exportObjectData() {
    StringBuilder objectData = new StringBuilder();

    OavpObject object = objects.getActiveObject();
    OavpVariable variable = object.getVariable();
    String objectKey = variable.name;
    String objectClassName = extractOavpClassName(object.getClass().getName());

    objectData.append("objects\n.add(\"" + objectKey + "\",\"" + objectClassName + "\")\n");

    for (String rawFieldName : MODIFIER_FIELDS) {
      String fieldName = rawFieldName.split("Mod")[0];

      try {
        Field field = variable.getClass().getDeclaredField(fieldName);
        Field fieldMod = variable.getClass().getDeclaredField(fieldName + "Mod");
        Field fieldModType = variable.getClass().getDeclaredField(fieldName + "ModType");
        Field fieldIter = variable.getClass().getDeclaredField(fieldName + "Iter");
        Field fieldIterFunc = variable.getClass().getDeclaredField(fieldName + "IterFunc");

        Object fieldValue = field.get(variable);
        Object fieldModValue = fieldMod.get(variable);
        Object fieldModTypeValue = fieldModType.get(variable);
        Object fieldIterValue = fieldIter.get(variable);
        Object fieldIterFuncValue = fieldIterFunc.get(variable);

        objectData.append(".set(\"" + fieldName + "\"," + fieldValue + ")\n");
        objectData.append(".set(\"" + fieldName + "Mod" + "\"," + fieldModValue + ")\n");
        objectData.append(".set(\"" + fieldName + "ModType" + "\",\"" + fieldModTypeValue + "\")\n");
        objectData.append(".set(\"" + fieldName + "Iter" + "\"," + fieldIterValue + ")\n");
        objectData.append(".set(\"" + fieldName + "IterFunc" + "\",\"" + fieldIterFuncValue + "\")\n");
      } catch (Exception e) {
        e.printStackTrace();
      }
    }

    if (variable.variation != 0) { objectData.append(".set(\"variation\",\"" + variable.getVariation() + "\")\n"); }

    for (HashMap.Entry<String, Object> customAttrEntry : variable.customAttrs.entrySet()) {
      if (customAttrEntry.getValue().getClass() == Float.class) {
        objectData.append(".set(\"" + customAttrEntry.getKey() + "\"," + customAttrEntry.getValue() + ")\n");
      } else if (customAttrEntry.getValue().getClass() == String.class) {
        objectData.append(".set(\"" + customAttrEntry.getKey() + "\",\"" + customAttrEntry.getValue() + "\")\n");
      } else if (customAttrEntry.getValue().getClass() == Integer.class) {
        objectData.append(".set(\"" + customAttrEntry.getKey() + "\"," + customAttrEntry.getValue() + ")\n");
      }
    }

    objectData.append(".set(\"modDelay\"," + variable.modDelay + ")\n");
    objectData.append(".set(\"i\"," + variable.i + ")");
    objectData.append(";");

    StringSelection stringSelection = new StringSelection(objectData.toString());
    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
    clipboard.setContents(stringSelection, null);

    String[] lines = objectData.toString().split("\n");
    saveStrings(sketchPath("") + "../tools/commander/target.txt", lines);

    return objectData.toString();
  }
}
