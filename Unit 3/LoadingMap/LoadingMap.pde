import fisica.*;

FWorld world;

PImage map;

int gridSize = 50;

void setup() {
    size(1200, 800);

    Fisica.init(this);
    world = new FWorld();

    map = loadImage("map.png");

    for (int y = 0; y < map.height; y++) {
        for (int x = 0; x < map.width; x++) {
            color c = map.get(x, y);

            if (alpha(c) != 0 && c != color(255)) {
                FBox box = new FBox(gridSize, gridSize);
                box.setFillColor(c);
                box.setStatic(true);
                box.setPosition(x*gridSize, y*gridSize);
                box.setGrabbable(false);
                world.add(box);
            }
        }
    }
}

void draw() {
    background(255);

    world.step();
    world.draw();
}