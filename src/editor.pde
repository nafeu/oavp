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
    if (input.isPressed(KEY_F)) {
      entities.cycleActiveVariable();
    }
    if (input.isPressed(KEY_J)) {
      entities.getActiveVariable().increaseZR();
    }
  }

  private void toggleEditMode() {
    this.isEditMode = !this.isEditMode;
  }

  public boolean isEditMode() {
    return this.isEditMode;
  }

  public void draw() {
    StringBuilder msg = new StringBuilder("EDIT MODE");
    msg.append("\nX: " + normalMouseX);
    msg.append("\nY: " + normalMouseY);
    msg.append("\nVAR: " + entities.getActiveVariable().name);

    text.create()
      .colour(palette.flat.white)
      .size(14)
      .moveDown(oavp.height(0.05))
      .moveRight(oavp.width(0.05))
      .write(msg.toString())
      .done();
  }

  public void drawIfEditMode() {
    if (this.isEditMode) {
      this.draw();
    }
  }
}

int KEY_A = 65;
int KEY_B = 66;
int KEY_C = 67;
int KEY_D = 68;
int KEY_E = 69;
int KEY_F = 70;
int KEY_G = 71;
int KEY_H = 72;
int KEY_I = 73;
int KEY_J = 74;
int KEY_K = 75;
int KEY_L = 76;
int KEY_M = 77;
int KEY_N = 78;
int KEY_O = 79;
int KEY_P = 80;
int KEY_Q = 81;
int KEY_R = 82;
int KEY_S = 83;
int KEY_T = 84;
int KEY_U = 85;
int KEY_V = 86;
int KEY_W = 87;
int KEY_X = 88;
int KEY_Y = 89;
int KEY_Z = 90;




















