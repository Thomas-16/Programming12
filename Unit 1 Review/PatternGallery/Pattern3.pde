
void drawPattern3() {
  color color1 = color(#004b23);
  color color2 = color(#ccff33);
  
  rectMode(CENTER);
  fill(0);
  float deg = 0;
  for(int size = 1200; size >= 1; size -= (80/700.0)) {
    pushMatrix();
    translate(width/2, height/2);
    rotate(radians(deg));
    
    color clr = lerpColor(color1, color2, map(size, 1200, 1, 0, 1));
    stroke(clr);
    
    strokeWeight(size * (5.5/700.0));
    square(0, 0, size);
    
    deg += 6;
    popMatrix();
  }
}
