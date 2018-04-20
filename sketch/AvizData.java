import ddf.minim.analysis.*;
import ddf.minim.*;

public class AvizData {
  private FFT fft;
  private AudioPlayer audio;

  private int avgSize;
  private int bufferSize;
  private float spectrumSmoothing = 0.0f;
  private float bufferSmoothing = 0.0f;
  private float levelSmoothing = 0.0f;

  private float[] spectrum;
  private float minSpectrumVal = 0.0f;
  private float maxSpectrumVal = 0.0f;

  private float[] leftBuffer;
  private float[] rightBuffer;

  private float leftLevel;
  private float minLeftLevel = 0.0f;
  private float maxLeftLevel = 0.0f;

  private float rightLevel;
  private float minRightLevel = 0.0f;
  private float maxRightLevel = 0.0f;

  private boolean firstMinDone = true;
  private boolean useDB = true;

  AvizData (Minim minim, String path, int bufferSize, int minBandwidthPerOctave, int bandsPerOctave) {
    audio = minim.loadFile(path, bufferSize);
    audio.loop();
    fft = new FFT(audio.bufferSize(), audio.sampleRate());
    fft.logAverages(minBandwidthPerOctave, bandsPerOctave);
    avgSize = fft.avgSize();
    bufferSize = audio.bufferSize();
    spectrum = new float[avgSize];
    leftBuffer = new float[bufferSize];
    rightBuffer = new float[bufferSize];
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
    // Adjust smoothing on left level
    float currLeftLevel;
    currLeftLevel = audio.left.level();

    // Smooth using exponential moving average
    leftLevel = (levelSmoothing) * leftLevel + ((1 - levelSmoothing) * currLeftLevel);

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
    rightLevel = (levelSmoothing) * rightLevel + ((1 - levelSmoothing) * currRightLevel);

    // Find max and min values ever displayed across whole spectrum
    if (currRightLevel > maxRightLevel) {
      maxRightLevel = currRightLevel;
    }
    if (!firstMinDone || (currRightLevel < minRightLevel)) {
      minRightLevel = rightLevel;
    }

    // Adjust smoothing on buffer
    for (int i = 0; i < audio.bufferSize(); i++) {
      float currLeftBuffer;
      float currRightBuffer;
      currLeftBuffer = audio.left.get(i);
      currRightBuffer = audio.right.get(i);
      leftBuffer[i] = (bufferSmoothing) * leftBuffer[i] + ((1 - bufferSmoothing) * currLeftBuffer);
      rightBuffer[i] = (bufferSmoothing) * rightBuffer[i] + ((1 - bufferSmoothing) * currRightBuffer);
    }

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
      spectrum[i] = (spectrumSmoothing) * spectrum[i] + ((1 - spectrumSmoothing) * currSpectrumVal);

      // Find max and min values ever displayed across whole spectrum
      if (spectrum[i] > maxSpectrumVal) {
        maxSpectrumVal = spectrum[i];
      }
      if (!firstMinDone || (spectrum[i] < minSpectrumVal)) {
        minSpectrumVal = spectrum[i];
      }
    }
  }

  public float getSpectrumVal(int i) {
    return spectrum[i];
  }

  public float getLeftBuffer(int i) {
    return leftBuffer[i];
  }

  public float getRightBuffer(int i) {
    return rightBuffer[i];
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

  public void setSpectrumSmoothing(float newSmoothing) {
    spectrumSmoothing = newSmoothing;
  }

  public void setLevelSmoothing(float newSmoothing) {
    levelSmoothing = newSmoothing;
  }

  public void setBufferSmoothing(float newSmoothing) {
    bufferSmoothing = newSmoothing;
  }
}