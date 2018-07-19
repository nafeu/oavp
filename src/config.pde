public class OavpConfig {
  public int FRAMERATE = 60;

  public String AUDIO_FILE;
  public int BUFFER_SIZE = 1024;
  public int MIN_BANDWIDTH_PER_OCTAVE = 200;
  public int BANDS_PER_OCTAVE = 30;

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

  public String FRAME_TITLE = "oavp";

  OavpConfig() {}

  public boolean loadConfig(String path) {
    boolean result = false;

    File config_f = new File(path);
    if (config_f.exists()) {
      JSONObject config = loadJSONObject(path);

      FRAMERATE = config.getInt("FRAMERATE");

      AUDIO_FILE = config.getString("AUDIO_FILE");
      if (AUDIO_FILE.length() < 1) {
        AUDIO_FILE = null;
      }

      BUFFER_SIZE = config.getInt("BUFFER_SIZE");
      MIN_BANDWIDTH_PER_OCTAVE = config.getInt("MIN_BANDWIDTH_PER_OCTAVE");
      BANDS_PER_OCTAVE = config.getInt("BANDS_PER_OCTAVE");

      FONT_FILE = config.getString("FONT_FILE");
      FONT_UNIT = config.getInt("FONT_UNIT");
      FONT_SCALE = config.getFloat("FONT_SCALE");

      STAGE_WIDTH = config.getFloat("STAGE_WIDTH");
      STAGE_HEIGHT = config.getFloat("STAGE_HEIGHT");
      w = STAGE_WIDTH;
      h = STAGE_HEIGHT;
      GRID_SCALE = config.getFloat("GRID_SCALE");

      SPECTRUM_SMOOTHING = config.getFloat("SPECTRUM_SMOOTHING");
      LEVEL_SMOOTHING = config.getFloat("LEVEL_SMOOTHING");
      BUFFER_SMOOTHING = config.getFloat("BUFFER_SMOOTHING");

      ENABLE_ORTHO = config.getBoolean("ENABLE_ORTHO");

      FRAME_TITLE = config.getString("FRAME_TITLE");
    }
    else {
      System.err.println("[ oavp ] Unable to find the Oavp config file at '" + path + "'");
    }

    return result;
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
