// Thomas Fang

color groundColor = #68c449;
color houseColor = #f78d23;
color roofColor = #2684ff;
color doorColor = #f1ff26;
color doorKnobColor = 0;

int groundHeight = 500;

void setup() {
  size(800, 720);
  
  background(#d4fcff);
  
  stroke(0); // black outlines
  strokeWeight(3);
  
  // draw ground
  fill(groundColor);
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
  
  // draw sun
  strokeWeight(3);
  circle(0, 0, 250);
  
  
  
  
}
