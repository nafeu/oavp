import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
BandData bandData;
Colors colors = new Colors();

// Configs
final int FPS = 60;

final int stageWidth = 700;
final int stageHeight = 700;

final int bufferSize = 1024;
final int minBandwidthPerOctave = 200;
final int bandsPerOctave = 10;
final float smoothing = 0.80;

int avgSize;
float[] data;

void setup() {
  frameRate(FPS);
  // size(stageWidth, stageHeight);
  size(700, 700); // Account for variable bug in processing-sublime;

  minim = new Minim(this);
  bandData = new BandData(minim,
                          "test-audio-1.mp3",
                          bufferSize,
                          minBandwidthPerOctave,
                          bandsPerOctave,
                          smoothing);
}

void draw() {
  background(colors.darkRed);
  noFill();
  stroke(colors.white);

  debug();

  data = bandData.getForwardSpectrumData();
  avgSize = bandData.getAvgSize();

  drawRectangleSpectrum();
  drawLineSpectrum();
  drawWaveForm();
  drawLevels();
}

void drawRectangleSpectrum() {
  for (int i = 0; i < avgSize; i++) {
    float displayAmplitude = bandData.getDisplayAmplitude(data[i]);
    rect(i * (stageWidth / avgSize), stageHeight, (stageWidth / avgSize), -(stageHeight / 2) * displayAmplitude);
  }
}

void drawLineSpectrum() {
  translate(0, stageHeight / 2);
  beginShape(LINES);
  for (int i = 0; i < avgSize - 1; i++) {
    vertex(i * (stageWidth / avgSize), -(stageHeight / 2) * bandData.getDisplayAmplitude(data[i]));
    vertex((i + 1) * (stageWidth / avgSize), -(stageHeight / 2) * bandData.getDisplayAmplitude(data[i + 1]));
  }
  endShape();
}

void drawWaveForm() {
  int audioBufferSize = bandData.getBufferSize();
  for(int i = 0; i < audioBufferSize - 1; i++) {
    float x1 = map( i, 0, audioBufferSize, 0, stageWidth );
    float x2 = map( i+1, 0, audioBufferSize, 0, stageWidth );
    line( x1, 50 + bandData.getLeftBuffer(i)*50, x2, 50 + bandData.getLeftBuffer(i+1)*50 );
    line( x1, 150 + bandData.getRightBuffer(i)*50, x2, 150 + bandData.getRightBuffer(i+1)*50 );
  }
}

void drawLevels() {
  rect( 0, 0, bandData.getLeftLevel() * stageWidth, 100 );
  rect( 0, 100, bandData.getRightLevel() * stageWidth, 100 );
}

void debug() {
  String output = "bufferSize: " + String.valueOf(bufferSize);
  output += ", minBandwidthPerOctave: " + String.valueOf(minBandwidthPerOctave);
  output += ", bandsPerOctave: " + String.valueOf(bandsPerOctave);
  output += ", smoothing: " + String.valueOf(smoothing);
  text(output, 10, 20);
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