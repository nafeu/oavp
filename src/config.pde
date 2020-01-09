public class OavpConfig {
  public int FRAMERATE = 1000;
  public int MOVIE_FPS = 60;
  public String AUDIO_ANALYSIS_SEPERATOR = "|";
  public String EVENTS_SEPERATOR = ",";
  public int ANALYSIS_PRECISION = 4;

  public String AUDIO_FILE = "100bpm.mp3";
  // public String AUDIO_FILE;
  public int TARGET_BPM = 100;
  public int QUANTIZATION = 4; // Quarter Notes
  public int BUFFER_SIZE = 1024;
  public int MIN_BANDWIDTH_PER_OCTAVE = 22;
  public int BANDS_PER_OCTAVE = 3;

  public String FONT_FILE = "RobotoMono-Regular-32.vlw";
  public int FONT_UNIT = 8;
  public float FONT_SCALE = 0.0033;

  public float STAGE_WIDTH = 1000;
  public float STAGE_HEIGHT = 1000;
  public float w = 1000;
  public float h = 1000;
  public float GRID_SCALE = 1000;

  public float SPECTRUM_SMOOTHING = 0.80f;
  public float LEVEL_SMOOTHING = 0.95f;
  public float BUFFER_SMOOTHING = 0.85f;

  public boolean ENABLE_ORTHO = false;
  public boolean ENABLE_VIDEO_RENDER = true;

  public String FRAME_TITLE = "oavp";

  public DefaultEvents DEFAULT_EVENTS;

  public class DefaultEvents {
    int QUANTIZATION_MARKER = 1;
    int BEAT = 2;
    DefaultEvents(){}
  }

  OavpConfig() {
    DEFAULT_EVENTS = new DefaultEvents();
  }

  public float width(float scale) {
    return w * scale;
  }

  public float width() {
    return w;
  }

  public float height(float scale) {
    return h * scale;
  }

  public float height() {
    return h;
  }
}
