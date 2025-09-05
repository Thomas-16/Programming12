// Thomas Fang

color groundColor = #68c449;
color houseColor = #f78d23;
color roofColor = #2684ff;
color doorColor = #f1ff26;
color doorKnobColor = 0;
color moonColor = #b8b8b8;

color skyColorDay = #d4fcff;
color skyColorNight = #101414;

int groundHeight = 500;

float sunAngle;

void setup() {
  size(800, 720);

}

void draw() {
  sunAngle += radians(1);
  float sunX = cos(sunAngle) * 300 + width/2;
  float sunY = sin(sunAngle) * 250 + groundHeight;
  
  float moonX = cos(sunAngle + PI) * 300 + width/2;
  float moonY = sin(sunAngle + PI) * 250 + groundHeight;
  
  // Draw sky 
  drawSky(sunY);
  
  // Draw sun and moon
  drawSun(sunX, sunY);
  drawMoon(moonX, moonY);
  
  // Draw landscape
  drawGround();
  drawHouse(550, groundHeight);
}

void drawSky(float sunY) {
  float t = map(sunY, groundHeight - 250, groundHeight + 250, 1.0, 0.0);
  color skyColor = lerpColor(skyColorNight, skyColorDay, t);
  background(skyColor);
}

void drawSun(float x, float y) {
  pushMatrix();
  translate(x, y);
  
  stroke(0);
  strokeWeight(3);
  fill(doorColor);
  circle(0, 0, 130);
  
  popMatrix();
}

void drawMoon(float x, float y) {
  pushMatrix();
  translate(x, y);
  
  stroke(0);
  strokeWeight(3);
  fill(moonColor);
  circle(0, 0, 130);
  
  popMatrix();
}

void drawGround() {
  stroke(0);
  strokeWeight(3);
  fill(groundColor);
  rectMode(CORNER);
  rect(0, groundHeight, width, height);
}

void drawHouse(float x, float y) {
  pushMatrix();
  translate(x, y);
  
  drawHouseBase();
  drawChimney();
  drawRoof();
  drawDoor();
  drawWindow();
  
  popMatrix();
}

void drawHouseBase() {
  int houseHeight = 150;
  stroke(0);
  strokeWeight(3);
  fill(houseColor);
  rectMode(CORNERS);
  rect(-150, 0, 150, -houseHeight);
}

void drawRoof() {
  stroke(0);
  strokeWeight(3);
  fill(roofColor);
  triangle(-170, -150, 170, -150, 0, -270);
}

void drawChimney() {
  stroke(0);
  strokeWeight(3);
  fill(houseColor);
  rectMode(CORNERS);
  rect(-120, -150, -80, -250);
}

void drawDoor() {
  pushMatrix();
  translate(50, 0);
  
  stroke(0);
  strokeWeight(3);
  fill(doorColor);
  rectMode(CORNERS);
  rect(0, 0, 60, -100);
  
  // Door knob
  fill(doorKnobColor);
  circle(48, -50, 8);
  
  popMatrix();
}

void drawWindow() {
  pushMatrix();
  translate(-80, -70);
  
  stroke(0);
  strokeWeight(2);
  fill(doorColor);
  rectMode(CENTER);
  int windowHalfSize = 33;
  square(0, 0, windowHalfSize * 2);
  
  // Window cross
  line(-windowHalfSize, 0, windowHalfSize, 0);
  line(0, -windowHalfSize, 0, windowHalfSize);
  
  popMatrix();
}
