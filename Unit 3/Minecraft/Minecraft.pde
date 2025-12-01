import fisica.*;

FWorld world;


int gridSize = 10;
float cameraZoom = 3;

void setup() {
    size(1300, 900);
    frameRate(60);

    Fisica.init(this);
    world = new FWorld();

}

void draw() {
    background(255);

    world.step();

    pushMatrix();
    scale(cameraZoom);
    // translate(-player1.getX() + (width/2 / cameraZoom), -player1.getY() + (height/2 / cameraZoom));

    world.draw();

    popMatrix();
}
