import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
OavpData oavpData;
OavpInterval levelInterval;
OavpInterval beatInterval;
OavpAmplitude beatAmplitude;
OavpInterval beatAmplitudeInterval;
OavpPosition cameraPosition;
OavpPosition entityPosition;
OavpCamera camera;
OavpShape visualizers;
OavpText text;
OavpStyle style;
String introText;
PShape logo;
PFont mono;
JSONObject configs;

float stageWidth = 1000;
float stageHeight = 1000;
float gridScale = 1000;

boolean isDayMode = true;
int primaryColor;
int secondaryColor;
int defaultStrokeWeight = 2;

void setup() {
  // size(1280, 1000, P3D);
  fullScreen(P3D);
  configs = loadJSONObject("config.json");
  frameRate(configs.getInt("frameRate"));

  style = new OavpStyle(configs.getInt("colorAccent"));

  cameraPosition = new OavpPosition(0, 0, gridScale);
  entityPosition = new OavpPosition(0, 0, gridScale);
  camera = new OavpCamera(cameraPosition, entityPosition, style, stageWidth / 2, stageHeight / 2, 0.10);

  minim = new Minim(this);

  oavpData = new OavpData(minim,
                          // configs.getString("audioFile"),
                          configs.getInt("bufferSize"),
                          configs.getInt("minBandwidthPerOctave"),
                          configs.getInt("bandsPerOctave"));

  oavpData.setSpectrumSmoothing(0.80f);
  oavpData.setLevelSmoothing(0.95f);
  oavpData.setBufferSmoothing(0.85f);

  levelInterval = new OavpInterval(20);
  levelInterval.setDelay(2);

  beatInterval = new OavpInterval(100);
  beatAmplitude = new OavpAmplitude(0, 1, 0.08);
  beatAmplitudeInterval = new OavpInterval(20);

  visualizers = new OavpShape(oavpData, entityPosition);
  text = new OavpText(entityPosition);
  text.setPadding(20);

  logo = loadShape("test-logo.svg");
  mono = loadFont("RobotoMono-Regular-32.vlw");
  textFont(mono, configs.getInt("fontUnit") * (Math.round(stageWidth * configs.getFloat("fontScale"))));

  style.setTargetColor(cameraPosition);

  introText = text.read("intro.txt");

  debug();
}

void draw() {
  style.updateColorInterp();
  style.getIntermediateColor();
  noFill();
  strokeWeight(2);

  if (isDayMode) {
    primaryColor = style.flat.black;
    secondaryColor = style.getIntermediateColor();
  } else {
    primaryColor = style.getIntermediateColor();
    secondaryColor = style.flat.black;
  }

  stroke(primaryColor);
  background(secondaryColor);

  camera.update();

  oavpData.forward();
  levelInterval.updateAveraged(oavpData.getLeftLevel());
  beatInterval.update(oavpData.isBeatOnset());
  beatAmplitude.update(oavpData);
  beatAmplitudeInterval.update(beatAmplitude.getValue());

  drawGallery();
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

void drawGallery() {

  text.write(introText);

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

  text.write("Beat Splash Circle");
  visualizers
    .create()
    .center().middle()
    .beats.splashCircle(0, stageWidth * 0.4, beatInterval)
    .done();

  entityPosition.moveToNextLine();

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

  text.write("Custom SVG");
  visualizers
    .create()
    .center().middle()
    .svg(400.0 / stageWidth, 400, logo)
    .done();

  entityPosition.moveRight();

  text.write("Bar Spectrum");
  visualizers
    .create()
    .left().top()
    .spectrum.bars(stageWidth, stageHeight)
    .done();

  entityPosition.moveToNextLine();

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

  entityPosition.moveToNextLine();

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