void sandboxSetup() {

}

void sandbox() {
  visualizers
    .create()
    .center().middle()
    .moveUp(stageWidth / 4)
    .rotate(45, 0, 45)
    .oscillators.zSquare(stageWidth / 2, stageHeight / 2, 1, stageHeight / 4, 0.025)
    .oscillators.zSquare(stageWidth / 2, stageHeight / 2, 1.1, stageHeight / 4, 0.0125)
    .oscillators.zSquare(stageWidth / 2, stageHeight / 2, 1.2, stageHeight / 4, 0.00625)
    .oscillators.zSquare(stageWidth / 2, stageHeight / 2, 1.3, stageHeight / 4, 0.003125)
    .spectrum.mesh(stageWidth / 2, stageHeight / 2, 2, spectrumInterval)
    .done();
}
