class Spaceship extends GameObject {
  public PVector dir;
  
  private float turnSpeed;
  private float moveSpeed;
  
  Spaceship(float x, float y) {
    super(x, y, 0, 0);
    
    dir = new PVector(1, 0);
    
    turnSpeed = 3.6;
    moveSpeed = 0.5;
    
  }
  
  public void update() {
    pos.add(vel);
    
    // decay velocity
    vel.mult(0.95);
    
    vel.limit(9.5);
    
    dir.setMag(moveSpeed);
    if(upDown) vel.add(dir);
    
    if(leftDown) dir.rotate(-radians(turnSpeed));
    if(rightDown) dir.rotate(radians(turnSpeed));
    
    // edge handling
    if(pos.x > width) pos.sub(width, 0);
    if(pos.x < 0) pos.add(width, 0);
    if(pos.y > height) pos.sub(0, height);
    if(pos.y < 0) pos.add(0, height);
    
    handleCollisions();
  }
  
  private void handleCollisions() {
    for(GameObject obj : gameObjects) {
      if(!(obj instanceof Asteroid)) continue;
      
      Asteroid asteroid = (Asteroid) obj;
      
      if(polyPointCollision(asteroid.pos, asteroid.verticies, this.pos.x, this.pos.y)) {
        println("player died");
      }
    }
  }
  
  public void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(dir.heading());
    
    fill(0);
    stroke(255);
    strokeWeight(2);
    triangle(-5, -15, -5, 15, 20, 0); // wings
    line(-5, -15, 5, -15); // left antena
    line(-5, 15, 5, 15); // right antena
    strokeWeight(1);
    line(0, -12, 0, 12); // wing detail
    strokeWeight(2);
    triangle(-10, -10, -10, 10, 30, 0);
    strokeWeight(1);
    line(-6, -8, -6, 8);
    line(-6, 0, 30, 0);
    strokeWeight(2);
    circle(15, 0, 5);
    
    popMatrix();
  }
  
}
