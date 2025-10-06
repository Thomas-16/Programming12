class Bullet extends GameObject {
  private float speed;
  private int lifeTime;
  
  public Bullet(PVector pos, PVector dir) {
    super(pos, dir);
    
    speed = 16;
    vel.setMag(speed);
    
    lifeTime = 80;
  }
  
  public void update() {
    pos.add(vel);
    
    // edge handling
    if(pos.x > width) pos.sub(width, 0);
    if(pos.x < 0) pos.add(width, 0);
    if(pos.y > height) pos.sub(0, height);
    if(pos.y < 0) pos.add(0, height);
    
    // lifetime
    lifeTime--;
    if(lifeTime < 0) {
      shouldBeDeleted = true;
    }
  }
  
  public void draw() {
    fill(255);
    noStroke();
    circle(pos.x, pos.y, 7);
  }
  
}
