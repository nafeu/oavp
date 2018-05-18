void exampleZSquareMesh() {
  visualizers
    .create()
    .center().middle()
    .moveUp(stageWidth / 4)
    .rotate(45, 0, 45)
    .oscillators.zSquare(stageWidth / 2, stageHeight / 2, 1, stageHeight / 4, 0.025)
    .oscillators.zSquare(stageWidth / 2, stageHeight / 2, 1.1, stageHeight / 4, 0.0125)
    .oscillators.zSquare(stageWidth / 2, stageHeight / 2, 1.2, stageHeight / 4, 0.00625)
    .oscillators.zSquare(stageWidth / 2, stageHeight / 2, 1.3, stageHeight / 4, 0.003125)
    .spectrum.mesh(stageWidth / 2, stageHeight / 2, 2, spectrumInterval)
    .done();
}

void exampleLinearEmitters() {
  visualizers.emitters.linearBeat(0, stageWidth / 2, 1.0, Ani.LINEAR, visTrackers);

  visualizers
    .create()
    .center().middle()
    .rotate(0, 0, frameCount * 0.25)
    .floaters.circle(10, visTrackers)
    .rotate(0, 0, 90)
    .floaters.circle(10, visTrackers)
    .rotate(0, 0, 90)
    .floaters.circle(10, visTrackers)
    .rotate(0, 0, 90)
    .floaters.circle(10, visTrackers)
    .done();

  visualizers
    .create()
    .center().middle()
    .rotate(0, 0, 30 + frameCount * 0.25)
    .floaters.square(10, visTrackers)
    .rotate(0, 0, 90)
    .floaters.square(10, visTrackers)
    .rotate(0, 0, 90)
    .floaters.square(10, visTrackers)
    .rotate(0, 0, 90)
    .floaters.square(10, visTrackers)
    .done();

  visualizers
    .create()
    .center().middle()
    .rotate(0, 0, 60 + frameCount * 0.25)
    .floaters.chevron(160, 80, visTrackers)
    .rotate(0, 0, 90)
    .floaters.chevron(160, 80, visTrackers)
    .rotate(0, 0, 90)
    .floaters.chevron(160, 80, visTrackers)
    .rotate(0, 0, 90)
    .floaters.chevron(160, 80, visTrackers)
    .done();

  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() - (stageHeight * 0.125))
    .rotate(-45, -45, 0)
    .grids.flatbox(stageWidth * 0.25, stageWidth * 0.25, stageWidth * 0.25 * 0.125, beatAmplitudeGridInterval)
    .done();
}

void exampleMultiFlatboxGrid() {
  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() + (stageHeight * 0.125))
    .rotate(-45, 135, 0)
    .grids.flatbox(stageWidth * 0.25, stageWidth * 0.25, stageWidth * 0.25, beatAmplitudeGridInterval)
    .done();
  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() + (stageHeight * 0.125))
    .rotate(-45, -45, 0)
    .grids.flatbox(stageWidth * 0.25, stageWidth * 0.25, stageWidth * 0.25, beatAmplitudeGridInterval)
    .done();
  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() + (stageHeight * 0.125))
    .rotate(-45, -135, 0)
    .grids.flatbox(stageWidth * 0.25, stageWidth * 0.25, stageWidth * 0.25, beatAmplitudeGridInterval)
    .done();
  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() + (stageHeight * 0.125))
    .rotate(-45, 45, 0)
    .grids.flatbox(stageWidth * 0.25, stageWidth * 0.25, stageWidth * 0.25, beatAmplitudeGridInterval)
    .done();
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
    .grids.square(entityPosition.scale, entityPosition.scale, beatAmplitudeGridInterval)
    .done();
}

void exampleDiagonalGrid() {
  visualizers
    .create(entityPosition.getScaledX(), entityPosition.getScaledY())
    .grids.square(entityPosition.scale / 2, entityPosition.scale / 2, beatAmplitudeGridInterval)
    .done()
    .create(entityPosition.scale, entityPosition.getScaledY())
    .rotate(0, 0, 90)
    .grids.square(entityPosition.scale / 2, entityPosition.scale / 2, beatAmplitudeGridInterval)
    .done()
    .create(entityPosition.getScaledX(), entityPosition.scale)
    .rotate(0, 0, 270)
    .grids.square(entityPosition.scale / 2, entityPosition.scale / 2, beatAmplitudeGridInterval)
    .done()
    .create(entityPosition.scale, entityPosition.scale)
    .rotate(0, 0, 180)
    .grids.square(entityPosition.scale / 2, entityPosition.scale / 2, beatAmplitudeGridInterval)
    .done();
}

void exampleGallery() {
  text.write(introText);
  entityPosition.moveRight();

  text.write("Square Emitter");

  visualizers
    .create()
    .center().middle()
    .rotate(0, 0, 0)
    .emitters.linearBeat(0, stageWidth / 2, 1.0, Ani.LINEAR, visTrackers)
    .floaters.square(stageWidth / 4, visTrackers)
    .done();

  entityPosition.moveRight();

  text.write("Levels/Beat Grid Flatbox");

  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() - (stageHeight * 0.125))
    .rotate(-45, -45, 0)
    .grids.flatbox(stageWidth * 0.25, stageWidth * 0.25, stageWidth * 0.25 * 0.125, beatAmplitudeGridInterval)
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
    .grids.square(entityPosition.scale, entityPosition.scale, beatAmplitudeGridInterval)
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
    .floaters.splashSquare(visTrackers)
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
    .floaters.splashCircle(visTrackers)
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
    .floaters.splashSquare(visTrackers)
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