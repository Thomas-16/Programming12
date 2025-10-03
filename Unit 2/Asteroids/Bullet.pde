class Bullet extends GameObject {
  private float speed;
  
  public Bullet(PVector pos, PVector dir) {
    super(pos, dir);
    
    speed = 10;
    vel.setMag(speed);
  }
  
  public void update() {
    pos.add(vel);
    
    if(pos.x > width || pos.x < 0 || pos.y > height || pos.y < 0) shouldBeDeleted = true;
  }
  
  public void draw() {
    fill(255);
    noStroke();
    circle(pos.x, pos.y, 6);
  }
  
}
