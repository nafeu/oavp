void setupSketch() {
  entities.addEmissions("example");
  emitters.useEmissions("example").duration(2);
}

void updateSketch() {
  emitters.useEmissions("example").emitSpectrum(analysis.isBeatOnset());
}

void drawSketch() {
  palette.reset(palette.flat.white, palette.flat.red, 2);

  visualizers
    .useEmissions("example")
    .dimensions(oavp.width(0.4), oavp.width(0.4))
    .create()
    .center().middle()
    .moveUp(oavp.width(0.4))
    .rotate(45, 0, 45)
    .draw.emissionSpectrumWire(oavp.width(0.4))
    .done();
}

void keyPressed() {
  if (key == 'q') { emitters.useEmissions("example").emitSpectrum(true); }
}