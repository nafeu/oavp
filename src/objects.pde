String[] OBJECT_LIST = {
  // "Image",
  "Line",
  "CurvedLine",
  "Rectangle",
  "Shader",
  "Spectrum",
  "RadialSpectrum",
  "Waveform",
  "Circle",
  "Triangle",
  "Box",
  "Flatbox",
  "Bullseye",
  "Splash",
  "SpectrumMesh",
  "ZRectangles",
  "GridInterval",
  // "Lyrics",
  "Terrain"
};

String[] SHADER_LIST = {
  "test-shader",
  "test-shader-2"
};

public OavpObject createObject(String className) {
  OavpObject object;

  switch (className) {
    case "Image": object = new OavpObjImage(); break;
    case "Line": object = new OavpObjLine(); break;
    case "CurvedLine": object = new OavpObjCurvedLine(); break;
    case "Rectangle": object = new OavpObjRectangle(); break;
    case "Shader": object = new OavpObjShader(); break;
    case "Spectrum": object = new OavpObjSpectrum(); break;
    case "RadialSpectrum": object = new OavpObjRadialSpectrum(); break;
    case "Waveform": object = new OavpObjWaveform(); break;
    case "Circle": object = new OavpObjCircle(); break;
    case "Triangle": object = new OavpObjTriangle(); break;
    case "Box": object = new OavpObjBox(); break;
    case "Flatbox": object = new OavpObjFlatbox(); break;
    case "Bullseye": object = new OavpObjBullseye(); break;
    case "Splash": object = new OavpObjSplash(); break;
    case "SpectrumMesh": object = new OavpObjSpectrumMesh(); break;
    case "ZRectangles": object = new OavpObjZRectangles(); break;
    case "GridInterval": object = new OavpObjGridInterval(); break;
    case "Lyrics": object = new OavpObjLyrics(); break;
    case "Terrain": object = new OavpObjTerrain(); break;
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

        Object fieldValue = field.get(this.variable);
        Object fieldModValue = fieldMod.get(this.variable);
        Object fieldModTypeValue = fieldModType.get(this.variable);

        cloneVariable.set(fieldName, fieldValue);
        cloneVariable.set(fieldName + "Mod", fieldModValue);
        cloneVariable.set(fieldName + "ModType", fieldModTypeValue);
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
  public void draw() {}
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

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .use(variable)
      .draw.basicRectangle(
        variable.val("w"),
        variable.val("h"),
        variable.val("paramA")
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

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .noStrokeStyle()
      .use(variable);

    visualizers.useShader(variable.name + (String) variable.customAttrs.get("shader"));
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
      .set("s", 100)
      .set("strokeColor", palette.flat.white);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .use(variable);

    if (variable.ofVariation("equilateral")) {
      visualizers.draw.basicEquilateralTriangle(variable.val("s"));
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
        "diagonal"
      )
      .set("w", 100)
      .set("h", 100)
      .set("s", 0)
      .set("strokeColor", palette.flat.white);
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
    } else {
      visualizers.draw.basicHorizontalLine(variable.val("w"), variable.val("h"), variable.val("l"), variable.val("s"));
    }

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

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .use(variable);

    if (variable.ofVariation("two-point")) {
      visualizers.draw.basicCurvedLine(
        variable.val("w"),
        variable.val("paramA"),
        variable.val("paramB"),
        variable.val("paramC"),
        variable.val("paramD"),
        map(variable.val("s"), -1000, 1000, -5.0, 5.0)
      );
    } else {
      visualizers.draw.basicCurvedLine(
        variable.val("w"),
        variable.val("paramA"),
        variable.val("paramB"),
        map(variable.val("s"), -1000, 1000, -5.0, 5.0)
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

  public void draw() {
    visualizers
      .startStyle()
      .create()
      .center().middle()
      .use(variable);

    if (variable.ofVariation("wire")) {
      visualizers.draw.basicSpectrumRadialWire(
        variable.val("s"),
        variable.val("l"),
        0
      );
    } else {
      visualizers.draw.basicSpectrumRadialBars(
        variable.val("paramA"),
        variable.val("s"),
        variable.val("l"),
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

  public void draw() {
    visualizers
      .startStyle()
      .create()
      .center().middle()
      .use(variable)
      .moveLeft(variable.val("w") / 2);

    if (variable.ofVariation("right-channel")) {
      visualizers.draw.basicRightWaveformWire(variable.val("s"));
    } else {
      visualizers.draw.basicLeftWaveformWire(variable.val("s"));
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

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .use(variable)
      .draw.basicCircle(variable.val("s"))
      .done();
  }
}

public class OavpObjSvg extends OavpObject {
  public void setup() {
    variable
      .set("s", 100)
      .set("svgName", variable.name);
  }

  public void draw() {
    visualizers
      .create()
      .center().middle()
      .use(variable)
      .draw.centeredSvg(variable.customAttrs.get("svgName"), variable.val("s") / 100)
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
      .set("w", 100)
      .set("h", 100)
      .set("l", 100)
      .set("strokeColor", palette.flat.white)
      .set("fillColor", palette.flat.black);
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

  public void draw() {
    if (variable.ofVariation("spacebar")) {
      visualizers.useInterval("spacebar-pulser-interval");
    } else {
      visualizers.useInterval(variable.customAttrs.get("varName"));
    }

    visualizers
      .create()
      .center().middle()
      .use(variable);

    if (variable.ofVariation("rectangular")) {
      visualizers.draw.intervalBullseyeRectangle(variable.val("w"), variable.val("h"), 10);
    } else if (variable.ofVariation("boxed")) {
      visualizers.draw.intervalBullseyeBox(variable.val("w"), variable.val("h"), variable.val("l"), 10);
    } else {
      visualizers.draw.intervalBullseyeCircle(variable.val("s"), 10);
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

  public void draw() {
    boolean useSpacebar = variable.val("paramA") > 0;

    if (useSpacebar) {
      float triggerCadence = variable.val("paramB");

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
      .use(variable);

    if (variable.ofVariation("rectangular")) {
      visualizers.draw.emissionSplashRectangle(variable.val("w"), variable.val("h"));
    } else if (variable.ofVariation("boxed")) {
      visualizers.draw.emissionSplashBox(variable.val("w"), variable.val("h"), variable.val("l"));
    } else {
      visualizers.draw.emissionSplashCircle(variable.val("s"));
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

  public void draw() {
    visualizers
      .useInterval(variable.name)
      .create()
      .center().middle()
      .use(variable)
      .moveLeft(variable.val("w") / 2)
      .moveUp(variable.val("h") / 2);

    if (variable.ofVariation("dotted")) {
      visualizers.draw.intervalSpectrumPoints(variable.val("s"), 2);
    } else if (variable.ofVariation("z-lines")) {
      visualizers.draw.intervalSpectrumZLines(variable.val("s"), 2);
    } else if (variable.ofVariation("x-lines")) {
      visualizers.draw.intervalSpectrumXLines(variable.val("s"), 2);
    } else {
      visualizers.draw.intervalSpectrumMesh(variable.val("s"), 2);
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
            oscillate(-variable.val("s"), variable.val("s"), 0.015 - (0.001 * i)),
            radius
          );
      } else {
        visualizers
          .draw.basicZRectangle(
            variable.val("w") * (1.00 - (gap * i)),
            variable.val("h") * (1.00 - (gap * i)),
            oscillate(-variable.val("s"), variable.val("s"), 0.015 - (0.001 * i))
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

  public void draw() {
    visualizers
      .useGridInterval(variable.name)
      .create()
      .center().middle()
      .use(variable)
      .moveLeft(variable.w / 2)
      .moveUp(variable.h / 2);

    if (variable.ofVariation("circular")) {
      visualizers.draw.gridIntervalCircles();
    } else if (variable.ofVariation("flatbox")) {
      visualizers.draw.gridIntervalFlatboxes(variable.val("l"), variable.strokeColor(), variable.fillColor());
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

  public void draw() {
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

  public void draw() {
    String imageName = (String) variable.customAttrs.get("image");

    float opacity = 1.0;

    if (variable.val("paramA") > 0) {
      opacity = 1 - constrain(variable.val("paramA") / 100, 0, 1.0);
    } else if (variable.val("paramA") < 0) {
      opacity = constrain(abs(variable.val("paramA")) / 100, 0, 1.0);
    }

    visualizers.create()
      .center().middle()
      .use(variable)
      .draw.img(
        imageName,
        max(variable.val("s") / 100, 0),
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

  public void draw() {
    float scale = variable.val("s");
    float displacement = variable.val("paramA");
    int window = max(1, int(variable.val("paramB")));
    int phaseShift = max(1, int(variable.val("paramC")));
    float position = max(0, variable.val("paramD"));

    visualizers
      .useTerrain(variable.name)
      .create()
      .center().middle()
      .use(variable)
      .moveLeft(variable.val("w") / 2)
      .moveUp(variable.val("h") / 2);

    if (variable.ofVariation("trees")) {
      visualizers.draw.terrainTrees(scale, displacement, window, phaseShift, position);
    } else {
      visualizers.draw.terrainHills(scale, displacement, window, phaseShift, position);
    }

    visualizers.done();
  }
}
