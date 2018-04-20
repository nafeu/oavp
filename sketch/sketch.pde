import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AvizData avizData;
Colors colors;

// Configs
final int FPS = 60;

final int bufferSize = 1024;
final int minBandwidthPerOctave = 200;
final int bandsPerOctave = 30;

final int stageDivider = 4;
int partitionedHeight;

float eyeZ = 0;

float[] data;

PShape logo;

void setup() {
  frameRate(FPS);
  // size(width, stageHeight);
  size(1000, 1000, P3D); // Account for variable bug in processing-sublime;
  partitionedHeight = (height / stageDivider);

  colors = new Colors();
  minim = new Minim(this);
  avizData = new AvizData(minim,
                          "test-audio.mp3",
                          bufferSize,
                          minBandwidthPerOctave,
                          bandsPerOctave);
  avizData.setSpectrumSmoothing(0.80f);
  avizData.setLevelSmoothing(0.95f);
  avizData.setBufferSmoothing(0.80f);

  logo = loadShape("test-logo.svg");
}

void draw() {
  float centerX = width/2.0 + map(mouseX, 0, width, -(width / 2), (width / 2));
  float centerY = height/2.0 + map(mouseY, 0, height, -(height / 2), (height / 2));
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0) + eyeZ,
         centerX, centerY, 0,
         0, 1, 0);

  background(colors.yellow);
  noFill();
  stroke(colors.black);
  debug();
  // rect(0, 0, width, stageHeight);

  avizData.forward();

  avizBarSpectrum(0, 0, width, partitionedHeight, avizData);
  avizLineSpectrum(0, partitionedHeight, width, partitionedHeight, avizData);
  avizLineWaveform(0, partitionedHeight * 2, width, partitionedHeight, avizData);
  avizBarLevels(0, partitionedHeight * 3, width, partitionedHeight, avizData);
  avizRotatingBox(width / 2, height / 2, 200, frameCount, avizData);
  avizRotatingBox(width / 2, height / 2, 100, -frameCount * 0.25, avizData);
  avizLogo(width / 2, height / 2, 0.50f, 400, logo);
  avizCircleSpectrum(width / 2, height / 2, 100, 150, 700, frameCount * 0.25, avizData);
}

void debug() {
  String output = "bufferSize: " + String.valueOf(bufferSize);
  output += ", minBandwidthPerOctave: " + String.valueOf(minBandwidthPerOctave);
  output += ", bandsPerOctave: " + String.valueOf(bandsPerOctave);
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