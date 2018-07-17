void setupSketch() {
  entities.addCamera("default");
  entities.addToggle("example");
}

void updateSketch() {

  entities.useCamera("default");
}

void drawSketch() {

  palette.reset(palette.flat.white, palette.flat.black, palette.flat.black, 2);

  visualizers
    .create().center().middle()
    .draw.centeredSvg("test-logo", 2)
    .next().center().middle()
    .moveBackward(20).moveRight(analysis.getLevel() * 50)
    .startStyle()
      .fillColor(palette.flat.blue, entities.getToggle("example").getValue())
      .draw.centeredSvg("test-logo", 2)
    .endStyle()
    .next().center().middle()
    .moveBackward(40).moveLeft(analysis.getLevel() * 50)
    .startStyle()
      .fillColor(palette.flat.red, entities.getToggle("example").getValue())
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
  if (key == 'q') {
    entities.getToggle("example").softToggle();
  }
  if (key == 'e') {
    entities.getToggle("example").toggle();
  }
}