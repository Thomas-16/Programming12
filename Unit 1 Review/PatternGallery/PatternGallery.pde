// Thomas Fang
// Pattern 1: https://www.vecteezy.com/video/8079150-animated-hypnotic-looping-tunnel-seamless-loop-background-animation
// Pattern 2: https://tenor.com/view/satisfying-gif-12900166457966624679
// Pattern 3: 




int currentPattern = 2;

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
  
  // for pattern 2
  pattern2Setup();
  
}

void draw() {
  background(0);
  
  // Draw pattern
  switch(currentPattern) {
    case 1:
      drawPattern1();
      break;
    case 2:
      drawPattern2();
      break;
    case 3:
      drawPattern3();
      break;
    
  }
  
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
  currentPattern--;
  if(currentPattern <= 0) {
    currentPattern = 3;
  }
}
void rightButtonOnClickCallback() {
  currentPattern++;
  if(currentPattern >= 4) {
    currentPattern = 1;
  }
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
