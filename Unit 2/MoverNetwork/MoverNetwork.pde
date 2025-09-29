
ArrayList<Mover> movers;
int numMovers = 90;

void setup() {
  size(1000, 800, P2D);
  
  movers = new ArrayList<Mover>();
  for(int i = 0; i < numMovers; i++) {
    movers.add(new Mover(new PVector(random(width), random(height))));
  }
  
}

void draw() {
  background(0);
  
  for(Mover mover : movers) {
    mover.update();
    //mover.drawBody();
    mover.drawConnector();
  }
}

void mousePressed() {
  
}
