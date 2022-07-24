String[] OBJECT_LIST = {
  "Arc",
  "Box",
  "Bullseye",
  "Circle",
  "CurvedLine",
  "Flatbox",
  "GoldenRatio",
  "Gradient",
  "GridInterval",
  "Line",
  "Orbital",
  "Pyramid",
  "RadialSpectrum",
  "Rectangle",
  "Shader",
  "Spectrum",
  "SpectrumMesh",
  "Sphere",
  "Splash",
  "Terrain",
  "Triangle",
  "Vegetation",
  "Waveform",
  "ZRectangles"
  // "Image",
  // "Lyrics",
};

String[] SHADER_LIST = {
  "test-shader",
  "test-shader-2"
};

public OavpObject createObject(String className) {
  OavpObject object;

  switch (className) {
    case "Arc": object = new OavpObjArc(); break;
    case "Box": object = new OavpObjBox(); break;
    case "Bullseye": object = new OavpObjBullseye(); break;
    case "Circle": object = new OavpObjCircle(); break;
    case "CurvedLine": object = new OavpObjCurvedLine(); break;
    case "Flatbox": object = new OavpObjFlatbox(); break;
    case "GoldenRatio": object = new OavpObjGoldenRatio(); break;
    case "Gradient": object = new OavpObjGradient(); break;
    case "GridInterval": object = new OavpObjGridInterval(); break;
    case "Image": object = new OavpObjImage(); break;
    case "Line": object = new OavpObjLine(); break;
    case "Orbital": object = new OavpObjOrbital(); break;
    case "Pyramid": object = new OavpObjPyramid(); break;
    case "Lyrics": object = new OavpObjLyrics(); break;
    case "RadialSpectrum": object = new OavpObjRadialSpectrum(); break;
    case "Rectangle": object = new OavpObjRectangle(); break;
    case "Shader": object = new OavpObjShader(); break;
    case "Spectrum": object = new OavpObjSpectrum(); break;
    case "SpectrumMesh": object = new OavpObjSpectrumMesh(); break;
    case "Sphere": object = new OavpObjSphere(); break;
    case "Splash": object = new OavpObjSplash(); break;
    case "Terrain": object = new OavpObjTerrain(); break;
    case "Triangle": object = new OavpObjTriangle(); break;
    case "Vegetation": object = new OavpObjVegetation(); break;
    case "Waveform": object = new OavpObjWaveform(); break;
    case "ZRectangles": object = new OavpObjZRectangles(); break;
    default: object = new OavpObject();
  }

  return object;
}

public String getAvailableShaders() {
  return String.join(",", SHADER_LIST);
}

public String getAvailableImages() {
  return String.join(",", entities.getImgs());
}

public class OavpObject {
  public OavpVariable variable;

  OavpObject() { this.variable = new OavpVariable(); }
  public OavpVariable getVariable() { return this.variable; }
  public void setName(String name) { this.variable.name = name; }

  public OavpObject header(String header) {
    editor.setModalHeader(header);
    return this;
  }

  public OavpObject option(String name, String optionType, String values) {
    editor.addModalOption(name, optionType, values);
    return this;
  }

  public OavpObject option(String name, String optionType) {
    editor.addModalOption(name, optionType);
    return this;
  }

  public OavpObject clone(String cloneName) {
    String rawClassName = this.getClass().getName();
    String className = rawClassName.split("OavpObj")[1];
    OavpObject clone = createObject(className);
    OavpVariable cloneVariable = clone.getVariable();

    clone.setName(cloneName);
    clone.setup();

    cloneVariable.name = cloneName;

    for (String rawFieldName : MODIFIER_FIELDS) {
      String fieldName = rawFieldName.split("Mod")[0];

      try {
        Field field = this.variable.getClass().getDeclaredField(fieldName);
        Field fieldMod = this.variable.getClass().getDeclaredField(fieldName + "Mod");
        Field fieldModType = this.variable.getClass().getDeclaredField(fieldName + "ModType");
        Field fieldIter = this.variable.getClass().getDeclaredField(fieldName + "Iter");
        Field fieldIterFunc = this.variable.getClass().getDeclaredField(fieldName + "IterFunc");

        Object fieldValue = field.get(this.variable);
        Object fieldModValue = fieldMod.get(this.variable);
        Object fieldModTypeValue = fieldModType.get(this.variable);
        Object fieldIterValue = fieldIter.get(this.variable);
        Object fieldIterFuncValue = fieldIterFunc.get(this.variable);

        cloneVariable.set(fieldName, fieldValue);
        cloneVariable.set(fieldName + "Mod", fieldModValue);
        cloneVariable.set(fieldName + "ModType", fieldModTypeValue);
        cloneVariable.set(fieldName + "Iter", fieldIterValue);
        cloneVariable.set(fieldName + "IterFunc", fieldIterFuncValue);
      } catch (Exception e) {
        e.printStackTrace();
      }
    }

    for (String rawFieldName : NON_MODIFIER_FIELDS) {
      try {
        Field field = this.variable.getClass().getDeclaredField(rawFieldName);
        Object fieldValue = field.get(this.variable);
        cloneVariable.set(rawFieldName, fieldValue);
      } catch (Exception e) {
        e.printStackTrace();
      }
    }

    cloneVariable.variation = this.variable.variation;

    for (HashMap.Entry<String, Object> customAttrEntry : this.variable.customAttrs.entrySet()) {
      cloneVariable.set(customAttrEntry.getKey(), customAttrEntry.getValue());
    }

    return clone;
  }

  public void setup() {}
  public void draw(int iteration) {}
  public void update() {}
  public void useOptions() {}
}

public class OavpObjRectangle extends OavpObject {
  public void setup() {
    variable
      .params("border-radius")
      .set("w", 100)
      .set("h", 100)
      .set("strokeColor", palette.flat.white)
      .set("s", 0);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration)
      .draw.basicRectangle(
        variable.val("w", iteration),
        variable.val("h", iteration),
        variable.val("paramA", iteration)
      )
      .done();
  }
}

public class OavpObjArc extends OavpObject {
  public void setup() {
    variable
      .params(
        "start",
        "stop"
      )
      .set("w", 100)
      .set("h", 100)
      .set("strokeColor", palette.flat.white)
      .set("paramA", 0)
      .set("paramB", 180);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration)
      .draw.basicArc(
        variable.val("w", iteration),
        variable.val("h", iteration),
        variable.val("paramA", iteration),
        variable.val("paramB", iteration)
      )
      .done();
  }
}

public class OavpObjShader extends OavpObject {
  public void useOptions() {
    header("Select shader")
      .option("shader", "select", getAvailableShaders());
  }

  public void setup() {
    String shader = (String) getModalValue("shader");
    variable
      .params(
        "Shader Parameter A",
        "Shader Parameter B",
        "Shader Parameter C",
        "Shader Parameter D",
        "Shader Parameter E"
      )
      .set("shader", shader)
      .set("w", 100)
      .set("h", 100)
      .set("fillColor", palette.flat.white)
      .set("s", 100);
    entities.addShader(variable.name + shader, shader);
  }

  public void update() {
    PShader shader = entities.getShader(variable.name + (String) variable.customAttrs.get("shader"));
    shader.set("paramA", constrain(variable.val("paramA"), 0, 200) / 200);
    shader.set("paramB", constrain(variable.val("paramB"), 0, 200) / 200);
    shader.set("paramC", constrain(variable.val("paramC"), 0, 200) / 200);
    shader.set("paramD", constrain(variable.val("paramD"), 0, 200) / 200);
    shader.set("paramE", constrain(variable.val("paramE"), 0, 200) / 200);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .noStrokeStyle()
      .use(variable, iteration);

    visualizers.useShader(variable.name + (String) variable.customAttrs.get("shader"));
    visualizers.draw.basicRectangle(variable.val("w", iteration), variable.val("h", iteration));
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
      .set("s", 100)
      .set("strokeColor", palette.flat.white);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration);

    if (variable.ofVariation("equilateral")) {
      visualizers.draw.basicEquilateralTriangle(variable.val("s", iteration));
    } else if (variable.ofVariation("left-right")) {
      visualizers.draw.basicLeftRightTriangle(variable.val("w", iteration), variable.val("h", iteration));
    } else if (variable.ofVariation("right-right")) {
      visualizers.draw.basicRightRightTriangle(variable.val("w", iteration), variable.val("h", iteration));
    } else {
      visualizers.draw.basicTriangle(variable.val("w", iteration), variable.val("h", iteration));
    }

    visualizers.done();
  }
}

public class OavpObjLine extends OavpObject {
  public void setup() {
    variable
      .variations(
        "vertical",
        "diagonal"
      )
      .set("w", 100)
      .set("h", 100)
      .set("s", 0)
      .set("strokeColor", palette.flat.white);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration);

    if (variable.ofVariation("vertical")) {
      visualizers.draw.basicVerticalLine(
        variable.val("w", iteration),
        variable.val("h", iteration),
        variable.val("l", iteration)
      );
    } else if (variable.ofVariation("diagonal")) {
      visualizers.draw.basicDiagonalLine(
        variable.val("w", iteration),
        variable.val("h", iteration),
        variable.val("l", iteration)
      );
    } else {
      visualizers.draw.basicHorizontalLine(
        variable.val("w", iteration),
        variable.val("h", iteration),
        variable.val("l", iteration),
        variable.val("s", iteration)
      );
    }

    visualizers.done();
  }
}

public class OavpObjOrbital extends OavpObject {
  public void setup() {
    variable
      .params("position")
      .set("w", 100)
      .set("h", 100)
      .set("s", 100)
      .set("strokeColor", palette.flat.white);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration);

    visualizers.draw.basicOrbitalCircle(
      variable.val("w", iteration),
      variable.val("h", iteration),
      variable.val("paramA", iteration),
      variable.val("s", iteration)
    );

    visualizers.done();
  }
}

public class OavpObjCurvedLine extends OavpObject {
  public void setup() {
    variable
      .variations(
        "two-point"
      )
      .set("w", 100)
      .set("s", 0)
      .set("paramB", -50)
      .set("paramD", 50)
      .set("strokeColor", palette.flat.white);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration);

    if (variable.ofVariation("two-point")) {
      visualizers.draw.basicCurvedLine(
        variable.val("w", iteration),
        variable.val("paramA", iteration),
        variable.val("paramB", iteration),
        variable.val("paramC", iteration),
        variable.val("paramD", iteration),
        map(variable.val("s", iteration), -1000, 1000, -5.0, 5.0)
      );
    } else {
      visualizers.draw.basicCurvedLine(
        variable.val("w", iteration),
        variable.val("paramA", iteration),
        variable.val("paramB", iteration),
        map(variable.val("s", iteration), -1000, 1000, -5.0, 5.0)
      );
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
      .set("w", 100)
      .set("h", 100)
      .set("strokeColor", palette.flat.white);
  }

  public void draw(int iteration) {
    visualizers
      .startStyle()
      .create()
      .center().middle()
      .use(variable, iteration)
      .moveLeft(variable.val("w", iteration) / 2)
      .moveUp(variable.val("h", iteration) / 2);

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

public class OavpObjRadialSpectrum extends OavpObject {
  public void setup() {
    println(
      "[OavpObjRadialSpectrum - CUSTOM PARAMS] : paramA => scale"
    );

    variable
      .variations(
        "wire"
      )
      .set("w", 100)
      .set("h", 100)
      .set("strokeColor", palette.flat.white);
  }

  public void draw(int iteration) {
    visualizers
      .startStyle()
      .create()
      .center().middle()
      .use(variable, iteration);

    if (variable.ofVariation("wire")) {
      visualizers.draw.basicSpectrumRadialWire(
        variable.val("s", iteration),
        variable.val("l", iteration),
        0
      );
    } else {
      visualizers.draw.basicSpectrumRadialBars(
        variable.val("paramA", iteration),
        variable.val("s", iteration),
        variable.val("l", iteration),
        0
      );
    }

    visualizers.done();
  }
}

public class OavpObjWaveform extends OavpObject {
  public void setup() {
    variable
      .variations("right-channel")
      .set("w", 100)
      .set("h", 100)
      .set("s", 5)
      .set("strokeColor", palette.flat.white);
  }

  public void draw(int iteration) {
    visualizers
      .startStyle()
      .create()
      .center().middle()
      .use(variable, iteration)
      .moveLeft(variable.val("w", iteration) / 2);

    if (variable.ofVariation("right-channel")) {
      visualizers.draw.basicRightWaveformWire(variable.val("s", iteration));
    } else {
      visualizers.draw.basicLeftWaveformWire(variable.val("s", iteration));
    }

    visualizers.done();
  }
}

public class OavpObjCircle extends OavpObject {
  public void setup() {
    variable
      .set("s", 100)
      .set("strokeColor", palette.flat.white);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration)
      .draw.basicCircle(variable.val("s", iteration))
      .done();
  }
}

public class OavpObjSphere extends OavpObject {
  public void setup() {
    variable
      .set("s", 100)
      .set("strokeColor", palette.flat.white);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration)
      .draw.basicSphere(variable.val("s", iteration))
      .done();
  }
}

public class OavpObjSvg extends OavpObject {
  public void setup() {
    variable
      .set("s", 100)
      .set("svgName", variable.name);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration)
      .draw.centeredSvg(variable.customAttrs.get("svgName"), variable.val("s", iteration) / 100)
      .done();
  }
}

public class OavpObjBox extends OavpObject {
  public void setup() {
    variable
      .set("s", 100)
      .set("w", 100)
      .set("h", 100)
      .set("l", 100)
      .set("strokeColor", palette.flat.white);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration)
      .draw.basicBox(
        variable.val("w", iteration),
        variable.val("h", iteration),
        variable.val("l", iteration)
      )
      .done();
  }
}

public class OavpObjFlatbox extends OavpObject {
  public void setup() {
    variable
      .set("w", 100)
      .set("h", 100)
      .set("l", 100)
      .set("strokeColor", palette.flat.white)
      .set("fillColor", palette.flat.black);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration)
      .draw.basicFlatbox(
        variable.val("w", iteration),
        variable.val("h", iteration),
        variable.val("l", iteration),
        variable.strokeColor(),
        variable.fillColor()
      )
      .done();
  }
}

public class OavpObjPyramid extends OavpObject {
  public void setup() {
    variable
      .set("w", 100)
      .set("h", 100)
      .set("l", 100)
      .set("strokeColor", palette.flat.white)
      .set("fillColor", palette.flat.black);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration)
      .draw.basicSquareBasePyramid(
        variable.val("w", iteration),
        variable.val("h", iteration),
        variable.val("l", iteration),
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
        "boxed",
        "circle-spacebar",
        "rectangular-spacebar",
        "boxed-spacebar"
      )
      .set("s", 100)
      .set("w", 100)
      .set("h", 100)
      .set("varName", variable.name)
      .set("strokeColor", palette.flat.white);
    entities.addPulser(variable.customAttrs.get("varName"));
    entities.addInterval(variable.customAttrs.get("varName"), 10, 1);
  }

  public void update() {
    entities.getPulser(variable.customAttrs.get("varName"))
      .pulseIf(analysis.isBeatOnset());
    entities.getInterval(variable.customAttrs.get("varName"))
      .update(entities.getPulser(variable.customAttrs.get("varName")).getValue());
  }

  public void draw(int iteration) {
    if (variable.ofVariation("spacebar")) {
      visualizers.useInterval("spacebar-pulser-interval");
    } else {
      visualizers.useInterval(variable.customAttrs.get("varName"));
    }

    visualizers
      .create()
      .center().middle()
      .use(variable, iteration);

    if (variable.ofVariation("rectangular")) {
      visualizers.draw.intervalBullseyeRectangle(variable.val("w", iteration), variable.val("h", iteration), 10);
    } else if (variable.ofVariation("boxed")) {
      visualizers.draw.intervalBullseyeBox(variable.val("w", iteration), variable.val("h", iteration), variable.val("l", iteration), 10);
    } else {
      visualizers.draw.intervalBullseyeCircle(variable.val("s", iteration), 10);
    }

    visualizers.done();
  }
}

public class OavpObjSplash extends OavpObject {
  public void setup() {
    variable
      .params(
        "useSpacebar",
        "cadence"
      )
      .variations(
        "rectangular",
        "boxed"
      )
      .set("s", 100)
      .set("w", 100)
      .set("h", 100)
      .set("varName", variable.name)
      .set("strokeColor", palette.flat.white);
    entities.addEmissions(variable.customAttrs.get("varName"));
  }

  public void update() {
    emitters.useEmissions(variable.customAttrs.get("varName"))
      .emitIf(analysis.isBeatOnset());
  }

  public void draw(int iteration) {
    boolean useSpacebar = variable.val("paramA", iteration) > 0;

    if (useSpacebar) {
      float triggerCadence = variable.val("paramB", iteration);

      if (triggerCadence < 100) {
        visualizers.useEmissions("spacebar");
      } else if (triggerCadence < 200) {
        visualizers.useEmissions("spacebar-2");
      } else if (triggerCadence < 300) {
        visualizers.useEmissions("spacebar-4");
      } else {
        visualizers.useEmissions("spacebar-8");
      }
    } else {
      visualizers.useEmissions(variable.customAttrs.get("varName"));
    }

    visualizers
      .create()
      .center().middle()
      .use(variable, iteration);

    if (variable.ofVariation("rectangular")) {
      visualizers.draw.emissionSplashRectangle(variable.val("w", iteration), variable.val("h", iteration));
    } else if (variable.ofVariation("boxed")) {
      visualizers.draw.emissionSplashBox(variable.val("w", iteration), variable.val("h", iteration), variable.val("l", iteration));
    } else {
      visualizers.draw.emissionSplashCircle(variable.val("s", iteration));
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
      .set("s", 100)
      .set("strokeColor", palette.flat.white);
    entities.addInterval(variable.name, 30, analysis.getAvgSize());
  }

  public void update() {
    entities.getInterval(variable.name).update(analysis.getSpectrum());
  }

  public void draw(int iteration) {
    visualizers
      .useInterval(variable.name)
      .create()
      .center().middle()
      .use(variable, iteration)
      .moveLeft(variable.val("w", iteration) / 2)
      .moveUp(variable.val("h", iteration) / 2);

    if (variable.ofVariation("dotted")) {
      visualizers.draw.intervalSpectrumPoints(variable.val("s", iteration), 2);
    } else if (variable.ofVariation("z-lines")) {
      visualizers.draw.intervalSpectrumZLines(variable.val("s", iteration), 2);
    } else if (variable.ofVariation("x-lines")) {
      visualizers.draw.intervalSpectrumXLines(variable.val("s", iteration), 2);
    } else {
      visualizers.draw.intervalSpectrumMesh(variable.val("s", iteration), 2);
    }

    visualizers.done();
  }
}

public class OavpObjZRectangles extends OavpObject {
  public void useOptions() {
    header("Configure Z Rectangles")
      .option("count", "slider")
      .option("gap", "number");
  }

  public void setup() {
    variable
      .variations("radial")
      .set("s", 100)
      .set("count", int((float) getModalValue("count")))
      .set("gap", ((float) getModalValue("gap")) * 0.01)
      .set("radius", 50)
      .set("strokeColor", palette.flat.white);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration);

    int count = (int) variable.customAttrs.get("count");
    float gap = (float) variable.customAttrs.get("gap");

    for (int i = 0; i < count; i++) {
      if (variable.ofVariation("radial")) {
        int radius = (int) variable.customAttrs.get("radius");
        visualizers
          .draw.basicZRectangle(
            variable.val("w", iteration) * (1.00 - (gap * i)),
            variable.val("h", iteration) * (1.00 - (gap * i)),
            oscillate(-variable.val("s", iteration), variable.val("s", iteration), 0.015 - (0.001 * i)),
            radius
          );
      } else {
        visualizers
          .draw.basicZRectangle(
            variable.val("w", iteration) * (1.00 - (gap * i)),
            variable.val("h", iteration) * (1.00 - (gap * i)),
            oscillate(-variable.val("s", iteration), variable.val("s", iteration), 0.015 - (0.001 * i))
          );
      }
    }

    visualizers.done();
  }
}

public class OavpObjGridInterval extends OavpObject {
  public void setup() {
    variable
      .params("scale")
      .variations(
        "dimensional",
        "diagonal",
        "circular",
        "circular-dimensional",
        "circular-diagonal",
        "flatbox",
        "flatbox-dimensional",
        "flatbox-diagonal"
      )
      .set("w", 100)
      .set("h", 100)
      .set("s", 0)
      .set("sModType", "level")
      .set("strokeColor", palette.flat.white);
    entities.addGridInterval(variable.name, 10, 10).delay(1);
  }

  public void update() {
    OavpGridInterval interval = entities.getGridInterval(variable.name);

    if (variable.val("paramA") >= 0) {
      interval.averageWeight(
        map(
          variable.val("paramA"),
          0.0, 500.0,
          0.1, 10.0
        )
      );
    } else {
      interval.averageWeight(1);
    }

    if (variable.ofVariation("dimensional")) {
      interval.updateDimensional(variable.val("s"));
    } else if (variable.ofVariation("diagonal")) {
      interval.updateDiagonal(variable.val("s"));
    } else {
      interval.update(variable.val("s"));
    }
  }

  public void draw(int iteration) {
    visualizers
      .useGridInterval(variable.name)
      .create()
      .center().middle()
      .use(variable, iteration)
      .moveLeft(variable.w / 2)
      .moveUp(variable.h / 2);

    if (variable.ofVariation("circular")) {
      visualizers.draw.gridIntervalCircles();
    } else if (variable.ofVariation("flatbox")) {
      visualizers.draw.gridIntervalFlatboxes(variable.val("l", iteration), variable.strokeColor(), variable.fillColor());
    } else {
      visualizers.draw.gridIntervalSquares();
    }

    visualizers.done();
  }
}

public class OavpObjLyrics extends OavpObject {
  public void setup() {
    variable
      .set("s", 10)
      .set("fillColor", palette.flat.white);
  }

  public void draw(int iteration) {
    text.create()
      .center().middle()
      .use(variable)
      .write("LYRICS HERE")
      .done();
  }
}

public class OavpObjImage extends OavpObject {
  public void useOptions() {
    header("Select image")
      .option("image", "select", getAvailableImages());
  }

  public void setup() {
    variable.set("s", 100);

    if (!variable.customAttrs.containsKey("image")) {
      variable.set("image", (String) getModalValue("image"));
    }
  }

  public void draw(int iteration) {
    String imageName = (String) variable.customAttrs.get("image");

    float opacity = 1.0;

    if (variable.val("paramA", iteration) > 0) {
      opacity = 1 - constrain(variable.val("paramA", iteration) / 100, 0, 1.0);
    } else if (variable.val("paramA", iteration) < 0) {
      opacity = constrain(abs(variable.val("paramA", iteration)) / 100, 0, 1.0);
    }

    visualizers.create()
      .center().middle()
      .use(variable, iteration)
      .draw.img(
        imageName,
        max(variable.val("s", iteration) / 100, 0),
        opacity
      )
      .done();
  }
}

public class OavpObjTerrain extends OavpObject {
  public void setup() {
    variable
      .variations(
        "trees"
      )
      .params(
        "displacement",
        "window",
        "phaseShift",
        "position"
      )
      .set("s", 10)
      .set("paramA", 50)
      .set("paramB", 100)
      .set("paramC", 100)
      .set("paramD", 50)
      .set("strokeColor", palette.flat.white);

    entities.addTerrain(variable.name);
  }

  public void draw(int iteration) {
    float scale = variable.val("s", iteration);
    float displacement = variable.val("paramA", iteration);
    int window = max(1, int(variable.val("paramB", iteration)));
    int phaseShift = max(1, int(variable.val("paramC", iteration)));
    float position = max(0, variable.val("paramD", iteration));

    visualizers
      .useTerrain(variable.name)
      .create()
      .center().middle()
      .use(variable, iteration)
      .moveLeft(variable.val("w", iteration) / 2)
      .moveUp(variable.val("h", iteration) / 2);

    if (variable.ofVariation("trees")) {
      visualizers.draw.terrainTrees(scale, displacement, window, phaseShift, position);
    } else {
      visualizers.draw.terrainHills(scale, displacement, window, phaseShift, position);
    }

    visualizers.done();
  }
}

public class OavpObjGradient extends OavpObject {
  public void setup() {
    variable
      .set("w", 100)
      .set("h", 100);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration);

    visualizers.draw.basicRectangleGradient(
      variable.val("w", iteration),
      variable.val("h", iteration),
      (color) variable.val("strokeColor"),
      (color) variable.val("fillColor")
    );

    visualizers.done();
  }
}

public class OavpObjGoldenRatio extends OavpObject {
  public void setup() {
    variable
      .variations(
        "spiral",
        "circles",
        "curves",
        "rule-of-thirds",
        "phi-grid"
      )
      .set("s", 100)
      .set("strokeColor", palette.flat.white);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration);

    if (variable.ofVariation("spiral")) {
      visualizers.draw.basicGoldenSpiral(variable.val("s", iteration));
    } else if (variable.ofVariation("circles")) {
      visualizers.draw.basicGoldenSpiralCircles(variable.val("s", iteration));
    } else if (variable.ofVariation("curves")) {
      visualizers.draw.basicGoldenSpiralCurves(variable.val("s", iteration));
    } else if (variable.ofVariation("rule-of-thirds")) {
      visualizers.draw.basicRuleOfThirds(variable.val("s", iteration));
    } else if (variable.ofVariation("phi-grid")) {
      visualizers.draw.basicPhiGrid(variable.val("s", iteration));
    } else {
      visualizers.draw.basicGoldenRectangle(variable.val("s", iteration));
    }

    visualizers.done();
  }
}

public class OavpObjVegetation extends OavpObject {
  public void setup() {
    variable
      .variations(
        "A2",
        "A3",
        "A4",
        "A5",
        "B1",
        "B2",
        "B3",
        "B4",
        "B5",
        "C1",
        "C2",
        "C3",
        "C4",
        "C5",
        "D1",
        "D2",
        "D3",
        "D4",
        "D5",
        "E1",
        "E2",
        "E3",
        "E4",
        "E5",
        "F1",
        "F2",
        "F3",
        "F4",
        "F5",
        "G1",
        "G2",
        "G3",
        "G4",
        "G5"
      )
      .set("s", 20)
      .set("h", 0)
      .set("strokeColor", palette.flat.white);
  }

  public void draw(int iteration) {
    visualizers
      .create()
      .center().middle()
      .use(variable, iteration);

    if (variable.ofVariation("A2")) {
      visualizers.draw.basicVegetationA2(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("A3")) {
      visualizers.draw.basicVegetationA3(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("A4")) {
      visualizers.draw.basicVegetationA4(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("A5")) {
      visualizers.draw.basicVegetationA5(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("B1")) {
      visualizers.draw.basicVegetationB1(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("B2")) {
      visualizers.draw.basicVegetationB2(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("B3")) {
      visualizers.draw.basicVegetationB3(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("B4")) {
      visualizers.draw.basicVegetationB4(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("B5")) {
      visualizers.draw.basicVegetationB5(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("C1")) {
      visualizers.draw.basicVegetationC1(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("C2")) {
      visualizers.draw.basicVegetationC2(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("C3")) {
      visualizers.draw.basicVegetationC3(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("C4")) {
      visualizers.draw.basicVegetationC4(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("C5")) {
      visualizers.draw.basicVegetationC5(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("D1")) {
      visualizers.draw.basicVegetationD1(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("D2")) {
      visualizers.draw.basicVegetationD2(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("D3")) {
      visualizers.draw.basicVegetationD3(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("D4")) {
      visualizers.draw.basicVegetationD4(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("D5")) {
      visualizers.draw.basicVegetationD5(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("E1")) {
      visualizers.draw.basicVegetationE1(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("E2")) {
      visualizers.draw.basicVegetationE2(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("E3")) {
      visualizers.draw.basicVegetationE3(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("E4")) {
      visualizers.draw.basicVegetationE4(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("E5")) {
      visualizers.draw.basicVegetationE5(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("F1")) {
      visualizers.draw.basicVegetationF1(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("F2")) {
      visualizers.draw.basicVegetationF2(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("F3")) {
      visualizers.draw.basicVegetationF3(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("F4")) {
      visualizers.draw.basicVegetationF4(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("F5")) {
      visualizers.draw.basicVegetationF5(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("G1")) {
      visualizers.draw.basicVegetationG1(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("G2")) {
      visualizers.draw.basicVegetationG2(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("G3")) {
      visualizers.draw.basicVegetationG3(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("G4")) {
      visualizers.draw.basicVegetationG4(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else if (variable.ofVariation("G5")) {
      visualizers.draw.basicVegetationG5(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    } else {
      visualizers.draw.basicVegetationA1(
        variable.val("s", iteration),
        variable.val("h", iteration)
      );
    }

    visualizers.done();
  }
}
