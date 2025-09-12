
PShape leftShape, rightShape, topShape;

void drawPattern2() {
  pushMatrix();
  //translate(width/2, height/2);
  
  for(float x = 0; x <= width + 100; x += 260.54) {
    for(float y = 0; y <= height + 100; y += 151.31) {
      drawYShape(x, y);
    }
  }
  
  for(float x = -130.27; x <= width + 100; x += 260.54) {
    for(float y = -151.31 + 76.97; y <= height + 100; y += 151.31) {
      drawYShape(x, y);
    }
  }
  
  popMatrix();
  
}

void drawYShape(float x, float y) {
  pushMatrix();
  translate(x, y);
  
  shape(leftShape);
  shape(rightShape);
  shape(topShape);
  
  popMatrix();
}
