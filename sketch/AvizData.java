import ddf.minim.analysis.*;
import ddf.minim.*;

public class AvizData {
  private FFT fft;
  private AudioPlayer audio;

  private int avgSize;
  private int bufferSize;
  private float smoothing;

  private float[] spectrum;
  private float minSpectrumVal = 0.0f;
  private float maxSpectrumVal = 0.0f;

  private float leftLevel;
  private float minLeftLevel = 0.0f;
  private float maxLeftLevel = 0.0f;

  private float rightLevel;
  private float minRightLevel = 0.0f;
  private float maxRightLevel = 0.0f;

  private boolean firstMinDone = true;
  private boolean useDB = true;

  AvizData (Minim minim, String path, int bufferSize, int minBandwidthPerOctave, int bandsPerOctave, float smoothingValue) {
    audio = minim.loadFile(path, bufferSize);
    audio.loop();
    fft = new FFT(audio.bufferSize(), audio.sampleRate());
    fft.logAverages(minBandwidthPerOctave, bandsPerOctave);
    avgSize = fft.avgSize();
    bufferSize = audio.bufferSize();
    smoothing = smoothingValue;
    spectrum = new float[avgSize];
  }

  private float dB(float x) {
    if (x == 0) {
      return 0;
    }
    else {
      return 10 * (float)Math.log10(x);
    }
  }

  public void forward() {
    fft.forward( audio.mix );

    // Adjust smoothing on spectrum values
    for (int i = 0; i < avgSize; i++) {
      // Get spectrum value (using dB conversion or not, as desired)
      float currSpectrumVal;
      if (useDB) {
        currSpectrumVal = dB(fft.getAvg(i));
      }
      else {
        currSpectrumVal = fft.getAvg(i);
      }

      // Smooth using exponential moving average
      spectrum[i] = (smoothing) * spectrum[i] + ((1 - smoothing) * currSpectrumVal);

      // Find max and min values ever displayed across whole spectrum
      if (spectrum[i] > maxSpectrumVal) {
        maxSpectrumVal = spectrum[i];
      }
      if (!firstMinDone || (spectrum[i] < minSpectrumVal)) {
        minSpectrumVal = spectrum[i];
      }
    }

    // Adjust smoothing on left level
    float currLeftLevel;
    currLeftLevel = audio.left.level();

    // Smooth using exponential moving average
    leftLevel = (smoothing) * leftLevel + ((1 - smoothing) * currLeftLevel);

    // Find max and min values ever displayed across whole spectrum
    if (currLeftLevel > maxLeftLevel) {
      maxLeftLevel = currLeftLevel;
    }
    if (!firstMinDone || (currLeftLevel < minLeftLevel)) {
      minLeftLevel = leftLevel;
    }

    // Adjust smoothing on right level
    float currRightLevel;
    currRightLevel = audio.right.level();

    // Smooth using exponential moving average
    rightLevel = (smoothing) * rightLevel + ((1 - smoothing) * currRightLevel);

    // Find max and min values ever displayed across whole spectrum
    if (currRightLevel > maxRightLevel) {
      maxRightLevel = currRightLevel;
    }
    if (!firstMinDone || (currRightLevel < minRightLevel)) {
      minRightLevel = rightLevel;
    }
  }

  public float getSpectrumVal(int i) {
    return spectrum[i];
  }

  public float getLeftBuffer(int i) {
    return audio.left.get(i);
  }

  public float getRightBuffer(int i) {
    return audio.right.get(i);
  }

  public float getLeftLevel() {
    return leftLevel;
  }

  public float getRightLevel() {
    return rightLevel;
  }

  public int getBufferSize() {
    return audio.bufferSize();
  }

  public int getAvgSize() {
    return avgSize;
  }

  public float getMaxSpectrumVal() {
    return maxSpectrumVal;
  }

  public float getMinSpectrumVal() {
    return minSpectrumVal;
  }

  public float scaleSpectrumVal(float x) {
    float scaleFactor = (maxSpectrumVal - minSpectrumVal) + 0.00001f;
    return (x - minSpectrumVal) / scaleFactor;
  }

  public float scaleLeftLevel(float x) {
    float scaleFactor = (maxLeftLevel - minLeftLevel) + 0.00001f;
    return (x - minLeftLevel) / scaleFactor;
  }

  public float scaleRightLevel(float x) {
    float scaleFactor = (maxRightLevel - minRightLevel) + 0.00001f;
    return (x - minRightLevel) / scaleFactor;
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