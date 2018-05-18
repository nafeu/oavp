void sandboxSetup() {
  metronome.setTempo(130);
}

void sandbox() {
  visualizers.emitters.linearSpectrumRhythm(0, stageWidth * 2, 1.0, Ani.LINEAR, metronome, visTrackers);

  visualizers
    .create()
    .floaters.spectrumWire(stageWidth, stageHeight, visTrackers)
    .done();
}
