void setupExamples() {
  entities.addTrackers("beats");
  palette.add("background", style.flat.black, style.flat.grey);
  palette.add("stroke", style.flat.white);
}

void updateExamples() {
  entities.update();
}

void drawExamples() {
  stroke(palette.get("stroke"));
  background(palette.get("background", analysis.getLevel()));
  noFill();
  strokeWeight(style.defaultStrokeWeight);

  emitters
    .useTrackers("beats")
      .emitBeatAngles(4, Ani.CUBIC_IN_OUT, 4, 90);

  visualizers
    .create()
    .center().middle()
    .useTrackers("beats")
    .draw.trackerConnectedRings(analysis.getLevel() * 100, oavp.STAGE_WIDTH / 2)
    .rotate(0, 0, 180)
    .draw.trackerConnectedRings(analysis.getLevel() * 100, oavp.STAGE_WIDTH / 2)
    .done();
}