import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AvizData avizData;
AvizInterval levelInterval;
AvizInterval beatInterval;
AvizAmplitude beatAmplitude;
AvizPosition cameraPosition;
AvizPosition entityPosition;
AvizCamera camera;
AvizShape visualizers;
FlatUIColors flatUIColors;
PShape logo;
PFont mono;
JSONObject configs;

int primaryColor;
int secondaryColor;

void setup() {
  size(1000, 1000, P3D);
  configs = loadJSONObject("config.json");
  frameRate(configs.getInt("frameRate"));

  cameraPosition = new AvizPosition(0, 0, width);
  entityPosition = new AvizPosition(0, 0, width);
  camera = new AvizCamera(cameraPosition, entityPosition, width / 2, height / 2, 0.10);

  flatUIColors = new FlatUIColors();
  minim = new Minim(this);
  avizData = new AvizData(minim,
                          configs.getString("audioFile"),
                          configs.getInt("bufferSize"),
                          configs.getInt("minBandwidthPerOctave"),
                          configs.getInt("bandsPerOctave"));
  avizData.setSpectrumSmoothing(0.80f);
  avizData.setLevelSmoothing(0.95f);
  avizData.setBufferSmoothing(0.85f);

  levelInterval = new AvizInterval(20);
  levelInterval.setDelay(2);

  beatInterval = new AvizInterval(100);
  beatAmplitude = new AvizAmplitude(0, 1, 0.08);

  visualizers = new AvizShape(avizData, entityPosition);

  logo = loadShape("test-logo.svg");
  mono = loadFont("RobotoMono-Regular-32.vlw");
  textFont(mono, configs.getInt("fontUnit") * (Math.round(width * configs.getFloat("fontScale"))));

  targetColor = getRandomColor(cameraPosition.x, cameraPosition.y, colorSeed);

  debug();
}

void draw() {
  updateColorInterp();
  intermediateColor = lerpColor(currColor, targetColor, currInterp);
  noFill();
  strokeWeight(2);

  // Day Mode
  primaryColor = flatUIColors.black;
  secondaryColor = intermediateColor;

  // Night Mode
  // primaryColor = intermediateColor;
  // secondaryColor = flatUIColors.black;

  stroke(primaryColor);
  background(secondaryColor);

  camera.update();

  avizData.forward();
  levelInterval.update(avizData.getLeftLevel());
  beatInterval.update(avizData.isBeatOnset());
  beatAmplitude.update(avizData);

  drawGallery();
}

void drawGallery() {
  title("Beat Splash Square", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers
    .create()
    .center().middle()
    .beats.splashSquare(0, width * 0.4, beatInterval)
    .done();

  entityPosition.moveRight();

  title("Beat Square", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers
    .create()
    .center().middle()
    .beats.square(0, width * 0.4, beatAmplitude)
    .done();

  entityPosition.moveRight();

  title("Beat Splash Circle", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers
    .create()
    .center().middle()
    .beats.splashCircle(0, width * 0.4, beatInterval)
    .done();

  entityPosition.moveRight();

  title("Beat Circle", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers
    .create()
    .center().middle()
    .beats.circle(0, width * 0.25, beatAmplitude)
    .done();

  entityPosition.moveToNextLine();

  title("Interval Bars", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers
    .create()
    .left().top()
    .levels.intervalBars(width, height, height, levelInterval)
    .done();

  entityPosition.moveRight();

  title("Custom SVG", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers
    .create()
    .center().middle()
    .svg(400.0 / width, 400, logo)
    .done();

  entityPosition.moveRight();

  title("Bar Spectrum", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers
    .create()
    .left().top()
    .spectrum.bars(width, height)
    .done();

  entityPosition.moveRight();

  title("Wire Spectrum", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers
    .create()
    .left().top()
    .spectrum.wire(width, height)
    .done();

  entityPosition.moveToNextLine();

  title("Radial Bar Spectrum", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers
    .create()
    .center().middle()
    .spectrum.radialBars(width * 0.25, width * 0.33, width, frameCount * 0.25)
    .done();

  entityPosition.moveRight();

  title("Radial Wire Spectrum", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers
    .create()
    .center().middle()
    .spectrum.radialWire(width * 0.25, width * 1.50, frameCount * 0.25)
    .done();

  entityPosition.moveRight();

  title("Wire Waveform", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers
    .create()
    .left().top()
    .waveform.wire(width, height)
    .done();

  entityPosition.moveRight();

  title("Radial Wire Waveform", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers
    .create()
    .center().middle()
    .waveform.radialWire(width * 0.25, width * 0.25, 0, frameCount * 0.25)
    .done();

  entityPosition.moveToNextLine();

  title("Bar Levels", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers
    .create()
    .left().top()
    .levels.bars(width, height)
    .done();

  entityPosition.moveRight();

  title("Cube Levels", entityPosition.getScaledX(), entityPosition.getScaledY());
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