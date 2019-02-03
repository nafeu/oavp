public class OavpAnalysis {
  private FFT fft;
  private AudioPlayer player;
  private AudioInput input;
  private BeatDetect beat;

  private int avgSize;
  private int bufferSize;
  private float spectrumSmoothing;
  private float bufferSmoothing;
  private float levelSmoothing;

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
  private boolean isLineIn;

  OavpAnalysis (Minim minim, OavpConfig config) {
    beat = new BeatDetect();
    beat.setSensitivity(300);
    if (config.AUDIO_FILE != null) {
      println("[ oavp ] Loading audio file: " + config.AUDIO_FILE);
      player = minim.loadFile(config.AUDIO_FILE, config.BUFFER_SIZE);
      player.loop();
      isLineIn = false;
      fft = new FFT(player.bufferSize(), player.sampleRate());
      fft.logAverages(config.MIN_BANDWIDTH_PER_OCTAVE, config.BANDS_PER_OCTAVE);
      avgSize = fft.avgSize();
      bufferSize = player.bufferSize();
    } else {
      input = minim.getLineIn();
      isLineIn = true;
      fft = new FFT(input.bufferSize(), input.sampleRate());
      fft.logAverages(config.MIN_BANDWIDTH_PER_OCTAVE, config.BANDS_PER_OCTAVE);
      avgSize = fft.avgSize();
      bufferSize = input.bufferSize();
    }
    spectrum = new float[avgSize];
    leftBuffer = new float[bufferSize];
    rightBuffer = new float[bufferSize];

    spectrumSmoothing = config.SPECTRUM_SMOOTHING;
    bufferSmoothing = config.BUFFER_SMOOTHING;
    levelSmoothing = config.LEVEL_SMOOTHING;
  }

  /**
   * Pause/play any queued audio track
   * @return none
   */
  public void toggleLoop() {
    if (!isLineIn) {
      if (player.isPlaying()) {
        player.pause();
      } else {
        player.loop();
      }
    }
  }

  /**
   * Get the logarithmic dB value of x
   * @param x the input value
   */
  private float dB(float x) {
    if (x == 0) {
      return 0;
    }
    else {
      return 10 * (float)Math.log10(x);
    }
  }

  /**
   * Run beat detection algorithm
   * @return none
   */
  private void detectBeat() {
    if (isLineIn) {
      beat.detect(input.mix);
    } else {
      beat.detect(player.mix);
    }
  }

  /**
   * Get current left channel audio level
   * @return the left level value
   */
  public float getCurrLeftLevel() {
    if (isLineIn) {
      return input.left.level();
    }
    return player.left.level();
  }

  /**
   * Get current right channel audio level
   * @return the right level value
   */
  public float getCurrRightLevel() {
    if (isLineIn) {
      return input.right.level();
    }
    return player.right.level();
  }

  /**
   * Get current ith value in left channel buffer
   * @param i the index
   * @return the current ith value in left channel buffer
   */
  public float getCurrLeftBuffer(int i) {
    if (isLineIn) {
      return input.left.get(i);
    }
    return player.left.get(i);
  }

  /**
   * Get current ith value in right channel buffer
   * @param i the index
   * @return the current ith value in right channel buffer
   */
  public float getCurrRightBuffer(int i) {
    if (isLineIn) {
      return input.right.get(i);
    }
    return player.right.get(i);
  }

  /**
   * Apply fast-fourier transform on currently active mix
   */
  private void forwardMix() {
    if (isLineIn) {
      fft.forward( input.mix );
    } else {
      fft.forward( player.mix );
    }
  }

  /**
   * Apply fast-fourier transform and spectrum smoothing on audio
   */
  public void forward() {
    detectBeat();

    // Adjust smoothing on left level
    float currLeftLevel;
    currLeftLevel = getCurrLeftLevel();

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
    currRightLevel = getCurrRightLevel();

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
    for (int i = 0; i < getBufferSize(); i++) {
      float currLeftBuffer;
      float currRightBuffer;
      currLeftBuffer = getCurrLeftBuffer(i);
      currRightBuffer = getCurrRightBuffer(i);
      leftBuffer[i] = (bufferSmoothing) * leftBuffer[i] + ((1 - bufferSmoothing) * currLeftBuffer);
      rightBuffer[i] = (bufferSmoothing) * rightBuffer[i] + ((1 - bufferSmoothing) * currRightBuffer);
    }

    forwardMix();

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

  /**
   * Get spectrum values
   * @return array of float values for spectrum
   */
  public float[] getSpectrum() {
    return spectrum;
  }

  /**
   * Get left channel buffer
   * @return array of float values for left buffer
   */
  public float[] getLeftBuffer() {
    return leftBuffer;
  }

  /**
   * Get right channel buffer
   * @return array of float values for right buffer
   */
  public float[] getRightBuffer() {
    return rightBuffer;
  }

  /**
   * Get ith spectrum value
   * @param i the index
   * @return the ith spectrum value
   */
  public float getSpectrumVal(int i) {
    return spectrum[i];
  }

  /**
   * Get ith left buffer value
   * @param i the index
   * @return the ith left buffer value
   */
  public float getLeftBuffer(int i) {
    return leftBuffer[i];
  }

  /**
   * Get ith right buffer value
   * @param i the index
   * @return the ith right buffer value
   */
  public float getRightBuffer(int i) {
    return rightBuffer[i];
  }

  /**
   * Get left channel level
   * @return the left channel level
   */
  public float getLeftLevel() {
    return leftLevel;
  }

  /**
   * Get right channel level
   * @return the right channel level
   */
  public float getRightLevel() {
    return rightLevel;
  }

  /**
   * Get the scaled average left/right channel level
   * @return the scaled average left/right channel level
   */
  public float getLevel() {
    return (scaleLeftLevel(leftLevel) + scaleRightLevel(rightLevel)) / 2;
  }

  /**
   * Get the current active input buffer size
   * @return the current active input buffer size
   */
  public int getBufferSize() {
    if (isLineIn) {
      return input.bufferSize();
    }
    return player.bufferSize();
  }

  /**
   * Get the current averaging size
   * @return the current averaging size
   */
  public int getAvgSize() {
    return avgSize;
  }

  /**
   * Get the max spectrum value
   * @return the max spectrum value
   */
  public float getMaxSpectrumVal() {
    return maxSpectrumVal;
  }

  /**
   * Get the min spectrum value
   * @return the min spectrum value
   */
  public float getMinSpectrumVal() {
    return minSpectrumVal;
  }

  /**
   * Get the scaled input spectrum value
   * @param x the input spectrum value
   * @return the scaled input spectrum value
   */
  public float scaleSpectrumVal(float x) {
    float scaleFactor = (maxSpectrumVal - minSpectrumVal) + 0.00001f;
    return (x - minSpectrumVal) / scaleFactor;
  }

  /**
   * Get the scaled input left level
   * @param x the input left level
   * @return the scaled input left level
   */
  public float scaleLeftLevel(float x) {
    float scaleFactor = (maxLeftLevel - minLeftLevel) + 0.00001f;
    return (x - minLeftLevel) / scaleFactor;
  }

  /**
   * Get the scaled input right level
   * @param x the input right level
   * @return the scaled input right level
   */
  public float scaleRightLevel(float x) {
    float scaleFactor = (maxRightLevel - minRightLevel) + 0.00001f;
    return (x - minRightLevel) / scaleFactor;
  }

  /**
   * Toggle decible usage
   */
  public void toggleUseDB() {
    useDB = !useDB;
  }

  /**
   * Toggle first min done
   */
  public void toggleFirstMinDone() {
    firstMinDone = !firstMinDone;
  }

  /**
   * Set spectrum smoothing value
   * @param newSmoothing the smoothing value
   */
  public void setSpectrumSmoothing(float newSmoothing) {
    spectrumSmoothing = newSmoothing;
  }

  /**
   * Set level smoothing value
   * @param newSmoothing the smoothing value
   */
  public void setLevelSmoothing(float newSmoothing) {
    levelSmoothing = newSmoothing;
  }

  /**
   * Set buffer smoothing value
   * @param newSmoothing the smoothing value
   */
  public void setBufferSmoothing(float newSmoothing) {
    bufferSmoothing = newSmoothing;
  }

  /**
   * Check if current slice is a beat onset
   */
  public boolean isBeatOnset() {
    return beat.isOnset();
  }
}