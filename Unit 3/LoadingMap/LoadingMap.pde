import fisica.*;

FWorld world;

PImage map;

ArrayList<FBox> worldBoxes;

FPlayer player;
FBomb bomb = null;

int gridSize = 10;

float cameraZoom = 3;

boolean wDown, aDown, sDown, dDown;
boolean spaceDown;

void setup() {
    size(1300, 900);
    frameRate(60);

    worldBoxes = new ArrayList<FBox>();

    Fisica.init(this);
    world = new FWorld();

    map = loadImage("map.png");

    for (int y = 0; y < map.height; y++) {
        for (int x = 0; x < map.width; x++) {
            color c = map.get(x, y);

            if (alpha(c) != 0 && c != color(255)) {
                FBox box = new FBox(gridSize, gridSize);
                box.setFillColor(c);
                box.setNoStroke();
                box.setStatic(true);
                box.setPosition(x*gridSize, y*gridSize);
                box.setGrabbable(false);
                world.add(box);
                
                worldBoxes.add(box);
            }
        }
    }

    // spawn player
    player = new FPlayer();
    world.add(player);
}

void draw() {
    background(255);

    world.step();

    pushMatrix();
    scale(cameraZoom);
    translate(-player.getX() + (width/2 / cameraZoom), -player.getY() + (height/2 / cameraZoom));

    world.draw();

    popMatrix();

    player.update();

    if(spaceDown && bomb == null) {
        bomb = new FBomb();
    }

    if (bomb != null) bomb.act();
}

void keyPressed() {
    if (key == 'W' || key =='w') wDown = true;
    if (key == 'A' || key =='a') aDown = true;
    if (key == 'S' || key =='s') sDown = true;
    if (key == 'D' || key =='d') dDown = true;
    if (key == ' ') spaceDown = true;
}

void keyReleased() {
    if (key == 'W' || key =='w') wDown = false;
    if (key == 'A' || key =='a') aDown = false;
    if (key == 'S' || key =='s') sDown = false;
    if (key == 'D' || key =='d') dDown = false;
    if (key == ' ') spaceDown = false;
}