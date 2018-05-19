OavpInterval meshInterval;

void setupSketch() {
  palette.add("monitor", style.flat.blue, style.flat.red);
  meshInterval = new OavpInterval(40, oavpData.getAvgSize());
}

void updateSketch() {
  meshInterval.update(oavpData.getSpectrum());
}

void drawSketch() {
  visualizers
    .create()
    .center().middle()
    .moveUp(oavp.STAGE_WIDTH / 4)
    .rotate(45, 0, 45)
    .startStyle().noFillStyle().strokeColor(palette.get("monitor", oavpData.getLevel()))
    .oscillators.zSquare(oavp.STAGE_WIDTH / 2, oavp.STAGE_HEIGHT / 2, 1, oavp.STAGE_HEIGHT / 4, 0.025)
    .oscillators.zSquare(oavp.STAGE_WIDTH / 2, oavp.STAGE_HEIGHT / 2, 1.1, oavp.STAGE_HEIGHT / 4, 0.0125)
    .oscillators.zSquare(oavp.STAGE_WIDTH / 2, oavp.STAGE_HEIGHT / 2, 1.2, oavp.STAGE_HEIGHT / 4, 0.00625)
    .oscillators.zSquare(oavp.STAGE_WIDTH / 2, oavp.STAGE_HEIGHT / 2, 1.3, oavp.STAGE_HEIGHT / 4, 0.003125)
    .spectrum.mesh(oavp.STAGE_WIDTH / 2, oavp.STAGE_HEIGHT / 2, oavp.STAGE_WIDTH / 2, 2, meshInterval)
    .endStyle()
    .done();
}
