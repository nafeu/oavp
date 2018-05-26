void setupExamples() {
  entities.addOscillator("spinner")
    .start();
  entities.addRhythm("seconds")
    .start();
  entities.addColorRotator("rainbow")
    .add(palette.flat.red)
    .add(palette.flat.purple)
    .add(palette.flat.blue)
    .add(palette.flat.green)
    .add(palette.flat.yellow)
    .add(palette.flat.orange);
}

void updateExamples() {
  entities.update();
  entities.rotateColorRotatorIf("rainbow", entities.onRhythm("seconds"));
}

void drawExamples() {
  stroke(palette.flat.white);
  background(entities.getColorRotator("rainbow").getColor());
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