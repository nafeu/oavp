void setupExamples() {
  entities.addCamera("default");

  entities.addRhythm("clock")
    .start();

  entities.addRotator("movement")
    .duration(0.5)
    .easing(Ani.QUAD_IN_OUT)
    .add(0, 0)
    .add(0, 1)
    .add(1, 1)
    .add(1, 0);
}

void updateExamples() {
  entities.getRotator("movement").rotateIf(entities.onRhythm("clock"));

  entities.useCamera("default");
}

void drawExamples() {
  palette.reset(palette.flat.black, palette.flat.white, 2);

  visualizers
    .create()
    .center().middle()
    .moveLeft(oavp.width(0.25))
    .moveUp(oavp.width(0.25))
    .moveRight(entities.getRotator("movement").getX() * oavp.width(0.5))
    .moveDown(entities.getRotator("movement").getY() * oavp.width(0.5))
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