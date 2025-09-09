// Thomas Fang
// Pattern 1: https://www.vecteezy.com/video/8079150-animated-hypnotic-looping-tunnel-seamless-loop-background-animation
// Pattern 2: https://tenor.com/view/satisfying-gif-12900166457966624679
// Pattern 3: 


int currentPattern = 0;

CircleButton leftButton, rightButton;

void setup() {
  size(1200, 800);
  
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
  
  
  // for pattern 2
  leftShape = createShape();
  leftShape.beginShape();
  leftShape.fill(leftColor);
  leftShape.stroke(#297071);
  leftShape.strokeWeight(2);
  leftShape.vertex(0, 0);
  
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
