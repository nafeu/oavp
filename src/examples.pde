void setupExamples() {
  entities.addTrackers("beats");
  entities.addOscillator("beats")
    .start();
  entities.addColorRotator("beats")
    .duration(0.5)
    .easing(Ani.SINE_IN_OUT)
    .add(palette.flat.blue)
    .add(palette.flat.red)
    .add(palette.flat.purple);
  entities.addColorRotator("chevrons")
    .duration(0.5)
    .easing(Ani.SINE_IN_OUT)
    .add(palette.flat.black)
    .add(palette.flat.white);
}

void updateExamples() {
  entities.update();
  entities.rotateColorRotatorIf("beats", analysis.isBeatOnset());
  entities.rotateColorRotatorIf("chevrons", analysis.isBeatOnset());
  emitters
    .useTrackers("beats")
    .duration(2)
    .easing(Ani.SINE_IN_OUT)
    .emitBeatColor(entities.getColorRotator("chevrons").getColor());
}

void drawExamples() {
  background(entities.getColorRotator("beats").getColor());
  noStroke();
  strokeWeight(3);

  visualizers
    .create()
    .center().middle()
    .useTrackers("beats")
    .moveUp(entities.getOscillator("beats").getValue() * oavp.STAGE_WIDTH / 4)
    .draw.trackerColorChevron(oavp.STAGE_WIDTH / 4, oavp.STAGE_WIDTH / 8, oavp.STAGE_WIDTH / 2)
    .draw.trackerColorChevron(oavp.STAGE_WIDTH / 8, oavp.STAGE_WIDTH / 16, oavp.STAGE_WIDTH / 2 * 0.75)
    .draw.trackerColorChevron(oavp.STAGE_WIDTH / 16, oavp.STAGE_WIDTH / 32, oavp.STAGE_WIDTH / 2 * 0.5)
    .moveDown(entities.getOscillator("beats").getValue() * oavp.STAGE_WIDTH / 4)
    .rotate(0, 0, 90)
    .moveUp(entities.getOscillator("beats").getValue() * oavp.STAGE_WIDTH / 4)
    .draw.trackerColorChevron(oavp.STAGE_WIDTH / 4, oavp.STAGE_WIDTH / 8, oavp.STAGE_WIDTH / 2)
    .draw.trackerColorChevron(oavp.STAGE_WIDTH / 8, oavp.STAGE_WIDTH / 16, oavp.STAGE_WIDTH / 2 * 0.75)
    .draw.trackerColorChevron(oavp.STAGE_WIDTH / 16, oavp.STAGE_WIDTH / 32, oavp.STAGE_WIDTH / 2 * 0.5)
    .moveDown(entities.getOscillator("beats").getValue() * oavp.STAGE_WIDTH / 4)
    .rotate(0, 0, 90)
    .moveUp(entities.getOscillator("beats").getValue() * oavp.STAGE_WIDTH / 4)
    .draw.trackerColorChevron(oavp.STAGE_WIDTH / 4, oavp.STAGE_WIDTH / 8, oavp.STAGE_WIDTH / 2)
    .draw.trackerColorChevron(oavp.STAGE_WIDTH / 8, oavp.STAGE_WIDTH / 16, oavp.STAGE_WIDTH / 2 * 0.75)
    .draw.trackerColorChevron(oavp.STAGE_WIDTH / 16, oavp.STAGE_WIDTH / 32, oavp.STAGE_WIDTH / 2 * 0.5)
    .moveDown(entities.getOscillator("beats").getValue() * oavp.STAGE_WIDTH / 4)
    .rotate(0, 0, 90)
    .moveUp(entities.getOscillator("beats").getValue() * oavp.STAGE_WIDTH / 4)
    .draw.trackerColorChevron(oavp.STAGE_WIDTH / 4, oavp.STAGE_WIDTH / 8, oavp.STAGE_WIDTH / 2)
    .draw.trackerColorChevron(oavp.STAGE_WIDTH / 8, oavp.STAGE_WIDTH / 16, oavp.STAGE_WIDTH / 2 * 0.75)
    .draw.trackerColorChevron(oavp.STAGE_WIDTH / 16, oavp.STAGE_WIDTH / 32, oavp.STAGE_WIDTH / 2 * 0.5)
    .moveDown(entities.getOscillator("beats").getValue() * oavp.STAGE_WIDTH / 4)
    .done();
}