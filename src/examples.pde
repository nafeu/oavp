OavpRotator rotatorA;

void setupExamples() {
  entities.addRhythm("beats", minim, 30, 1);
  entities.addTrackers("beats");
  rotatorA = new OavpRotator();
  rotatorA
    .add(22.5)
    .add(45)
    .add(67.5)
    .add(90)
    .add(112.5)
    .add(135)
    .add(112.5)
    .add(90)
    .add(67.5)
    .add(45);
  rectMode(CENTER);
  ellipseMode(CENTER);
}

void updateExamples() {
  entities.update();
  rotatorA.rotateIf(entities.onRhythm("beats"), 2, Ani.SINE_IN_OUT);
}

void drawExamples() {
  stroke(palette.flat.white);
  background(palette.flat.black);
  noFill();
  strokeWeight(2);

  emitters
    .useRhythm("beats")
    .useTrackers("beats")
    .emitRhythmAngles(2, Ani.SINE_IN_OUT, 4, 90);

  visualizers
    .create()
    .center().middle()
    .useTrackers("beats")
    .rotate(0, 0, rotatorA.getValue())
    .draw.trackerConnectedRings(50, oavp.STAGE_WIDTH / 4)
    .draw.trackerChevron(rotatorA.getValue(), (rotatorA.getValue()) * 0.5, rotatorA.getValue())
    .rotate(0, 0, 90)
    .draw.trackerChevron(rotatorA.getValue(), (rotatorA.getValue()) * 0.5, rotatorA.getValue())
    .rotate(0, 0, 90)
    .draw.trackerChevron(rotatorA.getValue(), (rotatorA.getValue()) * 0.5, rotatorA.getValue())
    .rotate(0, 0, 90)
    .draw.trackerChevron(rotatorA.getValue(), (rotatorA.getValue()) * 0.5, rotatorA.getValue())
    .done();

  pushMatrix();
  translate(oavp.STAGE_WIDTH / 2, oavp.STAGE_HEIGHT / 2);
  rotateZ(radians(rotatorA.getValue()));
  rect(0, 0, rotatorA.getValue(), rotatorA.getValue());
  popMatrix();

  pushMatrix();
  translate(oavp.STAGE_WIDTH / 2, oavp.STAGE_HEIGHT / 2);
  rotateZ(radians(-rotatorA.getValue()));
  rect(0, 0, rotatorA.getValue(), rotatorA.getValue());
  popMatrix();

  pushMatrix();
  translate(oavp.STAGE_WIDTH / 2, oavp.STAGE_HEIGHT / 2);
  ellipse(0, 0, rotatorA.getValue(), rotatorA.getValue());
  popMatrix();

}