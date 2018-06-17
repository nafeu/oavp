void setupExamples() {
  entities.addCamera("default");
  entities.addTerrain("example");
  entities.getCamera("default")
    .duration(1)
    .easing(Ani.QUAD_IN_OUT);
}

void updateExamples() {

  entities.useCamera("default");
}

void drawExamples() {
  palette.reset(palette.flat.black, palette.flat.white, 2);

  visualizers
    .useTerrain("example")
    .create()
    .dimensions(oavp.w, oavp.h)
    .top().left()
      .draw.basicHills(oavp.height(0.1), oavp.height(0.5), 100, 0, frameCount(0.1))
      .moveForward(2)
      .draw.basicHills(oavp.height(0.3), oavp.height(0.55), 100, 1000, frameCount(0.3))
      .moveForward(2)
      .draw.basicHills(oavp.height(0.2), oavp.height(0.7), 100, 2000, frameCount(0.7))
    .done();
}

void keyPressed() {
  if (key == 'W') {
    entities.getCamera("default").moveForward(250);
  }
  if (key == 'S') {
    entities.getCamera("default").moveBackward(250);
  }
  if (key == 'w') {
    entities.getCamera("default").moveUp(250);
  }
  if (key == 's') {
    entities.getCamera("default").moveDown(250);
  }
  if (key == 'a') {
    entities.getCamera("default").moveLeft(250);
  }
  if (key == 'd') {
    entities.getCamera("default").moveRight(250);
  }
}