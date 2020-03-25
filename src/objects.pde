String[] OBJECT_LIST = {
  "Rectangle",
  "Spectrum",
  "Circle",
  "Triangle",
  "Box",
  "Bullseye",
  "Splash",
  "SpectrumMesh",
  "ZRectangles"
};

public OavpObject createObject(String className) {
  OavpObject object;

  switch (className) {
    case "Rectangle":
      object = new OavpObjRectangle();
      break;
    case "Spectrum":
      object = new OavpObjSpectrum();
      break;
    case "Circle":
      object = new OavpObjCircle();
      break;
    case "Triangle":
      object = new OavpObjTriangle();
      break;
    case "Box":
      object = new OavpObjBox();
      break;
    case "Bullseye":
      object = new OavpObjBullseye();
      break;
    case "Splash":
      object = new OavpObjSplash();
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

public class OavpObjRectangle extends OavpObject {
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
      .use(variable)
      .draw.basicRectangle(variable.w(), variable.h(), variable.size())
      .done();
  }
}

public class OavpObjTriangle extends OavpObject {
  public void setup() {
    variable
      .size(100)
      .strokeColor(palette.flat.white);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .use(variable)
      .draw.basicTriangle(variable.size())
      .done();
  }
}

public class OavpObjSpectrum extends OavpObject {
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
      .use(variable)
      .moveLeft(variable.w() / 2)
      .moveUp(variable.h() / 2)
      .draw.basicSpectrumLines()
      .done();
  }
}

public class OavpObjCircle extends OavpObject {
  public void setup() {
    variable
      .size(100)
      .strokeColor(palette.flat.white);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .use(variable)
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
      .use(variable)
      .draw.centeredSvg(variable.customStringAttrs.get("svgName"), variable.size() / 100)
      .done();
  }
}

public class OavpObjBox extends OavpObject {
  public void setup() {
    variable
      .size(100)
      .strokeColor(palette.flat.white);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .use(variable)
      .draw.basicBox(variable.w(), variable.h(), variable.l())
      .done();
  }
}

public class OavpObjBullseye extends OavpObject {
  public void setup() {
    variable
      .variations(
        "rectangular",
        "boxed"
      )
      .size(100)
      .w(100)
      .h(100)
      .l(100)
      .set("varName", variable.name)
      .strokeColor(palette.flat.white);
    entities.addPulser(variable.customStringAttrs.get("varName"));
    entities.addInterval(variable.customStringAttrs.get("varName"), 10, 1);
  }

  public void update() {
    entities.getPulser(variable.customStringAttrs.get("varName"))
      .pulseIf(analysis.isBeatOnset());
    entities.getInterval(variable.customStringAttrs.get("varName"))
      .update(entities.getPulser(variable.customStringAttrs.get("varName")).getValue());
  }

  public void draw() {
    visualizers
      .useInterval(variable.customStringAttrs.get("varName"))
      .create()
      .center().middle()
      .use(variable);

    if (variable.ofVariation("rectangular")) {
      visualizers.draw.intervalBullseyeRectangle(variable.w(), variable.h(), 10);
    } else if (variable.ofVariation("boxed")) {
      visualizers.draw.intervalBullseyeBox(variable.w(), variable.h(), variable.l(), 10);
    } else {
      visualizers.draw.intervalBullseyeCircle(variable.size(), 10);
    }

    visualizers.done();
  }
}

public class OavpObjSplash extends OavpObject {
  public void setup() {
    variable
      .variations(
        "rectangular",
        "boxed"
      )
      .size(100)
      .w(100)
      .h(100)
      .l(100)
      .set("varName", variable.name)
      .strokeColor(palette.flat.white);
    entities.addEmissions(variable.customStringAttrs.get("varName"));
  }

  public void update() {
    emitters.useEmissions(variable.customStringAttrs.get("varName"))
      .emitIf(analysis.isBeatOnset());
  }

  public void draw() {
    visualizers
      .useEmissions(variable.customStringAttrs.get("varName"))
      .create()
      .center().middle()
      .use(variable);

    if (variable.ofVariation("rectangular")) {
      visualizers.draw.emissionSplashRectangle(variable.w(), variable.h());
    } else if (variable.ofVariation("boxed")) {
      visualizers.draw.emissionSplashBox(variable.w(), variable.h(), variable.l());
    } else {
      visualizers.draw.emissionSplashCircle(variable.size());
    }

    visualizers.done();
  }
}

public class OavpObjSpectrumMesh extends OavpObject {
  public void setup() {
    variable
      .variations(
        "dotted",
        "z-lines",
        "x-lines"
      )
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
      .use(variable)
      .moveLeft(variable.w() / 2)
      .moveUp(variable.h() / 2);

    if (variable.ofVariation("dotted")) {
      visualizers.draw.intervalSpectrumPoints(variable.size(), 2);
    } else if (variable.ofVariation("z-lines")) {
      visualizers.draw.intervalSpectrumZLines(variable.size(), 2);
    } else if (variable.ofVariation("x-lines")) {
      visualizers.draw.intervalSpectrumXLines(variable.size(), 2);
    } else {
      visualizers.draw.intervalSpectrumMesh(variable.size(), 2);
    }

    visualizers.done();
  }
}

public class OavpObjZRectangles extends OavpObject {
  public void setup() {
    variable
      .variations("radial")
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
      .use(variable);

    int count = variable.customIntAttrs.get("count");
    float gap = variable.customFloatAttrs.get("gap");

    for (int i = 0; i < count; i++) {
      if (variable.ofVariation("radial")) {
        int radius = variable.customIntAttrs.get("radius");
        visualizers
          .draw.basicZRectangle(
            variable.w() * (1.00 - (gap * i)),
            variable.h() * (1.00 - (gap * i)),
            oscillate(-variable.size(), variable.size(), 0.015 - (0.001 * i)),
            radius
          );
      } else {
        visualizers
          .draw.basicZRectangle(
            variable.w() * (1.00 - (gap * i)),
            variable.h() * (1.00 - (gap * i)),
            oscillate(-variable.size(), variable.size(), 0.015 - (0.001 * i))
          );
      }
    }

    visualizers.done();
  }
}