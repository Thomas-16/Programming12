void drawPattern3() {
  rectMode(CENTER);
  fill(0);
  stroke(255);
  int deg = 0;
  for(int size = 700; size >= 1; size -= (60/700.0)) {
    pushMatrix();
    translate(width/2, height/2);
    rotate(radians(deg));
    
    strokeWeight(size * (8/700.0));
    square(0, 0, size);
    
    deg += 6;
    popMatrix();
  }
  
}
