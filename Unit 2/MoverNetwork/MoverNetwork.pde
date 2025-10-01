
ArrayList<Mover> movers;
int numMovers = 75;

void setup() {
  size(1200, 800, P2D);
  smooth(4);
  frameRate(60);
  colorMode(HSB, 360, 100, 100);

  movers = new ArrayList<Mover>();
  for (int i = 0; i < numMovers; i++) {
    movers.add(new Mover(new PVector(random(width), random(height))));
  }
}

void draw() {
  fill(0, 18);
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
