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
OavpEmitter emitters;
OavpShape shapes;
OavpText text;
OavpColorPalette palette;
OavpEntityManager entities;

void setup() {
  // Load configs
  oavp = new OavpConfig("config.json");

  // Screen Setup
  // size(1000, 1000, P3D);
  fullScreen(P3D, 2);
  frameRate(oavp.FRAMERATE);

  // Library initialization
  minim = new Minim(this);
  Ani.init(this);

  // Entity Setup
  entityPosition = new OavpPosition(0, 0, oavp.GRID_SCALE);
  entities = new OavpEntityManager();

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
  palette = new OavpColorPalette();

  // Audio Analysis Tools Setup
  oavpData = new OavpData(minim, oavp);

  // Main Visualizer Setup
  visualizers = new OavpVisualizer(oavpData, entityPosition, entities);
  emitters = new OavpEmitter(oavpData, entities);
  shapes = new OavpShape();

  // Load Files
  entities.addSvg("test-logo.svg");
  entities.addImg("test-image.jpg");

  if (oavp.SHOW_EXAMPLES) {
    setupExamples();
  } else {
    setupSketch();
  }

  // Typography Setup
  text = new OavpText(entityPosition);
  text.setPadding(20);

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
  if (oavp.SHOW_EXAMPLES) {
    updateExamples();
  } else {
    updateSketch();
  }
}