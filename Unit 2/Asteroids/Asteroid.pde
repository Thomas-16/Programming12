class Asteroid extends GameObject {
  private int size; // 1, 2, or 3

  public PVector[] baseVertices; // original unrotated vertices
  public PVector[] vertices; // rotated vertices used for collision detection
  
  private PShape shape; // not rotated shape, we're rotating when drawing it
  private int numVertices;
  private float maxSize = 0;
  private float rotation;
  private float rotateVel;
  
  private PVector targetVel;
  
  public Asteroid(int x, int y, int size, PVector dir, boolean isSplit) {
    super(x, y, 1, 1);
    
    dir.normalize();
    
    targetVel = dir.copy();
    targetVel.setMag(random(0.5, 1.5));

    if(isSplit) {
      vel = dir.copy();
      vel.setMag(random(3, 4.5)); // Start fast when splitting
    } else {
      vel = targetVel.copy();
    }
    
    this.size = size;
    this.rotation = 0;
    this.rotateVel = random(0.0005, 0.003) * (random(1) < 0.5 ? -1 : 1);

    numVertices = (int) random(10, 18);
    baseVertices = new PVector[numVertices];
    vertices = new PVector[numVertices];
    
    shape = createShape();
    shape.beginShape();
    shape.fill(0);
    shape.stroke(255);
    if(size >= 2)
      shape.strokeWeight(4);
    else
      shape.strokeWeight(3);
    
    int radius = this.size * 35;
    for(int i = 0; i < numVertices; i++) {
      float angle = TWO_PI / numVertices * (float) i;
      float randomOffset;
      if(size >= 2)
        randomOffset = random(0.7, 1.3);
      else
        randomOffset = random(0.8, 1.2);
      float randomRadius = radius * randomOffset;
      
      if(randomRadius * 2 > maxSize) {
        maxSize = randomRadius * 2;
      }

      float px = cos(angle) * randomRadius;
      float py = sin(angle) * randomRadius;

      baseVertices[i] = new PVector(px, py);
      vertices[i] = new PVector(px, py);

      shape.vertex(px, py);
    }
    shape.endShape(CLOSE);
  }
  
  public Asteroid(int size) {
    this((int)random(width), (int)random(height), size, PVector.random2D(), false);
  }
  
  public void update() {
    // slow down to target velocity
    if(vel.mag() > targetVel.mag()) {
      vel.mult(0.98);
      
      if(vel.mag() <= targetVel.mag()) {
        vel = targetVel.copy();
      }
    }
    
    pos.add(vel);

    rotation += rotateVel;

    // rotate collision vertices (stay relative to center)
    float c = cos(rotation);
    float s = sin(rotation);
    for (int i = 0; i < numVertices; i++) {
      PVector b = baseVertices[i];
      float rx = b.x * c - b.y * s;
      float ry = b.x * s + b.y * c;
      vertices[i].set(rx, ry);
    }

    // edge handling
    if(pos.x > width + maxSize/2) pos.sub(width + maxSize, 0);
    if(pos.x < 0 - maxSize/2) pos.add(width + maxSize, 0);
    if(pos.y > height + maxSize/2) pos.sub(0, height + maxSize);
    if(pos.y < 0 - maxSize/2) pos.add(0, height + maxSize);
    
    handleCollisions();
  }
  
  private void handleCollisions() {
    // bullet collision
    for(GameObject go : gameObjects) {
      if(!(go instanceof Bullet)) continue;
      
      Bullet bullet = (Bullet) go;
      
      if(!bullet.shouldBeDeleted && bullet.isPlayers && polyPointCollision(this.pos, this.vertices, bullet.pos.x, bullet.pos.y)) {
        spawnCollisionParticles(bullet.pos, bullet.vel, color(255, 200, 100), 45);

        this.delete();
        bullet.delete();

        spawnExplosionParticles(pos, color(150, 150, 150), 45);
        
        if(size > 1) {
          // split asteroids
          PVector dir1 = bullet.vel.copy().rotate(radians(90));
          PVector dir2 = dir1.copy().rotate(PI);
  
          gameObjects.add(new Asteroid((int)pos.x, (int)pos.y, size-1, dir1, true));
          gameObjects.add(new Asteroid((int)pos.x, (int)pos.y, size-1, dir2, true));
        }
        
        break;
      }
    }
  }
  
  public void draw() {
    // draw the PShape rotated around its center
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rotation);
    shape(shape, 0, 0);
    popMatrix();
  }
  
}
