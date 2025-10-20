class UFO extends GameObject {
  private float lastShotTime = 4000;
  
  public UFO() {
    super(random(width), random(height), random(1.5, 2.5) * (random(1) < 0.5 ? -1 : 1), random(1.5, 2.5) * (random(1) < 0.5 ? -1 : 1));
  }
  
  public void update() {
    pos.add(vel);

    vel.x = (sin(millis() / 2000.0 - 74382) - 0.5) * 5;
    vel.y = (sin(millis() / 2000.0 + 4894) - 0.5) * 5;
    vel.limit(4);

    // edge handling
    if(pos.x > width) pos.sub(width, 0);
    if(pos.x < 0) pos.add(width, 0);
    if(pos.y > height) pos.sub(0, height);
    if(pos.y < 0) pos.add(0, height);

    if(millis() - 4000 > lastShotTime) {
      gameObjects.add(new Bullet(this.pos, PVector.sub(player.pos, this.pos), false));
      lastShotTime = millis();
    }

    handleCollisions();
  }

  private void handleCollisions() {
    for(GameObject obj : gameObjects) {
      if(!(obj instanceof Bullet)) continue;

      Bullet bullet = (Bullet) obj;

      if(bullet.isPlayers && !bullet.shouldBeDeleted) {
        float distance = PVector.dist(this.pos, bullet.pos);
        if(distance < 50) {
          println("UFO destroyed by player bullet");
          this.delete();
          bullet.delete();
          lastUfoSpawnTime = millis();
          break;
        }
      }
    }
  }
  
  public void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    
    fill(0);
    stroke(255, 0, 0);
    strokeWeight(3);
    
    ellipse(0, 5, 100, 30);
    
    arc(0, 0, 50, 40, PI, TWO_PI);
    line(-25, 0, 25, 0);
    
    popMatrix();
  }
  
  
}
