void setupExamples() {
  entities.addCamera("default");
  entities.addTerrain("example");
  entities.addOscillator("camera")
    .duration(5)
    .easing(Ani.SINE_IN_OUT)
    .start();
}

void updateExamples() {
  entities.getCamera("default").rotateAroundX(frameCount(0.5), oavp.width(0.5));

  entities.useCamera("default");
}

void drawExamples() {
  palette.reset(palette.flat.black, palette.flat.white, 2);

  visualizers
    .useTerrain("example")
    .create()
    .dimensions(oavp.w, oavp.h)
    .top().left()
    .startStyle()
      .fillColor(palette.flat.black)
      .draw.basicHills(oavp.height(0.1), oavp.height(0.5), 100, 0, frameCount(0.1))
      .moveForward(2)
      .draw.basicHills(oavp.height(0.3), oavp.height(0.55), 100, 1000, frameCount(0.3))
      .moveForward(2)
      .draw.basicHills(oavp.height(0.2), oavp.height(0.7), 100, 2000, frameCount(0.7))
    .endStyle()
    .done();
}