
class GameObject {
  public PVector pos;
  public PVector vel;
  public boolean shouldBeDeleted;
  
  public GameObject() {
    this.pos = new PVector(width/2, height/2);
    this.vel = new PVector(0,0);
  }
  
  public GameObject(float x, float y, float vx, float vy) {
    pos = new PVector(x, y);
    vel = new PVector(vx, vy);
  }
  
  public GameObject(PVector pos, PVector vel) {
    this.pos = pos.copy();
    this.vel = vel.copy();
  }
  
  public void update() {
    
  }
  
  public void draw() {
    
  }
}
