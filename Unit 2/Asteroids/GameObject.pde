
class GameObject {
  public PVector pos;
  public PVector vel;
  public boolean shouldBeDeleted;
  
  public GameObject() {
    this.pos = new PVector(width/2, height/2);
    this.vel = new PVector(0,0);
    this.shouldBeDeleted = false;
  }
  
  public GameObject(float x, float y, float vx, float vy) {
    this.pos = new PVector(x, y);
    this.vel = new PVector(vx, vy);
    this.shouldBeDeleted = false;
  }
  
  public GameObject(PVector pos, PVector vel) {
    this.pos = pos.copy();
    this.vel = vel.copy();
    this.shouldBeDeleted = false;
  }
  
  public void update() {
    
  }
  
  public void draw() {
    
  }
}
