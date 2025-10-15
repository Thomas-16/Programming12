class UFO extends GameObject {
  
  public UFO() {
    super(random(width), random(height), random(1.5, 2.5) * (random(1) < 0.5 ? -1 : 1), random(1.5, 2.5) * (random(1) < 0.5 ? -1 : 1));
  }
  
  public void update() {
    pos.add(vel);
    
    vel.x = (sin(millis() / 2000.0 - 74382) - 0.5) * 6;
    vel.y = (sin(millis() / 2000.0 + 4894) - 0.5) * 6;
    vel.limit(4.5);
    
    println((sin(millis() / 2000.0 - 74382) - 0.5) * 7);
    
    // edge handling
    if(pos.x > width) pos.sub(width, 0);
    if(pos.x < 0) pos.add(width, 0);
    if(pos.y > height) pos.sub(0, height);
    if(pos.y < 0) pos.add(0, height);
  }
  
  public void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    
    fill(0);
    stroke(255, 0, 0);
    strokeWeight(3);
    
    ellipse(0, 5, 50, 15);
    
    arc(0, 0, 25, 20, PI, TWO_PI);
    line(-12.5, 0, 12.5, 0);
    
    popMatrix();
  }
  
  
}
