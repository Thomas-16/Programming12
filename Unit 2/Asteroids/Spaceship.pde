class Spaceship extends GameObject {
  public PVector dir;

  private float turnSpeed;
  private float moveAccel;

  private boolean isInvulnerable;
  private int invulnStartTime;
  private final int INVULN_DURATION = 3000;
  
  private float shieldRot;

  Spaceship(float x, float y) {
    super(x, y, 0, 0);

    dir = new PVector(1, 0);

    turnSpeed = 2;
    moveAccel = 0.65;

    makeInvulnerable();
    
    shieldRot = 0;
  }
  
  public void update() {
    pos.add(vel);

    // decay velocity
    vel.mult(0.975);

    vel.limit(4.25);

    dir.setMag(moveAccel);
    if(upDown) {
      vel.add(dir);
      
      // thruster particles
      spawnThrusterParticles(pos, dir, 1);
    }

    if(leftDown) dir.rotate(-radians(turnSpeed));
    if(rightDown) dir.rotate(radians(turnSpeed));

    // edge handling
    if(pos.x > width) pos.sub(width, 0);
    if(pos.x < 0) pos.add(width, 0);
    if(pos.y > height) pos.sub(0, height);
    if(pos.y < 0) pos.add(0, height);

    // Update invulnerability
    if(isInvulnerable && millis() - invulnStartTime > INVULN_DURATION) {
      isInvulnerable = false;
    }
    
    if(isInvulnerable)
      shieldRot += 0.01;

    handleCollisions();
  }

  public void makeInvulnerable() {
    isInvulnerable = true;
    invulnStartTime = millis();
    shieldRot = 0;
  }

  public void loseLife() {
    // Spawn explosion particles
    spawnExplosionParticles(pos, color(255, 100, 50), 25);

    lives--;
    makeInvulnerable();
    
    addScreenShake(4);

    if(lives == 0)
      gameOver(false);
  }
  
  private void handleCollisions() {
    if(isInvulnerable) return;

    for(GameObject obj : gameObjects) {
      // Check asteroid collision
      if(obj instanceof Asteroid) {
        Asteroid asteroid = (Asteroid) obj;

        if(polyPointCollision(asteroid.pos, asteroid.vertices, this.pos.x, this.pos.y)) {
          loseLife();
          break;
        }
      }

      // Check UFO bullet collision
      if(obj instanceof Bullet) {
        Bullet bullet = (Bullet) obj;

        if(!bullet.isPlayers && !bullet.shouldBeDeleted) {
          float distance = PVector.dist(this.pos, bullet.pos);
          if(distance < 20) {
            bullet.delete();
            loseLife();
            break;
          }
        }
      }

      // Check UFO collision
      if(obj instanceof UFO) {
        UFO ufo = (UFO) obj;

        if(!ufo.shouldBeDeleted) {
          float distance = PVector.dist(this.pos, ufo.pos);
          if(distance < 55) {
            ufo.delete();
            lastUfoSpawnTime = millis();
            loseLife();
            break;
          }
        }
      }
    }
  }
  
  public void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(dir.heading());
    drawShip();
    popMatrix();
    
    if(isInvulnerable) {
      pushMatrix();
      
      PVector offset = new PVector(10, 0);
      offset.rotate(dir.heading());
      PVector shieldPos = PVector.add(pos, offset);
      
      translate(shieldPos.x, shieldPos.y);
      rotate(shieldRot);
      drawShield();
      
      popMatrix();
    }
  }
  
  private void drawShip() {
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
  }
  private void drawShield() {
    int timeRemaining = INVULN_DURATION - (millis() - invulnStartTime);

    // Flicker effect
    if(timeRemaining < 800) {
      if((millis() / 100) % 2 == 0) {
        return;
      }
    }

    fill(100, 150, 255, 100);
    stroke(255);
    strokeWeight(1.5);

    // Outer hexagon shape
    beginShape();
    for(int i = 0; i < 6; i++) {
      float angle = TWO_PI / 6 * i;
      float x = cos(angle) * 45;
      float y = sin(angle) * 45;
      vertex(x, y);
    }
    endShape(CLOSE);
    
    // Inner triangle
    noFill();
    beginShape();
    for(int i = 0; i < 3; i++) {
      float angle = TWO_PI / 3 * i;
      float x = cos(angle) * 45;
      float y = sin(angle) * 45;
      vertex(x, y);
    }
    endShape(CLOSE);
  }
  
  public void teleport(PVector newPos) {
    this.pos = newPos;
  }
  
}
