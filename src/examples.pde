void setupExamples() {
  entities.addCamera("default");

  entities.addRhythm("clock")
    .start();

  entities.addCounter("spinner")
    .duration(0.5)
    .easing(Ani.QUAD_IN_OUT);
}

void updateExamples() {

  entities.getCounter("spinner").incrementIf(entities.onRhythm("clock"));

  entities.useCamera("default");
}

void drawExamples() {
  palette.reset(palette.flat.black, palette.flat.white, 2);

  visualizers
    .create()
    .center().middle()
    .rotateClockwise(entities.getCounter("spinner").getValue() * 22.5)
    .draw.basicSquare(oavp.width(0.5))
    .done();

  visualizers
    .create()
    .center().middle()
    .rotateClockwise(entities.getCounter("spinner").getCount() * 22.5)
    .draw.basicSquare(oavp.width(0.5))
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