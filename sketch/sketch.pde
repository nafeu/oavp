import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioPlayer audio;
FFT         fft;

BandData bd;

class BandData {
  private FFT fft;
  private AudioPlayer audio;
  private int avgSize;
  private float[] fftSmooth;
  private float minVal = 0.0;
  private float maxVal = 0.0;
  private float smoothing = 0.80;
  private boolean firstMinDone = true;
  private boolean useDB = true;

  BandData (Minim minim, String path, int bufferSize, int minBandwidthPerOctave, int bandsPerOctave) {
    audio = minim.loadFile(path, bufferSize);
    audio.loop();
    fft = new FFT(audio.bufferSize(), audio.sampleRate());
    fft.logAverages(minBandwidthPerOctave, bandsPerOctave);
    avgSize = fft.avgSize();
    fftSmooth = new float[avgSize];
  }

  private float dB(float x) {
    if (x == 0) {
      return 0;
    }
    else {
      return 10 * (float)Math.log10(x);
    }
  }

  public float[] getForwardData() {
    fft.forward( audio.mix );
    for (int i = 0; i < avgSize; i++) {
      // Get spectrum value (using dB conversion or not, as desired)
      float fftCurr;
      if (useDB) {
        fftCurr = dB(fft.getAvg(i));
      }
      else {
        fftCurr = fft.getAvg(i);
      }

      // Smooth using exponential moving average
      fftSmooth[i] = (smoothing) * fftSmooth[i] + ((1 - smoothing) * fftCurr);

      // Find max and min values ever displayed across whole spectrum
      if (fftSmooth[i] > maxVal) {
        maxVal = fftSmooth[i];
      }
      if (!firstMinDone || (fftSmooth[i] < minVal)) {
        minVal = fftSmooth[i];
      }
    }
    return fftSmooth;
  }

  public int getAvgSize() {
    return avgSize;
  }

  public float getMaxVal() {
    return maxVal;
  }

  public float getMinVal() {
    return minVal;
  }

  public float getScaleFactor() {
    return (maxVal - minVal) + 0.00001;
  }

  public float getDisplayAmplitude(float x) {
    return (x - minVal) / ((maxVal - minVal) + 0.00001);
  }

  public void toggleUseDB() {
    useDB = !useDB;
  }

  public void toggleFirstMinDone() {
    firstMinDone = !firstMinDone;
  }

  public void setSmoothing(float newSmoothing) {
    smoothing = newSmoothing;
  }
}

void setup() {
  frameRate(60);
  size(500, 500);

  minim = new Minim(this);
  bd = new BandData(minim, "test-audio-1.mp3", 1024, 200, 10);

}

void draw() {
  background(0);
  fill(255);
  stroke(255);

  float[] data = bd.getForwardData();
  int avgSize = bd.getAvgSize();

  drawRectangleBars(avgSize, data);
  drawWaveForm(avgSize, data);
  // debug();
}

void drawRectangleBars(int avgSize, float[] data) {
  for (int i = 0; i < avgSize; i++) {
    float displayAmplitude = bd.getDisplayAmplitude(data[i]);
    rect(i * (500 / avgSize), 500, (500 / avgSize), -(500 / 2) * displayAmplitude);
  }
}

void drawWaveForm(int avgSize, float[] data) {
  translate(0, 250);
  beginShape(LINES);
  for (int i = 0; i < avgSize - 1; i++) {
    vertex(i * (500 / avgSize), -(500 / 2) * bd.getDisplayAmplitude(data[i]));
    vertex((i + 1) * (500 / avgSize), -(500 / 2) * bd.getDisplayAmplitude(data[i + 1]));
  }
  endShape();
}

// void debug() {
//   text("BUFFER_SIZE: " + String.valueOf(BUFFER_SIZE), 10, 20);
// }
