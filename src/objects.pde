public class OavpObjectManager {
  private HashMap<String, OavpObject> objectsStorage;

  OavpObjectManager() {
    objectsStorage = new HashMap<String, OavpObject>();
  }

  public OavpObject add(String name, String className) {
    OavpObject object;

    switch (className) {
      case "BasicRectangle":
        object = new OavpObjBasicRectangle();
        break;
      case "BasicSquare":
        object = new OavpObjBasicSquare();
        break;
      default:
        object = new OavpObject();
    }

    object.setup();
    objectsStorage.put(name, object);
    return object;
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
}

public class OavpObject {
  public OavpVariable variable;

  OavpObject() {
    this.variable = new OavpVariable();
  }

  public OavpVariable getVariable() {
    return this.variable;
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
        variable.w + analysis.getLevel() * variable.w,
        variable.h + analysis.getLevel() * variable.h,
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
      .rotate(variable.xr, variable.yr, variable.zr + frameCount(variable.size / 500))
      .draw.basicSquare(variable.size + analysis.getLevel() * variable.size)
      .done();
  }
}