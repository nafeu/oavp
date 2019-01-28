void setupSketch() {
  entities.addEmissions("a");
  entities.addEmissions("b");
  entities.addEmissions("c");
}

void updateSketch() {}

void drawSketch() {
  palette.reset(palette.flat.white, palette.flat.red, 2);

  visualizers
    .create()
    .center().middle()
    .dimensions(oavp.width(0.2), oavp.width(0.1))
    .useEmissions("a")
    .startStyle()
      .strokeColor(palette.flat.blue)
      .draw.emissionSplashSquare(oavp.width(0.4))
    .endStyle()
    .useEmissions("b")
    .startStyle()
      .strokeColor(palette.flat.green)
      .draw.emissionSplashCircle(oavp.width(0.4))
    .endStyle()
    .useEmissions("c")
    .startStyle()
      .strokeColor(palette.flat.red)
      .rotate(0, 0, 90)
      .draw.emissionChevron(oavp.width(0.2))
      .rotate(0, 0, 180)
      .draw.emissionChevron(oavp.width(0.2))
    .endStyle()
    .done();
}

void keyPressed() {
  if (key == 'q') { emitters.useEmissions("a").emit(); }
  if (key == 'w') { emitters.useEmissions("b").emit(); }
  if (key == 'e') { emitters.useEmissions("c").emit(); }
}
