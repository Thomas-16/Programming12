class Asteroid extends GameObject {
  private int size; // 1, 2, or 3

  public PVector[] baseVertices; // original unrotated vertices
  public PVector[] vertices; // rotated vertices used for collision detection
  
  private PShape shape; // not rotated shape, we're rotating when drawing it
  private int numVertices;
  private float maxSize = 0;
  private float rotation;
  private float rotateVel;

  public Asteroid(int x, int y, int size, PVector dir) {
    super(x, y, 1, 1);
    
    dir.normalize();
    vel = dir.copy();
    vel.setMag(random(1, 3));
    
    this.size = size;
    this.rotation = 0;
    this.rotateVel = random(0.001, 0.006) * (random(1) < 0.5 ? -1 : 1);

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
    
    int radius = this.size * 30;
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
    this((int)random(width), (int)random(height), size, PVector.random2D());
  }
  
  public void update() {
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
    for(GameObject bullet : gameObjects) {
      if(!(bullet instanceof Bullet)) continue;
      
      if(polyPointCollision(this.pos, this.vertices, bullet.pos.x, bullet.pos.y) && !bullet.shouldBeDeleted) {
        this.delete();
        bullet.delete();
        
        if(this.size > 1) {
          PVector dir1 = bullet.vel.copy().rotate(radians(90));
          PVector dir2 = dir1.copy().rotate(PI);
          
          gameObjects.add(new Asteroid((int)pos.x, (int)pos.y, size-1, dir1));
          gameObjects.add(new Asteroid((int)pos.x, (int)pos.y, size-1, dir2));
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
