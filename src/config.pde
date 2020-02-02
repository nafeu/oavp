public class OavpConfig {

public String DISPLAY_SETTINGS = "fullscreen";
public int FRAMERATE = 60;
public int MOVIE_FPS = 60;
public String AUDIO_ANALYSIS_SEPERATOR = "|";
public String EVENTS_SEPERATOR = ",";
public int ANALYSIS_PRECISION = 4;
public int ANALYSIS_INDEX = 3;
public int ANALYSIS_LEFT_LEVEL_INDEX = 1;
public int ANALYSIS_RIGHT_LEVEL_INDEX = 2;
public int MAX_MIDI_NOTE_RANGE = 128;
public String AUDIO_FILE = "";
public String MIDI_FILE = "";
public int TARGET_BPM = 120;
public int QUANTIZATION = 4;
public int BUFFER_SIZE = 1024;
public int MIN_BANDWIDTH_PER_OCTAVE = 22;
public int BANDS_PER_OCTAVE = 3;
public String FONT_REGULAR = "RobotoMonoForPowerline-Regular";
public String FONT_BOLD = "RobotoMonoForPowerline-Bold";
public String FONT_THIN = "RobotoMonoForPowerline-Thin";
public int FONT_SIZE = 64;
public float FONT_SCALE = 0.0033;
public int STAGE_WIDTH = 1000;
public int STAGE_HEIGHT = 1000;
public int w = 1000;
public int h = 1000;
public int GRID_SCALE = 1000;
public float SPECTRUM_SMOOTHING = 0.8;
public float LEVEL_SMOOTHING = 0.95;
public float BUFFER_SMOOTHING = 0.85;
public boolean ENABLE_ORTHO = false;
public boolean ENABLE_VIDEO_RENDER = false;
public boolean ANALYZE_AUDIO = false;
public int FRAME_OFFSET_MULTIPLIER = 0;
public String FRAME_TITLE = "oavp";
public String TOPIC_NAME = "Phrakture";
public String TOPIC_TITLE = "Reinvented By Silence";
public String COLOR_A = "#B2DFDB";
public String COLOR_B = "#EF9A9A";
public String COLOR_C = "#8E24AA";
public String COLOR_D = "#F57F17";
public String COLOR_E = "#FF5252";
public String COLOR_BG = "#1A237E";

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
