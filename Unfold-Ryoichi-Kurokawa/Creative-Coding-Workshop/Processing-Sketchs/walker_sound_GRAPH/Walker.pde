// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A random walker object!

class Walker {
  float x, y;
  float tx, ty;
  float w, h; //max widht max height

  float prevX, prevY;

  Walker(float _w, float _h) {
    w = _w;
    h = _h;
    tx = 0;
    ty = 1000;
    x = map(noise(tx), 0, 1, 0, w);
    y = map(noise(ty), 0, 1, 0, h);
  }

  void render() {
    pushStyle();
    stroke(255);
    line(prevX, prevY, x, y);
    popStyle();
  }

  // Randomly move according to floating point values
  void step() {

    prevX = x;
    prevY = y;

    x = map(noise(tx), 0, 1, 0, w);
    y = map(noise(ty), 0, 1, 0, h);

    tx += 0.01;
    ty += 0.01;

  }
}