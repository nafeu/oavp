float position;

void setupExamples() {
  position = map(mouseX, 0, width, 0, 1) * 100;

  noiseSeed(1);

  entities.addTerrain("terrain")
    .distance(oavp.STAGE_WIDTH)
    .generate("hill_a", 0)
    .generate("hill_b", 100);
}

void updateExamples() {
  position = map(mouseX, 0, width, 0, 1) * 100;

  entities.update();
  entities.updateTerrain("terrain", "hill_a", position);
  entities.updateTerrain("terrain", "hill_b", position + 100);
}

void drawExamples() {
  background(palette.flat.black);
  stroke(palette.flat.white);
  noFill();
  strokeWeight(2);

  rect(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT);

  stroke(palette.flat.red);
  beginShape();
  for (OavpTerrainPoint p : entities.getTerrain("terrain").getValues("hill_a")) {
    curveVertex(p.x, p.y * oavp.STAGE_HEIGHT);
  }
  endShape();

  stroke(palette.flat.blue);
  beginShape();
  for (OavpTerrainPoint p : entities.getTerrain("terrain").getValues("hill_b")) {
    vertex(p.x, p.y * oavp.STAGE_HEIGHT);
  }
  endShape();
}