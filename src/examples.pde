void setupExamples() {
  entities.addTrackers("beatsA");
  entities.addTrackers("beatsB");
  entities.addTrackers("beatsC");
  palette.add("stroke", palette.flat.white);
  palette.setRotatingColorByPosition(entityPosition, 5, 0.3, Ani.SINE_IN_OUT);
}

void updateExamples() {
  entities.update();
}

void drawExamples() {
  stroke(palette.get("stroke"));
  background(palette.getRotatingColor());
  noFill();
  strokeWeight(2);

  emitters
    .useTrackers("beatsA")
      .emitBeatAngles(2, Ani.SINE_IN_OUT, 3, 90)
    .useTrackers("beatsB")
      .emitBeatAngles(2, Ani.SINE_IN_OUT, 4, 90)
    .useTrackers("beatsC")
      .emitBeatAngles(2, Ani.SINE_IN_OUT, 5, 45);

  visualizers
    .create()
    .center().middle()
    .useTrackers("beatsA")
    .draw.trackerConnectedRings(analysis.getLevel() * oavp.STAGE_WIDTH / 8, oavp.STAGE_WIDTH / 4)
    .done();

  entityPosition.moveRight();

  visualizers
    .create()
    .center().middle()
    .useTrackers("beatsB")
    .draw.trackerConnectedRings(analysis.getLevel() * oavp.STAGE_WIDTH / 8, oavp.STAGE_WIDTH / 4)
    .done();

  entityPosition.moveRight();

  visualizers
    .create()
    .center().middle()
    .useTrackers("beatsC")
    .draw.trackerConnectedRings(analysis.getLevel() * oavp.STAGE_WIDTH / 8, oavp.STAGE_WIDTH / 4)
    .done();

  entityPosition.reset();
}