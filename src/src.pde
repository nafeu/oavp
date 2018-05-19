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
OavpText text;
OavpSvgManager svgs;
OavpImageManager images;

void setup() {
  // Load configs
  oavp = new OavpConfig("config.json");

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

  if (oavp.SHOW_EXAMPLES) {
    setupExamples();
  } else {
    setupSketch();
  }

  // Typography Setup
  text = new OavpText(entityPosition);
  text.setPadding(20);

  // SVG Loading
  svgs = new OavpSvgManager();
  svgs.add("test-logo");

  // Image Loading
  images = new OavpImageManager();

  style.setTargetColor(cameraPosition);

  debug();
}

void draw() {
  updateEntities();

  if (oavp.SHOW_EXAMPLES) {
    drawExamples();
  } else {
    drawSketch();
  }
}

void updateEntities() {
  camera.update();
  oavpData.forward();

  if (oavp.ROTATE_COLORS_WITH_CAMERA) {
    style.updateColor(cameraPosition);
  }
  style.updateColorInterp();
  noFill();
  strokeWeight(style.defaultStrokeWeight);

  stroke(style.getPrimaryColor());
  background(style.getSecondaryColor());

  if (oavp.SHOW_EXAMPLES) {
    updateExamples();
  } else {
    updateSketch();
  }
}