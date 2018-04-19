import ddf.minim.analysis.*;
import ddf.minim.*;

public class AvizData {
  private FFT fft;
  private AudioPlayer audio;
  private int avgSize;
  private float smoothing;
  private float[] fftSmooth;
  private float leftLevelSmooth = 0;
  private float rightLevelSmooth = 0;
  private float minVal = 0.0f;
  private float maxVal = 0.0f;
  private boolean firstMinDone = true;
  private boolean useDB = true;

  AvizData (Minim minim, String path, int bufferSize, int minBandwidthPerOctave, int bandsPerOctave, float smoothingValue) {
    audio = minim.loadFile(path, bufferSize);
    audio.loop();
    fft = new FFT(audio.bufferSize(), audio.sampleRate());
    fft.logAverages(minBandwidthPerOctave, bandsPerOctave);
    avgSize = fft.avgSize();
    smoothing = smoothingValue;
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

  public float[] getForwardSpectrumData() {
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

  public float getLeftBuffer(int i) {
    return audio.left.get(i);
  }

  public float getRightBuffer(int i) {
    return audio.right.get(i);
  }

  public float getLeftLevel() {
    return audio.left.level();
  }

  public float getRightLevel() {
    return audio.right.level();
  }

  public float getLeftLevelSmooth() {
    leftLevelSmooth = (smoothing) * leftLevelSmooth + ((1 - smoothing) * audio.left.level());
    return leftLevelSmooth;
  }

  public float getRightLevelSmooth() {
    rightLevelSmooth = (smoothing) * rightLevelSmooth + ((1 - smoothing) * audio.right.level());
    return rightLevelSmooth;
  }

  public int getBufferSize() {
    return audio.bufferSize();
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
    return (maxVal - minVal) + 0.00001f;
  }

  public float getDisplayAmplitude(float x) {
    return (x - minVal) / ((maxVal - minVal) + 0.00001f);
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