void setupSketch() {
  entities.addCamera("default");
}

void updateSketch() {

  entities.useCamera("default");
}

void drawSketch() {
  palette.reset(palette.flat.black, palette.flat.white, 2);
  fill(palette.flat.white);

  visualizers
    .create()
    .center().middle()
    .draw.centeredSvg("test-logo", normalMouseX)
    .done();

  visualizers
    .create()
    .center().middle()
    .moveBackward(5)
    .moveUp(analysis.getLevel() * 100)
    .startStyle()
      .fillColor(palette.flat.red)
      .draw.centeredSvg("test-logo", normalMouseY)
    .endStyle()
    .done();

  visualizers
    .create()
    .center().middle()
    .moveBackward(10)
    .moveDown(analysis.getLevel() * 100)
    .startStyle()
      .fillColor(palette.flat.yellow)
      .draw.centeredSvg("test-logo", normalMouseY)
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