class Mover {
  public PVector pos;
  public PVector velocity;
  
  private float d;
  private int maxDist;
  
  Mover() {
    d = 100;
    maxDist = 200;
    pos = new PVector(random(0, width), random(0, height));
    
    // random magnitude and direction
    velocity = new PVector(1, 0);
    velocity.setMag(random(0.5, 2.5));
    velocity.rotate(random(0, 2 * PI));
  }
  
  void update() {
    pos.add(velocity);
    
    handleCollision();
  }
  
  void handleCollision() {
    if(pos.x < 0 || pos.x > width) velocity.x *= -1;
    if(pos.y < 0 || pos.y > height) velocity.y *= -1;
  }
  
  void drawBody() {
    noStroke();
    fill(250, 50);
    circle(pos.x, pos.y, d);
  }
  
  void drawConnector() {
    for(Mover mover : movers) {
      float dist = dist(pos.x, pos.y, mover.pos.x, mover.pos.y);
      if(dist < maxDist) {
        float a = map(dist, 0, maxDist, 220, 0);
        stroke(255, a);
        strokeWeight(2);
        line(pos.x, pos.y, mover.pos.x, mover.pos.y);
      }
    }
  }
}
