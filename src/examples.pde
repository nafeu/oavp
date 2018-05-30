void setupExamples() {
  noiseSeed(1);

  entities.addRhythm("clock")
    .start();

  entities.addCounter("shifter")
    .duration(1)
    .easing(Ani.SINE_IN_OUT);

  entities.addNoise("landscape")
    .numPoints(100)
    .granularity(0.015)
    .variance(5)
    .generate("hill_a")
    .generate("hill_b")
    .generate("hill_c")
    .generate("hill_d");
}

void updateExamples() {
  entities.update();
  entities.incrementCounterIf("shifter", entities.onRhythm("clock"));
  entities.updateNoise("landscape", "hill_a", entities.getCounter("shifter").getValue() * 10);
  entities.updateNoise("landscape", "hill_b", entities.getCounter("shifter").getValue() * 20);
  entities.updateNoise("landscape", "hill_c", entities.getCounter("shifter").getValue() * 30);
  entities.updateNoise("landscape", "hill_d", entities.getCounter("shifter").getValue() * 40);
}

void drawExamples() {
  background(palette.flat.white);
  stroke(palette.flat.black);
  fill(palette.flat.white);
  strokeWeight(2);

  shapes.dots(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 0.25, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_a"));
  shapes.trees(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 0.25, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_a"), entities.getNoise("landscape").getStructure("hill_a"));
  translate(0, 0, 20);
  shapes.dots(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 0.5, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_b"));
  shapes.trees(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 0.5, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_b"), entities.getNoise("landscape").getStructure("hill_b"));
  translate(0, 0, 20);
  shapes.dots(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 0.75, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_c"));
  shapes.trees(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 0.75, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_c"), entities.getNoise("landscape").getStructure("hill_c"));
  translate(0, 0, 20);
  shapes.dots(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 1, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_d"));
  shapes.trees(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 1, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_d"), entities.getNoise("landscape").getStructure("hill_d"));
}