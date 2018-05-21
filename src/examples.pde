void setupExamples() {
  entities.addAmplitude("beat", 1, Ani.LINEAR);
  palette.add("background", style.flat.black);
  palette.add("stroke", style.flat.white);
}

void updateExamples() {
  entities.update();

  entities.getAmplitude("beat").update(oavpData.isBeatOnset());
}

void drawExamples() {
  stroke(palette.get("stroke"));
  background(palette.get("background"));
  noFill();
  strokeWeight(style.defaultStrokeWeight);

  visualizers
    .create()
    .center().middle()
    .beats.square(oavp.STAGE_WIDTH, entities.getAmplitude("beat"))
    .done();
}