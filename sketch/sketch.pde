import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AvizData avizData;
Colors colors;

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

int stagePositionX = 0;
int stagePositionY = 0;
float targetCameraX = 0;
float targetCameraY = 0;
float targetCameraZ = 0;
float currCameraX = 0;
float currCameraY = 0;
float currCameraZ = 0;
float easing = 0.10;

PShape logo;

void setup() {
  frameRate(FPS);
  size(1000, 1000, P3D);

  colors = new Colors();
  minim = new Minim(this);
  avizData = new AvizData(minim,
                          "test-audio.mp3",
                          bufferSize,
                          minBandwidthPerOctave,
                          bandsPerOctave);
  avizData.setSpectrumSmoothing(0.80f);
  avizData.setLevelSmoothing(0.95f);
  avizData.setBufferSmoothing(0.85f);

  logo = loadShape("test-logo.svg");

  debug();
}

void draw() {
  noCursor();
  background(colors.teal);
  stroke(colors.black);
  noFill();
  strokeWeight(2);

  float centerX;
  float centerY;

  if (mousePressed && (mouseButton == LEFT)) {
    centerX = width/2.0 + map(mouseX, 0, width, -(width / 2), (width / 2));
    centerY = height/2.0 + map(mouseY, 0, height, -(height / 2), (height / 2));
  } else {
    centerX = width/2.0;
    centerY = height/2.0;
  }

  float dx = targetCameraX - currCameraX;
  currCameraX += dx * easing;

  float dy = targetCameraY - currCameraY;
  currCameraY += dy * easing;

  float dz = targetCameraZ - currCameraZ;
  currCameraZ += dz * easing;

  camera(width/2.0 + currCameraX, height/2.0 + currCameraY, (height/2.0) / tan(PI*30.0 / 180.0) + currCameraZ,
         centerX + currCameraX, centerY + currCameraY, 0,
         0, 1, 0);

  avizData.forward();

  exampleSketch();
}

void exampleSketch() {
  avizLogo(width / 2, height / 2, 0.50f, 400, logo);
  avizCircleLineWaveform(width / 2, height / 2, 0, 50, 200, frameCount * 0.25, avizData);
  avizCircleBarSpectrum(width / 2, height / 2, 160, 232, 1024, frameCount * 0.25, avizData);
  avizBarSpectrum(0, height - (height / 4), width, height / 4, avizData);
  avizLineSpectrum(0, height / 4, width, -(height / 4), avizData);
  // avizLineWaveform(0, 0, width, height, avizData);
  // avizBarLevels(0, height, width, height, avizData);
  avizRotatingBox(0 + 144, height / 2, 200, frameCount, avizData);
  avizRotatingBox(0 + 144, height / 2, 100, -frameCount * 0.25, avizData);
  avizRotatingBox(width - 144, height / 2, 200, frameCount, avizData);
  avizRotatingBox(width - 144, height / 2, 100, -frameCount * 0.25, avizData);
}