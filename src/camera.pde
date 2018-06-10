public class OavpCamera {
  PVector eye;
  PVector center;
  PVector up;

  PVector eyeMovement = new PVector(0, 0, 0);
  PVector centerMovement = new PVector(0, 0, 0);
  PVector upMovement = new PVector(0, 0, 0);

  OavpCamera() {
    eye = new PVector();
    center = new PVector();
    up = new PVector();

    eye.x = oavp.w/2.0;
    eye.y = oavp.h/2.0;
    eye.z = (oavp.h/2.0) / tan(PI*30.0 / 180.0);
    center.x = oavp.w/2.0;
    center.y = oavp.h/2.0;
    center.z = 0;
    up.x = 0;
    up.y = 1;
    up.z = 0;
  }

  OavpCamera(float viewWidth, float viewHeight) {
    eye = new PVector();
    center = new PVector();
    up = new PVector();

    eye.x = viewWidth/2.0;
    eye.y = viewHeight/2.0;
    eye.z = (viewHeight/2.0) / tan(PI*30.0 / 180.0);
    center.x = viewWidth/2.0;
    center.y = viewHeight/2.0;
    center.z = 0;
    up.x = 0;
    up.y = 1;
    up.z = 0;
  }

  void view() {
    camera(eye.x + eyeMovement.x,
           eye.y + eyeMovement.y,
           eye.z + eyeMovement.z,
           center.x + centerMovement.x,
           center.y + centerMovement.y,
           center.z + centerMovement.z,
           up.x + upMovement.x,
           up.y + upMovement.y,
           up.z + upMovement.z);
  }

  void updateEye(float x, float y, float z) {
    eyeMovement.set(x, y, z);
  }

  void updateCenter(float x, float y, float z) {
    centerMovement.set(x, y, z);
  }

  void updateUp(float x, float y, float z) {
    upMovement.set(x, y, z);
  }

  void rotateAroundY(float angle, float distance) {
    float h = distance / tan(PI*30.0 / 180.0);
    eye.x = center.x + cos(radians(angle)) * h;
    eye.z = center.z + sin(radians(angle)) * h;
  }

  void rotateAroundX(float angle, float distance) {
    float h = distance / tan(PI*30.0 / 180.0);
    eye.z = center.z + cos(radians(angle)) * h;
    eye.y = center.y + sin(radians(angle)) * h;
    up.z = -sin(radians(angle));
    up.y = cos(radians(angle));
  }

  void rotateAroundZ(float angle) {
    up.x = sin(radians(angle));
    up.y = cos(radians(angle));
  }

  void distance(float distance) {
    eye.z = center.z + distance;
  }
}

