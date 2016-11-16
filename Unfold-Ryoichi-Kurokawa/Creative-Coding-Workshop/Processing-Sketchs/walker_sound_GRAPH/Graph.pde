class Graph {
  final static int NUM = 100;
  final static float W = 200;
  float px, py;
  ArrayList<Float> points;

  Graph(float _px, float _py) {
    px = _px;
    py = _py;
    points = new ArrayList<Float>();
  }

  void addPoint(float p) {
    if (p!=-1) {
      points.add(p);
      if (points.size() > NUM) {
        points.remove(0);
      }
    }
  }
  void draw() {
    pushStyle();
    pushMatrix();
    translate(px, py);
    fill(50);
    rect(0, 0, W, 60);
    stroke(255);
    strokeWeight(2);
    beginShape();
    for (int x = 0; x < points.size(); x++) {
      vertex(x*W/NUM, 60-60*points.get(x));
    }
    endShape();
    popMatrix();
    popStyle();

  }
}