public class OavpSvgManager {
  HashMap<String, PShape> storage;

  OavpSvgManager() {
    storage = new HashMap<String, PShape>();
  }

  void add(String name) {
    storage.put(name, loadShape(name + ".svg"));
  }

  PShape get(String name) {
    return storage.get(name);
  }
}