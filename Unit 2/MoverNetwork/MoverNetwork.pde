
Mover[] movers;
int numMovers = 80;

void setup() {
  size(1000, 800, P2D);
  
  movers = new Mover[numMovers];
  for(int i = 0; i < numMovers; i++) {
    movers[i] = new Mover();
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
