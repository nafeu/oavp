public class OavpData {
  private FFT fft;
  private AudioPlayer player;
  private AudioInput input;
  private BeatDetect beat;

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
  private boolean isLineIn;

  private boolean sendBeat = false;
  private boolean strictBeatOnset = false;

  OavpData (Minim minim, String path, int bufferSize, int minBandwidthPerOctave, int bandsPerOctave) {
    player = minim.loadFile(path, bufferSize);
    player.loop();
    isLineIn = false;
    beat = new BeatDetect();
    fft = new FFT(player.bufferSize(), player.sampleRate());
    fft.logAverages(minBandwidthPerOctave, bandsPerOctave);
    avgSize = fft.avgSize();
    bufferSize = player.bufferSize();
    spectrum = new float[avgSize];
    leftBuffer = new float[bufferSize];
    rightBuffer = new float[bufferSize];
  }

  OavpData (Minim minim, int bufferSize, int minBandwidthPerOctave, int bandsPerOctave) {
    input = minim.getLineIn();
    isLineIn = true;
    beat = new BeatDetect();
    fft = new FFT(input.bufferSize(), input.sampleRate());
    fft.logAverages(minBandwidthPerOctave, bandsPerOctave);
    avgSize = fft.avgSize();
    bufferSize = input.bufferSize();
    spectrum = new float[avgSize];
    leftBuffer = new float[bufferSize];
    rightBuffer = new float[bufferSize];
  }

  public void toggleLoop() {
    if (!isLineIn) {
      if (player.isPlaying()) {
        player.pause();
      } else {
        player.loop();
      }
    }
  }

  private float dB(float x) {
    if (x == 0) {
      return 0;
    }
    else {
      return 10 * (float)Math.log10(x);
    }
  }

  void detectBeat() {
    if (isLineIn) {
      beat.detect(input.mix);
    } else {
      beat.detect(player.mix);
    }
  }

  float getCurrLeftLevel() {
    if (isLineIn) {
      return input.left.level();
    }
    return player.left.level();
  }

  float getCurrRightLevel() {
    if (isLineIn) {
      return input.right.level();
    }
    return player.right.level();
  }

  float getCurrLeftBuffer(int i) {
    if (isLineIn) {
      return input.left.get(i);
    }
    return player.left.get(i);
  }

  float getCurrRightBuffer(int i) {
    if (isLineIn) {
      return input.right.get(i);
    }
    return player.right.get(i);
  }

  void forwardMix() {
    if (isLineIn) {
      fft.forward( input.mix );
    } else {
      fft.forward( player.mix );
    }
  }

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

    strictBeatOnset = false;
    if (!isBeatOnset()) {
      sendBeat = true;
    }

    if (sendBeat && isBeatOnset()) {
      strictBeatOnset = true;
      sendBeat = false;
    }
  }

  public float[] getSpectrum() {
    return spectrum;
  }

  public float[] getLeftBuffer() {
    return leftBuffer;
  }

  public float[] getRightBuffer() {
    return rightBuffer;
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
    if (isLineIn) {
      return input.bufferSize();
    }
    return player.bufferSize();
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

  public boolean isBeatOnset() {
    return beat.isOnset();
  }

  public boolean isStrictBeatOnset() {
    return strictBeatOnset;
  }

  public void update(List trackers) {
    Iterator<OavpTracker> i = trackers.iterator();
    while(i.hasNext()) {
      OavpTracker item = i.next();
      item.update();
      if (item.isDead) {
        i.remove();
      }
    }
  }
}