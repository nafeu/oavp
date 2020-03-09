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

  public OavpVariable duplicate() {
    println("Duplicating " + this.getActiveVariable().name);
    OavpObject clone = this.getActiveObject().clone();

    objectsStorage.put(this.getActiveVariable().name + "-copy", clone);
    activeObjects.add(clone);
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

  public OavpObject clone() {
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

    clone.getVariable()
      .set("x", this.variable.x)
      .set("xr", this.variable.xr)
      .set("y", this.variable.y)
      .set("yr", this.variable.yr)
      .set("z", this.variable.z)
      .set("zr", this.variable.zr)
      .set("strokeColor", this.variable.strokeColor)
      .set("fillColor", this.variable.fillColor)
      .set("w", this.variable.w)
      .set("h", this.variable.h)
      .set("l", this.variable.l)
      .set("size", this.variable.size);

    for (HashMap.Entry<String, Float> entry : this.variable.customFloatAttrs.entrySet()) {
      clone.getVariable().set(entry.getKey(), entry.getValue());
    }

    for (HashMap.Entry<String, Integer> entry : this.variable.customIntAttrs.entrySet()) {
      clone.getVariable().set(entry.getKey(), entry.getValue());
    }

    for (HashMap.Entry<String, String> entry : this.variable.customStringAttrs.entrySet()) {
      clone.getVariable().set(entry.getKey(), entry.getValue());
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
