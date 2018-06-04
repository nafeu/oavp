void setupExamples() {
  noiseSeed(1);

  entities.addTerrain("terrain")
    .distance(oavp.STAGE_WIDTH)
    .numPoints(20)
    .generate("hill_a", 0);
}

void updateExamples() {
  entities.update();
  entities.updateTerrain("terrain", "hill_a", entities.mouseX(0, 40));
}

void drawExamples() {
  background(palette.flat.black);
  stroke(palette.flat.white);
  noFill();
  strokeWeight(2);

  pushStyle();
  fill(palette.flat.white);
  noStroke();
  text.write(String.valueOf(floor(entities.mouseX(0, 40))), 0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, 50);
  popStyle();

  rect(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT);

  for (OavpTerrainPoint p : entities.getTerrain("terrain").getValues("hill_a")) {
    ellipse(p.x, oavp.STAGE_HEIGHT / 2 + p.y * oavp.STAGE_HEIGHT / 2, 10, 10);
  }
}