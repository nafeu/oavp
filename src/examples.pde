void setupExamples() {
  entities.addCamera("default")
    .duration(1)
    .easing(Ani.QUAD_IN_OUT);

  entities.addRhythm("seconds")
    .start();

  entities.addAmplitude("amplitude")
    .duration(0.5)
    .easing(Ani.QUAD_IN_OUT);
}

void updateExamples() {

  entities.getAmplitude("amplitude").update(entities.onRhythm("seconds"));

  entities.useCamera("default");
}

void drawExamples() {
  palette.reset(palette.flat.black, palette.flat.white, 2);

  visualizers
    .create()
    .center().middle()
    .draw.basicSquare(oavp.width(0.5) * entities.getAmplitude("amplitude").getValue())
    .done();
}

void keyPressed() {
  if (key == 'W') {
    entities.getCamera("default").moveForward(oavp.width(0.25));
  }
  if (key == 'S') {
    entities.getCamera("default").moveBackward(oavp.width(0.25));
  }
  if (key == 'w') {
    entities.getCamera("default").moveUp(oavp.width(0.25));
  }
  if (key == 's') {
    entities.getCamera("default").moveDown(oavp.width(0.25));
  }
  if (key == 'a') {
    entities.getCamera("default").moveLeft(oavp.width(0.25));
  }
  if (key == 'd') {
    entities.getCamera("default").moveRight(oavp.width(0.25));
  }
}