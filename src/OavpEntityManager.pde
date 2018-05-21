public class OavpEntityManager {
  HashMap<String, PShape> svgs;
  HashMap<String, PImage> imgs;
  HashMap<String, OavpAmplitude> amplitudes;
  HashMap<String, OavpInterval> intervals;
  HashMap<String, OavpGridInterval> gridIntervals;
  HashMap<String, List> trackers;
  HashMap<String, OavpRhythm> rhythms;

  OavpEntityManager() {
    svgs = new HashMap<String, PShape>();
    imgs = new HashMap<String, PImage>();
    amplitudes = new HashMap<String, OavpAmplitude>();
    intervals = new HashMap<String, OavpInterval>();
    trackers = new HashMap<String, List>();
    rhythms = new HashMap<String, OavpRhythm>();
  }

  void addSvg(String filename) {
    String[] fn = filename.split("\\.");
    svgs.put(fn[0], loadShape(filename));
  }

  PShape getSvg(String name) {
    return svgs.get(name);
  }

  void addImg(String filename) {
    String[] fn = filename.split("\\.");
    imgs.put(fn[0], loadImage(filename));
  }

  PImage getImg(String name) {
    return imgs.get(name);
  }

  void addAmplitude(String name, float duration, Easing easing) {
    amplitudes.put(name, new OavpAmplitude(duration, easing));
  }

  OavpAmplitude getAmplitude(String name) {
    return amplitudes.get(name);
  }

  void addInterval(String name, int storageSize, int snapshotSize) {
    intervals.put(name, new OavpInterval(storageSize, snapshotSize));
  }

  OavpInterval getInterval(String name) {
    return intervals.get(name);
  }

  void addGridInterval(String name, int numRows, int numCols) {
    gridIntervals.put(name, new OavpGridInterval(numRows, numCols));
  }

  OavpGridInterval getGridInterval(String name) {
    return gridIntervals.get(name);
  }

  void addTracker(String name) {
    trackers.put(name, new ArrayList());
  }

  void updateTrackers() {
    for (HashMap.Entry<String, List> entry : trackers.entrySet())
    {
      Iterator<OavpTracker> i = entry.getValue().iterator();
      while(i.hasNext()) {
        OavpTracker item = i.next();
        item.update();
        if (item.isDead) {
          i.remove();
        }
      }
    }
  }

  List getTracker(String name) {
    return trackers.get(name);
  }

  void addRhythm(String name, Minim minim, float tempo, float rhythm) {
    rhythms.put(name, new OavpRhythm(minim, tempo, rhythm));
  }

  void updateRhythms() {
    for (HashMap.Entry<String, OavpRhythm> entry : rhythms.entrySet())
    {
      entry.getValue().update();
    }
  }

  OavpRhythm getRhythm(String name) {
    return rhythms.get(name);
  }

  void update() {
    updateRhythms();
    updateTrackers();
  }
}