void sandboxSetup() {

}

void sandbox() {
  visualizers.emitters.linearDelay(0, stageWidth / 2, 0.02, 30, visTrackers);

  visualizers
    .create()
    .center().middle()
    .floaters.square(10, visTrackers)
    .done();
}
