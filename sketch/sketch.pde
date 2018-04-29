import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
OavpData oavpData;
OavpInterval levelInterval;
OavpInterval beatInterval;
OavpAmplitude beatAmplitude;
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

int primaryColor;
int secondaryColor;

void setup() {
  size(1000, 1000, P3D);
  configs = loadJSONObject("config.json");
  frameRate(configs.getInt("frameRate"));

  style = new OavpStyle(configs.getInt("colorSeed"));

  cameraPosition = new OavpPosition(0, 0, width);
  entityPosition = new OavpPosition(0, 0, width);
  camera = new OavpCamera(cameraPosition, entityPosition, style, width / 2, height / 2, 0.10);

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

  visualizers = new OavpShape(oavpData, entityPosition);
  text = new OavpText(entityPosition);
  text.setPadding(20);

  logo = loadShape("test-logo.svg");
  mono = loadFont("RobotoMono-Regular-32.vlw");
  textFont(mono, configs.getInt("fontUnit") * (Math.round(width * configs.getFloat("fontScale"))));

  style.setTargetColor(cameraPosition);

  introText = text.read("intro.txt");

  debug();
}

void draw() {
  style.updateColorInterp();
  style.getIntermediateColor();
  noFill();
  strokeWeight(2);

  // Day Mode
  primaryColor = style.flat.black;
  secondaryColor = style.getIntermediateColor();

  // Night Mode
  // primaryColor = intermediateColor;
  // secondaryColor = flatUIColors.black;

  stroke(primaryColor);
  background(secondaryColor);

  camera.update();

  oavpData.forward();
  levelInterval.update(oavpData.getLeftLevel());
  beatInterval.update(oavpData.isBeatOnset());
  beatAmplitude.update(oavpData);

  drawGallery();
}

void drawGallery() {

  text.write(introText);

  entityPosition.moveRight();

  text.write("Beat Splash Square");
  visualizers
    .create()
    .center().middle()
    .beats.splashSquare(0, width * 0.4, beatInterval)
    .done();

  entityPosition.moveRight();

  text.write("Beat Square");
  visualizers
    .create()
    .center().middle()
    .beats.square(0, width * 0.4, beatAmplitude)
    .done();

  entityPosition.moveRight();

  text.write("Beat Splash Circle");
  visualizers
    .create()
    .center().middle()
    .beats.splashCircle(0, width * 0.4, beatInterval)
    .done();

  entityPosition.moveToNextLine();

  text.write("Beat Circle");
  visualizers
    .create()
    .center().middle()
    .beats.circle(0, width * 0.25, beatAmplitude)
    .done();

  entityPosition.moveRight();

  text.write("Interval Bars");
  visualizers
    .create()
    .left().top()
    .levels.intervalBars(width, height, height, levelInterval)
    .done();

  entityPosition.moveRight();

  text.write("Custom SVG");
  visualizers
    .create()
    .center().middle()
    .svg(400.0 / width, 400, logo)
    .done();

  entityPosition.moveRight();

  text.write("Bar Spectrum");
  visualizers
    .create()
    .left().top()
    .spectrum.bars(width, height)
    .done();

  entityPosition.moveToNextLine();

  text.write("Wire Spectrum");
  visualizers
    .create()
    .left().top()
    .spectrum.wire(width, height)
    .done();

  entityPosition.moveRight();

  text.write("Radial Bar Spectrum");
  visualizers
    .create()
    .center().middle()
    .spectrum.radialBars(width * 0.25, width * 0.33, width, frameCount * 0.25)
    .done();

  entityPosition.moveRight();

  text.write("Radial Wire Spectrum");
  visualizers
    .create()
    .center().middle()
    .spectrum.radialWire(width * 0.25, width * 1.50, frameCount * 0.25)
    .done();

  entityPosition.moveRight();

  text.write("Wire Waveform");
  visualizers
    .create()
    .left().top()
    .waveform.wire(width, height)
    .done();

  entityPosition.moveToNextLine();

  text.write("Radial Wire Waveform");
  visualizers
    .create()
    .center().middle()
    .waveform.radialWire(width * 0.25, width * 0.25, 0, frameCount * 0.25)
    .done();

  entityPosition.moveRight();

  text.write("Bar Levels");
  visualizers
    .create()
    .left().top()
    .levels.bars(width, height)
    .done();

  entityPosition.moveRight();

  text.write("Cube Levels");
  visualizers
    .create()
    .center().middle()
    .rotate(frameCount, frameCount)
    .levels.cube(width * 0.75)
    .next()
    .center().middle()
    .rotate(-frameCount * 0.25, -frameCount * 0.25)
    .levels.cube(width * 0.25)
    .done();

  entityPosition.reset();
}