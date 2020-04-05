String[] OBJECT_LIST = {
  "Line",
  "Rectangle",
  "Shader",
  "Spectrum",
  "Waveform",
  "Circle",
  "Triangle",
  "Box",
  "Flatbox",
  "Bullseye",
  "Splash",
  "SpectrumMesh",
  "ZRectangles",
  "GridInterval"
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
    case "Shader":
      object = new OavpObjShader();
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
    case "GridInterval":
      object = new OavpObjGridInterval();
      break;
    default:
      object = new OavpObject();
  }

  return object;
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

  public OavpObject clone(String cloneName) {
    String rawClassName = this.getClass().getName();
    String className = rawClassName.split("OavpObj")[1];
    OavpObject clone = createObject(className);
    OavpVariable cloneVariable = clone.getVariable();

    clone.setName(cloneName);
    clone.setup();

    cloneVariable.name = cloneName;
    cloneVariable.x = this.variable.x;
    cloneVariable.xMod = this.variable.xMod;
    cloneVariable.xModType = this.variable.xModType;
    cloneVariable.xr = this.variable.xr;
    cloneVariable.xrMod = this.variable.xrMod;
    cloneVariable.xrModType = this.variable.xrModType;
    cloneVariable.y = this.variable.y;
    cloneVariable.yMod = this.variable.yMod;
    cloneVariable.yModType = this.variable.yModType;
    cloneVariable.yr = this.variable.yr;
    cloneVariable.yrMod = this.variable.yrMod;
    cloneVariable.yrModType = this.variable.yrModType;
    cloneVariable.z = this.variable.z;
    cloneVariable.zMod = this.variable.zMod;
    cloneVariable.zModType = this.variable.zModType;
    cloneVariable.zr = this.variable.zr;
    cloneVariable.zrMod = this.variable.zrMod;
    cloneVariable.zrModType = this.variable.zrModType;
    cloneVariable.w = this.variable.w;
    cloneVariable.wMod = this.variable.wMod;
    cloneVariable.wModType = this.variable.wModType;
    cloneVariable.h = this.variable.h;
    cloneVariable.hMod = this.variable.hMod;
    cloneVariable.hModType = this.variable.hModType;
    cloneVariable.l = this.variable.l;
    cloneVariable.lMod = this.variable.lMod;
    cloneVariable.lModType = this.variable.lModType;
    cloneVariable.size = this.variable.size;
    cloneVariable.sizeMod = this.variable.sizeMod;
    cloneVariable.sizeModType = this.variable.sizeModType;
    cloneVariable.strokeColor = this.variable.strokeColor;
    cloneVariable.strokeColorMod = this.variable.strokeColorMod;
    cloneVariable.strokeColorModType = this.variable.strokeColorModType;
    cloneVariable.strokeWeight = this.variable.strokeWeight;
    cloneVariable.strokeWeightMod = this.variable.strokeWeightMod;
    cloneVariable.strokeWeightModType = this.variable.strokeWeightModType;
    cloneVariable.fillColor = this.variable.fillColor;
    cloneVariable.fillColorMod = this.variable.fillColorMod;
    cloneVariable.fillColorModType = this.variable.fillColorModType;
    cloneVariable.variation = this.variable.variation;

    for (HashMap.Entry<String, Object> customAttrEntry : this.variable.customAttrs.entrySet()) {
      cloneVariable.set(customAttrEntry.getKey(), customAttrEntry.getValue());
    }

    return clone;
  }

  public void setup() {}
  public void draw() {}
  public void update() {}
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
      .draw.basicRectangle(
        variable.val("w"),
        variable.val("h"),
        variable.val("size")
      )
      .done();
  }
}

public class OavpObjShader extends OavpObject {
  public void setup() {
    variable
      .variations(
        "test-shader-2"
      )
      .w(100)
      .h(100)
      .fillColor(palette.flat.white)
      .size(100);
    entities.addShader(variable.name + "test-shader", "test-shader");
    entities.addShader(variable.name + "test-shader-2", "test-shader-2");
  }

  public void update() {
    PShader shader;

    if (variable.ofVariation("test-shader-2")) {
      shader = entities.getShader(variable.name + "test-shader-2");
    } else {
      shader = entities.getShader(variable.name + "test-shader");
    }

    shader.set("paramA", constrain(variable.val("size"), 0, 200) / 100);
    shader.set("paramB", constrain(variable.val("size"), 0, 200) / 100);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .noStrokeStyle()
      .use(variable);

    if (variable.ofVariation("test-shader-2")) {
      visualizers.useShader(variable.name + "test-shader-2");
    } else {
      visualizers.useShader(variable.name + "test-shader");
    }

    visualizers.draw.basicRectangle(variable.val("w"), variable.val("h"));

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
      visualizers.draw.basicEquilateralTriangle(variable.val("size"));
    } else if (variable.ofVariation("left-right")) {
      visualizers.draw.basicLeftRightTriangle(variable.val("w"), variable.val("h"));
    } else if (variable.ofVariation("right-right")) {
      visualizers.draw.basicRightRightTriangle(variable.val("w"), variable.val("h"));
    } else {
      visualizers.draw.basicTriangle(variable.val("w"), variable.val("h"));
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
      .strokeColor(palette.flat.white);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .use(variable);

    if (variable.ofVariation("vertical")) {
      visualizers.draw.basicVerticalLine(variable.val("w"), variable.val("h"), variable.val("l"));
    } else if (variable.ofVariation("diagonal")) {
      visualizers.draw.basicDiagonalLine(variable.val("w"), variable.val("h"), variable.val("l"));
    } else if (variable.ofVariation("dashed-horizontal")) {
      visualizers.draw.basicDashedHorizontalLine(variable.val("w"), variable.val("h"), variable.val("l"), variable.val("size"));
    } else if (variable.ofVariation("dashed-vertical")) {
      visualizers.draw.basicDashedVerticalLine(variable.val("w"), variable.val("h"), variable.val("l"), variable.val("size"));
    } else if (variable.ofVariation("dashed-diagonal")) {
      visualizers.draw.basicDashedDiagonalLine(variable.val("w"), variable.val("h"), variable.val("l"), variable.val("size"));
    } else {
      visualizers.draw.basicHorizontalLine(variable.val("w"), variable.val("h"), variable.val("l"));
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
      .moveLeft(variable.val("w") / 2)
      .moveUp(variable.val("h") / 2);

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
      .size(5)
      .strokeColor(palette.flat.white);
  }

  public void draw() {
    visualizers
      .startStyle()
      .create()
      .center().middle()
      .use(variable)
      .moveLeft(variable.val("w") / 2);

    if (variable.ofVariation("right-channel")) {
      visualizers.draw.basicRightWaveformWire(variable.val("size"));
    } else {
      visualizers.draw.basicLeftWaveformWire(variable.val("size"));
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
      .draw.centeredSvg(variable.customAttrs.get("svgName"), variable.val("size") / 100)
      .done();
  }
}

public class OavpObjBox extends OavpObject {
  public void setup() {
    variable
      .size(100)
      .w(100)
      .h(100)
      .l(100)
      .strokeColor(palette.flat.white);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .use(variable)
      .draw.basicBox(variable.val("w"), variable.val("h"), variable.val("l"))
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
        variable.val("w"),
        variable.val("h"),
        variable.val("l"),
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
      visualizers.draw.intervalBullseyeRectangle(variable.val("w"), variable.val("h"), 10);
    } else if (variable.ofVariation("boxed")) {
      visualizers.draw.intervalBullseyeBox(variable.val("w"), variable.val("h"), variable.val("l"), 10);
    } else {
      visualizers.draw.intervalBullseyeCircle(variable.val("size"), 10);
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
      visualizers.draw.emissionSplashRectangle(variable.val("w"), variable.val("h"));
    } else if (variable.ofVariation("boxed")) {
      visualizers.draw.emissionSplashBox(variable.val("w"), variable.val("h"), variable.val("l"));
    } else {
      visualizers.draw.emissionSplashCircle(variable.val("size"));
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
      .moveLeft(variable.val("w") / 2)
      .moveUp(variable.val("h") / 2);

    if (variable.ofVariation("dotted")) {
      visualizers.draw.intervalSpectrumPoints(variable.val("size"), 2);
    } else if (variable.ofVariation("z-lines")) {
      visualizers.draw.intervalSpectrumZLines(variable.val("size"), 2);
    } else if (variable.ofVariation("x-lines")) {
      visualizers.draw.intervalSpectrumXLines(variable.val("size"), 2);
    } else {
      visualizers.draw.intervalSpectrumMesh(variable.val("size"), 2);
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
            variable.val("w") * (1.00 - (gap * i)),
            variable.val("h") * (1.00 - (gap * i)),
            oscillate(-variable.val("size"), variable.val("size"), 0.015 - (0.001 * i)),
            radius
          );
      } else {
        visualizers
          .draw.basicZRectangle(
            variable.val("w") * (1.00 - (gap * i)),
            variable.val("h") * (1.00 - (gap * i)),
            oscillate(-variable.val("size"), variable.val("size"), 0.015 - (0.001 * i))
          );
      }
    }

    visualizers.done();
  }
}

public class OavpObjGridInterval extends OavpObject {
  public void setup() {
    variable
      .variations(
        "dimensional",
        "diagonal"
      )
      .w(100)
      .h(100)
      .size(0)
      .set("sizeModType", "level")
      .strokeColor(palette.flat.white);
    entities.addGridInterval(variable.name, 5, 5).delay(1);
  }

  public void update() {
    OavpGridInterval interval = entities.getGridInterval(variable.name);

    if (variable.ofVariation("dimensional")) {
      interval.updateDimensional(variable.val("size"));
    } else if (variable.ofVariation("diagonal")) {
      interval.updateDiagonal(variable.val("size"));
    } else {
      interval.update(variable.val("size"));
    }
  }

  public void draw() {
    visualizers
      .useGridInterval(variable.name)
      .create()
      .center().middle()
      .use(variable)
      .moveLeft(variable.w / 2)
      .moveUp(variable.h / 2);

    visualizers
      .draw.gridIntervalSquares();

    visualizers.done();
  }
}