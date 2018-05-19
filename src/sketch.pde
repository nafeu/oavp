void setupSketch() {
  metronome = new OavpRhythm(minim, 120, 1);
  visTrackers = new ArrayList();
}

void updateSketch() {
  metronome.update();
  oavpData.update(visTrackers);
}

void drawSketch() {
  visualizers.emitters.linearSpectrumRhythm(0, oavp.STAGE_WIDTH * 2, 1.0, Ani.LINEAR, metronome, visTrackers);

  visualizers
    .create()
    .floaters.spectrumWire(oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, visTrackers)
    .done();
}
