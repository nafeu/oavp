void setupExamples() {
  entities.addCamera("default");

  entities.addOscillator("example")
    .duration(2)
    .easing(Ani.QUAD_IN_OUT)
    .start();
}

void updateExamples() {

  entities.useCamera("default");
}

void drawExamples() {
  palette.reset(palette.flat.black, palette.flat.white, 2);

  visualizers
    .create()
    .top().left()
    .moveDown(oavp.width(0.25))
    .moveRight(oavp.width(0.25))
    .moveRight(oavp.width(0.5) * entities.getOscillator("example").getValue())
    .draw.basicSquare(oavp.width(0.25))
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