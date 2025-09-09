float deg = 0;
float largestSize = 1250;

void drawPattern1() {
  rectMode(CENTER);
  fill(0);
  stroke(255);
  float largestSizeTemp = largestSize;
  float degTemp = deg;
  for(float size = largestSizeTemp; size >= 1; size *= ((largestSizeTemp-100)/ (float)largestSizeTemp) ) {
    pushMatrix();
    translate(width/2, height/2);
    rotate(radians(degTemp));
    
    strokeWeight(size * (12/ (float)largestSizeTemp) );
    square(0, 0, size);
    
    degTemp += 5;
    popMatrix();
  }
  deg += 0.2;
  largestSize *= 1.002;
}
