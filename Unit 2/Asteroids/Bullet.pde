class Bullet extends GameObject {
  private float speed;
  private int lifeTime;
  public boolean isPlayers;
  
  public Bullet(PVector pos, PVector dir, boolean isPlayers) {
    super(pos, dir);
    this.isPlayers = isPlayers;
    
    if(isPlayers)
      speed = 17;
    else
      speed = 12;
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
    if(isPlayers)
      fill(255);
    else
      fill(255,0,0);
    noStroke();
    circle(pos.x, pos.y, 7);
  }
  
}
