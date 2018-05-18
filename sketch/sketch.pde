import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.Random;
import java.util.List;
import java.util.Iterator;
import java.util.ListIterator;
import java.util.HashMap;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

OavpConfig oavp;
Minim minim;
OavpPosition entityPosition;
OavpPosition cameraPosition;
OavpCamera camera;
OavpStyle style;
OavpData oavpData;
OavpVisualizer visualizers;
OavpShape shapes;
OavpInterval spectrumInterval;
OavpInterval levelInterval;
OavpGridInterval levelGridInterval;
OavpAmplitude beatAmplitude;
OavpInterval beatAmplitudeInterval;
OavpGridInterval beatAmplitudeGridInterval;
OavpRhythm metronome;
List visTrackers;
OavpText text;
OavpSvgManager svgs;
OavpImageManager images;

boolean isDayMode = true;
int defaultStrokeWeight = 2;

void setup() {
  // Load configs
  oavp = new OavpConfig();

  // Screen Setup
  fullScreen(P3D, 2);
  frameRate(oavp.FRAMERATE);

  // Library initialization
  minim = new Minim(this);
  Ani.init(this);

  // Entity Setup
  entityPosition = new OavpPosition(0, 0, oavp.GRID_SCALE);

  // Camera Setup
  cameraPosition = new OavpPosition(0, 0, oavp.GRID_SCALE);
  camera = new OavpCamera(cameraPosition,
                          entityPosition,
                          oavp.STAGE_WIDTH / 2,
                          oavp.STAGE_HEIGHT / 2,
                          oavp.CAMERA_EASING);
  if (oavp.ENABLE_ORTHO) {
    camera.enableOrthoCamera();
  }

  // Style Setup
  style = new OavpStyle(oavp);

  // Audio Analysis Tools Setup
  oavpData = new OavpData(minim, oavp);

  // Main Visualizer Setup
  visualizers = new OavpVisualizer(oavpData, entityPosition);
  shapes = new OavpShape();

  // Emitters and Intervals Setup
  metronome = new OavpRhythm(minim, 120, 1);
  spectrumInterval = new OavpInterval(40, oavpData.getAvgSize());
  levelInterval = new OavpInterval(20);
  levelGridInterval = new OavpGridInterval(4);
  beatAmplitude = new OavpAmplitude(0, 1, 0.08);
  beatAmplitudeInterval = new OavpInterval(20);
  beatAmplitudeGridInterval = new OavpGridInterval(4);
  visTrackers = new ArrayList();

  // Typography Setup
  text = new OavpText(entityPosition);
  text.setPadding(20);

  // SVG Loading
  svgs = new OavpSvgManager();
  svgs.add("test-logo");

  // Image Loading
  images = new OavpImageManager();

  style.setTargetColor(cameraPosition);

  sandboxSetup();
  debug();
}

void draw() {
  updateEntities();

  exampleGallery();
  // sandbox();
}

void updateEntities() {
  metronome.update();

  style.updateColor(cameraPosition);
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