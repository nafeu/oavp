public class OavpConfig {

public String DISPLAY_SETTINGS = "fullscreen";
public int FRAMERATE = 5;
public int MOVIE_FPS = 30;
public String AUDIO_ANALYSIS_SEPERATOR = "|";
public String EVENTS_SEPERATOR = ",";
public int ANALYSIS_PRECISION = 4;
public int ANALYSIS_INDEX = 3;
public int ANALYSIS_LEFT_LEVEL_INDEX = 1;
public int ANALYSIS_RIGHT_LEVEL_INDEX = 2;
public int MAX_MIDI_NOTE_RANGE = 128;
public String AUDIO_FILE = null;
// public String AUDIO_FILE = "dl.mp3";
public String MIDI_FILE = null;
public int TARGET_BPM = 120;
public int QUANTIZATION = 4;
public int BUFFER_SIZE = 1024;
public int MIN_BANDWIDTH_PER_OCTAVE = 22;
public int BANDS_PER_OCTAVE = 3;
public String FONT_REGULAR = "FiraCode-Regular";
public String FONT_BOLD = "FiraCode-Bold";
public String FONT_THIN = "FiraCode-Light";
public int FONT_SIZE = 64;
public float FONT_SCALE = 0.0033;
public int STAGE_WIDTH = 1080;
public int STAGE_HEIGHT = 864;
public int w = 1080;
public int h = 864;
public float SPECTRUM_SMOOTHING = 0.8;
public float LEVEL_SMOOTHING = 0.95;
public float BUFFER_SMOOTHING = 0.85;
public boolean ENABLE_ORTHO = true;
public boolean ENABLE_VIDEO_RENDER = false;
public boolean ANALYZE_AUDIO = false;
public int FRAME_OFFSET_MULTIPLIER = 0;
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
