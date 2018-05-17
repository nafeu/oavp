void sandboxSetup() {
  metronome.setTempo(130);
}

void sandbox() {
  visualizers.emitters.linearSpectrumTempo(0, stageWidth * 2, 0.005, metronome, visTrackers);

  visualizers
    .create()
    .floaters.spectrumWire(stageWidth, stageHeight, visTrackers)
    .done();
}
