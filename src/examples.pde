void setupExamples() {
  entities.addOscillator("wave")
    .duration(20)
    .easing(Ani.SINE_IN_OUT)
    .start();
  noiseSeed(1);
  randomSeed(1);

  entities.addColorRotator("colors")
    .duration(0.5)
    .easing(Ani.SINE_IN_OUT)
    .add(palette.flat.red)
    .add(palette.flat.purple)
    .add(palette.flat.blue);

  palette.add("background", palette.flat.black);
  palette.add("stroke", palette.flat.red);
}

void updateExamples() {
  entities.rotateColorRotatorIf("colors", analysis.isBeatOnset());
}

void drawExamples() {
  float mappedMouseX = map(mouseX, 0, width, 0, 1);
  float mappedMouseY = map(mouseY, 0, height, 0, 1);
  float mappedOsc = entities.getOscillator("wave").getValue();
  float granularity = 0.015;
  float sunX = 125 + mappedOsc * (oavp.STAGE_WIDTH - 250);
  float sunY = mappedMouseY * 100 + 150;
  int numDataPoints = 100;

  background(palette.get("background"));
  stroke(entities.getColorRotator("colors").getColor());
  fill(palette.get("background"));
  strokeWeight(2);

  visualizers
    .create()
    .move(sunX, sunY)
    .draw.basicSpectrumRadialBars(50 + paramA, 100 + paramB, 200 + paramC, frameCount * 0.25)
    .done();

  ellipse(sunX, sunY, 10 + mappedMouseY * 100 + analysis.getLevel() * 50, 10 + mappedMouseY * 100 + analysis.getLevel() * 50);

  shapes.trapezoid(sunX * 0.25, oavp.STAGE_HEIGHT * 0.25, 200, 450, 100, 0);
  shapes.trapezoid(sunX * 0.25, oavp.STAGE_HEIGHT * 0.25, 200, 450, 50, 0);
  shapes.trapezoid(sunX * 0.50 + 250, oavp.STAGE_HEIGHT * 0.30, 125, 350, 0, 50);
  shapes.trapezoid(sunX * 0.50 + 250, oavp.STAGE_HEIGHT * 0.30, 125, 350, 0, 25);
  shapes.cylinder(sunX * 0.15 + 750, oavp.STAGE_HEIGHT * 0.30, 400, 200, 40);

  visualizers
    .create()
    .move(sunX * 0.15 + 750, oavp.STAGE_HEIGHT * 0.25, 20)
    .rotate(frameCount * 0.25, frameCount * 0.25, frameCount * 0.25)
    .draw.basicLevelCube(100)
    .done();

  translate(0, 0, 2);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT / 2, mappedMouseY * oavp.STAGE_HEIGHT * 0.25, numDataPoints, granularity, mappedOsc * 250 + 250);
  translate(0, 0, 2);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT / 2, mappedMouseY * oavp.STAGE_HEIGHT * 0.5, numDataPoints, granularity, mappedOsc * 500 + 500);
  translate(0, 0, 2);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT / 2, mappedMouseY * oavp.STAGE_HEIGHT * 0.75, numDataPoints, granularity, mappedOsc * 750 + 750);
  translate(0, 0, 2);
  shapes.hill(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT / 2, mappedMouseY * oavp.STAGE_HEIGHT * 1, numDataPoints, granularity, mappedOsc * 1000 + 1000);
}