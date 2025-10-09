class Asteroid extends GameObject {
  private int size; // 1, 2, or 3

  public PVector[] baseVertices; // original unrotated vertices
  public PVector[] vertices; // rotated vertices used for collision detection
  
  private PShape shape; // not rotated shape, we're rotating when drawing it
  private int numVertices;
  private float maxSize = 0;
  private float rotation;
  private float rotateVel;

  public Asteroid(int size) {
    super(random(width), random(height), 1, 1);
    vel.setMag(random(1, 3));
    vel.rotate(random(TWO_PI));
    
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
    shape.strokeWeight(4);
    
    int radius = this.size * 30;
    for(int i = 0; i < numVertices; i++) {
      float angle = TWO_PI / numVertices * (float) i;
      float randomOffset = random(0.7, 1.3);
      float randomRadius = radius * randomOffset;
      
      if(randomRadius * 2 > maxSize) {
        maxSize = randomRadius * 2;
      }

      float x = cos(angle) * randomRadius;
      float y = sin(angle) * randomRadius;

      baseVertices[i] = new PVector(x, y);
      vertices[i] = new PVector(x, y);

      shape.vertex(x, y);
    }
    shape.endShape(CLOSE);
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
      
      if(polyPointCollision(this.pos, this.vertices, bullet.pos.x, bullet.pos.y)) {
        this.delete();
        bullet.delete();
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
