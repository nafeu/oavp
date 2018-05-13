void sandboxSetup() {

}

void sandbox() {
  visualizers.emitters.linearTempo(0, stageWidth / 2, 0.02, metronome, visTrackers);

  visualizers
    .create()
    .center().middle()
    .rotate(0, 0, frameCount * 0.25)
    .floaters.circle(10, visTrackers)
    .rotate(0, 0, 90)
    .floaters.circle(10, visTrackers)
    .rotate(0, 0, 90)
    .floaters.circle(10, visTrackers)
    .rotate(0, 0, 90)
    .floaters.circle(10, visTrackers)
    .done();
}
