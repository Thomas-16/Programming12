// Thomas Fang
// Pattern 1: https://www.vecteezy.com/video/8079150-animated-hypnotic-looping-tunnel-seamless-loop-background-animation
// Pattern 2: https://tenor.com/view/satisfying-gif-12900166457966624679
// Pattern 3: 




int currentPattern = 0;

CircleButton leftButton, rightButton;

void setup() {
  size(1200, 900);
  
  // initialize buttons
  leftButton = new CircleButton(100, height/2, 80, color(255), color(0), color(100), color(210), 3);
  rightButton = new CircleButton(width - 100, height/2, 80, color(255), color(0), color(100), color(210), 3);
  
  // setup onClick callbacks
  leftButton.setOnClick(() -> {
    leftButtonOnClickCallback();
  });
  rightButton.setOnClick(() -> {
    rightButtonOnClickCallback();
  });
  
  
  color leftColor = color(#85d079);
  color rightColor = color(#41ac90);
  color topColor = color(#ece862);
  color outlineColor = color(#297071);

  // for pattern 2
  leftShape = createShape();
  leftShape.beginShape();
  leftShape.fill(leftColor);
  leftShape.stroke(outlineColor);
  leftShape.strokeWeight(2);
  leftShape.vertex(0, 0);
  leftShape.vertex(0, 100);
  leftShape.vertex(-44.44, 100-25.66);
  leftShape.vertex(-44.44, 25.66);
  leftShape.vertex(-85.83, 0);
  leftShape.vertex(-85.83, -51.32);
  leftShape.endShape(CLOSE);
  leftShape.setFill(leftColor);
  
  topShape = copyAndRotateShape(leftShape, radians(120));
  topShape.beginShape();
  topShape.fill(topColor);
  topShape.stroke(outlineColor);
  topShape.strokeWeight(2);
  topShape.endShape();
  
  rightShape = copyAndRotateShape(topShape, radians(120));
  rightShape.beginShape();
  rightShape.fill(rightColor);
  rightShape.stroke(outlineColor);
  rightShape.strokeWeight(2);
  rightShape.endShape();
  
}

void draw() {
  background(0);
  
  // Draw pattern
  drawPattern2();
  
  // Draw buttons
  leftButton.draw();
  rightButton.draw();
  textAlign(CENTER, CENTER);
  textSize(50);
  fill(0);
  text("<", leftButton.getX(), leftButton.getY());
  text(">", rightButton.getX(), rightButton.getY());
}

void leftButtonOnClickCallback() {
  
}
void rightButtonOnClickCallback() {
  
}

PShape copyAndRotateShape(PShape original, float ang) {
  PShape result = createShape();
  result.beginShape();
  //result.fill(original.getFill(0)); // copy style (optional)

  float c = cos(ang), s = sin(ang);
  int n = original.getVertexCount();
  for (int i = 0; i < n; i++) {
    PVector v = original.getVertex(i);
    float xr = v.x * c - v.y * s;
    float yr = v.x * s + v.y * c;
    result.vertex(xr, yr);
  }

  result.endShape(CLOSE);
  return result;
}

void mousePressed() {
  leftButton.mousePressed();
  rightButton.mousePressed();
}
void mouseReleased() {
  leftButton.mouseReleased();
  rightButton.mouseReleased();
}

float sqrMagnitude(int x1, int y1, int x2, int y2) {
  return pow(x1 - x2, 2) + pow(y1 - y2, 2);
}
