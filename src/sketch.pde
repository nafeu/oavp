List trackers;
OavpRhythm metro;

void setupSketch() {
  trackers = new ArrayList();
  metro = new OavpRhythm(minim, 120, 1);
  palette.add("background", style.flat.red, style.flat.yellow);
}

void updateSketch() {
  metro.update();
  oavpData.update(trackers);
}

void drawSketch() {
  float interpolation = map(sin(frameCount * 0.01), -1, 1, 0, 1);
  background(palette.get("background", interpolation));
  noFill();
  strokeWeight(1);

  visualizers.emitters.rhythmAngles(0, 1, 2.0, Ani.QUAD_IN_OUT, 2, metro, trackers);

  visualizers
    .create()
    .startStyle()
      .noFillStyle()
      .strokeColor(style.flat.white)
    .center().middle()
    .floaters.connectedRings(oavpData.getLevel() * 100, oavp.STAGE_WIDTH, trackers)
    .endStyle()
    .done();
}
