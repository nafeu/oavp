String[] OBJECT_LIST = {
  "Rectangle",
  "RectangleSpectrum",
  "StaticCircle",
  "LiveCircle",
  "GhostSplash",
  "SpectrumMesh",
  "ZRectangles"
};

public OavpObject createObject(String className) {
  OavpObject object;

  switch (className) {
    case "Rectangle":
      object = new OavpObjRectangle();
      break;
    case "RectangleSpectrum":
      object = new OavpObjRectangleSpectrum();
      break;
    case "StaticCircle":
      object = new OavpObjStaticCircle();
      break;
    case "LiveCircle":
      object = new OavpObjLiveCircle();
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
      .strokeColor(variable.strokeColor)
      .fillColor(variable.fillColor)
      .strokeWeightStyle(variable.strokeWeight)
      .move(
        variable.x + (variable.xMod * getMod(variable.xModType)),
        variable.y + (variable.yMod * getMod(variable.yModType)),
        variable.z + (variable.zMod * getMod(variable.zModType))
      )
      .rotate(
        variable.xr + (variable.xrMod * getMod(variable.xrModType)),
        variable.yr + (variable.yrMod * getMod(variable.yrModType)),
        variable.zr + (variable.zrMod * getMod(variable.zrModType))
      )
      .draw.basicRectangle(
        variable.w + (variable.wMod * getMod(variable.wModType)),
        variable.h + (variable.hMod * getMod(variable.hModType)),
        variable.size + (variable.sizeMod * getMod(variable.sizeModType)))
      .done();
  }
}

public class OavpObjRectangleSpectrum extends OavpObject {
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

public class OavpObjStaticCircle extends OavpObject {
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

public class OavpObjLiveCircle extends OavpObject {
  public void setup() {
    variable
      .size(100)
      .set("size-mod", 100)
      .strokeColor(palette.flat.white);
  }

  public void draw() {
    float sizeModifier = analysis.getLevel();

    visualizers
      .create()
      .center().middle()
      .strokeColor(variable.strokeColor)
      .fillColor(variable.fillColor)
      .move(variable.x, variable.y, variable.z)
      .rotate(variable.xr, variable.yr, variable.zr)
      .draw.basicCircle(variable.size + (variable.customIntAttrs.get("size-mod") * sizeModifier))
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
    // entities.addInterval(variable.customStringAttrs.get("varName"), 10, 1);
  }

  public void update() {
    entities.getPulser(variable.customStringAttrs.get("varName"))
      .pulseIf(analysis.isBeatOnset());
    emitters.useEmissions(variable.customStringAttrs.get("varName"))
      .emitIf(analysis.isBeatOnset());
    // entities.getInterval(variable.customStringAttrs.get("varName"))
    //   .update(entities.getPulser(variable.customStringAttrs.get("varName")).getValue());
  }

  public void draw() {
    // visualizers
    //   .useInterval(variable.customStringAttrs.get("varName"))
    //   .create()
    //   .center().middle()
    //   .strokeColor(variable.strokeColor)
    //   .fillColor(variable.fillColor)
    //   .move(variable.x, variable.y, variable.z)
    //   .rotate(variable.xr, variable.yr, variable.zr)
    //   .draw.intervalGhostCircle(0, variable.size * 2, 10)
    //   .done();

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