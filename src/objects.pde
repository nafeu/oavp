String[] OBJECT_LIST = {
  "Line",
  "Rectangle",
  "Spectrum",
  "Waveform",
  "Circle",
  "Triangle",
  "Box",
  "Flatbox",
  "Bullseye",
  "Splash",
  "SpectrumMesh",
  "ZRectangles"
};

public OavpObject createObject(String className) {
  OavpObject object;

  switch (className) {
    case "Line":
      object = new OavpObjLine();
      break;
    case "Rectangle":
      object = new OavpObjRectangle();
      break;
    case "Spectrum":
      object = new OavpObjSpectrum();
      break;
    case "Waveform":
      object = new OavpObjWaveform();
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
    case "Flatbox":
      object = new OavpObjFlatbox();
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
      .variations("dashed")
      .w(200)
      .h(50)
      .l(0)
      .strokeColor(palette.flat.white)
      .size(0);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .use(variable);

    if (variable.ofVariation("dashed")) {
      visualizers.draw.basicDashedRectangle(variable.w(), variable.h(), variable.size());
    } else {
      visualizers.draw.basicRectangle(variable.w(), variable.h(), variable.size());
    }
    visualizers.done();
  }
}

public class OavpObjTriangle extends OavpObject {
  public void setup() {
    variable
      .variations(
        "equilateral",
        "left-right",
        "right-right"
      )
      .size(100)
      .strokeColor(palette.flat.white);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .use(variable);

    if (variable.ofVariation("equilateral")) {
      visualizers.draw.basicEquilateralTriangle(variable.size());
    } else if (variable.ofVariation("left-right")) {
      visualizers.draw.basicLeftRightTriangle(variable.w(), variable.h());
    } else if (variable.ofVariation("right-right")) {
      visualizers.draw.basicRightRightTriangle(variable.w(), variable.h());
    } else {
      visualizers.draw.basicTriangle(variable.w(), variable.h());
    }

    visualizers.done();
  }
}

public class OavpObjLine extends OavpObject {
  public void setup() {
    variable
      .variations(
        "vertical",
        "diagonal",
        "dashed-horizontal",
        "dashed-vertical",
        "dashed-diagonal"
      )
      .w(100)
      .h(100)
      .size(0)
      .l(0)
      .strokeColor(palette.flat.white);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .use(variable);

    if (variable.ofVariation("vertical")) {
      visualizers.draw.basicVerticalLine(variable.w(), variable.h(), variable.l());
    } else if (variable.ofVariation("diagonal")) {
      visualizers.draw.basicDiagonalLine(variable.w(), variable.h(), variable.l());
    } else if (variable.ofVariation("dashed-horizontal")) {
      visualizers.draw.basicDashedHorizontalLine(variable.w(), variable.h(), variable.l(), variable.size());
    } else if (variable.ofVariation("dashed-vertical")) {
      visualizers.draw.basicDashedVerticalLine(variable.w(), variable.h(), variable.l(), variable.size());
    } else if (variable.ofVariation("dashed-diagonal")) {
      visualizers.draw.basicDashedDiagonalLine(variable.w(), variable.h(), variable.l(), variable.size());
    } else {
      visualizers.draw.basicHorizontalLine(variable.w(), variable.h(), variable.l());
    }

    visualizers.done();
  }
}

public class OavpObjSpectrum extends OavpObject {
  public void setup() {
    variable
      .variations(
        "bars",
        "wire",
        "dotted"
      )
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
      .moveUp(variable.h() / 2);

    if (variable.ofVariation("bars")) {
      visualizers.draw.basicSpectrumBars();
    } else if (variable.ofVariation("wire")) {
      visualizers.draw.basicSpectrumWire();
    } else if (variable.ofVariation("dotted")) {
      visualizers.draw.basicSpectrumDotted();
    } else {
      visualizers.draw.basicSpectrumLines();
    }

    visualizers.done();
  }
}

public class OavpObjWaveform extends OavpObject {
  public void setup() {
    variable
      .variations("right-channel")
      .w(100)
      .h(100)
      .l(0)
      .size(5)
      .strokeColor(palette.flat.white);
  }

  public void draw() {
    visualizers
      .startStyle()
      .create()
      .center().middle()
      .use(variable)
      .moveLeft(variable.w() / 2);

    if (variable.ofVariation("right-channel")) {
      visualizers.draw.basicRightWaveformWire(variable.size());
    } else {
      visualizers.draw.basicLeftWaveformWire(variable.size());
    }

    visualizers.done();
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
      .draw.centeredSvg(variable.customAttrs.get("svgName"), variable.size() / 100)
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

public class OavpObjFlatbox extends OavpObject {
  public void setup() {
    variable
      .w(100)
      .h(100)
      .l(100)
      .strokeColor(palette.flat.white)
      .fillColor(palette.flat.black);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .use(variable)
      .draw.basicFlatbox(
        variable.w(),
        variable.h(),
        variable.l(),
        variable.strokeColor(),
        variable.fillColor()
      )
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
    entities.addPulser(variable.customAttrs.get("varName"));
    entities.addInterval(variable.customAttrs.get("varName"), 10, 1);
  }

  public void update() {
    entities.getPulser(variable.customAttrs.get("varName"))
      .pulseIf(analysis.isBeatOnset());
    entities.getInterval(variable.customAttrs.get("varName"))
      .update(entities.getPulser(variable.customAttrs.get("varName")).getValue());
  }

  public void draw() {
    visualizers
      .useInterval(variable.customAttrs.get("varName"))
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
    entities.addEmissions(variable.customAttrs.get("varName"));
  }

  public void update() {
    emitters.useEmissions(variable.customAttrs.get("varName"))
      .emitIf(analysis.isBeatOnset());
  }

  public void draw() {
    visualizers
      .useEmissions(variable.customAttrs.get("varName"))
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

    int count = (int) variable.customAttrs.get("count");
    float gap = (float) variable.customAttrs.get("gap");

    for (int i = 0; i < count; i++) {
      if (variable.ofVariation("radial")) {
        int radius = (int) variable.customAttrs.get("radius");
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