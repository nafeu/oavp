OavpRhythm mainBeat;
ArrayList trackers;

void setupSketch() {
  mainBeat = new OavpRhythm(minim, 120, 1);
  trackers = new ArrayList();
}

void updateSketch() {
  mainBeat.update();
  oavpData.update(trackers);
}

void drawSketch() {
  visualizers.emitters.linearSpectrumRhythm(0, oavp.STAGE_WIDTH * 2, 1.0, Ani.LINEAR, mainBeat, trackers);

  visualizers
    .create()
    .floaters.spectrumWire(oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, trackers)
    .done();
}
