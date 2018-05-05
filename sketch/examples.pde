void drawExamples() {
  exampleGallery();
  // sandbox();
}

void sandboxSetup() {

}

void sandbox() {
  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() + (stageHeight * 0.125))
    .rotate(-45, 135, 0)
    .levels.gridFlatbox(stageWidth * 0.25, stageWidth * 0.25, stageWidth * 0.25 * 0.125, beatAmplitudeGridInterval)
    .done();
  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() + (stageHeight * 0.125))
    .rotate(-45, -45, 0)
    .levels.gridFlatbox(stageWidth * 0.25, stageWidth * 0.25, stageWidth * 0.25 * 0.125, beatAmplitudeGridInterval)
    .done();
  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() + (stageHeight * 0.125))
    .rotate(-45, -135, 0)
    .levels.gridFlatbox(stageWidth * 0.25, stageWidth * 0.25, stageWidth * 0.25 * 0.125, beatAmplitudeGridInterval)
    .done();
  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() + (stageHeight * 0.125))
    .rotate(-45, 45, 0)
    .levels.gridFlatbox(stageWidth * 0.25, stageWidth * 0.25, stageWidth * 0.25 * 0.125, beatAmplitudeGridInterval)
    .done();

  pushMatrix();
  rotateX(radians(-45));
  rotateY(radians(-45));
  translate(entityPosition.getCenteredX() + 205.0, entityPosition.getCenteredY() -380.0, 0);
  box(stageWidth * 0.25 + 280.0, stageWidth * 0.25 + paramA, stageWidth * 0.25 + 280.0);
  popMatrix();
}

void exampleFlatbox() {
  visualizers
    .create()
    .center().middle()
    .rotate(-22.5, -45, 0)
    .levels.flatbox(stageWidth * 0.25, style.flat.red)
    .done();

  visualizers
    .create()
    .left().middle()
    .rotate(-22.5, -45, 0)
    .levels.flatbox(stageWidth * 0.25, style.flat.blue)
    .done();

  visualizers
    .create()
    .right().middle()
    .rotate(-22.5, -45, 0)
    .levels.flatbox(stageWidth * 0.25, style.flat.green)
    .done();
}

void exampleDimensionalGrid() {
  visualizers
    .create()
    .beats.gridSquare(entityPosition.scale, entityPosition.scale, beatAmplitudeGridInterval)
    .done();
}

void exampleDiagonalGrid() {
  visualizers
    .create(entityPosition.getScaledX(), entityPosition.getScaledY())
    .beats.gridSquare(entityPosition.scale / 2, entityPosition.scale / 2, beatAmplitudeGridInterval)
    .done()
    .create(entityPosition.scale, entityPosition.getScaledY())
    .rotate(0, 0, 90)
    .beats.gridSquare(entityPosition.scale / 2, entityPosition.scale / 2, beatAmplitudeGridInterval)
    .done()
    .create(entityPosition.getScaledX(), entityPosition.scale)
    .rotate(0, 0, 270)
    .beats.gridSquare(entityPosition.scale / 2, entityPosition.scale / 2, beatAmplitudeGridInterval)
    .done()
    .create(entityPosition.scale, entityPosition.scale)
    .rotate(0, 0, 180)
    .beats.gridSquare(entityPosition.scale / 2, entityPosition.scale / 2, beatAmplitudeGridInterval)
    .done();
}

void exampleGallery() {
  text.write(introText);
  entityPosition.moveRight();

  text.write("Levels/Beat Grid Flatbox");

  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() - (stageHeight * 0.125))
    .rotate(-45, -45, 0)
    .levels.gridFlatbox(stageWidth * 0.25, stageWidth * 0.25, stageWidth * 0.25 * 0.125, beatAmplitudeGridInterval)
    .done();

  entityPosition.moveRight();

  text.write("Levels/Beat Flatbox");

  visualizers
    .create()
    .center().middle()
    .rotate(-22.5, -45, 0)
    .levels.flatbox(stageWidth * 0.125, style.flat.grey)
    .done();

  visualizers
    .create()
    .center().middle()
    .rotate(-22.5, -45, 0)
    .beats.flatbox(stageWidth * 0.25, style.flat.grey, beatAmplitude)
    .done();

  entityPosition.moveRight();

  text.write("Beat Grid Square");

  visualizers
    .create()
    .top().left()
    .beats.gridSquare(entityPosition.scale, entityPosition.scale, beatAmplitudeGridInterval)
    .done();

  entityPosition.moveRight();

  text.write("Beat Ghost Square");

  visualizers
    .create()
    .center().middle()
    .beats.ghostSquare(0, stageWidth * 0.75, beatAmplitudeInterval, 20)
    .done();

  entityPosition.moveRight();

  text.write("Beat Splash Square");

  visualizers
    .create()
    .center().middle()
    .beats.splashSquare(0, stageWidth * 0.4, beatInterval)
    .done();

  entityPosition.moveRight();

  text.write("Beat Square");

  visualizers
    .create()
    .center().middle()
    .beats.square(0, stageWidth * 0.4, beatAmplitude)
    .done();

  entityPosition.moveRight();

  text.write("Beat Ghost Circle");

  visualizers
    .create()
    .center().middle()
    .beats.ghostCircle(0, stageWidth * 0.4, beatAmplitudeInterval, 20)
    .done();

  entityPosition.moveRight();

  text.write("Beat Splash Circle");

  visualizers
    .create()
    .center().middle()
    .beats.splashCircle(0, stageWidth * 0.4, beatInterval)
    .done();

  entityPosition.moveRight();

  text.write("Beat Circle");
  visualizers
    .create()
    .center().middle()
    .beats.circle(0, stageWidth * 0.25, beatAmplitude)
    .done();

  entityPosition.moveRight();

  text.write("Interval Bars");
  visualizers
    .create()
    .left().top()
    .levels.intervalBars(stageWidth, stageHeight, stageHeight, levelInterval)
    .done();

  entityPosition.moveRight();

  pushStyle();
  fill(style.getPrimaryColor());
  noStroke();

  text.write("Custom SVG");
  visualizers
    .create()
    .center().middle()
    .svg(400.0 / stageWidth, 400, logo)
    .done();

  popStyle();

  entityPosition.moveRight();

  text.write("Bar Spectrum");
  visualizers
    .create()
    .left().top()
    .spectrum.bars(stageWidth, stageHeight)
    .done();

  entityPosition.moveRight();

  text.write("Wire Spectrum");
  visualizers
    .create()
    .left().top()
    .spectrum.wire(stageWidth, stageHeight)
    .done();

  entityPosition.moveRight();

  text.write("Radial Bar Spectrum");
  visualizers
    .create()
    .center().middle()
    .spectrum.radialBars(stageWidth * 0.25, stageWidth * 0.33, stageWidth, frameCount * 0.25)
    .done();

  entityPosition.moveRight();

  text.write("Radial Wire Spectrum");
  visualizers
    .create()
    .center().middle()
    .spectrum.radialWire(stageWidth * 0.25, stageWidth * 1.50, frameCount * 0.25)
    .done();

  entityPosition.moveRight();

  text.write("Wire Waveform");
  visualizers
    .create()
    .left().top()
    .waveform.wire(stageWidth, stageHeight)
    .done();

  entityPosition.moveRight();

  text.write("Radial Wire Waveform");
  visualizers
    .create()
    .center().middle()
    .waveform.radialWire(stageWidth * 0.25, stageWidth * 0.25, 0, frameCount * 0.25)
    .done();

  entityPosition.moveRight();

  text.write("Bar Levels");
  visualizers
    .create()
    .left().top()
    .levels.bars(stageWidth, stageHeight)
    .done();

  entityPosition.moveRight();

  text.write("Cube Levels");
  visualizers
    .create()
    .center().middle()
    .rotate(frameCount, frameCount)
    .levels.cube(stageWidth * 0.75)
    .next()
    .center().middle()
    .rotate(-frameCount * 0.25, -frameCount * 0.25)
    .levels.cube(stageWidth * 0.25)
    .done();

  entityPosition.reset();
}

void exampleGhostCircle() {
  visualizers
    .create()
    .center().middle()
    .beats.ghostCircle(0, stageWidth * 0.75, beatAmplitudeInterval, 20)
    .done();

  visualizers
    .create()
    .center().middle()
    .rotate(0, 0, frameCount * 0.25)
    .beats.splashSquare(0, stageWidth * 0.4, beatInterval)
    .done();

  visualizers
    .create()
    .center().middle()
    .rotate(frameCount, frameCount)
    .levels.cube(stageWidth * 0.75)
    .next()
    .center().middle()
    .rotate(-frameCount * 0.25, -frameCount * 0.25)
    .levels.cube(stageWidth * 0.25)
    .done();
}