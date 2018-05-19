void setupSketch() {

}

void updateSketch() {

}

void drawSketch() {
  PImage img = images.get("test-image");
  float imgScale = img.width / oavp.STAGE_WIDTH;
  visualizers
    .create()
    .center().middle()
    .moveLeft(img.width * imgScale / 2)
    .moveUp(img.height * imgScale / 2)
    .img(imgScale, img)
    .done();
}
