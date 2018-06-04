void setupExamples() {
  noiseSeed(1);
  entities.addTerrain("terrain");
}

void updateExamples() {
  entities.update();
}

void drawExamples() {
  background(palette.flat.black);
  stroke(palette.flat.white);
  noFill();
  strokeWeight(2);

  pushStyle();
  fill(palette.flat.white);
  noStroke();
  text.write(String.valueOf(floor(frameCount * 0.25)), 0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, 50);
  popStyle();

  fill(palette.flat.black);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT * 0.1, oavp.STAGE_HEIGHT * 0.5, entities.getTerrain("terrain").getWindow(frameCount * 0.1, 100, 0), frameCount * 0.1);
  shapes.trees(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT * 0.1, oavp.STAGE_HEIGHT * 0.5, entities.getTerrain("terrain").getWindow(frameCount * 0.1, 100, 0), entities.getTerrain("terrain").getStructures(frameCount * 0.1, 100, 0), frameCount * 0.1);
  translate(0, 0, 2);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT * 0.3, oavp.STAGE_HEIGHT * 0.55, entities.getTerrain("terrain").getWindow(frameCount * 0.3, 100, 1000), frameCount * 0.3);
  shapes.trees(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT * 0.3, oavp.STAGE_HEIGHT * 0.55, entities.getTerrain("terrain").getWindow(frameCount * 0.3, 100, 1000), entities.getTerrain("terrain").getStructures(frameCount * 0.3, 100, 1000), frameCount * 0.3);
  translate(0, 0, 2);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT * 0.2, oavp.STAGE_HEIGHT * 0.7, entities.getTerrain("terrain").getWindow(frameCount * 0.7, 100, 2000), frameCount * 0.7);
  shapes.trees(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT * 0.2, oavp.STAGE_HEIGHT * 0.7, entities.getTerrain("terrain").getWindow(frameCount * 0.7, 100, 2000), entities.getTerrain("terrain").getStructures(frameCount * 0.7, 100, 2000), frameCount * 0.7);
  translate(0, 0, 2);
}