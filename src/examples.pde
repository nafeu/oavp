void setupExamples() {
  entities.addCamera("default");

  entities.addRhythm("example")
    .start();

  entities.addPulser("example")
    .duration(0.5)
    .easing(Ani.QUAD_IN_OUT);
}

void updateExamples() {

  entities.getPulser("example").pulseIf(entities.onRhythm("example"));

  entities.useCamera("default");
}

void drawExamples() {
  palette.reset(palette.flat.black, palette.flat.white, 2);

  visualizers
    .create()
    .center().middle()
    .rotateClockwise(frameCount(0.25))
    .draw.basicSquare(oavp.width(0.5) * entities.getPulser("example").getValue())
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