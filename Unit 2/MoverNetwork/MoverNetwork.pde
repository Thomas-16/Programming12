
ArrayList<Mover> movers;
int numMovers = 80;

void setup() {
  size(1000, 800, P2D);
  frameRate(60);

  movers = new ArrayList<Mover>();
  for (int i = 0; i < numMovers; i++) {
    movers.add(new Mover(new PVector(random(width), random(height))));
  }
}

void draw() {
  fill(0, 30);
  noStroke();
  rect(0, 0, width, height);

  for (Mover mover : movers) {
    mover.update();
    //mover.drawBody();
    mover.drawConnector();
  }
}

void mousePressed() {
  if (mouseButton != LEFT) return;

  for (Mover mover : movers) {
    if (dist(mouseX, mouseY, mover.pos.x, mover.pos.y) < 25) {
      movers.remove(mover);
      break;
    }
  }
}
