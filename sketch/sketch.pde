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
AvizShapes visualizers;
FlatUIColors flatUIColors;

final int FPS = 60;

final int bufferSize = 1024;
final int minBandwidthPerOctave = 200;
final int bandsPerOctave = 30;

int primaryColor;
int secondaryColor;

float fontUnit = 8;
float fontScale = 0.0033;

PShape logo;
PFont mono;

void setup() {
  frameRate(FPS);
  size(600, 600, P3D);

  cameraPosition = new AvizPosition(0, 0, width);
  entityPosition = new AvizPosition(0, 0, width);
  camera = new AvizCamera(cameraPosition, entityPosition, width / 2, height / 2);

  flatUIColors = new FlatUIColors();
  minim = new Minim(this);
  avizData = new AvizData(minim,
                          "test-audio.mp3",
                          bufferSize,
                          minBandwidthPerOctave,
                          bandsPerOctave);
  avizData.setSpectrumSmoothing(0.80f);
  avizData.setLevelSmoothing(0.95f);
  avizData.setBufferSmoothing(0.85f);

  levelInterval = new AvizInterval(20);
  levelInterval.setDelay(2);

  beatInterval = new AvizInterval(100);
  beatAmplitude = new AvizAmplitude(0, 1, 0.08);

  visualizers = new AvizShapes(avizData);

  logo = loadShape("test-logo.svg");
  mono = loadFont("RobotoMono-Regular-32.vlw");
  textFont(mono, 8 * (Math.round(width * 0.0033)));

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

  title("Beat Splash Square (Diamond)", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers.beats.splashSquare(entityPosition.getCenteredX(), entityPosition.getCenteredY(), 0, width * 0.4, 45, beatInterval);

  entityPosition.moveRight();

  title("Beat Square (Diamond)", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers.beats.square(entityPosition.getCenteredX(), entityPosition.getCenteredY(), 0, width * 0.4, 45, beatAmplitude);

  entityPosition.moveRight();

  title("Beat Splash Circle", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers.beats.splashCircle(entityPosition.getCenteredX(), entityPosition.getCenteredY(), 0, width * 0.4, beatInterval);

  entityPosition.moveRight();

  title("Beat Circle", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers.beats.circle(entityPosition.getCenteredX(), entityPosition.getCenteredY(), 0, width * 0.25, beatAmplitude);

  entityPosition.moveToNextLine();

  title("Interval Bars", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers.levels.intervalBars(entityPosition.getScaledX(), entityPosition.getScaledY(), width, height, height, levelInterval);

  entityPosition.moveRight();

  title("Custom SVG", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers.svg(entityPosition.getCenteredX(), entityPosition.getCenteredY(), 400.0 / width, 400, logo);

  entityPosition.moveRight();

  title("Bar Spectrum", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers.spectrum.bars(entityPosition.getScaledX(), entityPosition.getScaledY(), width, height);

  entityPosition.moveRight();

  title("Wire Spectrum", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers.spectrum.wire(entityPosition.getScaledX(), entityPosition.getScaledY(), width, height);

  entityPosition.moveToNextLine();

  title("Radial Bar Spectrum", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers.spectrum.radialBars(entityPosition.getCenteredX(), entityPosition.getCenteredY(), width * 0.25, width * 0.33, width, frameCount * 0.25);

  entityPosition.moveRight();

  title("Radial Wire Spectrum", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers.spectrum.radialWire(entityPosition.getCenteredX(), entityPosition.getCenteredY(), width * 0.25, width * 1.50, frameCount * 0.25);

  entityPosition.moveRight();

  title("Wire Waveform", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers.waveform.wire(entityPosition.getScaledX(), entityPosition.getScaledY(), width, height);

  entityPosition.moveRight();

  title("Radial Wire Waveform", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers.waveform.radialWire(entityPosition.getCenteredX(), entityPosition.getCenteredY(), width * 0.25, width * 0.25, 0, frameCount * 0.25);

  entityPosition.moveToNextLine();

  title("Bar Levels", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers.levels.bars(entityPosition.getScaledX(), entityPosition.getScaledY(), width, height);

  entityPosition.moveRight();

  title("Cube Levels", entityPosition.getScaledX(), entityPosition.getScaledY());
  visualizers.levels.cube(entityPosition.getCenteredX(), entityPosition.getCenteredY(), width * 0.75, frameCount);
  visualizers.levels.cube(entityPosition.getCenteredX(), entityPosition.getCenteredY(), width * 0.25, -frameCount * 0.25);

  entityPosition.reset();
}