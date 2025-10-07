class Asteroid extends GameObject {
  private int size; // 1, 2, or 3
  
  private PShape shape;
  private PVector[] verticies;
  private int numVertices;
  private float maxSize = 0;
  
  public Asteroid() {
    super(random(width), random(height), 1, 1);
    vel.setMag(random(1, 3));
    vel.rotate(random(TWO_PI));
    
    size = 3;
    
    numVertices = (int) random(10, 18);
    verticies = new PVector[numVertices];
    
    shape = createShape();
    shape.beginShape();
    shape.fill(0);
    shape.stroke(255);
    shape.strokeWeight(4);
    
    int radius = size * 30;
    for(int i = 0; i < numVertices; i++) {
      float angle = TWO_PI / (numVertices-1) * (float) i;
      float randomOffset = random(0.7, 1.3);
      float randomRadius = radius * randomOffset;
      
      if(randomRadius * 2 > maxSize) {
        maxSize = randomRadius * 2;
      }
      
      verticies[i] = new PVector(cos(angle) * randomRadius, sin(angle) * randomRadius);
      shape.vertex(cos(angle) * randomRadius, sin(angle) * randomRadius);
    }
    shape.endShape(CLOSE);
  }
  
  public void update() {
    pos.add(vel);
    
    // edge handling
    if(pos.x > width + maxSize/2) pos.sub(width + maxSize, 0);
    if(pos.x < 0 - maxSize/2) pos.add(width + maxSize, 0);
    if(pos.y > height + maxSize/2) pos.sub(0, height + maxSize);
    if(pos.y < 0 - maxSize/2) pos.add(0, height + maxSize);
    
    handleCollisions();
  }
  
  private void handleCollisions() {
    
  }
  
  public void draw() {
    fill(0);
    stroke(255);
    strokeWeight(4);
    shape(shape, pos.x, pos.y);
  }
  
}
