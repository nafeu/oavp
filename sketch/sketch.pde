import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AvizData avizData;
AvizInterval levelInterval;
AvizInterval beatInterval;
AvizAmplitude beatAmplitude;
AvizPosition cameraPosition;
AvizPosition entities;
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

  entities = new AvizPosition(0, 0, width);

  xOffset = width/2.0;
  yOffset = height/2.0;

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

  updateCamera();
  avizData.forward();
  levelInterval.update(avizData.getLeftLevel());
  beatInterval.update(avizData.isBeatOnset());
  beatAmplitude.update(avizData);
  drawGallery();
}

void drawGallery() {

  title("Beat Splash Square (Diamond)", entities.getScaledX(), entities.getScaledY());
  visualizers.beats.splashSquare(entities.getCenteredX(), entities.getCenteredY(), 0, width * 0.4, 45, beatInterval);

  entities.moveRight();

  title("Beat Square (Diamond)", entities.getScaledX(), entities.getScaledY());
  visualizers.beats.square(entities.getCenteredX(), entities.getCenteredY(), 0, width * 0.4, 45, beatAmplitude);

  entities.moveRight();

  title("Beat Splash Circle", entities.getScaledX(), entities.getScaledY());
  visualizers.beats.splashCircle(entities.getCenteredX(), entities.getCenteredY(), 0, width * 0.4, beatInterval);

  entities.moveRight();

  title("Beat Circle", entities.getScaledX(), entities.getScaledY());
  visualizers.beats.circle(entities.getCenteredX(), entities.getCenteredY(), 0, width * 0.25, beatAmplitude);

  entities.moveToNextLine();

  title("Interval Bars", entities.getScaledX(), entities.getScaledY());
  visualizers.levels.intervalBars(entities.getScaledX(), entities.getScaledY(), width, height, height, levelInterval);

  entities.moveRight();

  title("Custom SVG", entities.getScaledX(), entities.getScaledY());
  visualizers.svg(entities.getCenteredX(), entities.getCenteredY(), 400.0 / width, 400, logo);

  entities.moveRight();

  title("Bar Spectrum", entities.getScaledX(), entities.getScaledY());
  visualizers.spectrum.bars(entities.getScaledX(), entities.getScaledY(), width, height);

  entities.moveRight();

  title("Wire Spectrum", entities.getScaledX(), entities.getScaledY());
  visualizers.spectrum.wire(entities.getScaledX(), entities.getScaledY(), width, height);

  entities.moveToNextLine();

  title("Radial Bar Spectrum", entities.getScaledX(), entities.getScaledY());
  visualizers.spectrum.radialBars(entities.getCenteredX(), entities.getCenteredY(), width * 0.25, width * 0.33, width, frameCount * 0.25);

  entities.moveRight();

  title("Radial Wire Spectrum", entities.getScaledX(), entities.getScaledY());
  visualizers.spectrum.radialWire(entities.getCenteredX(), entities.getCenteredY(), width * 0.25, width * 1.50, frameCount * 0.25);

  entities.moveRight();

  title("Wire Waveform", entities.getScaledX(), entities.getScaledY());
  visualizers.waveform.wire(entities.getScaledX(), entities.getScaledY(), width, height);

  entities.moveRight();

  title("Radial Wire Waveform", entities.getScaledX(), entities.getScaledY());
  visualizers.waveform.radialWire(entities.getCenteredX(), entities.getCenteredY(), width * 0.25, width * 0.25, 0, frameCount * 0.25);

  entities.moveToNextLine();

  title("Bar Levels", entities.getScaledX(), entities.getScaledY());
  visualizers.levels.bars(entities.getScaledX(), entities.getScaledY(), width, height);

  entities.moveRight();

  title("Cube Levels", entities.getScaledX(), entities.getScaledY());
  visualizers.levels.cube(entities.getCenteredX(), entities.getCenteredY(), width * 0.75, frameCount);
  visualizers.levels.cube(entities.getCenteredX(), entities.getCenteredY(), width * 0.25, -frameCount * 0.25);

  entities.reset();
}