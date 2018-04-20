import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AvizData avizData;
Colors colors;

// Configs
final int FPS = 60;

final int stageWidth = 500;
final int stageHeight = 500;

final int bufferSize = 1024;
final int minBandwidthPerOctave = 200;
final int bandsPerOctave = 10;
final float smoothing = 0.80;
final float bufferSmoothing = 0.50;

final int stageDivider = 4;
final int stageHeightDivided = (stageHeight / stageDivider);

float eyeZ = 0;

float[] data;

void setup() {
  frameRate(FPS);
  // size(stageWidth, stageHeight);
  size(500, 500, P3D); // Account for variable bug in processing-sublime;

  colors = new Colors();
  minim = new Minim(this);
  avizData = new AvizData(minim,
                          "test-audio.mp3",
                          bufferSize,
                          minBandwidthPerOctave,
                          bandsPerOctave);
  avizData.setSpectrumSmoothing(smoothing);
  avizData.setLevelSmoothing(smoothing);
  avizData.setBufferSmoothing(bufferSmoothing);
}

void draw() {
  float centerX = width/2.0 + map(mouseX, 0, stageWidth, -(stageWidth / 2), (stageWidth / 2));
  float centerY = height/2.0 + map(mouseY, 0, stageHeight, -(stageHeight / 2), (stageHeight / 2));
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0) + eyeZ,
         centerX, centerY, 0,
         0, 1, 0);
  background(colors.darkBlue);
  noFill();
  stroke(colors.white);
  debug();

  avizData.forward();

  avizBarSpectrum(0, 0, stageWidth, stageHeightDivided, avizData);
  avizLineSpectrum(0, stageHeightDivided, stageWidth, stageHeightDivided, avizData);
  avizLineWaveform(0, stageHeightDivided * 2, stageWidth, stageHeightDivided, avizData);
  avizBarLevels(0, stageHeightDivided * 3, stageWidth, stageHeightDivided, avizData);
}

void drawRotatingBoxExample() {
  translate(stageWidth / 2, stageHeight / 2);
  rotateY(radians(frameCount));
  float boxLevel = ((avizData.getLeftLevel() + avizData.getRightLevel()) / 2) * stageWidth;
  box(boxLevel, boxLevel, boxLevel);
}

void debug() {
  String output = "bufferSize: " + String.valueOf(bufferSize);
  output += ", minBandwidthPerOctave: " + String.valueOf(minBandwidthPerOctave);
  output += ", bandsPerOctave: " + String.valueOf(bandsPerOctave);
  output += ", smoothing: " + String.valueOf(smoothing);
  text(output, 10, -20);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  eyeZ += e * 20;
}

public class Colors {
  int teal = #1abc9c;
  int darkTeal = #16a085;
  int green = #2ecc71;
  int darkGreen = #27ae60;
  int blue = #3498db;
  int darkBlue = #2980b9;
  int purple = #9b59b6;
  int darkPurple = #8e44ad;
  int red = #e74c3c;
  int darkRed = #c0392b;
  int orange = #e67e22;
  int darkOrange = #d35400;
  int yellow = #f1c40f;
  int darkYellow = #f39c12;
  int grey = #95a5a6;
  int darkGrey = #7f8c8d;
  int primary = #ecf0f1;
  int darkPrimary = #bdc3c7;
  int secondary = #34495e;
  int darkSecondary = #2c3e50;
  int white = #FFFFFF;
  int black = #000000;
  Colors() {}
}