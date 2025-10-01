class Mover {
  public PVector pos;
  public PVector velocity;
  
  private float d;
  private int maxDist;
  private float maxRepelStrength = 0.4;
  
  Mover(PVector pos) {
    d = 100;
    maxDist = 200;
    
    this.pos = pos.copy();
    
    // random magnitude and direction
    velocity = new PVector(1, 0);
    velocity.setMag(random(0.5, 2.5));
    velocity.rotate(random(0, 2 * PI));
  }
  
  void update() {
    applyRepulsion();
    pos.add(velocity);
    
    handleCollision();
  }
  
  void applyRepulsion() {
    PVector repulsion = new PVector(0, 0);
    int repelDist = 50;
    
    for(Mover other : movers) {
      if(other == this) continue;
      
      float dist = dist(pos.x, pos.y, other.pos.x, other.pos.y);
      
      if(dist < repelDist && dist > 0) {
        // direction away from other mover
        PVector away = PVector.sub(pos, other.pos);
        away.normalize();
        
        float strength = map(dist, 0, repelDist, maxRepelStrength, 0);
        away.mult(strength);
        
        repulsion.add(away);
      }
    }
    
    velocity.add(repulsion);
    velocity.limit(4.5);
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
