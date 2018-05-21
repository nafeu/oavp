List trackers;

void setupSketch() {
  trackers = new ArrayList();
  metronome = new OavpRhythm(minim, 120, 1);
}

void updateSketch() {
  metronome.update();
  oavpData.update(trackers);
}

void drawSketch() {
  visualizers.emitters.rhythmAngles(4.0, Ani.QUAD_IN_OUT, floor(random(2,5)), metronome, trackers);

  visualizers
    .create()
    .startStyle()
      .noFillStyle()
      .strokeColor(style.flat.white)
    .center().middle()
    .rotate(0, 0, frameCount * 0.25)
    .floaters.connectedRings(25 + (oavpData.getLevel() * 100), oavp.STAGE_WIDTH, trackers)
    .endStyle()
    .done();
}
