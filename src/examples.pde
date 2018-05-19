OavpRhythm metronome;
OavpInterval spectrumInterval;
OavpInterval levelInterval;
OavpGridInterval levelGridInterval;
OavpAmplitude beatAmplitude;
OavpInterval beatAmplitudeInterval;
OavpGridInterval beatAmplitudeGridInterval;
List visTrackers;

void drawExamples() {
  gallery();
}

void setupExamples() {
  metronome = new OavpRhythm(minim, 120, 1);
  spectrumInterval = new OavpInterval(40, oavpData.getAvgSize());
  levelInterval = new OavpInterval(20);
  levelGridInterval = new OavpGridInterval(4);
  beatAmplitude = new OavpAmplitude(0, 1, 0.08);
  beatAmplitudeInterval = new OavpInterval(20);
  beatAmplitudeGridInterval = new OavpGridInterval(4);
  visTrackers = new ArrayList();
}

void updateExamples() {
  style.updateColor(cameraPosition);
  style.updateColorInterp();
  noFill();
  strokeWeight(style.defaultStrokeWeight);
  stroke(style.getPrimaryColor());
  background(style.getSecondaryColor());

  metronome.update();
  oavpData.update(visTrackers);
  spectrumInterval.update(oavpData.getSpectrum());
  levelInterval.update(oavpData.getLeftLevel(), 1);
  levelGridInterval.updateDiagonal(oavpData.getLeftLevel(), 0);
  beatAmplitude.update(oavpData);
  beatAmplitudeInterval.update(beatAmplitude.getValue(), 0);
  beatAmplitudeGridInterval.updateDiagonal(beatAmplitude.getValue(), 0);
}

void exampleZSquareMesh() {
  visualizers
    .create()
    .center().middle()
    .moveUp(oavp.STAGE_WIDTH / 4)
    .rotate(45, 0, 45)
    .oscillators.zSquare(oavp.STAGE_WIDTH / 2, oavp.STAGE_HEIGHT / 2, 1, oavp.STAGE_HEIGHT / 4, 0.025)
    .oscillators.zSquare(oavp.STAGE_WIDTH / 2, oavp.STAGE_HEIGHT / 2, 1.1, oavp.STAGE_HEIGHT / 4, 0.0125)
    .oscillators.zSquare(oavp.STAGE_WIDTH / 2, oavp.STAGE_HEIGHT / 2, 1.2, oavp.STAGE_HEIGHT / 4, 0.00625)
    .oscillators.zSquare(oavp.STAGE_WIDTH / 2, oavp.STAGE_HEIGHT / 2, 1.3, oavp.STAGE_HEIGHT / 4, 0.003125)
    .spectrum.mesh(oavp.STAGE_WIDTH / 2, oavp.STAGE_HEIGHT / 2, oavp.STAGE_WIDTH / 2, 2, spectrumInterval)
    .done();
}

void exampleLinearEmitters() {
  visualizers.emitters.linearBeat(0, oavp.STAGE_WIDTH / 2, 1.0, Ani.LINEAR, visTrackers);

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
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() - (oavp.STAGE_HEIGHT * 0.125))
    .rotate(-45, -45, 0)
    .grids.flatbox(oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 0.25 * 0.125, beatAmplitudeGridInterval)
    .done();
}

void exampleMultiFlatboxGrid() {
  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() + (oavp.STAGE_HEIGHT * 0.125))
    .rotate(-45, 135, 0)
    .grids.flatbox(oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 0.25, beatAmplitudeGridInterval)
    .done();
  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() + (oavp.STAGE_HEIGHT * 0.125))
    .rotate(-45, -45, 0)
    .grids.flatbox(oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 0.25, beatAmplitudeGridInterval)
    .done();
  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() + (oavp.STAGE_HEIGHT * 0.125))
    .rotate(-45, -135, 0)
    .grids.flatbox(oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 0.25, beatAmplitudeGridInterval)
    .done();
  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() + (oavp.STAGE_HEIGHT * 0.125))
    .rotate(-45, 45, 0)
    .grids.flatbox(oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 0.25, beatAmplitudeGridInterval)
    .done();
}

void exampleFlatbox() {
  visualizers
    .create()
    .center().middle()
    .rotate(-22.5, -45, 0)
    .startStyle().fillColor(style.flat.red)
    .levels.flatbox(oavp.STAGE_WIDTH * 0.25)
    .endStyle()
    .done();

  visualizers
    .create()
    .left().middle()
    .rotate(-22.5, -45, 0)
    .startStyle().fillColor(style.flat.green)
    .levels.flatbox(oavp.STAGE_WIDTH * 0.25)
    .endStyle()
    .done();

  visualizers
    .create()
    .right().middle()
    .rotate(-22.5, -45, 0)
    .startStyle().fillColor(style.flat.blue)
    .levels.flatbox(oavp.STAGE_WIDTH * 0.25)
    .endStyle()
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

void gallery() {
  text.write(text.read("intro.txt"));
  entityPosition.moveRight();

  text.write("Square Emitter");

  visualizers
    .create()
    .center().middle()
    .rotate(0, 0, 0)
    .emitters.linearBeat(0, oavp.STAGE_WIDTH / 2, 1.0, Ani.LINEAR, visTrackers)
    .floaters.square(oavp.STAGE_WIDTH / 4, visTrackers)
    .done();

  entityPosition.moveRight();

  text.write("Levels/Beat Grid Flatbox");

  visualizers
    .create(entityPosition.getCenteredX(), entityPosition.getCenteredY() - (oavp.STAGE_HEIGHT * 0.125))
    .rotate(-45, -45, 0)
    .startStyle().fillColor(style.getSecondaryColor())
    .grids.flatbox(oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 0.25 * 0.125, beatAmplitudeGridInterval)
    .endStyle()
    .done();

  entityPosition.moveRight();

  text.write("Levels/Beat Flatbox");

  visualizers
    .create()
    .center().middle()
    .rotate(-22.5, -45, 0)
    .startStyle().fillColor(style.getSecondaryColor())
    .levels.flatbox(oavp.STAGE_WIDTH * 0.125)
    .endStyle()
    .done();

  visualizers
    .create()
    .center().middle()
    .rotate(-22.5, -45, 0)
    .startStyle().fillColor(style.getSecondaryColor())
    .beats.flatbox(oavp.STAGE_WIDTH * 0.25, beatAmplitude)
    .endStyle()
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
    .beats.ghostSquare(0, oavp.STAGE_WIDTH * 0.75, beatAmplitudeInterval, 20)
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
    .beats.square(0, oavp.STAGE_WIDTH * 0.4, beatAmplitude)
    .done();

  entityPosition.moveRight();

  text.write("Beat Ghost Circle");

  visualizers
    .create()
    .center().middle()
    .beats.ghostCircle(0, oavp.STAGE_WIDTH * 0.4, beatAmplitudeInterval, 20)
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
    .beats.circle(0, oavp.STAGE_WIDTH * 0.25, beatAmplitude)
    .done();

  entityPosition.moveRight();

  text.write("Interval Bars");
  visualizers
    .create()
    .left().top()
    .levels.intervalBars(oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT, oavp.STAGE_HEIGHT, levelInterval)
    .done();

  entityPosition.moveRight();

  pushStyle();
  fill(style.getPrimaryColor());
  noStroke();

  text.write("Custom SVG");
  PShape logo = svgs.get("test-logo");
  float logoScale = logo.width / oavp.STAGE_WIDTH;
  visualizers
    .create()
    .center().middle()
    .moveLeft(logo.width * logoScale / 2)
    .moveUp(logo.height * logoScale / 2)
    .svg(logoScale, logo)
    .done();

  popStyle();

  entityPosition.moveRight();

  text.write("Bar Spectrum");
  visualizers
    .create()
    .left().top()
    .spectrum.bars(oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT)
    .done();

  entityPosition.moveRight();

  text.write("Wire Spectrum");
  visualizers
    .create()
    .left().top()
    .spectrum.wire(oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT)
    .done();

  entityPosition.moveRight();

  text.write("Radial Bar Spectrum");
  visualizers
    .create()
    .center().middle()
    .spectrum.radialBars(oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 0.33, oavp.STAGE_WIDTH, frameCount * 0.25)
    .done();

  entityPosition.moveRight();

  text.write("Radial Wire Spectrum");
  visualizers
    .create()
    .center().middle()
    .spectrum.radialWire(oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 1.50, frameCount * 0.25)
    .done();

  entityPosition.moveRight();

  text.write("Wire Waveform");
  visualizers
    .create()
    .left().top()
    .waveform.wire(oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT)
    .done();

  entityPosition.moveRight();

  text.write("Radial Wire Waveform");
  visualizers
    .create()
    .center().middle()
    .waveform.radialWire(oavp.STAGE_WIDTH * 0.25, oavp.STAGE_WIDTH * 0.25, 0, frameCount * 0.25)
    .done();

  entityPosition.moveRight();

  text.write("Bar Levels");
  visualizers
    .create()
    .left().top()
    .levels.bars(oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT)
    .done();

  entityPosition.moveRight();

  text.write("Cube Levels");
  visualizers
    .create()
    .center().middle()
    .rotate(frameCount, frameCount)
    .levels.cube(oavp.STAGE_WIDTH * 0.75)
    .next()
    .center().middle()
    .rotate(-frameCount * 0.25, -frameCount * 0.25)
    .levels.cube(oavp.STAGE_WIDTH * 0.25)
    .done();

  entityPosition.reset();
}

void exampleGhostCircle() {
  visualizers
    .create()
    .center().middle()
    .beats.ghostCircle(0, oavp.STAGE_WIDTH * 0.75, beatAmplitudeInterval, 20)
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
    .levels.cube(oavp.STAGE_WIDTH * 0.75)
    .next()
    .center().middle()
    .rotate(-frameCount * 0.25, -frameCount * 0.25)
    .levels.cube(oavp.STAGE_WIDTH * 0.25)
    .done();
}