void setupExamples() {
  entities.addOscillator("spinner")
    .duration(2)
    .easing(Ani.BOUNCE_OUT)
    .start();
}

void updateExamples() {
  entities.update();
}

void drawExamples() {
  stroke(palette.flat.black);
  background(palette.flat.white);
  noFill();
  strokeWeight(2);

  visualizers
    .create()
    .center().middle()
    .moveDown(oavp.STAGE_WIDTH / 8)
    .rotate(65, 0, 45)
    .draw.basicZSquare(oavp.STAGE_WIDTH / 4, entities.getOscillator("spinner").getValue() * oavp.STAGE_WIDTH / 4)
    .done();
}