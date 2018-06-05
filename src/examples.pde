void setupExamples() {
  noiseSeed(1);
  entities.addTerrain("terrain");
}

void updateExamples() {
  entities.update();
}

void drawExamples() {
  palette.reset(palette.flat.white, palette.flat.black, 2);

  text.write(frameCount * 0.25, palette.flat.black);

  visualizers
    .create()
    .top().left()
    .useTerrain("terrain")
    .draw.basicHills(oavp.w, oavp.h, oavp.height(0.1), oavp.height(0.5), 100, 0, frameCount(0.1))
    .draw.basicHills(oavp.w, oavp.h, oavp.height(0.3), oavp.height(0.55), 100, 1000, frameCount(0.3))
    .draw.basicHills(oavp.w, oavp.h, oavp.height(0.2), oavp.height(0.7), 100, 2000, frameCount(0.7))
    .done();
}