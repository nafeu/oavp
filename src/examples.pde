void setupExamples() {
  entities.addRhythm("beats", minim, 60, 1);
  entities.addTrackers("beats");
  entities.addRotator("beats")
    .duration(1)
    .easing(Ani.SINE_IN_OUT)
    .add(250)
    .add(500)
    .add(100);
  entities.addCounter("beats")
    .duration(1)
    .easing(Ani.SINE_IN_OUT);

  palette.add("background", palette.flat.black, palette.flat.white);
}

void updateExamples() {
  entities.update();
  entities.rotateRotatorIf("beats", analysis.isBeatOnset());
  entities.incrementCounterIf("beats", analysis.isBeatOnset());
  emitters
    .useTrackers("beats")
    .emitBeatAngles(2, Ani.SINE_IN_OUT, 3, 90);
  palette.setRotatingColorIf(analysis.isBeatOnset(), palette.getRandomColor(), 0.5, Ani.SINE_IN_OUT);
}

void drawExamples() {
  stroke(palette.getRotatingColor());
  background(palette.flat.black);
  noFill();
  strokeWeight(2);

  visualizers
    .create()
    .left().middle()
    .moveRight(entities.getRotator("beats").getValue())
    .rotate(0, 0, entities.getCounter("beats").getValue() * 45)
    .draw.basicSquare(oavp.STAGE_WIDTH / 4)
    .done()
    .create()
    .right().middle()
    .moveLeft(entities.getRotator("beats").getValue())
    .rotate(0, 0, -entities.getCounter("beats").getValue() * 45)
    .draw.basicSquare(oavp.STAGE_WIDTH / 4)
    .done()
    .create()
    .left().middle()
    .moveRight(entities.getRotator("beats").getValue() * 0.5)
    .rotate(0, 0, entities.getCounter("beats").getValue() * 45)
    .draw.basicSquare(oavp.STAGE_WIDTH / 8)
    .done()
    .create()
    .right().middle()
    .moveLeft(entities.getRotator("beats").getValue() * 0.5)
    .rotate(0, 0, -entities.getCounter("beats").getValue() * 45)
    .draw.basicSquare(oavp.STAGE_WIDTH / 8)
    .done();

  visualizers
    .create()
    .center().top()
    .moveDown(entities.getRotator("beats").getValue())
    .rotate(0, 0, entities.getCounter("beats").getValue() * 45)
    .draw.basicSquare(oavp.STAGE_WIDTH / 4)
    .done()
    .create()
    .center().bottom()
    .moveUp(entities.getRotator("beats").getValue())
    .rotate(0, 0, -entities.getCounter("beats").getValue() * 45)
    .draw.basicSquare(oavp.STAGE_WIDTH / 4)
    .done()
    .create()
    .center().top()
    .moveDown(entities.getRotator("beats").getValue() * 0.5)
    .rotate(0, 0, entities.getCounter("beats").getValue() * 45)
    .draw.basicSquare(oavp.STAGE_WIDTH / 8)
    .done()
    .create()
    .center().bottom()
    .moveUp(entities.getRotator("beats").getValue() * 0.5)
    .rotate(0, 0, -entities.getCounter("beats").getValue() * 45)
    .draw.basicSquare(oavp.STAGE_WIDTH / 8)
    .done();

  visualizers
    .create()
    .center().middle()
    .rotate(0, 0, 90)
    .useTrackers("beats")
    .draw.trackerConnectedRings(analysis.getLevel() * 100, oavp.STAGE_WIDTH / 2)
    .done();

  visualizers
    .create()
    .center().middle()
    .rotate(0, 0, -90)
    .useTrackers("beats")
    .draw.trackerConnectedRings(analysis.getLevel() * 100, oavp.STAGE_WIDTH / 2)
    .done();
}