
PShape leftShape, rightShape, topShape;

void drawPattern2() {
  pushMatrix();
  translate(width/2, height/2);
  
  shape(leftShape);
  shape(rightShape);
  shape(topShape);
  
  translate(0, 151.31);
  
  shape(leftShape);
  shape(rightShape);
  shape(topShape);
  
  translate(260.54, 0);
  
  shape(leftShape);
  shape(rightShape);
  shape(topShape);
  
  translate(-130.27, 76.97);
  
  shape(leftShape);
  shape(rightShape);
  shape(topShape);
  
  translate(0, -151.31);
  
  shape(leftShape);
  shape(rightShape);
  shape(topShape);
  
  popMatrix();
  
}
