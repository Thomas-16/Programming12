import fisica.*;

// https://nicopardo.itch.io/cyberlab
// https://nicopardo.itch.io/cyberlab-expansion-pack-1

color TRANSPARENT = color(0, 0, 0, 0);

color SPAWN_COLOR = #990030;

color GROUND_COLOR = #4d6df3;
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
color BUTTON_COLOR = #709ad1;
color CUBE_COLOR = #ffa3b1;
color DOOR_COLOR = #2f3699;

PImage BG_IMG;
PImage BUTTON_IMG, BUTTON_DOWN_IMG;
PImage CUBE_IMG;
PImage[] DOOR_LEFT_IMGS;
PImage[] DOOR_RIGHT_IMGS;

PImage GROUND_CENTER, GROUND_N, GROUND_S, GROUND_E, GROUND_W, GROUND_NE, GROUND_NW, GROUND_SE, GROUND_SW;
PImage GROUND_INNER_NE, GROUND_INNER_NW, GROUND_INNER_SE, GROUND_INNER_SW;
PImage GROUND_ALONE, GROUND_ONEDEEP_LEFT, GROUND_ONEDEEP_CENTER, GROUND_ONEDEEP_RIGHT;
PImage GROUND_PILLAR_TOP, GROUND_PILLAR_CENTER, GROUND_PILLAR_BOTTOM;
PImage SLIME;
PImage ICE;
PImage SPIKE;
PImage TRUNK, TREE_INTERSECT, LEAF_CENTER, LEAF_W, LEAF_E;
PImage BRIDGE;
PImage ONEWAY_LEFT, ONEWAY_RIGHT;
PImage[] LAVA_IMGS;
PImage THWOMP_IMG_0;
PImage THWOMP_IMG_1;

PImage mapImg;

PImage[] idleRightImgs;
PImage[] idleLeftImgs;
PImage[] jumpLeftImgs;
PImage[] jumpRightImgs;
PImage[] fallLeftImgs;
PImage[] fallRightImgs;
PImage[] runLeftImgs;
PImage[] runRightImgs;
PImage[] hitLeftImgs;
PImage[] hitRightImgs;
PImage[] currentImgs;

PImage[] ghostIdleRightImgs;
PImage[] ghostIdleLeftImgs;
PImage[] ghostJumpLeftImgs;
PImage[] ghostJumpRightImgs;
PImage[] ghostFallLeftImgs;
PImage[] ghostFallRightImgs;
PImage[] ghostRunLeftImgs;
PImage[] ghostRunRightImgs;
PImage[] ghostHitLeftImgs;
PImage[] ghostHitRightImgs;

PImage[] goombaImgs;

PImage[] hammerBroRightImgs;
PImage[] hammerBroLeftImgs;
PImage HAMMER_IMG_RIGHT;
PImage HAMMER_IMG_LEFT;

FWorld world;

FPlayer player;
ArrayList<FGameObject> terrain;
ArrayList<FGameObject> enemies;
ArrayList<FDoor> doors;

int gridSize = 64;

float zoom = 1.2;

PVector spawnPos = new PVector(0,0);

boolean wDown, aDown, sDown, dDown;

ArrayList<PVector> recordedPositions;
boolean isRecording = false;
int recordStartFrame = 0;
int RECORD_DURATION = 4 * 120; 
FGhost ghost = null;


void setup() {
  pixelDensity(1);
  size(1600, 1000, P2D);
  frameRate(120);

  terrain = new ArrayList<FGameObject>();
  enemies = new ArrayList<FGameObject>();
  doors = new ArrayList<FDoor>();

  int scaleFactor = 2;

  idleRightImgs = new PImage[6];
  idleLeftImgs = new PImage[6];
  for (int i = 0; i < 6; i++) {
    PImage img = loadImage("CyberLab_ExPack1/Animations/MainCharacter/idle00" + i + ".png");
    idleRightImgs[i] = scaleImage(img, img.width * scaleFactor, img.height * scaleFactor);
    idleLeftImgs[i] = scaleImage(reverseImage(img), img.width * scaleFactor, img.height * scaleFactor);
  }

  runRightImgs = new PImage[10];
  runLeftImgs = new PImage[10];
  for (int i = 0; i < 10; i++) {
    PImage img = loadImage("CyberLab_ExPack1/Animations/MainCharacter/run00" + i + ".png");
    runRightImgs[i] = scaleImage(img, img.width * scaleFactor, img.height * scaleFactor);
    runLeftImgs[i] = scaleImage(reverseImage(img), img.width * scaleFactor, img.height * scaleFactor);
  }

  PImage jumpImg = loadImage("CyberLab_ExPack1/Animations/MainCharacter/jump.png");
  jumpRightImgs = new PImage[] { scaleImage(jumpImg, jumpImg.width * scaleFactor, jumpImg.height * scaleFactor) };
  jumpLeftImgs = new PImage[] { scaleImage(reverseImage(jumpImg), jumpImg.width * scaleFactor, jumpImg.height * scaleFactor) };

  PImage fallImg = loadImage("CyberLab_ExPack1/Animations/MainCharacter/fall.png");
  fallRightImgs = new PImage[] { scaleImage(fallImg, fallImg.width * scaleFactor, fallImg.height * scaleFactor) };
  fallLeftImgs = new PImage[] { scaleImage(reverseImage(fallImg), fallImg.width * scaleFactor, fallImg.height * scaleFactor) };

  hitRightImgs = new PImage[4];
  hitLeftImgs = new PImage[4];
  for (int i = 0; i < 4; i++) {
    // String num = nf(i, 3);
    PImage img = loadImage("CyberLab_ExPack1/Animations/MainCharacter/hit00" + i + ".png");
    hitRightImgs[i] = scaleImage(img, img.width * scaleFactor, img.height * scaleFactor);
    hitLeftImgs[i] = scaleImage(reverseImage(img), img.width * scaleFactor, img.height * scaleFactor);
  }

  goombaImgs = new PImage[] { scaleImage(loadImage("Enemies/goomba0.png"), gridSize, gridSize), scaleImage(loadImage("Enemies/goomba1.png"), gridSize, gridSize) };

  hammerBroRightImgs = new PImage[] { scaleImage(loadImage("Enemies/hammerbro0.png"), gridSize, gridSize), scaleImage(loadImage("Enemies/hammerbro1.png"), gridSize, gridSize) };
  hammerBroLeftImgs = new PImage[] { scaleImage(reverseImage(loadImage("Enemies/hammerbro0.png")), gridSize, gridSize), scaleImage(reverseImage(loadImage("Enemies/hammerbro1.png")), gridSize, gridSize) };
  HAMMER_IMG_RIGHT = scaleImage(loadImage("Enemies/hammer.png"), gridSize, gridSize);
  HAMMER_IMG_LEFT = scaleImage(reverseImage(loadImage("Enemies/hammer.png")), gridSize, gridSize);

  THWOMP_IMG_0 = scaleImage(loadImage("Enemies/thwomp0.png"), gridSize*2, gridSize*2);
  THWOMP_IMG_1 = scaleImage(loadImage("Enemies/thwomp1.png"), gridSize*2, gridSize*2);

  currentImgs = idleRightImgs;

  ghostIdleRightImgs = new PImage[idleRightImgs.length];
  ghostIdleLeftImgs = new PImage[idleLeftImgs.length];
  ghostJumpRightImgs = new PImage[jumpRightImgs.length];
  ghostJumpLeftImgs = new PImage[jumpLeftImgs.length];
  ghostFallRightImgs = new PImage[fallRightImgs.length];
  ghostFallLeftImgs = new PImage[fallLeftImgs.length];
  ghostRunRightImgs = new PImage[runRightImgs.length];
  ghostRunLeftImgs = new PImage[runLeftImgs.length];
  ghostHitRightImgs = new PImage[hitRightImgs.length];
  ghostHitLeftImgs = new PImage[hitLeftImgs.length];
  for (int i = 0; i < idleRightImgs.length; i++) ghostIdleRightImgs[i] = makeGhostImage(idleRightImgs[i]);
  for (int i = 0; i < idleLeftImgs.length; i++) ghostIdleLeftImgs[i] = makeGhostImage(idleLeftImgs[i]);
  for (int i = 0; i < jumpRightImgs.length; i++) ghostJumpRightImgs[i] = makeGhostImage(jumpRightImgs[i]);
  for (int i = 0; i < jumpLeftImgs.length; i++) ghostJumpLeftImgs[i] = makeGhostImage(jumpLeftImgs[i]);
  for (int i = 0; i < fallRightImgs.length; i++) ghostFallRightImgs[i] = makeGhostImage(fallRightImgs[i]);
  for (int i = 0; i < fallLeftImgs.length; i++) ghostFallLeftImgs[i] = makeGhostImage(fallLeftImgs[i]);
  for (int i = 0; i < runRightImgs.length; i++) ghostRunRightImgs[i] = makeGhostImage(runRightImgs[i]);
  for (int i = 0; i < runLeftImgs.length; i++) ghostRunLeftImgs[i] = makeGhostImage(runLeftImgs[i]);
  for (int i = 0; i < hitRightImgs.length; i++) ghostHitRightImgs[i] = makeGhostImage(hitRightImgs[i]);
  for (int i = 0; i < hitLeftImgs.length; i++) ghostHitLeftImgs[i] = makeGhostImage(hitLeftImgs[i]);

  recordedPositions = new ArrayList<PVector>();

  mapImg = loadImage("map.png");

  BG_IMG = loadImage("CyberLab_ExPack1/TileSets/background.png");
  BG_IMG = scaleImage(BG_IMG, 512, 512);

  GROUND_CENTER = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_center.png"), gridSize, gridSize);
  GROUND_N = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_top.png"), gridSize, gridSize);
  GROUND_S = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_bottom.png"), gridSize, gridSize);
  GROUND_E = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_right.png"), gridSize, gridSize);
  GROUND_W = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_left.png"), gridSize, gridSize);
  GROUND_NE = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_outercorner_topright.png"), gridSize, gridSize);
  GROUND_NW = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_outercorner_topleft.png"), gridSize, gridSize);
  GROUND_SE = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_outercorner_bottomright.png"), gridSize, gridSize);
  GROUND_SW = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_outercorner_bottomleft.png"), gridSize, gridSize);
  GROUND_INNER_NE = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_innercorner_topright.png"), gridSize, gridSize);
  GROUND_INNER_NW = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_innercorner_topleft.png"), gridSize, gridSize);
  GROUND_INNER_SE = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_innercorner_bottomright.png"), gridSize, gridSize);
  GROUND_INNER_SW = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_innercorner_bottomleft.png"), gridSize, gridSize);
  GROUND_ALONE = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_alone.png"), gridSize, gridSize);
  GROUND_ONEDEEP_LEFT = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_onedeep_left.png"), gridSize, gridSize);
  GROUND_ONEDEEP_CENTER = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_onedeep_center.png"), gridSize, gridSize);
  GROUND_ONEDEEP_RIGHT = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_onedeep_right.png"), gridSize, gridSize);
  GROUND_PILLAR_TOP = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_pillar_top.png"), gridSize, gridSize);
  GROUND_PILLAR_CENTER = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_pillar_center.png"), gridSize, gridSize);
  GROUND_PILLAR_BOTTOM = scaleImage(loadImage("CyberLab_ExPack1/ground/ground_pillar_bottom.png"), gridSize, gridSize);
  SLIME = scaleImage(loadImage("OGTerrain/slime_block.png"), gridSize, gridSize);
  ICE = scaleImage(loadImage("OGTerrain/blueBlock.png"), gridSize, gridSize);
  SPIKE = scaleImage(loadImage("CyberLab_ExPack1/traps/spike.png"), gridSize, gridSize);
  TRUNK = scaleImage(loadImage("OGTerrain/tree_trunk.png"), gridSize, gridSize);
  TREE_INTERSECT = scaleImage(loadImage("OGTerrain/tree_intersect.png"), gridSize, gridSize);
  LEAF_CENTER = scaleImage(loadImage("OGTerrain/treetop_center.png"), gridSize, gridSize);
  LEAF_W = scaleImage(loadImage("OGTerrain/treetop_w.png"), gridSize, gridSize);
  LEAF_E = scaleImage(loadImage("OGTerrain/treetop_e.png"), gridSize, gridSize);
  BRIDGE = scaleImage(loadImage("CyberLab_ExPack1/platforms/bridge.png"), gridSize, gridSize);
  ONEWAY_LEFT = scaleImage(loadImage("CyberLab_ExPack1/platforms/oneway_left.png"), gridSize, gridSize);
  ONEWAY_RIGHT = scaleImage(loadImage("CyberLab_ExPack1/platforms/oneway_right.png"), gridSize, gridSize);
  BUTTON_IMG = scaleImage(loadImage("button.png"), gridSize, gridSize);
  BUTTON_DOWN_IMG = scaleImage(loadImage("button_down.png"), gridSize, gridSize);
  CUBE_IMG = scaleImage(loadImage("cube.png"), gridSize, gridSize);

  DOOR_LEFT_IMGS = new PImage[4];
  DOOR_RIGHT_IMGS = new PImage[4];
  for (int i = 0; i < 4; i++) {
    DOOR_LEFT_IMGS[i] = scaleImage(loadImage("door/door" + (i + 1) + ".png"), gridSize, gridSize * 2);
    DOOR_RIGHT_IMGS[i] = scaleImage(reverseImage(loadImage("door/door" + (i + 1) + ".png")), gridSize, gridSize * 2);
  }

  LAVA_IMGS = new PImage[6];
  for (int i = 0; i < 6; i++) {
    LAVA_IMGS[i] = scaleImage(loadImage("OGTerrain/lava" + i + ".png"), gridSize, gridSize);
  }

  Fisica.init(this);
  world = new FWorld(Integer.MIN_VALUE, Integer.MIN_VALUE, Integer.MAX_VALUE, Integer.MAX_VALUE);
  world.setGravity(0, 400);

  FCompound ground = new FCompound();
  HashMap<Integer, FButton> buttonsByCode = new HashMap<Integer, FButton>();

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
        boolean ne = isTileType(x + 1, y - 1, GROUND_COLOR);
        boolean nw = isTileType(x - 1, y - 1, GROUND_COLOR);
        boolean se = isTileType(x + 1, y + 1, GROUND_COLOR);
        boolean sw = isTileType(x - 1, y + 1, GROUND_COLOR);

        PImage texture = GROUND_CENTER;
        // Alone
        if (!n && !s && !e && !w) texture = GROUND_ALONE;
        // Horizontal platform
        else if (!n && !s && !w && e) texture = GROUND_ONEDEEP_LEFT;
        else if (!n && !s && w && !e) texture = GROUND_ONEDEEP_RIGHT;
        else if (!n && !s && w && e) texture = GROUND_ONEDEEP_CENTER;
        // Virtical platform
        else if (!n && s && !e && !w) texture = GROUND_PILLAR_TOP;
        else if (n && !s && !e && !w) texture = GROUND_PILLAR_BOTTOM;
        else if (n && s && !e && !w) texture = GROUND_PILLAR_CENTER;
        // Outer corners
        else if (!n && !e) texture = GROUND_NE;
        else if (!n && !w) texture = GROUND_NW;
        else if (!s && !e) texture = GROUND_SE;
        else if (!s && !w) texture = GROUND_SW;
        // Edges
        else if (!n) texture = GROUND_N;
        else if (!s) texture = GROUND_S;
        else if (!e) texture = GROUND_E;
        else if (!w) texture = GROUND_W;
        // Inner corners
        else if (n && e && !ne) texture = GROUND_INNER_NE;
        else if (n && w && !nw) texture = GROUND_INNER_NW;
        else if (s && e && !se) texture = GROUND_INNER_SE;
        else if (s && w && !sw) texture = GROUND_INNER_SW;
        
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
          // spike visual
          FBox visual = new FBox(gridSize, gridSize);
          visual.attachImage(SPIKE);
          visual.setSensor(true);
          visual.setStatic(true);
          visual.setStroke(0, 0, 0, 0);
          visual.setPosition(x*gridSize, y*gridSize);
          visual.setGrabbable(false);
          world.add(visual);

          // Collider
          float hitboxHeight = gridSize * 0.4;
          box = new FBox(gridSize * 0.6, hitboxHeight);
          box.setName("spike");
          box.setStatic(true);
          box.setNoFill();
          box.setNoStroke();
          box.setPosition(x*gridSize, y*gridSize + hitboxHeight/2);
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
          FBridge bridge = new FBridge(x*gridSize, y*gridSize, BRIDGE);
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
          world.add(lava.getVisual());
          terrain.add(lava);
        }
        else if (c == ONEWAY_COLOR) {
          color leftColor = x > 0 ? mapImg.get(x-1, y) : 0;
          boolean leftIsOneway = leftColor == ONEWAY_COLOR;

          PImage platformTexture = leftIsOneway ? ONEWAY_RIGHT : ONEWAY_LEFT;

          FOneWayPlatform platform = new FOneWayPlatform(x*gridSize, y*gridSize, platformTexture);
          platform.setStatic(true);
          platform.setStroke(0,0,0,0);
          platform.setGrabbable(false);
          world.add(platform);
          terrain.add(platform);
        }
        else if (c == BUTTON_COLOR) {
          FButton button = new FButton(x*gridSize, y*gridSize);
          button.setStatic(true);
          button.setStroke(0,0,0,0);
          button.setGrabbable(false);
          world.add(button);
          terrain.add(button);

          if (y > 0) {
            color codeColor = mapImg.get(x, y - 1);
            buttonsByCode.put(codeColor, button);
          }
        }
        else if (c == CUBE_COLOR) {
          FBox cube = new FBox(gridSize, gridSize);
          cube.setPosition(x*gridSize, y*gridSize);
          cube.attachImage(CUBE_IMG);
          cube.setStroke(0,0,0,0);
          cube.setDensity(0.5);
          cube.setFriction(0.5);
          cube.setGrabbable(false);
          cube.setRotatable(false);
          cube.setName("cube");
          world.add(cube);
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

  // Second pass to create doors
  for (int y = 0; y < mapImg.height; y++) {
    for (int x = 0; x < mapImg.width; x++) {
      color c = mapImg.get(x, y);

      if (c == DOOR_COLOR) {
        boolean isTopOfDoor = y == 0 || mapImg.get(x, y - 1) != DOOR_COLOR;
        if (!isTopOfDoor) continue;

        color leftColor = x > 0 ? mapImg.get(x - 1, y) : 0;
        color rightColor = x < mapImg.width - 1 ? mapImg.get(x + 1, y) : 0;

        boolean isLeft = false;
        color codeColor = 0;

        if (leftColor != DOOR_COLOR && leftColor != 0 && alpha(leftColor) > 0) {
          isLeft = true;
          codeColor = leftColor;
        }
        else if (rightColor != DOOR_COLOR && rightColor != 0 && alpha(rightColor) > 0) {
          isLeft = false;
          codeColor = rightColor;
        }

        FButton button = buttonsByCode.get(codeColor);
        if (button != null) {
          FDoor door = new FDoor(x * gridSize, y * gridSize, button, isLeft);
          door.setStatic(true);
          door.setStroke(0, 0, 0, 0);
          door.setGrabbable(false);
          world.add(door);
          doors.add(door);
        }
      }
    }
  }

  ground.setStatic(true);
  ground.setName("ground");
  world.add(ground);

  // spawn player
  player = new FPlayer((int)spawnPos.x, (int)spawnPos.y);
  world.add(player);
  world.add(player.getFootSensor());
}

void draw() {
  // println(frameRate);
  drawBackground();

  for (FGameObject gameObject : terrain) {
    gameObject.update();
  }
  for (FGameObject gameObject : enemies) {
    gameObject.update();
  }
  for (FDoor door : doors) {
    door.update();
  }
  player.update();

  if (isRecording) {
    recordedPositions.add(new PVector(player.getX(), player.getY()));
    if (frameCount - recordStartFrame >= RECORD_DURATION) {
      stopRecording();
    }
  }

  if (ghost != null) {
    ghost.update();
    if (ghost.isFinished()) {
      world.remove(ghost);
      ghost = null;
    }
  }

  world.step();

  float levelWidth = mapImg.width * gridSize;
  float levelHeight = mapImg.height * gridSize;
  float viewWidth = width / zoom;
  float viewHeight = height / zoom;
  float camX = constrain(player.getX(), viewWidth/2, levelWidth - viewWidth/2) - gridSize/2;
  float camY = constrain(player.getY(), viewHeight/2, levelHeight - viewHeight/2) - gridSize/2;

  pushMatrix();
  scale(zoom);
  translate(-camX + viewWidth/2, -camY + viewHeight/2);

  world.draw();
  // world.drawDebug();

  popMatrix();

  drawUI();
}

private void drawUI() {
  float barWidth = 200;
  float barHeight = 20;
  float x = width - barWidth - 20;
  float y = 20;

  fill(40);
  noStroke();
  rect(x, y, barWidth, barHeight);

  if (isRecording) {
    // recording bar
    float progress = map(frameCount - recordStartFrame, 0, RECORD_DURATION, 0, 1);
    progress = 1 - progress;
    fill(255, 70, 70);
    rect(x, y, barWidth * progress, barHeight);
  } else if (ghost != null && !ghost.isFinished()) {
    // playback bar
    float progress = map(ghost.getPlaybackIndex(), 0, ghost.getPositionCount(), 0, 1);
    progress = 1 - progress;

    fill(70, 150, 255);
    rect(x, y, barWidth * progress, barHeight);
  }
}

void drawBackground() {
  int tileSize = BG_IMG.width;
  int tilesX = (width / tileSize) + 2;
  int tilesY = (height / tileSize) + 2;

  for (int ty = -tileSize/2; ty < tilesY*2; ty++) {
    for (int tx = -tileSize/2; tx < tilesX*2; tx++) {
      image(BG_IMG, tx * tileSize/2, ty * tileSize/2);
    }
  }
}

void keyPressed() {
  if (key == 'W' || key =='w') wDown = true;
  if (key == 'A' || key =='a') aDown = true;
  if (key == 'S' || key =='s') sDown = true;
  if (key == 'D' || key =='d') dDown = true;

  if (key == 'R' || key == 'r') {
    if (isRecording) {
      stopRecording();
    } else {
      startRecording();
    }
  }

  if (key == 'P' || key == 'p') {
    if(isRecording) stopRecording();
    spawnGhost();
  }
}

void startRecording() {
  recordedPositions.clear();
  isRecording = true;
  recordStartFrame = frameCount;
}

void stopRecording() {
  isRecording = false;
  player.setPosition(recordedPositions.get(0).x, recordedPositions.get(0).y);
}

void spawnGhost() {
  if (recordedPositions.size() == 0) return;

  if (ghost != null) {
    world.remove(ghost);
  }
  ghost = new FGhost(recordedPositions);
  world.add(ghost);
}

void keyReleased() {
  if (key == 'W' || key =='w') wDown = false;
  if (key == 'A' || key =='a') aDown = false;
  if (key == 'S' || key =='s') sDown = false;
  if (key == 'D' || key =='d') dDown = false;
}

boolean isTileType(int x, int y, color clr) {
  // Blocks outside the map are counted as ground center tiles
  if (x < 0 || x >= mapImg.width || y < 0 || y >= mapImg.height) {
    if (clr == GROUND_COLOR) return true;
  }
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

PImage makeGhostImage(PImage src) {
  PImage out = src.copy();
  out.loadPixels();

  for (int i = 0; i < out.pixels.length; i++) {
    color c = out.pixels[i];

    float r = red(c);
    float g = green(c);
    float b = blue(c);
    float a = alpha(c);

    // desaturate
    float gray = (r + g + b) / 3;
    r = lerp(r, gray, 0.7);
    g = lerp(g, gray, 0.7);
    b = lerp(b, gray, 0.7);

    // Blue tint
    // b = min(255, b + 30);

    a *= 0.5;

    out.pixels[i] = color(r, g, b, a);
  }

  out.updatePixels();
  return out;
}
