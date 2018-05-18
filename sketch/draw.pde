void sandboxSetup() {
  metronome.setTempo(130);
}

void sandbox() {
  visualizers.emitters.linearSpectrumRhythm(0, oavp.STAGE_WIDTH * 2, 1.0, Ani.LINEAR, metronome, visTrackers);

  visualizers
    .create()
    .floaters.spectrumWire(oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, visTrackers)
    .done();
}
