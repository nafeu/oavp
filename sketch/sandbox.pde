void sandboxSetup() {

}

void sandbox() {
  visualizers.emitters.linearSpectrumTempo(0, stageWidth * 2, 0.005, metronome, visTrackers);

  visualizers
    .create()
    // .moveUp(stageWidth / 4)
    .floaters.spectrumWire(stageWidth, stageHeight, visTrackers)
    .done();
}
