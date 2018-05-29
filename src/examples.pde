void setupExamples() {
  noiseSeed(1);

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
  entities.updateNoise("landscape", "hill_a", normalMouseX * 250 + 250);
  entities.updateNoise("landscape", "hill_b", normalMouseX * 500 + 500);
  entities.updateNoise("landscape", "hill_c", normalMouseX * 750 + 750);
  entities.updateNoise("landscape", "hill_d", normalMouseX * 1000 + 1000);
}

void drawExamples() {
  float sunX = 125 + normalMouseX * (oavp.STAGE_WIDTH - 250);
  float sunY = normalMouseY * 100 + 150;

  background(palette.flat.white);
  stroke(palette.flat.black);
  fill(palette.flat.white);
  strokeWeight(2);

  ellipse(sunX, sunY, 10 + normalMouseY * 100 , 10 + normalMouseY * 100);

  translate(0, 0, 2);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 0.25, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_a"));
  shapes.trees(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 0.25, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_a"), entities.getNoise("landscape").getStructure("hill_a"));
  translate(0, 0, 2);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 0.5, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_b"));
  shapes.trees(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 0.5, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_b"), entities.getNoise("landscape").getStructure("hill_b"));
  translate(0, 0, 2);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 0.75, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_c"));
  shapes.trees(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 0.75, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_c"), entities.getNoise("landscape").getStructure("hill_c"));
  translate(0, 0, 2);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 1, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_d"));
  shapes.trees(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, normalMouseY * oavp.STAGE_HEIGHT * 1, oavp.STAGE_HEIGHT / 2, entities.getNoise("landscape").getTerrain("hill_d"), entities.getNoise("landscape").getStructure("hill_d"));
}