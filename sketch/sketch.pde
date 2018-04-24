import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AvizData avizData;
AvizPosition cameraPosition;
AvizPosition entities;
AvizShapes visualizers;
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

// Camera Values
float targetCameraX = 0;
float targetCameraY = 0;
float targetCameraZ = 0;
float currCameraX = 0;
float currCameraY = 0;
float currCameraZ = 0;
float cameraEasing = 0.10;
float finalEyeX;
float finalEyeY;
float finalEyeZ;
float finalCenterX;
float finalCenterY;
float finalCenterZ;
float finalUpX;
float finalUpY;
float finalUpZ;


float xOffset;
float yOffset;

// int colorSeed = Math.round(random(0, 100));
int colorSeed = 25;
int currColor = 0;
int intermediateColor = 0;
int targetColor;
float currInterp = 0.0;
float targetInterp = 1.0;
float colorEasing = 0.025;

PShape logo;
PFont mono;


void setup() {
  frameRate(FPS);
  size(1000, 1000, P3D);

  cameraPosition = new AvizPosition(0, 0, width);

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

  visualizers = new AvizShapes(avizData);

  logo = loadShape("test-logo.svg");
  mono = loadFont("RobotoMono-Regular-32.vlw");
  textFont(mono, 32);

  targetColor = getBackgroundColor(cameraPosition.x, cameraPosition.y, colorSeed);

  debug();

  entities = new AvizPosition(0, 0, width);

  xOffset = width/2.0;
  yOffset = height/2.0;
}

void draw() {
  // noCursor();
  updateBackgroundColorInterp();
  intermediateColor = lerpColor(currColor, targetColor, currInterp);
  background(intermediateColor);
  stroke(flatUIColors.black);
  noFill();
  strokeWeight(2);
  updateCamera();
  avizData.forward();
  mainSketch();
}

void mainSketch() {
  title("Custom SVG", entities.getScaledX(), entities.getScaledY());
  visualizers.svg(entities.getCenteredX(), entities.getCenteredY(), 2, 400, logo);

  entities.moveRight();

  title("Bar Spectrum", entities.getScaledX(), entities.getScaledY());
  visualizers.spectrum.bars(entities.getScaledX(), entities.getScaledY(), width, height);

  entities.moveRight();

  title("Wire Spectrum", entities.getScaledX(), entities.getScaledY());
  visualizers.spectrum.wire(entities.getScaledX(), entities.getScaledY(), width, height);

  entities.moveRight();

  title("Radial Bar Spectrum", entities.getScaledX(), entities.getScaledY());
  visualizers.spectrum.radialBars(entities.getCenteredX(), entities.getCenteredY(), width * 0.25, width * 0.33, width, frameCount * 0.25);

  entities.moveRight();

  title("Radial Wire Spectrum", entities.getScaledX(), entities.getScaledY());
  visualizers.spectrum.radialWire(entities.getCenteredX(), entities.getCenteredY(), width * 0.25, width * 1.50, frameCount * 0.25);

  entities.moveToNextLine();

  title("Wire Waveform", entities.getScaledX(), entities.getScaledY());
  visualizers.waveform.wire(entities.getScaledX(), entities.getScaledY(), width, height);

  entities.moveRight();

  title("Radial Wire Waveform", entities.getScaledX(), entities.getScaledY());
  visualizers.waveform.radialWire(entities.getCenteredX(), entities.getCenteredY(), width * 0.25, width * 0.25, 0, frameCount * 0.25);

  entities.moveRight();

  title("Bar Levels", entities.getScaledX(), entities.getScaledY());
  visualizers.levels.bars(entities.getScaledX(), entities.getScaledY(), width, height);

  entities.moveRight();

  title("Cube Levels", entities.getScaledX(), entities.getScaledY());
  visualizers.levels.cube(entities.getCenteredX(), entities.getCenteredY(), width * 0.75, frameCount);
  visualizers.levels.cube(entities.getCenteredX(), entities.getCenteredY(), width * 0.25, -frameCount * 0.25);

  entities.reset();
}