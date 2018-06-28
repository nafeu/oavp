void setupExamples() {
  entities.addPulser("example")
    .duration(0.5)
    .easing(Ani.QUAD_IN_OUT);
}

void updateExamples() {

  entities.getPulser("example").pulseIf(analysis.isBeatOnset());
}

void drawExamples() {
  palette.reset(palette.flat.black, palette.flat.white, 2);

  visualizers
    .create()
    .center().middle()
    .usePulser("example")
    .draw.pulserSquare(oavp.width(0.5))
    .done();
}