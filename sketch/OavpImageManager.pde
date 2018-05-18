public class OavpImageManager {
  HashMap<String, PImage> storage;

  OavpImageManager() {
    storage = new HashMap<String, PImage>();
  }

  void add(String filename) {
    String[] fn = filename.split("\\.");
    storage.put(fn[0], loadImage(filename));
  }

  PImage get(String name) {
    return storage.get(name);
  }
}