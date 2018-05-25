void setupExamples() {
  entities.addRhythm("beats", minim, 60, 1);
  entities.addCounter("beats")
    .limit(4);
  entities.addRotator("beats")
    .addCombinations(0, 1, 4);
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
    .center().middle()
    .move(entities.getRotator("beats").getX() * oavp.STAGE_WIDTH / 2, entities.getRotator("beats").getY() * oavp.STAGE_WIDTH / 2)
    .draw.basicSquare(oavp.STAGE_WIDTH / 8)
    .done();
}