public class OavpObjectManager {
  private HashMap<String, OavpObject> objectsStorage;
  private List<OavpObject> activeObjects;
  private int selectedObjectIndex = 0;

  OavpObjectManager() {
    objectsStorage = new HashMap<String, OavpObject>();
    activeObjects = new ArrayList();
    selectedObjectIndex = 0;
  }

  public OavpVariable add(String name, String className) {
    OavpObject object;

    switch (className) {
      case "BasicRectangle":
        object = new OavpObjBasicRectangle();
        break;
      case "BasicSquare":
        object = new OavpObjBasicSquare();
        break;
      case "BasicCircle":
        object = new OavpObjBasicCircle();
        break;
      default:
        object = new OavpObject();
    }

    object.setName(name);
    object.setup();
    objectsStorage.put(name, object);
    activeObjects.add(object);
    return object.getVariable();
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
  }

  public void lastActiveVariable() {
    this.selectedObjectIndex = this.activeObjects.size() - 1;
  }

  public void prevActiveVariable() {
    if (this.selectedObjectIndex == 0) {
      this.selectedObjectIndex = this.activeObjects.size() - 1;
    } else {
      this.selectedObjectIndex -= 1;
    }
  }
}

public class OavpObject {
  public OavpVariable variable;

  OavpObject() {
    this.variable = new OavpVariable();
  }

  public OavpVariable getVariable() {
    return this.variable;
  }

  public void setName(String name) {
    this.variable.name = name;
  }

  public OavpObject clone(String name) {
    OavpObject clone;

    String rawClassName = this.getClass().getName();
    String className = rawClassName.split("OavpObj")[1];

    switch (className) {
      case "BasicRectangle":
        clone = new OavpObjBasicRectangle();
        break;
      case "BasicSquare":
        clone = new OavpObjBasicSquare();
        break;
      case "BasicCircle":
        clone = new OavpObjBasicCircle();
        break;
      default:
        clone = new OavpObject();
    }

    OavpVariable cloneVariable = clone.getVariable();

    cloneVariable.name = name;
    cloneVariable.x = this.variable.x;
    cloneVariable.xOrig = this.variable.xOrig;
    cloneVariable.xr = this.variable.xr;
    cloneVariable.xrOrig = this.variable.xrOrig;
    cloneVariable.y = this.variable.y;
    cloneVariable.yOrig = this.variable.yOrig;
    cloneVariable.yr = this.variable.yr;
    cloneVariable.yrOrig = this.variable.yrOrig;
    cloneVariable.z = this.variable.z;
    cloneVariable.zOrig = this.variable.zOrig;
    cloneVariable.zr = this.variable.zr;
    cloneVariable.zrOrig = this.variable.zrOrig;
    cloneVariable.w = this.variable.w;
    cloneVariable.wOrig = this.variable.wOrig;
    cloneVariable.h = this.variable.h;
    cloneVariable.hOrig = this.variable.hOrig;
    cloneVariable.l = this.variable.l;
    cloneVariable.lOrig = this.variable.lOrig;
    cloneVariable.size = this.variable.size;
    cloneVariable.sizeOrig = this.variable.sizeOrig;
    cloneVariable.strokeColor = this.variable.strokeColor;
    cloneVariable.fillColor = this.variable.fillColor;

    for (HashMap.Entry<String, Float> entry : this.variable.customFloatAttrs.entrySet()) {
      cloneVariable.set(entry.getKey(), entry.getValue());
    }

    for (HashMap.Entry<String, Integer> entry : this.variable.customIntAttrs.entrySet()) {
      cloneVariable.set(entry.getKey(), entry.getValue());
    }

    for (HashMap.Entry<String, String> entry : this.variable.customStringAttrs.entrySet()) {
      cloneVariable.set(entry.getKey(), entry.getValue());
    }

    return clone;
  }

  public void setup() {}
  public void draw() {}
  public void update() {}
}

public class OavpObjBasicRectangle extends OavpObject {
  public void setup() {
    variable
      .w(200)
      .h(50)
      .size(0);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .strokeColor(variable.strokeColor)
      .move(variable.x, variable.y, variable.z)
      .rotate(variable.xr, variable.yr, variable.zr)
      .draw.basicRectangle(
        variable.w,
        variable.h,
        variable.size)
      .done();
  }
}

public class OavpObjBasicSquare extends OavpObject {
  public void setup() {
    variable
      .size(100);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .strokeColor(variable.strokeColor)
      .move(variable.x, variable.y, variable.z)
      .rotate(variable.xr, variable.yr, variable.zr)
      .draw.basicSquare(variable.size)
      .done();
  }
}

public class OavpObjBasicCircle extends OavpObject {
  public void setup() {
    variable
      .size(100);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .strokeColor(variable.strokeColor)
      .move(variable.x, variable.y, variable.z)
      .rotate(variable.xr, variable.yr, variable.zr)
      .draw.basicCircle(variable.size)
      .done();
  }
}
