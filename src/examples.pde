void setupExamples() {
  entities.addRhythm("metronome", minim, 120, 1);
  entities.addTracker("beats");
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

  visualizers
    .create()
    .center().middle()
    .emitters.rhythm(1, Ani.LINEAR, entities.getRhythm("metronome"), entities.getTracker("beats"))
    .floaters.splashSquare(oavp.STAGE_WIDTH, entities.getTracker("beats"))
    .done();
}