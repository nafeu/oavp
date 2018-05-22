boolean toggle = false;

void setupExamples() {
  entities.addTrackers("beats");
  entities.addCounter("beats", 2);
  palette.add("stroke", palette.flat.white);
}

void updateExamples() {
  entities.update();
  entities.updateCounter("beats", analysis.isBeatOnset());
  if (entities.checkCounter("beats")) {
    if (toggle) {
      palette.setRotatingColor(palette.flat.black, 0.3, Ani.SINE_IN_OUT);
    } else {
      palette.setRotatingColor(palette.flat.white, 0.3, Ani.SINE_IN_OUT);
    }
    toggle = !toggle;
    entities.incrementCounter("beats");
  }
}

void drawExamples() {
  stroke(palette.get("stroke"));
  background(palette.getRotatingColor());
  noFill();
  strokeWeight(2);

  emitters
    .useTrackers("beats")
      .emitBeatAngles(2, Ani.SINE_IN_OUT, 4, 90);

  visualizers
    .create()
    .center().middle()
    .useTrackers("beats")
    .draw.trackerConnectedRings(analysis.getLevel() * oavp.STAGE_WIDTH / 8, oavp.STAGE_WIDTH / 4)
    .done();
}