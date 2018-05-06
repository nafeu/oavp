void sandboxSetup() {

}

void sandbox() {
  visualizers
    .create()
    .center().middle()
    .moveUp(stageWidth / 4)
    .rotate(0, 0, 0)
    .emitters.linear(1, 90, 4, stageWidth / 4, visTrackers)
    .floaters.chevron(stageWidth / 4, stageWidth / 8, visTrackers)
    .done();
  visualizers
    .create()
    .center().middle()
    .moveRight(stageWidth / 4)
    .rotate(0, 0, 90)
    .emitters.linear(1, 90, 4, stageWidth / 4, visTrackers)
    .floaters.chevron(stageWidth / 4, stageWidth / 8, visTrackers)
    .done();
  visualizers
    .create()
    .center().middle()
    .moveDown(stageWidth / 4)
    .rotate(0, 0, 180)
    .emitters.linear(1, 90, 4, stageWidth / 4, visTrackers)
    .floaters.chevron(stageWidth / 4, stageWidth / 8, visTrackers)
    .done();
  visualizers
    .create()
    .center().middle()
    .moveLeft(stageWidth / 4)
    .rotate(0, 0, 270)
    .emitters.linear(1, 90, 4, stageWidth / 4, visTrackers)
    .floaters.chevron(stageWidth / 4, stageWidth / 8, visTrackers)
    .done();
}
