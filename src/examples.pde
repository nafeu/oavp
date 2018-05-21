void setupExamples() {
  entities.addTrackers("beats");
  palette.add("background", style.flat.black);
  palette.add("stroke", style.flat.white);
}

void updateExamples() {
  entities.update();
}

void drawExamples() {
  stroke(palette.get("stroke"));
  background(palette.get("background"));
  noFill();
  strokeWeight(style.defaultStrokeWeight);

  emitters
    .useTrackers("beats")
      .emitBeatAngles(4, Ani.LINEAR, 3);

  visualizers
    .create()
    .center().middle()
    .useTrackers("beats")
      .draw.trackerConnectedRings(25, oavp.STAGE_WIDTH)
      .done();
}