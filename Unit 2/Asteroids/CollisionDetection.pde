
boolean polyPointCollision(PVector polyPos, PVector[] vertices, float px, float py) {
  boolean collision = false;

  int next = 0;
  for (int current=0; current<vertices.length; current++) {

    // get next vertex in list
    // if we've hit the end, wrap around to 0
    next = current+1;
    if (next == vertices.length) next = 0;

    PVector vc = PVector.add(vertices[current], polyPos);    // current
    PVector vn = PVector.add(vertices[next], polyPos);       // next
    
    // compare position, flip 'collision' variable
    // back and forth
    if (((vc.y >= py && vn.y < py) || (vc.y < py && vn.y >= py)) &&
         (px < (vn.x-vc.x)*(py-vc.y) / (vn.y-vc.y)+vc.x)) {
            collision = !collision;
    }
  }
  return collision;
}

boolean polyPolyCollision(PVector p1Pos, PVector[] p1, PVector p2Pos, PVector[] p2) {

  int next = 0;
  for (int current=0; current<p1.length; current++) {

    // get next vertex in list
    // if we've hit the end, wrap around to 0
    next = current+1;
    if (next == p1.length) next = 0;

    PVector vc = PVector.add(p1[current], p1Pos);    // current
    PVector vn = PVector.add(p1[next], p1Pos);       // next

    // now we can use these two points (a line) to compare
    // to the other polygon's vertices using polyLine()
    boolean collision = polyLineCollision(p2Pos, p2, vc.x,vc.y,vn.x,vn.y);
    if (collision) return true;

    // optional: check if the 2nd polygon is INSIDE the first
    collision = polyPointCollision(p1Pos, p1, p2[0].x + p2Pos.x, p2[0].y + p2Pos.y);
    if (collision) return true;
  }

  return false;
}

boolean polyLineCollision(PVector pos, PVector[] vertices, float x1, float y1, float x2, float y2) {

  int next = 0;
  for (int current=0; current<vertices.length; current++) {

    // get next vertex in list
    // if we've hit the end, wrap around to 0
    next = current+1;
    if (next == vertices.length) next = 0;

    // get the PVectors at our current position
    // extract X/Y coordinates from each
    float x3 = PVector.add(vertices[current], pos).x;
    float y3 = PVector.add(vertices[current], pos).y;
    float x4 = PVector.add(vertices[next], pos).x;
    float y4 = PVector.add(vertices[next], pos).y;

    // do a Line/Line comparison
    boolean hit = lineLineCollision(x1, y1, x2, y2, x3, y3, x4, y4);
    if (hit) {
      return true;
    }
  }

  return false;
}

boolean lineLineCollision(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

  // calculate the direction of the lines
  float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

  // if uA and uB are between 0-1, lines are colliding
  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
    return true;
  }
  return false;
}
