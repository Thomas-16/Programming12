import fisica.*;

color TRANSPARENT = color(0, 0, 0, 0);

color GROUND_COLOR = #22b14c;
color SLIME_COLOR = #a8e61d;
color ICE_COLOR = #00b7ef;
color SPIKE_COLOR = #464646;
color TRUNK_COLOR = #9c5a3c;
color LEAF_COLOR = #d3f9bc;
color BRIDGE_COLOR = #e5aa7a;
color LAVA_COLOR = #ed1c24;

PImage DIRT_CENTER, DIRT_N, DIRT_S, DIRT_E, DIRT_W, DIRT_NE, DIRT_NW, DIRT_SE, DIRT_SW;
PImage SLIME;
PImage ICE;
PImage SPIKE;
PImage TRUNK, TREE_INTERSECT, LEAF_CENTER, LEAF_W, LEAF_E;
PImage BRIDGE;
PImage[] LAVA_IMGS;

PImage mapImg;

PImage[] idleRightImgs;
PImage[] idleLeftImgs;
PImage[] jumpLeftImgs;
PImage[] jumpRightImgs;
PImage[] runLeftImgs;
PImage[] runRightImgs;
PImage[] currentImgs;


FWorld world;

FPlayer player;
ArrayList<FGameObject> terrain;

int gridSize = 64;

boolean wDown, aDown, sDown, dDown;

void setup() {
  pixelDensity(1);
  size(1300, 900, P2D);
  frameRate(120);

  terrain = new ArrayList<FGameObject>();

  idleRightImgs = new PImage[] { loadImage("idle0.png"), loadImage("idle1.png") };
  int scaleFactor = 2;
  for (int i = 0; i < idleRightImgs.length; i++) {
    idleRightImgs[i] = scaleImage(idleRightImgs[i], idleRightImgs[i].width * scaleFactor, idleRightImgs[i].height * scaleFactor);
  }
  idleLeftImgs = new PImage[] { reverseImage(loadImage("idle0.png")), reverseImage(loadImage("idle1.png")) };
  for (int i = 0; i < idleLeftImgs.length; i++) {
    idleLeftImgs[i] = scaleImage(idleLeftImgs[i], idleLeftImgs[i].width * scaleFactor, idleLeftImgs[i].height * scaleFactor);
  }
  jumpRightImgs = new PImage[] { loadImage("jump0.png") };
  for (int i = 0; i < jumpRightImgs.length; i++) {
    jumpRightImgs[i] = scaleImage(jumpRightImgs[i], jumpRightImgs[i].width * scaleFactor, jumpRightImgs[i].height * scaleFactor);
  }
  jumpLeftImgs = new PImage[] { loadImage("jump1.png") };
  for (int i = 0; i < jumpLeftImgs.length; i++) {
    jumpLeftImgs[i] = scaleImage(jumpLeftImgs[i], jumpLeftImgs[i].width * scaleFactor, jumpLeftImgs[i].height * scaleFactor);
  }
  runRightImgs = new PImage[] { loadImage("runright0.png"), loadImage("runright1.png"), loadImage("runright2.png") };
  for (int i = 0; i < runRightImgs.length; i++) {
    runRightImgs[i] = scaleImage(runRightImgs[i], runRightImgs[i].width * scaleFactor, runRightImgs[i].height * scaleFactor);
  }
  runLeftImgs = new PImage[] { loadImage("runleft0.png"), loadImage("runleft1.png"), loadImage("runleft2.png") };
  for (int i = 0; i < runLeftImgs.length; i++) {
    runLeftImgs[i] = scaleImage(runLeftImgs[i], runLeftImgs[i].width * scaleFactor, runLeftImgs[i].height * scaleFactor);
  }

  currentImgs = idleRightImgs;

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
  SPIKE = scaleImage(loadImage("spike.png"), gridSize, gridSize);
  TRUNK = scaleImage(loadImage("tree_trunk.png"), gridSize, gridSize);
  TREE_INTERSECT = scaleImage(loadImage("tree_intersect.png"), gridSize, gridSize);
  LEAF_CENTER = scaleImage(loadImage("treetop_center.png"), gridSize, gridSize);
  LEAF_W = scaleImage(loadImage("treetop_w.png"), gridSize, gridSize);
  LEAF_E = scaleImage(loadImage("treetop_e.png"), gridSize, gridSize);
  BRIDGE = scaleImage(loadImage("bridge_center.png"), gridSize, gridSize);

  LAVA_IMGS = new PImage[6];
  for (int i = 0; i < 6; i++) {
    LAVA_IMGS[i] = scaleImage(loadImage("lava" + i + ".png"), gridSize, gridSize);
  }

  Fisica.init(this);
  world = new FWorld(Integer.MIN_VALUE, Integer.MIN_VALUE, Integer.MAX_VALUE, Integer.MAX_VALUE);
  world.setGravity(0, 400);

  FCompound ground = new FCompound();

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
        box.setName("ground");
      }
      else if (c == SLIME_COLOR) {
        box = new FBox(gridSize, gridSize);
        box.attachImage(SLIME);
        box.setRestitution(2);
        box.setName("slime");
      }
      else if (c == ICE_COLOR) {
        box = new FBox(gridSize, gridSize);
        box.attachImage(ICE);
        box.setFriction(0);
        box.setName("ice");
      }
      
      // not ground terrain
      if(box == null) {
        if (c == SPIKE_COLOR) {
          box = new FBox(gridSize, gridSize);
          box.attachImage(SPIKE);
          box.setName("spike");
          box.setStatic(true);
          box.setStroke(0, 0, 0, 0);
          box.setPosition(x*gridSize, y*gridSize);
          box.setGrabbable(false);
          world.add(box);
        }
        else if (c == TRUNK_COLOR) {
          box = new FBox(gridSize, gridSize);
          box.attachImage(TRUNK);
          box.setSensor(true);
          box.setStatic(true);
          box.setStroke(0, 0, 0, 0);
          box.setPosition(x*gridSize, y*gridSize);
          box.setGrabbable(false);
          world.add(box);
        }
        else if (c == LEAF_COLOR) {
          boolean s = isTileType(x, y + 1, TRUNK_COLOR);
          boolean e = isTileType(x + 1, y, LEAF_COLOR);
          boolean w = isTileType(x - 1, y, LEAF_COLOR);

          PImage texture = LEAF_CENTER;
          if (s) texture = TREE_INTERSECT;
          else if (!w && e) texture = LEAF_W;
          else if (w && !e) texture = LEAF_E;
          else if (w && e) texture = LEAF_CENTER;
          
          box = new FBox(gridSize, gridSize);
          box.setSensor(true);
          box.attachImage(texture);
          box.setStatic(true);
          box.setStroke(0, 0, 0, 0);
          box.setPosition(x*gridSize, y*gridSize);
          box.setGrabbable(false);
          world.add(box);
        }
        else if (c == BRIDGE_COLOR) {
          box = new FBridge();
          box.setStatic(true);
          box.setStroke(0,0,0,0);
          box.setPosition(x*gridSize, y*gridSize);
          box.setGrabbable(false);
          world.add(box);
          terrain.add((FGameObject)box);
        }
        else if (c == LAVA_COLOR) {
          box = new FLava();
          box.setStatic(true);
          box.setStroke(0,0,0,0);
          box.setPosition(x*gridSize, y*gridSize);
          box.setGrabbable(false);
          world.add(box);
          terrain.add((FGameObject)box);
        }
        continue;
      }
      box.setStatic(true);
      box.setStroke(0, 0, 0, 0);
      box.setPosition(x*gridSize, y*gridSize);
      box.setGrabbable(false);
      ground.addBody(box);

    }
  }
  ground.setStatic(true);
  world.add(ground);

  // spawn player
  player = new FPlayer();
  world.add(player);
}

void draw() {
  // println(frameRate);
  background(255);

  for (FGameObject gameObject : terrain) {
    gameObject.update();
  }
  player.update();
  
  world.step();

  pushMatrix();
  translate(-player.getX() + (width/2), -player.getY() + (height/2));

  world.draw();
  // world.drawDebug();

  popMatrix();
}

void keyPressed() {
  if (key == 'W' || key =='w') wDown = true;
  if (key == 'A' || key =='a') aDown = true;
  if (key == 'S' || key =='s') sDown = true;
  if (key == 'D' || key =='d') dDown = true;

  if (key == 'R' || key == 'r') player.die();
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
