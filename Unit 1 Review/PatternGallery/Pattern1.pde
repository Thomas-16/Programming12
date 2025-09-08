void drawPattern1() {
  rectMode(CENTER);
  fill(0);
  stroke(255);
  strokeWeight(3);
  for(int size = 700; size >= 20; size -= 80) {
    square(width/2, height/2, size);
  }
  
}
