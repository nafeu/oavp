import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.Random;
import java.util.List;
import java.util.Iterator;
import java.util.ListIterator;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

Minim minim;
OavpConfig oavp;
OavpData oavpData;
OavpInterval spectrumInterval;
OavpInterval levelInterval;
OavpGridInterval levelGridInterval;
OavpAmplitude beatAmplitude;
OavpInterval beatAmplitudeInterval;
OavpGridInterval beatAmplitudeGridInterval;
OavpPosition cameraPosition;
OavpPosition entityPosition;
OavpCamera camera;
OavpVisualizer visualizers;
OavpRhythm metronome;
List visTrackers;
OavpShape shapes;
OavpText text;
OavpStyle style;
String introText;
PShape logo;
PFont mono;

boolean isDayMode = true;
int defaultStrokeWeight = 2;

void setup() {
  // Load configs
  oavp = new OavpConfig();

  // Screen setup
  fullScreen(P3D, 2);
  frameRate(oavp.FRAMERATE);

  // Library initialization
  minim = new Minim(this);
  Ani.init(this);

  // Camera setup
  cameraPosition = new OavpPosition(0, 0, oavp.GRID_SCALE);
  entityPosition = new OavpPosition(0, 0, oavp.GRID_SCALE);
  camera = new OavpCamera(cameraPosition, entityPosition, style, oavp.STAGE_WIDTH / 2, oavp.STAGE_HEIGHT / 2, 0.10);
  if (oavp.ENABLE_ORTHO) {
    camera.enableOrthoCamera();
  }

  // Style setup
  style = new OavpStyle(oavp.COLOR_ACCENT);

  // Audio Analysis Tools Setup
  oavpData = new OavpData(minim,
                          // oavp.AUDIO_FILE,
                          oavp.BUFFER_SIZE,
                          oavp.MIN_BANDWIDTH_PER_OCTAVE,
                          oavp.BANDS_PER_OCTAVE);
  oavpData.setSpectrumSmoothing(oavp.SPECTRUM_SMOOTHING);
  oavpData.setLevelSmoothing(oavp.LEVEL_SMOOTHING);
  oavpData.setBufferSmoothing(oavp.BUFFER_SMOOTHING);


  metronome = new OavpRhythm(minim, 120, 1);

  spectrumInterval = new OavpInterval(40, oavpData.getAvgSize());
  levelInterval = new OavpInterval(20);
  levelGridInterval = new OavpGridInterval(4);

  beatAmplitude = new OavpAmplitude(0, 1, 0.08);
  beatAmplitudeInterval = new OavpInterval(20);
  beatAmplitudeGridInterval = new OavpGridInterval(4);

  visualizers = new OavpVisualizer(oavpData, entityPosition);
  visTrackers = new ArrayList();

  shapes = new OavpShape();
  text = new OavpText(entityPosition);
  text.setPadding(20);

  logo = loadShape("test-logo.svg");
  mono = loadFont("RobotoMono-Regular-32.vlw");
  textFont(mono, oavp.FONT_UNIT * (Math.round(oavp.STAGE_WIDTH * oavp.FONT_SCALE)));

  style.setTargetColor(cameraPosition);

  introText = text.read("intro.txt");

  sandboxSetup();
  debug();
}

void draw() {
  updateEntities();

  // exampleGallery();
  sandbox();
}

void updateEntities() {
  metronome.update();

  style.updateColorInterp();
  style.getIntermediateColor();
  noFill();
  strokeWeight(2);

  stroke(style.getPrimaryColor());
  background(style.getSecondaryColor());

  camera.update();

  oavpData.forward();
  oavpData.update(visTrackers);
  spectrumInterval.update(oavpData.getSpectrum());
  levelInterval.update(oavpData.getLeftLevel(), 1);
  levelGridInterval.updateDiagonal(oavpData.getLeftLevel(), 0);
  beatAmplitude.update(oavpData);
  beatAmplitudeInterval.update(beatAmplitude.getValue(), 0);
  beatAmplitudeGridInterval.updateDiagonal(beatAmplitude.getValue(), 0);
}