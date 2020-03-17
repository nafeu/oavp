String[] OBJECT_LIST = {
  "BasicRectangle",
  "BasicRectangleSpectrum",
  "BasicCircle",
  "GhostSplash",
  "SpectrumMesh",
  "ZRectangles"
};

public OavpObject createObject(String className) {
  OavpObject object;

  switch (className) {
    case "BasicRectangle":
      object = new OavpObjBasicRectangle();
      break;
    case "BasicRectangleSpectrum":
      object = new OavpObjBasicRectangleSpectrum();
      break;
    case "BasicCircle":
      object = new OavpObjBasicCircle();
      break;
    case "Svg":
      object = new OavpObjSvg();
      break;
    case "GhostSplash":
      object = new OavpObjGhostSplash();
      break;
    case "SpectrumMesh":
      object = new OavpObjSpectrumMesh();
      break;
    case "ZRectangles":
      object = new OavpObjZRectangles();
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
      .strokeColor(palette.flat.white)
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
      .h(100)
      .strokeColor(palette.flat.white);
  }

  public void draw() {
    visualizers
      .startStyle()
      .create()
      .center().middle()
      .strokeColor(variable.strokeColor)
      .fillColor(variable.fillColor)
      .move(variable.x, variable.y, variable.z)
      .rotate(variable.xr, variable.yr, variable.zr);

    if (variable.options.contains("outline")) {
      visualizers
        .dimensions(variable.w * 0.9, variable.h * 0.9)
        .draw.basicRectangle(variable.w, variable.h)
        .moveLeft(variable.w * 0.9 / 2)
        .moveUp(variable.h * 0.9 / 2)
        .moveForward(2)
        .draw.basicSpectrumLines()
        .done();
    } else {
      visualizers
        .dimensions(variable.w, variable.h)
        .moveLeft(variable.w / 2)
        .moveUp(variable.h / 2)
        .draw.basicSpectrumLines()
        .done();
    }
  }
}

public class OavpObjBasicCircle extends OavpObject {
  public void setup() {
    variable
      .size(100)
      .strokeColor(palette.flat.white);
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

public class OavpObjSvg extends OavpObject {
  public void setup() {
    variable
      .size(100)
      .set("svgName", variable.name);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .strokeColor(variable.strokeColor)
      .fillColor(variable.fillColor)
      .move(variable.x, variable.y, variable.z)
      .rotate(variable.xr, variable.yr, variable.zr)
      .draw.centeredSvg(variable.customStringAttrs.get("svgName"), variable.size / 100)
      .done();
  }
}

public class OavpObjGhostSplash extends OavpObject {
  public void setup() {
    variable
      .size(100)
      .set("varName", variable.name)
      .strokeColor(palette.flat.white);
    entities.addPulser(variable.customStringAttrs.get("varName"));
    entities.addEmissions(variable.customStringAttrs.get("varName"));
    entities.addInterval(variable.customStringAttrs.get("varName"), 10, 1);
  }

  public void update() {
    entities.getPulser(variable.customStringAttrs.get("varName"))
      .pulseIf(analysis.isBeatOnset());
    emitters.useEmissions(variable.customStringAttrs.get("varName"))
      .emitIf(analysis.isBeatOnset());
    entities.getInterval(variable.customStringAttrs.get("varName"))
      .update(entities.getPulser(variable.customStringAttrs.get("varName")).getValue());
  }

  public void draw() {
    visualizers
      .useInterval(variable.customStringAttrs.get("varName"))
      .create()
      .center().middle()
      .strokeColor(variable.strokeColor)
      .fillColor(variable.fillColor)
      .move(variable.x, variable.y, variable.z)
      .rotate(variable.xr, variable.yr, variable.zr)
      .draw.intervalGhostCircle(0, variable.size * 2, 10)
      .done();

    visualizers
      .create()
      .center().middle()
      .strokeColor(variable.strokeColor)
      .fillColor(variable.fillColor)
      .move(variable.x, variable.y, variable.z)
      .rotate(variable.xr, variable.yr, variable.zr)
      .rotate(frameCount, frameCount)
      .draw.basicLevelCube(variable.size * 4)
      .next()
      .center().middle()
      .strokeColor(variable.strokeColor)
      .fillColor(variable.fillColor)
      .move(variable.x, variable.y, variable.z)
      .rotate(variable.xr, variable.yr, variable.zr)
      .rotate(frameCount(-0.25), frameCount(-0.25))
      .draw.basicLevelCube(variable.size * 2)
      .done();

    visualizers
      .useEmissions(variable.customStringAttrs.get("varName"))
      .create()
      .center().middle()
      .strokeColor(variable.strokeColor)
      .fillColor(variable.fillColor)
      .move(variable.x, variable.y, variable.z)
      .rotate(variable.xr, variable.yr, variable.zr)
      .rotate(0, 0, frameCount(0.25))
      .draw.emissionSplashSquare(variable.size * 2)
      .done();
  }
}

public class OavpObjSpectrumMesh extends OavpObject {
  public void setup() {
    variable
      .size(100)
      .strokeColor(palette.flat.white);
    entities.addInterval(variable.name, 30, analysis.getAvgSize());
  }

  public void update() {
    entities.getInterval(variable.name).update(analysis.getSpectrum());
  }

  public void draw() {
    visualizers
      .useInterval(variable.name)
      .create()
      .center().middle()
      .strokeColor(variable.strokeColor)
      .fillColor(variable.fillColor)
      .move(variable.x, variable.y, variable.z)
      .rotate(variable.xr, variable.yr, variable.zr)
      .dimensions(variable.w, variable.h)
      .moveLeft(variable.w / 2)
      .moveUp(variable.h / 2)
      .draw.intervalSpectrumMesh(variable.size, 2)
      .done();
  }
}

public class OavpObjZRectangles extends OavpObject {
  public void setup() {
    variable
      .size(100)
      .set("count", 3)
      .set("gap", 0.10)
      .set("radius", 50)
      .strokeColor(palette.flat.white);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .strokeColor(variable.strokeColor)
      .fillColor(variable.fillColor)
      .strokeWeightStyle(variable.strokeWeight)
      .move(variable.x, variable.y, variable.z)
      .rotate(variable.xr, variable.yr, variable.zr)
      .dimensions(variable.w, variable.h);

    int count = variable.customIntAttrs.get("count");
    float gap = variable.customFloatAttrs.get("gap");

    for (int i = 0; i < count; i++) {
      if (variable.options.contains("radial")) {
        int radius = variable.customIntAttrs.get("radius");
        visualizers
          .draw.basicZRectangle(
            variable.w * (1.00 - (gap * i)),
            variable.h * (1.00 - (gap * i)),
            oscillate(-variable.size, variable.size, 0.015 - (0.001 * i)),
            radius
          );
      } else {
        visualizers
          .draw.basicZRectangle(
            variable.w * (1.00 - (gap * i)),
            variable.h * (1.00 - (gap * i)),
            oscillate(-variable.size, variable.size, 0.015 - (0.001 * i))
          );
      }
    }

    visualizers.done();
  }
}