import fisica.*;

color TRANSPARENT = color(0, 0, 0, 0);

color GROUND_COLOR = #22b14c;
color SLIME_COLOR = #a8e61d;
color ICE_COLOR = #00b7ef;

PImage DIRT_CENTER, DIRT_N, DIRT_S, DIRT_E, DIRT_W, DIRT_NE, DIRT_NW, DIRT_SE, DIRT_SW;
PImage SLIME;
PImage ICE;

PImage mapImg;

FWorld world;

FPlayer player;

int gridSize = 64;

boolean wDown, aDown, sDown, dDown;

void setup() {
  pixelDensity(1);
  size(1300, 900, P2D);
  frameRate(120);

  mapImg = loadImage("map.png");

  DIRT_CENTER = scaleImage(loadImage("dirt_center.png"), gridSize, gridSize);
  DIRT_N = scaleImage(loadImage("dirt_n.png"), gridSize, gridSize);
  DIRT_S = scaleImage(loadImage("dirt_s.png"), gridSize, gridSize);
  DIRT_E = scaleImage(loadImage("dirt_e.png"), gridSize, gridSize);
  DIRT_W = scaleImage(loadImage("dirt_w.png"), gridSize, gridSize);
  DIRT_NE = scaleImage(loadImage("dirt_ne.png"), gridSize, gridSize);
  DIRT_NW = scaleImage(loadImage("dirt_nw.png"), gridSize, gridSize);
  DIRT_SE = scaleImage(loadImage("dirt_se.png"), gridSize, gridSize);
  DIRT_SW = scaleImage(loadImage("dirt_sw.png"), gridSize, gridSize);
  SLIME = scaleImage(loadImage("slime_block.png"), gridSize, gridSize);
  ICE = scaleImage(loadImage("blueBlock.png"), gridSize, gridSize);

  Fisica.init(this);
  world = new FWorld(Integer.MIN_VALUE, Integer.MIN_VALUE, Integer.MAX_VALUE, Integer.MAX_VALUE);
  world.setGravity(0, 400);

  for (int y = 0; y < mapImg.height; y++) {
    for (int x = 0; x < mapImg.width; x++) {
      color c = mapImg.get(x, y);

      FBox box = null;

      if (c == GROUND_COLOR) {
        boolean n = isTileType(x, y - 1, GROUND_COLOR);
        boolean s = isTileType(x, y + 1, GROUND_COLOR);
        boolean e = isTileType(x + 1, y, GROUND_COLOR);
        boolean w = isTileType(x - 1, y, GROUND_COLOR);

        PImage texture = DIRT_CENTER;
        if (!n && !e) texture = DIRT_NE;
        else if (!n && !w) texture = DIRT_NW;
        else if (!s && !e) texture = DIRT_SE;
        else if (!s && !w) texture = DIRT_SW;
        else if (!n) texture = DIRT_N;
        else if (!s) texture = DIRT_S;
        else if (!e) texture = DIRT_E;
        else if (!w) texture = DIRT_W;
        
        box = new FBox(gridSize, gridSize);
        box.attachImage(texture);
      }
      else if (c == SLIME_COLOR) {
        box = new FBox(gridSize, gridSize);
        box.attachImage(SLIME);
        box.setRestitution(2);
      }
      else if (c == ICE_COLOR) {
        box = new FBox(gridSize, gridSize);
        box.attachImage(ICE);
        box.setFriction(0);
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
  // println(frameRate);
  background(255);

  player.update();
  world.step();

  pushMatrix();
  translate(-player.getX() + (width/2), -player.getY() + (height/2));

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

boolean isTileType(int x, int y, color clr) {
  if (x < 0 || x >= mapImg.width || y < 0 || y >= mapImg.height) return false;
  return mapImg.get(x, y) == clr;
}

PImage scaleImage(PImage src, int w, int h) {
  PImage out = createImage(w, h, ARGB);
  out.loadPixels();
  src.loadPixels();
  for (int y = 0; y < h; y++) {
    int sy = (y * src.height) / h;
    for (int x = 0; x < w; x++) {
      int sx = (x * src.width) / w;
      out.pixels[y * w + x] = src.pixels[sy * src.width + sx];
    }
  }
  out.updatePixels();
  return out;
}
