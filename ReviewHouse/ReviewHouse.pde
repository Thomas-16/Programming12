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
  
  float t = map(sunY, groundHeight - 250, groundHeight + 250, 1.0, 0.0);
  
  color skyColor = lerpColor(skyColorNight, skyColorDay, t);
  background(skyColor);
  
  stroke(0); // black outlines
  strokeWeight(3);
  
  // draw sun
  strokeWeight(3);
  fill(doorColor);
  circle(sunX, sunY, 130);
  
  // draw moon
  fill(moonColor);
  circle(moonX, moonY, 130);
  
  // draw ground
  fill(groundColor);
  rectMode(CORNER);
  rect(0, groundHeight, width, height);
  
  // draw house
  int houseHeight = 150;
  fill(houseColor);
  rectMode(CORNERS);
  rect(400, groundHeight, 700, groundHeight - houseHeight);
  
  // draw chimney
  rect(430, groundHeight - houseHeight, 470, groundHeight - houseHeight - 100);
  
  // draw roof
  fill(roofColor);
  triangle(400-20, groundHeight - houseHeight, 700+20, groundHeight - houseHeight, 550, groundHeight-houseHeight - 120);
  
  // draw door
  fill(doorColor);
  rect(600, groundHeight, 660, groundHeight - 100);
  
  // draw door knob
  fill(doorKnobColor);
  circle(648, groundHeight - 50, 8);
  
  // draw window
  fill(doorColor);
  strokeWeight(2);
  rectMode(CENTER);
  int windowHalfSize = 33;
  square(470, groundHeight - 70, windowHalfSize * 2);
  line(470 - windowHalfSize, groundHeight-70, 470 + windowHalfSize, groundHeight-70);
  line(470, groundHeight - 70 - windowHalfSize, 470, groundHeight - 70 + windowHalfSize);
}
