import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AvizData avizData;
FlatUIColors flatUIColors;

final int FPS = 60;

final int bufferSize = 1024;
final int minBandwidthPerOctave = 200;
final int bandsPerOctave = 30;

float paramA = 0;
float deltaA = 16;
float paramB = 0;
float deltaB = 16;
float paramC = 0;
float deltaC = 16;
float paramD = 0;
float deltaD = 16;
float paramE = 0;
float deltaE = 16;

StagePosition cameraPosition;
StagePosition entities;

// Camera Values
float targetCameraX = 0;
float targetCameraY = 0;
float targetCameraZ = 0;
float currCameraX = 0;
float currCameraY = 0;
float currCameraZ = 0;
float cameraEasing = 0.10;

// int colorSeed = Math.round(random(0, 100));
int colorSeed = 25;
int currColor = 0;
int targetColor;
float currInterp = 0.0;
float targetInterp = 1.0;
float colorEasing = 0.05;

PShape logo;
PFont mono;

void setup() {
  frameRate(FPS);
  size(1000, 1000, P3D);

  cameraPosition = new StagePosition(0, 0, width);

  flatUIColors = new FlatUIColors();
  minim = new Minim(this);
  avizData = new AvizData(minim,
                          "sample.mp3",
                          bufferSize,
                          minBandwidthPerOctave,
                          bandsPerOctave);
  avizData.setSpectrumSmoothing(0.80f);
  avizData.setLevelSmoothing(0.95f);
  avizData.setBufferSmoothing(0.85f);

  logo = loadShape("test-logo.svg");
  mono = loadFont("RobotoMono-Regular-32.vlw");
  textFont(mono, 32);

  targetColor = getBackgroundColor(cameraPosition.x, cameraPosition.y, colorSeed);

  debug();
}

void draw() {
  noCursor();
  updateBackgroundColorInterp();
  background(lerpColor(currColor, targetColor, currInterp));
  stroke(flatUIColors.black);
  noFill();
  strokeWeight(2);

  updateCamera();
  avizData.forward();
  mainSketch();
}

void mainSketch() {
  entities = new StagePosition(0, 0, width);

  title("Custom SVG Logo", entities.getScaledX(), entities.getScaledY());
  avizLogo(entities.getCenteredX(), entities.getCenteredY(), 2, 400, logo);

  entities.moveRight();

  title("Rectangular Bar Spectrum", entities.getScaledX(), entities.getScaledY());
  avizBarSpectrum(entities.getScaledX(), entities.getScaledY(), width, height, avizData);

  entities.moveRight();

  title("Rectangular Line Spectrum", entities.getScaledX(), entities.getScaledY());
  avizLineSpectrum(entities.getScaledX(), entities.getScaledY(), width, height, avizData);

  entities.moveRight();

  title("Rectangular Bar Levels", entities.getScaledX(), entities.getScaledY());
  avizBarLevels(entities.getScaledX(), entities.getScaledY(), width, height, avizData);

  entities.moveRight();

  title("Rectangular Line Waveform", entities.getScaledX(), entities.getScaledY());
  avizLineWaveform(entities.getScaledX(), entities.getScaledY(), width, height, avizData);

  entities.moveToNextLine();

  title("3D Rotating Box", entities.getScaledX(), entities.getScaledY());
  avizRotatingBox(entities.getCenteredX(), entities.getCenteredY(), width * 0.75, frameCount, avizData);
  avizRotatingBox(entities.getCenteredX(), entities.getCenteredY(), width * 0.25, -frameCount * 0.25, avizData);

  entities.moveRight();

  title("Circular Bar Spectrum", entities.getScaledX(), entities.getScaledY());
  avizCircleBarSpectrum(entities.getCenteredX(), entities.getCenteredY(), width * 0.25, width * 0.33, width, frameCount * 0.25, avizData);

  entities.moveRight();

  title("Circular Line Spectrum", entities.getScaledX(), entities.getScaledY());
  avizCircleLineSpectrum(entities.getCenteredX(), entities.getCenteredY(), width * 0.25, width * 1.50, frameCount * 0.25, avizData);

  entities.moveRight();

  title("Circular Line Waveform", entities.getScaledX(), entities.getScaledY());
  avizCircleLineWaveform(entities.getCenteredX(), entities.getCenteredY(), width * 0.25, width * 0.25, 0, frameCount * 0.25, avizData);
}