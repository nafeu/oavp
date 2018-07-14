void setupSketch() {
  entities.addCamera("default");
}

void updateSketch() {

  entities.useCamera("default");
}

void drawSketch() {
  palette.reset(palette.flat.black, palette.flat.white, palette.flat.white, 2);

  visualizers
    .create()
    .center().middle()
    .draw.centeredSvg("test-logo", 2)
    .done();

  visualizers
    .create()
    .center().middle()
    .moveBackward(5)
    .moveRight(analysis.getLevel() * 100)
    .startStyle()
      .fillColor(palette.flat.blue, oscillate(0, 1, 0.025))
      .draw.centeredSvg("test-logo", 2)
    .endStyle()
    .done();

  visualizers
    .create()
    .center().middle()
    .moveBackward(10)
    .moveLeft(analysis.getLevel() * 100)
    .startStyle()
      .fillColor(palette.flat.red, oscillate(0, 1, 0.05))
      .draw.centeredSvg("test-logo", 2)
    .endStyle()
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