class Asteroid extends GameObject {
  private int size; // 1, 2, or 3
  
  private PShape shape;
  private int numVertices;
  
  public Asteroid() {
    super(random(width), random(height), 0, 0);
    size = 3;
    
    numVertices = (int) random(10, 18);
    
    shape = createShape();
    shape.beginShape();
    shape.fill(0);
    shape.stroke(255);
    shape.strokeWeight(4);
    
    int radius = size * 30;
    for(int i = 0; i < numVertices; i++) {
      float angle = TWO_PI / (numVertices-1) * (float) i;
      float randomOffset = random(0.7, 1.3);
      
      shape.vertex(cos(angle) * radius * randomOffset, sin(angle) * radius * randomOffset);
    }
    shape.endShape(CLOSE);
  }
  
  public void update() {
    pos.add(vel);
  }
  
  public void draw() {
    fill(0);
    stroke(255);
    strokeWeight(4);
    shape(shape, pos.x, pos.y);
  }
  
}
