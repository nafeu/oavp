public OavpObject createObject(String className) {
  OavpObject object;

  switch (className) {
    case "BasicRectangle":
      object = new OavpObjBasicRectangle();
      break;
    case "BasicRectangleSpectrum":
      object = new OavpObjBasicRectangleSpectrum();
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

  return object;
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

public class OavpObjBasicRectangleSpectrum extends OavpObject {
  public void setup() {
    variable
      .w(100)
      .h(100);
  }

  public void draw() {
    visualizers
      .create()
      .dimensions(variable.w * 0.9, variable.h * 0.9)
      .center().middle()
      .strokeColor(variable.strokeColor)
      .fillColor(variable.fillColor)
      .move(variable.x, variable.y, variable.z)
      .rotate(variable.xr, variable.yr, variable.zr)
      .draw.basicRectangle(variable.w, variable.h)
      .moveLeft(variable.w * 0.9 / 2)
      .moveUp(variable.h * 0.9 / 2)
      .moveForward(2)
      .draw.basicSpectrumLines()
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
