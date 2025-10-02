class Spaceship {
  public PVector pos;
  public PVector vel;
  public PVector dir;
  
  Spaceship() {
    pos = new PVector(width/2, height/2);
    vel = new PVector(0,0);
    dir = new PVector(1, 0);
  }
  
  public void update() {
    
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
  
  public void shoot() {
    
  }
  
}
