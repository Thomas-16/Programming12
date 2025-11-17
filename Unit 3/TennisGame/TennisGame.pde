import fisica.*;

FWorld world;


void setup() {
  size(1200, 800);

  Fisica.init(this);
  
  
  setupWorld();
}

void setupWorld() {
  world = new FWorld();

  world.setGravity(0, 900);
  
  FBox floor = new FBox(width, 80);
  floor.setPosition(width/2, height);
  floor.setStatic(true);
  floor.setFill(0, 255, 0);
  world.add(floor);
}

void draw() {
  background(230);

  world.step();
  world.draw();
}
