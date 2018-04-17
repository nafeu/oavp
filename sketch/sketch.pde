import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
BandData bandData;

// Configs
final int FPS = 60;

final int stageWidth = 700;
final int stageHeight = 700;

final int bufferSize = 1024;
final int minBandwidthPerOctave = 200;
final int bandsPerOctave = 10;
final float smoothing = 0.80;

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
  background(0);
  fill(255);
  stroke(255);

  debug();

  float[] data = bandData.getForwardSpectrumData();
  int avgSize = bandData.getAvgSize();

  drawRectangleSpectrum(avgSize, data);
  drawLineSpectrum(avgSize, data);
  drawWaveForm();
  drawLevels();
}

void drawRectangleSpectrum(int avgSize, float[] data) {
  for (int i = 0; i < avgSize; i++) {
    float displayAmplitude = bandData.getDisplayAmplitude(data[i]);
    rect(i * (stageWidth / avgSize), stageHeight, (stageWidth / avgSize), -(stageHeight / 2) * displayAmplitude);
  }
}

void drawLineSpectrum(int avgSize, float[] data) {
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
