import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

int mode = 1;

ArrayList<PVector> points;
void setup() {

  size(500, 500);
  printArray(Arduino.list());
  points = new ArrayList<PVector>();
  frameRate(60);
  
   arduino = new Arduino(this, Arduino.list()[0], 57600);

}

void draw() {
  background(255);
  
  points.add(new PVector(mouseX, mouseY));
  
  //with frame rate 60fps
  //adding points every 1/60 X 30 points, 0.5 last half second of points
  if (points.size() > 30) {
    points.remove(points.get(0));
  }

  PVector p0 = points.get(points.size()-1); //actual real time points
  PVector p1 = points.get(0);  //0.5 delay points 

  fill(255, 0, 0);
  ellipse(width/3, p0.y, 50, 50);
  ellipse(2*width/3, p1.y, 50, 50);
  
  float a = map(height - p0.y, 0, height, 180, 0);  //mode 1 usereal time points
  if(mode == 2){
     a = map(height - p1.y, 0, height, 180, 0); // mode 2 use delayed points
  }
  //send position do servo on Arduino
  arduino.servoWrite(9, int(a));
}

void keyPressed() {
  if (key == '1') {
    mode = 1;
  } else if (key == '2') {
    mode = 2;
  }
}