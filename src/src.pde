import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.Random;
import java.util.List;
import java.util.Iterator;
import java.util.ListIterator;
import java.util.HashMap;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.video.*;

PApplet context;
OavpConfig oavp;
Minim minim;
OavpPosition entityPosition;
OavpCamera defaultCamera;
OavpAnalysis analysis;
OavpVisualizer visualizers;
OavpEmitter emitters;
OavpShape shapes;
OavpText text;
OavpPalette palette;
OavpEntityManager entities;

void setup() {
  context = this;
  println("[ oavp ] Version 0.1 - github.com/nafeu/oavp");

  // Display Setup
  // size(1000, 1000, P3D);
  fullScreen(P3D, 2);

  try {
    // Load configs
    oavp = new OavpConfig("config.json");

    // Frame Setup
    frameRate(oavp.FRAMERATE);
    surface.setTitle(oavp.FRAME_TITLE);

    // Library initialization
    minim = new Minim(context);
    Ani.init(context);

    // Entity Setup
    entityPosition = new OavpPosition(0, 0, oavp.GRID_SCALE);
    entities = new OavpEntityManager(context, minim);

    // Default Camera Setup
    defaultCamera = new OavpCamera();
    defaultCamera.view();

    // Style Setup
    palette = new OavpPalette(oavp);

    // Audio Analysis Tools Setup
    analysis = new OavpAnalysis(minim, oavp);

    // Main Visualizer Setup
    visualizers = new OavpVisualizer(analysis, entityPosition, entities);
    emitters = new OavpEmitter(analysis, entities);
    shapes = new OavpShape();

    // Autoload Files
    File[] files = new File(dataPath("")).listFiles();
    String filenames[] = new String[files.length];

    for (int i = 0; i < files.length; i++) {
      String extension = getFileExtension(files[i]);
      String name = files[i].getName();

      switch(extension) {
        case "svg":
          println("[ oavp ] Loading svg: " + name);
          entities.addSvg(name);
          break;
        case "jpg":
        case "png":
          println("[ oavp ] Loading image: " + name);
          entities.addImg(name);
          break;
        case "mov":
          println("[ oavp ] Loading movie: " + name);
          entities.addMovie(name);
          break;
        default:
          break;
      }
    }

    setupSketch();
  } catch (Exception e) {
    println("[ oavp ] Error during setup");
    debugError(e);
    exit();
  }

  // Typography Setup
  text = new OavpText(entityPosition);
  text.setPadding(20);
}

void draw() {
  try {
    updateHelpers();
    updateEntities();
    drawSketch();
  } catch (Exception e) {
    println("[ oavp ] Error during draw loop");
    debugError(e);
    exit();
  }
}

void updateEntities() {
  try {
    entities.update();
    analysis.forward();
    updateSketch();
  } catch (Exception e) {
    println("[ oavp ] Error during update loop");
    debugError(e);
    exit();
  }
}

void movieEvent(Movie m) {
  m.read();
}