public class OavpEditor {
  private boolean isEditMode = false;
  private OavpInput input;
  private OavpEntityManager entities;
  private OavpText text;

  OavpEditor(OavpInput input, OavpEntityManager entities, OavpText text) {
    this.input = input;
    this.entities = entities;
    this.text = text;
  }

  public void handleKeyInputs() {
    if (input.isPressed(KEY_E)) {
      toggleEditMode();
    }
  }

  private void toggleEditMode() {
    this.isEditMode = !this.isEditMode;
  }

  public boolean isEditMode() {
    return this.isEditMode;
  }

  public void draw() {
    text.create()
      .colour(palette.flat.white)
      .size(14)
      .moveDown(oavp.height(0.1))
      .write("EDIT MODE\nMOUSE X: " + normalMouseX + "\nMOUSE Y: " + normalMouseY)
      .done();
  }

  public void drawIfEditMode() {
    if (this.isEditMode) {
      this.draw();
    }
  }
}

int KEY_E = 69;
