import fisica.*;

color TRANSPARENT = color(0,0,0,0);

color GROUND_COLOR = #22b14c;

PImage DIRT_IMG;

PImage mapImg;

FWorld world;

FPlayer player;

int gridSize = 32;

float cameraZoom = 2;

boolean wDown, aDown, sDown, dDown;

void setup() {
    pixelDensity(1);
    size(1300, 900, P2D);
    frameRate(120);

    mapImg = loadImage("map.png");

    DIRT_IMG = scaleImage(loadImage("dirt_center.png"), gridSize, gridSize);

    Fisica.init(this);
    world = new FWorld();


    for (int y = 0; y < mapImg.height; y++) {
        for (int x = 0; x < mapImg.width; x++) {
            color c = mapImg.get(x, y);
            if (c == TRANSPARENT) continue;

            FBox box = null;

            if (c == GROUND_COLOR) {
                box = new FBox(gridSize, gridSize);
                box.setFill(0, 0, 0);
                // box.attachImage(DIRT_IMG);
            }

            if(box == null) continue;
            box.setStatic(true);
            box.setStroke(0, 0, 0, 0);
            box.setPosition(x*gridSize, y*gridSize);
            box.setGrabbable(false);
            world.add(box);
        }
    }
    
    // spawn player
    player = new FPlayer();
    world.add(player);
}

void draw() {
    println(frameRate);
    background(255);

    player.update();
    world.step();

    pushMatrix();
    scale(cameraZoom);
    translate(-player.getX() + (width/2 / cameraZoom), -player.getY() + (height/2 / cameraZoom));

    world.draw();

    popMatrix();
}

void keyPressed() {
    if (key == 'W' || key =='w') wDown = true;
    if (key == 'A' || key =='a') aDown = true;
    if (key == 'S' || key =='s') sDown = true;
    if (key == 'D' || key =='d') dDown = true;
}

void keyReleased() {
    if (key == 'W' || key =='w') wDown = false;
    if (key == 'A' || key =='a') aDown = false;
    if (key == 'S' || key =='s') sDown = false;
    if (key == 'D' || key =='d') dDown = false;
}

PImage scaleImage(PImage src, int w, int h) {
  PImage out = createImage(w, h, ARGB);
  out.loadPixels();
  src.loadPixels();

  for (int y = 0; y < h; y++) {
    int sy = int(y * src.height / (float) h); 
    for (int x = 0; x < w; x++) {
      int sx = int(x * src.width / (float) w);
      out.pixels[y * w + x] = src.pixels[sy * src.width + sx];
    }
  }
  out.updatePixels();
  return out;
}