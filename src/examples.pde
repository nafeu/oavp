void setupExamples() {
  entities.addInterval("example", 100, 1);
}

void updateExamples() {

  entities.getInterval("example").update(analysis.getLevel(), 1);
}

void drawExamples() {
  palette.reset(palette.flat.black, palette.flat.white, 2);

  visualizers
    .create()
    .left().middle()
    .useInterval("example")
    .dimensions(oavp.w, oavp.height(0.5))
    .draw.intervalLevelBars(oavp.width(0.5))
    .done();
}