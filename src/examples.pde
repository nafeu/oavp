void setupExamples() {
  entities.addRhythm("beats")
    .start();
  entities.addCounter("beats")
    .duration(0.5)
    .easing(Ani.BOUNCE_OUT);
  entities.addRotator("beats")
    .duration(1)
    .easing(Ani.SINE_IN_OUT)
    .add(0, 0)
    .add(1, 0)
    .add(1, 1)
    .add(0, 1);
}

void updateExamples() {
  entities.update();
  entities.rotateRotatorIf("beats", entities.onRhythm("beats"));
  entities.incrementCounterIf("beats", entities.onRhythm("beats"));
}

void drawExamples() {
  stroke(palette.flat.black);
  background(palette.flat.white);
  noFill();
  strokeWeight(2);

  visualizers
    .create()
    .left().top()
    .moveRight(oavp.STAGE_WIDTH / 8)
    .moveDown(oavp.STAGE_WIDTH / 8)
    .move(entities.getRotator("beats").getX() * oavp.STAGE_WIDTH / 2, entities.getRotator("beats").getY() * oavp.STAGE_WIDTH / 2)
    .rotate(0, 0, entities.getCounter("beats").getValue() * 45)
    .draw.basicSquare(oavp.STAGE_WIDTH / 8)
    .done();
}