import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
BandData bandData;
Colors colors = new Colors();

// Configs
final int FPS = 60;

final int stageWidth = 1000;
final int stageHeight = 1000;

final int bufferSize = 1024;
final int minBandwidthPerOctave = 200;
final int bandsPerOctave = 10;
final float smoothing = 0.80;

final int stageDivider = 3;

float eyeZ = 0;

int avgSize;
float[] data;

void setup() {
  frameRate(FPS);
  // size(stageWidth, stageHeight);
  size(1000, 1000, P3D); // Account for variable bug in processing-sublime;

  minim = new Minim(this);
  bandData = new BandData(minim,
                          "test-audio.mp3",
                          bufferSize,
                          minBandwidthPerOctave,
                          bandsPerOctave,
                          smoothing);
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

  data = bandData.getForwardSpectrumData();
  avgSize = bandData.getAvgSize();

  drawLevels();
  drawWaveForm();

  translate(0, (stageHeight / stageDivider));
  drawLineSpectrum();

  translate(0, (stageHeight / stageDivider));
  drawRectangleSpectrum();
}

void drawRectangleSpectrum() {
  for (int i = 0; i < avgSize; i++) {
    float displayAmplitude = bandData.getDisplayAmplitude(data[i]);
    rect(i * (stageWidth / avgSize), (stageHeight / stageDivider), (stageWidth / avgSize), -(stageHeight / stageDivider) * displayAmplitude);
  }
}

void drawLineSpectrum() {
  beginShape(LINES);
  for (int i = 0; i < avgSize - 1; i++) {
    vertex(i * (stageWidth / avgSize), -(stageHeight / stageDivider) * bandData.getDisplayAmplitude(data[i]) + (stageHeight / stageDivider));
    vertex((i + 1) * (stageWidth / avgSize), -(stageHeight / stageDivider) * bandData.getDisplayAmplitude(data[i + 1]) + (stageHeight / stageDivider));
  }
  endShape();
}

void drawWaveForm() {
  int audioBufferSize = bandData.getBufferSize();
  for(int i = 0; i < audioBufferSize - 1; i++) {
    float x1 = map( i, 0, audioBufferSize, 0, stageWidth );
    float x2 = map( i + 1, 0, audioBufferSize, 0, stageWidth );
    float leftLevelScale = ((stageHeight / stageDivider) / 4);
    float rightLevelScale = ((stageHeight / stageDivider) / 4) * 3;
    float waveformScale = ((stageHeight / stageDivider) / 4);
    line( x1, leftLevelScale + bandData.getLeftBuffer(i) * waveformScale, x2, leftLevelScale + bandData.getLeftBuffer(i+1) * waveformScale );
    line( x1, rightLevelScale + bandData.getRightBuffer(i) * waveformScale, x2, rightLevelScale + bandData.getRightBuffer(i+1) * waveformScale );
  }
}

void drawLevels() {
  rect( 0, 0, bandData.getLeftLevel() * stageWidth, (stageHeight / stageDivider) / 2);
  rect( 0, (stageHeight / stageDivider) / 2, bandData.getRightLevel() * stageWidth, (stageHeight / stageDivider) / 2 );
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