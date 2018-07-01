void setupExamples() {
  entities.addCamera("default");

  entities.addInterval("spectrumMesh", 30, analysis.getAvgSize());
}

void updateExamples() {
  entities.getInterval("spectrumMesh").update(analysis.getSpectrum());

  entities.useCamera("default");
}

void drawExamples() {
  palette.reset(palette.flat.black, palette.flat.white, 2);

  visualizers
    .useInterval("spectrumMesh")
    .create()
    .center().middle()
    .moveUp(oavp.width(0.125))
    .rotate(45, 0, 45)
    .dimensions(oavp.width(0.25), oavp.height(0.25))
    .draw.intervalSpectrumMesh(oavp.width(0.25), 2)
    .done();
}

void keyPressed() {
  if (key == 'W') {
    entities.getCamera("default").moveForward(250);
  }
  if (key == 'S') {
    entities.getCamera("default").moveBackward(250);
  }
  if (key == 'w') {
    entities.getCamera("default").moveUp(250);
  }
  if (key == 's') {
    entities.getCamera("default").moveDown(250);
  }
  if (key == 'a') {
    entities.getCamera("default").moveLeft(250);
  }
  if (key == 'd') {
    entities.getCamera("default").moveRight(250);
  }
}