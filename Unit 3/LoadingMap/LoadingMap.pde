import fisica.*;

FWorld world;

PImage map;

ArrayList<FBox> worldBoxes;

FBox player1, player2;
FBomb bomb = null;

int gridSize = 10;

float cameraZoom = 3;

boolean wDown, aDown, sDown, dDown;
boolean upDown, leftDown, downDown, rightDown;
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

    // spawn players
    player1 = new FBox(gridSize, gridSize);
    player1.setFillColor(#2159ff);
    player1.setGrabbable(false);
    player1.setNoStroke();
    world.add(player1);

    player2 = new FBox(gridSize, gridSize);
    player2.setFillColor(#ff3721);
    player2.setGrabbable(false);
    player2.setNoStroke();
    world.add(player2);
}

void draw() {
    background(255);

    world.step();

    pushMatrix();
    scale(cameraZoom);
    translate(-player1.getX() + (width/2 / cameraZoom), -player1.getY() + (height/2 / cameraZoom));

    world.draw();

    popMatrix();

    int vx1 = 0;
    if (aDown) vx1 = -100;
    if (dDown) vx1 = 100;
    player1.setVelocity(vx1, player1.getVelocityY());

    int vx2 = 0;
    if (leftDown) vx2 = -100;
    if (rightDown) vx2 = 100;
    player2.setVelocity(vx2, player2.getVelocityY());

    int contactCount1 = player1.getContacts().size();
    if(contactCount1 > 0 && wDown) player1.setVelocity(player1.getVelocityX(), -150);

    int contactCount2 = player2.getContacts().size();
    if(contactCount2 > 0 && upDown) player2.setVelocity(player2.getVelocityX(), -150);

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
    if (keyCode == UP) upDown = true;
    if (keyCode == LEFT) leftDown = true;
    if (keyCode == RIGHT) rightDown = true;
    if (keyCode == DOWN) downDown = true;
}

void keyReleased() {
    if (key == 'W' || key =='w') wDown = false;
    if (key == 'A' || key =='a') aDown = false;
    if (key == 'S' || key =='s') sDown = false;
    if (key == 'D' || key =='d') dDown = false;
    if (key == ' ') spaceDown = false;
    if (keyCode == UP) upDown = false;
    if (keyCode == LEFT) leftDown = false;
    if (keyCode == RIGHT) rightDown = false;
    if (keyCode == DOWN) downDown = false;
}