import fisica.*;

color TRANSPARENT = color(0, 0, 0, 0);

color SPAWN_COLOR = #990030;

color GROUND_COLOR = #22b14c;
color SLIME_COLOR = #a8e61d;
color ICE_COLOR = #00b7ef;
color SPIKE_COLOR = #464646;
color TRUNK_COLOR = #9c5a3c;
color LEAF_COLOR = #d3f9bc;
color BRIDGE_COLOR = #e5aa7a;
color LAVA_COLOR = #ed1c24;
color ONEWAY_COLOR = #f5e49c;

color GOOMBA_COLOR = #fff200;
color THWOMP_COLOR = #546d8e;
color HAMMER_BRO_COLOR = #ffc20e;

PImage BG_IMG;

PImage DIRT_CENTER, DIRT_N, DIRT_S, DIRT_E, DIRT_W, DIRT_NE, DIRT_NW, DIRT_SE, DIRT_SW;
PImage SLIME;
PImage ICE;
PImage SPIKE;
PImage TRUNK, TREE_INTERSECT, LEAF_CENTER, LEAF_W, LEAF_E;
PImage BRIDGE, BRIDGE_E, BRIDGE_W;
PImage[] LAVA_IMGS;
PImage THWOMP_IMG_0;
PImage THWOMP_IMG_1;

PImage mapImg;

PImage[] idleRightImgs;
PImage[] idleLeftImgs;
PImage[] jumpLeftImgs;
PImage[] jumpRightImgs;
PImage[] runLeftImgs;
PImage[] runRightImgs;
PImage[] currentImgs;

PImage[] goombaImgs;

PImage[] hammerBroRightImgs;
PImage[] hammerBroLeftImgs;
PImage HAMMER_IMG_RIGHT;
PImage HAMMER_IMG_LEFT;

FWorld world;

FPlayer player;
ArrayList<FGameObject> terrain;
ArrayList<FGameObject> enemies;

int gridSize = 64;

PVector spawnPos = new PVector(0,0);

boolean wDown, aDown, sDown, dDown;

// TODOS:
// new tiles
// button
// a moveable block - block can be pushed and put on button to press the button
// level design
// new enemy types
// rewind time gimmick
// multiple levels
// sound effects

void setup() {
  pixelDensity(1);
  size(1600, 1000, P2D);
  frameRate(120);

  terrain = new ArrayList<FGameObject>();
  enemies = new ArrayList<FGameObject>();

  idleRightImgs = new PImage[] { loadImage("Player/idle0.png"), loadImage("Player/idle1.png") };
  int scaleFactor = 2;
  for (int i = 0; i < idleRightImgs.length; i++) {
    idleRightImgs[i] = scaleImage(idleRightImgs[i], idleRightImgs[i].width * scaleFactor, idleRightImgs[i].height * scaleFactor);
  }
  idleLeftImgs = new PImage[] { reverseImage(loadImage("Player/idle0.png")), reverseImage(loadImage("Player/idle1.png")) };
  for (int i = 0; i < idleLeftImgs.length; i++) {
    idleLeftImgs[i] = scaleImage(idleLeftImgs[i], idleLeftImgs[i].width * scaleFactor, idleLeftImgs[i].height * scaleFactor);
  }
  jumpRightImgs = new PImage[] { loadImage("Player/jump0.png") };
  for (int i = 0; i < jumpRightImgs.length; i++) {
    jumpRightImgs[i] = scaleImage(jumpRightImgs[i], jumpRightImgs[i].width * scaleFactor, jumpRightImgs[i].height * scaleFactor);
  }
  jumpLeftImgs = new PImage[] { loadImage("Player/jump1.png") };
  for (int i = 0; i < jumpLeftImgs.length; i++) {
    jumpLeftImgs[i] = scaleImage(jumpLeftImgs[i], jumpLeftImgs[i].width * scaleFactor, jumpLeftImgs[i].height * scaleFactor);
  }
  runRightImgs = new PImage[] { loadImage("Player/runright0.png"), loadImage("Player/runright1.png"), loadImage("Player/runright2.png") };
  for (int i = 0; i < runRightImgs.length; i++) {
    runRightImgs[i] = scaleImage(runRightImgs[i], runRightImgs[i].width * scaleFactor, runRightImgs[i].height * scaleFactor);
  }
  runLeftImgs = new PImage[] { loadImage("Player/runleft0.png"), loadImage("Player/runleft1.png"), loadImage("Player/runleft2.png") };
  for (int i = 0; i < runLeftImgs.length; i++) {
    runLeftImgs[i] = scaleImage(runLeftImgs[i], runLeftImgs[i].width * scaleFactor, runLeftImgs[i].height * scaleFactor);
  }

  goombaImgs = new PImage[] { scaleImage(loadImage("Enemies/goomba0.png"), gridSize, gridSize), scaleImage(loadImage("Enemies/goomba1.png"), gridSize, gridSize) };

  hammerBroRightImgs = new PImage[] { scaleImage(loadImage("Enemies/hammerbro0.png"), gridSize, gridSize), scaleImage(loadImage("Enemies/hammerbro1.png"), gridSize, gridSize) };
  hammerBroLeftImgs = new PImage[] { scaleImage(reverseImage(loadImage("Enemies/hammerbro0.png")), gridSize, gridSize), scaleImage(reverseImage(loadImage("Enemies/hammerbro1.png")), gridSize, gridSize) };
  HAMMER_IMG_RIGHT = scaleImage(loadImage("Enemies/hammer.png"), gridSize, gridSize);
  HAMMER_IMG_LEFT = scaleImage(reverseImage(loadImage("Enemies/hammer.png")), gridSize, gridSize);

  THWOMP_IMG_0 = scaleImage(loadImage("Enemies/thwomp0.png"), gridSize*2, gridSize*2);
  THWOMP_IMG_1 = scaleImage(loadImage("Enemies/thwomp1.png"), gridSize*2, gridSize*2);

  currentImgs = idleRightImgs;

  mapImg = loadImage("map.png");

  BG_IMG = scaleImage(loadImage("background.png"), width, height);

  DIRT_CENTER = scaleImage(loadImage("OGTerrain/dirt_center.png"), gridSize, gridSize);
  DIRT_N = scaleImage(loadImage("OGTerrain/dirt_n.png"), gridSize, gridSize);
  DIRT_S = scaleImage(loadImage("OGTerrain/dirt_s.png"), gridSize, gridSize);
  DIRT_E = scaleImage(loadImage("OGTerrain/dirt_e.png"), gridSize, gridSize);
  DIRT_W = scaleImage(loadImage("OGTerrain/dirt_w.png"), gridSize, gridSize);
  DIRT_NE = scaleImage(loadImage("OGTerrain/dirt_ne.png"), gridSize, gridSize);
  DIRT_NW = scaleImage(loadImage("OGTerrain/dirt_nw.png"), gridSize, gridSize);
  DIRT_SE = scaleImage(loadImage("OGTerrain/dirt_se.png"), gridSize, gridSize);
  DIRT_SW = scaleImage(loadImage("OGTerrain/dirt_sw.png"), gridSize, gridSize);
  SLIME = scaleImage(loadImage("OGTerrain/slime_block.png"), gridSize, gridSize);
  ICE = scaleImage(loadImage("OGTerrain/blueBlock.png"), gridSize, gridSize);
  SPIKE = scaleImage(loadImage("OGTerrain/spike.png"), gridSize, gridSize);
  TRUNK = scaleImage(loadImage("OGTerrain/tree_trunk.png"), gridSize, gridSize);
  TREE_INTERSECT = scaleImage(loadImage("OGTerrain/tree_intersect.png"), gridSize, gridSize);
  LEAF_CENTER = scaleImage(loadImage("OGTerrain/treetop_center.png"), gridSize, gridSize);
  LEAF_W = scaleImage(loadImage("OGTerrain/treetop_w.png"), gridSize, gridSize);
  LEAF_E = scaleImage(loadImage("OGTerrain/treetop_e.png"), gridSize, gridSize);
  BRIDGE = scaleImage(loadImage("OGTerrain/bridge_center.png"), gridSize, gridSize);
  BRIDGE_E = scaleImage(loadImage("OGTerrain/bridge_e.png"), gridSize, gridSize);
  BRIDGE_W = scaleImage(loadImage("OGTerrain/bridge_w.png"), gridSize, gridSize);
  
  LAVA_IMGS = new PImage[6];
  for (int i = 0; i < 6; i++) {
    LAVA_IMGS[i] = scaleImage(loadImage("OGTerrain/lava" + i + ".png"), gridSize, gridSize);
  }

  Fisica.init(this);
  world = new FWorld(Integer.MIN_VALUE, Integer.MIN_VALUE, Integer.MAX_VALUE, Integer.MAX_VALUE);
  world.setGravity(0, 400);

  FCompound ground = new FCompound();

  for (int y = 0; y < mapImg.height; y++) {
    for (int x = 0; x < mapImg.width; x++) {
      color c = mapImg.get(x, y);

      if (c == SPAWN_COLOR) {
        spawnPos.set(x*gridSize, y*gridSize);
        continue;
      }

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
          color leftColor = x > 0 ? mapImg.get(x-1, y) : 0;
          color rightColor = x < mapImg.width-1 ? mapImg.get(x+1, y) : 0;
          boolean leftIsBridge = leftColor == BRIDGE_COLOR || leftColor == ONEWAY_COLOR;
          boolean rightIsBridge = rightColor == BRIDGE_COLOR || rightColor == ONEWAY_COLOR;

          PImage bridgeTexture = BRIDGE;
          if (!leftIsBridge && rightIsBridge) bridgeTexture = BRIDGE_W;
          else if (leftIsBridge && !rightIsBridge) bridgeTexture = BRIDGE_E;

          FBridge bridge = new FBridge(x*gridSize, y*gridSize, bridgeTexture);
          bridge.setStatic(true);
          bridge.setStroke(0,0,0,0);
          bridge.setGrabbable(false);
          world.add(bridge);
          terrain.add(bridge);
        }
        else if (c == LAVA_COLOR) {
          FLava lava = new FLava(x*gridSize, y*gridSize);
          lava.setStatic(true);
          lava.setStroke(0,0,0,0);
          lava.setGrabbable(false);
          world.add(lava);
          terrain.add(lava);
        }
        else if (c == ONEWAY_COLOR) {
          color leftColor = x > 0 ? mapImg.get(x-1, y) : 0;
          color rightColor = x < mapImg.width-1 ? mapImg.get(x+1, y) : 0;
          boolean leftIsBridge = leftColor == BRIDGE_COLOR || leftColor == ONEWAY_COLOR;
          boolean rightIsBridge = rightColor == BRIDGE_COLOR || rightColor == ONEWAY_COLOR;

          PImage platformTexture = BRIDGE;
          if (!leftIsBridge && rightIsBridge) platformTexture = BRIDGE_W;
          else if (leftIsBridge && !rightIsBridge) platformTexture = BRIDGE_E;

          FOneWayPlatform platform = new FOneWayPlatform(x*gridSize, y*gridSize, platformTexture);
          platform.setStatic(true);
          platform.setStroke(0,0,0,0);
          platform.setGrabbable(false);
          world.add(platform);
          terrain.add(platform);
        }
        else if (c == GOOMBA_COLOR) {
          FGoomba goomba = new FGoomba(x*gridSize, y*gridSize);
          goomba.setStroke(0,0,0,0);
          goomba.setGrabbable(false);
          world.add(goomba);
          enemies.add(goomba);

          int leftWall = x - 1;
          while (leftWall >= 0) {
            color pixelColor = mapImg.get(leftWall, y);
            if (pixelColor == GROUND_COLOR || pixelColor == SLIME_COLOR || pixelColor == ICE_COLOR || pixelColor == BRIDGE_COLOR) {
              break;
            }
            leftWall--;
          }

          int rightWall = x + 1;
          while (rightWall < mapImg.width) {
            color pixelColor = mapImg.get(rightWall, y);
            if (pixelColor == GROUND_COLOR || pixelColor == SLIME_COLOR || pixelColor == ICE_COLOR || pixelColor == BRIDGE_COLOR) {
              break;
            }
            rightWall++;
          }

          FBox leftSensor = new FBox(gridSize/6, gridSize);
          leftSensor.setPosition(leftWall*gridSize + gridSize/2, y*gridSize);
          leftSensor.setStatic(true);
          leftSensor.setSensor(true);
          leftSensor.setName("wall");
          leftSensor.setNoStroke();
          leftSensor.setNoFill();
          world.add(leftSensor);

          FBox rightSensor = new FBox(gridSize/6, gridSize);
          rightSensor.setPosition(rightWall*gridSize - gridSize/2, y*gridSize);
          rightSensor.setStatic(true);
          rightSensor.setSensor(true);
          rightSensor.setName("wall");
          rightSensor.setNoStroke();
          rightSensor.setNoFill();
          world.add(rightSensor);
        }
        else if (c == THWOMP_COLOR) {
          FThwomp thwomp = new FThwomp(x*gridSize + gridSize/2, y*gridSize + gridSize/2);
          thwomp.setGrabbable(false);
          world.add(thwomp);
          enemies.add(thwomp);
        }
        else if (c == HAMMER_BRO_COLOR) {
          FHammerBro hammerBro = new FHammerBro(x*gridSize, y*gridSize);
          hammerBro.setStroke(0,0,0,0);
          hammerBro.setGrabbable(false);
          world.add(hammerBro);
          enemies.add(hammerBro);

          int leftWall = x - 1;
          while (leftWall >= 0) {
            color pixelColor = mapImg.get(leftWall, y);
            if (pixelColor == GROUND_COLOR || pixelColor == SLIME_COLOR || pixelColor == ICE_COLOR || pixelColor == BRIDGE_COLOR) {
              break;
            }
            leftWall--;
          }

          int rightWall = x + 1;
          while (rightWall < mapImg.width) {
            color pixelColor = mapImg.get(rightWall, y);
            if (pixelColor == GROUND_COLOR || pixelColor == SLIME_COLOR || pixelColor == ICE_COLOR || pixelColor == BRIDGE_COLOR) {
              break;
            }
            rightWall++;
          }

          FBox leftSensor = new FBox(gridSize/6, gridSize);
          leftSensor.setPosition(leftWall*gridSize + gridSize/2, y*gridSize);
          leftSensor.setStatic(true);
          leftSensor.setSensor(true);
          leftSensor.setName("wall");
          leftSensor.setNoStroke();
          leftSensor.setNoFill();
          world.add(leftSensor);

          FBox rightSensor = new FBox(gridSize/6, gridSize);
          rightSensor.setPosition(rightWall*gridSize - gridSize/2, y*gridSize);
          rightSensor.setStatic(true);
          rightSensor.setSensor(true);
          rightSensor.setName("wall");
          rightSensor.setNoStroke();
          rightSensor.setNoFill();
          world.add(rightSensor);
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
  ground.setName("ground");
  world.add(ground);

  // spawn player
  player = new FPlayer((int)spawnPos.x, (int)spawnPos.y);
  world.add(player);
}

void draw() {
  // println(frameRate);
  background(BG_IMG);

  for (FGameObject gameObject : terrain) {
    gameObject.update();
  }
  for (FGameObject gameObject : enemies) {
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
