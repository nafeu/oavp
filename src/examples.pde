void setupExamples() {
  entities.addCamera("default");
  entities.addEmissions("example");
}

void updateExamples() {

  entities.useCamera("default");
}

void drawExamples() {
  palette.reset(palette.flat.black, palette.flat.white, 2);

  emitters
    .useEmissions("example")
    .duration(2)
    .easing(Ani.QUAD_IN_OUT)
    .emitIf(analysis.isBeatOnset());

  visualizers
    .useEmissions("example")
    .create()
    .center().middle()
    .draw.emissionSquare(oavp.width(0.25), oavp.width(0.5))
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