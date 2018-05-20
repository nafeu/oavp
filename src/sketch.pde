void setupSketch() {
  palette.add("monitor", style.flat.black, style.flat.darkBlue);

  palette.add("a", style.flat.teal);
  palette.add("b", style.flat.darkTeal);
  palette.add("c", style.flat.green);
  palette.add("d", style.flat.darkGreen);
}

void updateSketch() {

}

void drawSketch() {
  background(style.flat.blue);
  noStroke();
  fill(palette.get("a"));
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT / 2, oavp.STAGE_HEIGHT / 2, 100, mouseX * 0.0001);
  translate(0, 0, -1);
  fill(palette.get("b"));
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT / 2, oavp.STAGE_HEIGHT / 4, 100, mouseX * 0.0001);
  translate(0, 0, -1);
  fill(palette.get("c"));
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT / 2, oavp.STAGE_HEIGHT / 8, 100, mouseX * 0.0001);
  translate(0, 0, -1);
  fill(palette.get("d"));
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT / 2, oavp.STAGE_HEIGHT / 16, 100, mouseX * 0.0001);
}
