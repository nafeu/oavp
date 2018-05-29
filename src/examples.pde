void setupExamples() {
  entities.addOscillator("wave")
    .duration(10)
    .easing(Ani.SINE_IN_OUT)
    .start();
  noiseSeed(1);

  palette.add("background", palette.flat.black, palette.flat.blue);
  palette.add("stroke", palette.flat.yellow, palette.flat.white);
}

void updateExamples() {
}

void drawExamples() {
  float mappedMouseX = map(mouseX, 0, width, 0, 1);
  float mappedMouseY = map(mouseY, 0, height, 0, 1);
  float mappedOsc = entities.getOscillator("wave").getValue();
  float granularity = 0.015;
  int numDataPoints = 100;

  background(palette.get("background", mappedOsc));
  stroke(palette.get("stroke", mappedOsc));
  fill(palette.get("background", mappedOsc));
  strokeWeight(2);

  visualizers
    .create()
    .move(125 + mappedOsc * (oavp.STAGE_WIDTH - 250), mappedMouseY * 100 + 150)
    .draw.basicSpectrumRadialBars(50 + paramA, 100 + paramB, 200 + paramC, frameCount * 0.25)
    .done();

  ellipse(125 + mappedOsc * (oavp.STAGE_WIDTH - 250), mappedMouseY * 100 + 150, 10 + mappedMouseY * 100 + analysis.getLevel() * 50, 10 + mappedMouseY * 100 + analysis.getLevel() * 50);

  translate(0, 0, 2);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT / 2, mappedMouseY * oavp.STAGE_HEIGHT * 0.25, numDataPoints, granularity, mappedOsc * 250 + 250);
  translate(0, 0, 2);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT / 2, mappedMouseY * oavp.STAGE_HEIGHT * 0.5, numDataPoints, granularity, mappedOsc * 500 + 500);
  translate(0, 0, 2);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT / 2, mappedMouseY * oavp.STAGE_HEIGHT * 0.75, numDataPoints, granularity, mappedOsc * 750 + 750);
  translate(0, 0, 2);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT / 2, mappedMouseY * oavp.STAGE_HEIGHT * 1, numDataPoints, granularity, mappedOsc * 1000 + 1000);
}