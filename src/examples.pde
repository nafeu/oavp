void setupExamples() {
  entities.addTrackers("beats");
  entities.addColorRotator("beats")
    .add(palette.flat.red)
    .add(palette.flat.orange)
    .add(palette.flat.yellow);
}

void updateExamples() {
  entities.update();
  entities.rotateColorRotatorIf("beats", analysis.isBeatOnset());
  emitters
    .useTrackers("beats")
    .duration(2)
    .easing(Ani.SINE_IN_OUT)
    .emitRandomColorAngles(entities.getColorRotator("beats").getColor(), 5, analysis.isBeatOnset());
}

void drawExamples() {
  background(palette.flat.black);
  noStroke();
  noFill();
  strokeWeight(analysis.getLevel() * 12);

  visualizers
    .useTrackers("beats")
    .create()
    .center().middle()
    .draw.trackerColorConnectedRings(analysis.getLevel() * 120, oavp.STAGE_WIDTH / 2)
    .done();
}