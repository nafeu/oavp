void setupSketch() {
  entities.addCamera("default");

  entities.addPulser("a").duration(1).easing(Ani.QUAD_IN_OUT);
  entities.addGridInterval("a", 5, 5).delay(1);

  palette.add("a", palette.getRandomColor());
  palette.add("b", palette.getRandomColor());
  palette.add("c", palette.getRandomColor());
  palette.add("d", palette.getRandomColor());
  palette.add("bg", palette.getRandomColor());
  println(palette.get("a"));
  println(palette.get("b"));
  println(palette.get("c"));
  println(palette.get("d"));
  println(palette.get("bg"));
}

void updateSketch() {
  entities.getGridInterval("a").updateDimensional(entities.getPulser("a").getValue());

  entities.useCamera("default");
}

void drawSketch() {
  palette.reset(palette.get("bg"), palette.flat.white, 2);

  visualizers
    .create()
    .center().middle()
    .moveRight(10)
    .dimensions(oavp.width(0.4), oavp.height(0.4))
    .useGridInterval("a")
    .startStyle()
    .noStrokeStyle()
      .fillColor(palette.get("a"))
      .draw.gridIntervalDiamond()
    .moveLeft(oavp.width(0.4))
      .fillColor(palette.get("b"))
      .draw.gridIntervalDiamond()
    .rotate(0, 0, -180)
    .moveLeft(oavp.width(0.4))
      .fillColor(palette.get("c"))
      .draw.gridIntervalDiamond()
    .moveLeft(oavp.width(0.4))
      .fillColor(palette.get("d"))
      .draw.gridIntervalDiamond()
    .endStyle()
    .done();

  visualizers
    .create()
    .center().middle()
    .dimensions(oavp.width(0.4), oavp.height(0.4))
    .useGridInterval("a")
    .startStyle()
    .noStrokeStyle()
      .fillColor(palette.get("d"))
      .draw.gridIntervalDiamond()
    .moveLeft(oavp.width(0.4))
      .fillColor(palette.get("a"))
      .draw.gridIntervalDiamond()
    .rotate(0, 0, -180)
    .moveLeft(oavp.width(0.4))
      .fillColor(palette.get("b"))
      .draw.gridIntervalDiamond()
    .moveLeft(oavp.width(0.4))
      .fillColor(palette.get("c"))
      .draw.gridIntervalDiamond()
    .endStyle()
    .done();
}

void keyPressed() {
  if (key == 'q') {
    entities.getPulser("a").pulse();
  }
  if (key == 'w') {
    palette.add("a", palette.getRandomColor());
    palette.add("b", palette.getRandomColor());
    palette.add("c", palette.getRandomColor());
    palette.add("d", palette.getRandomColor());
    palette.add("bg", palette.getRandomColor());
    println(palette.get("a"));
    println(palette.get("b"));
    println(palette.get("c"));
    println(palette.get("d"));
    println(palette.get("bg"));
  }
}