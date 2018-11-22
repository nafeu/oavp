void setupSketch() {
  entities.addInterval("spectrum", 30, analysis.getAvgSize());
}

void updateSketch() {
  entities.getInterval("spectrum").update(analysis.getSpectrum());
}

void drawSketch() {
  palette.reset(palette.flat.white, palette.flat.black, 2);

  visualizers
    .useInterval("spectrum")
    .create()
    .center().middle()
    .moveUp(oavp.width(0.125))
    .rotate(45, 0, 45)
    .dimensions(oavp.width(0.25), oavp.height(0.25))
    .draw.intervalSpectrumMesh(oavp.width(0.25), 1)
    .draw.basicZSquare(oavp.width(0.4), oscillate(-100, 100, 0.005))
    .draw.basicZSquare(oavp.width(0.45), oscillate(-100, 100, 0.010))
    .draw.basicZSquare(oavp.width(0.5), oscillate(-100, 100, 0.015))
    .done();
}