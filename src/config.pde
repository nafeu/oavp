public class OavpConfig {
  public int FRAMERATE = 1000;
  // public int FRAMERATE = 60;
  public int MOVIE_FPS = 60;
  public String AUDIO_ANALYSIS_SEPERATOR = "|";
  public String EVENTS_SEPERATOR = ",";
  public int ANALYSIS_PRECISION = 4;
  public int ANALYSIS_INDEX = 3;
  public int ANALYSIS_LEFT_LEVEL_INDEX = 1;
  public int ANALYSIS_RIGHT_LEVEL_INDEX = 2;
  public int MAX_MIDI_NOTE_RANGE = 128;

  // public String AUDIO_FILE;
  // public String MIDI_FILE;
  public String AUDIO_FILE = "120.wav";
  public String MIDI_FILE = "120.mid";
  public int TARGET_BPM = 120;
  public int QUANTIZATION = 4; // Sixteenth
  // public int QUANTIZATION = 1; // Quarter
  // public int QUANTIZATION = 2; // Eight
  // public int QUANTIZATION = 8; // Thirty-Secondth

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
  // public boolean ENABLE_VIDEO_RENDER = false;
  // public boolean ANALYZE_AUDIO = false;
  public boolean ENABLE_VIDEO_RENDER = true;
  public boolean ANALYZE_AUDIO = true;

  // public float FRAME_OFFSET_MULTIPLIER = 0.5;
  public float FRAME_OFFSET_MULTIPLIER = 0;

  public String FRAME_TITLE = "oavp";

  public DefaultEvents DEFAULT_EVENTS;

  public class DefaultEvents {
    int QUANTIZATION_MARKER = 1 + MAX_MIDI_NOTE_RANGE;
    int BEAT = 2 + MAX_MIDI_NOTE_RANGE;
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
