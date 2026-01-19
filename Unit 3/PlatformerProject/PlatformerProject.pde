import fisica.*;

// https://nicopardo.itch.io/cyberlab
// https://nicopardo.itch.io/cyberlab-expansion-pack-1

final int INTRO_SCENE = 0;
final int GAME_SCENE = 1;
final int GAMEOVER_SCENE = 2;
int scene = INTRO_SCENE;

int totalLevels = 4;

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
color DOOR_INVERTED_COLOR = #b5a5d5;
color STAR_COLOR = #6f3198;

PImage BG_IMG;
PImage BUTTON_IMG, BUTTON_DOWN_IMG;
PImage CUBE_IMG;
PImage[] DOOR_LEFT_IMGS;
PImage[] DOOR_RIGHT_IMGS;
PImage[] STAR_IMGS;

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

PFont font;

FWorld world;

FPlayer player;
ArrayList<FGameObject> terrain;
ArrayList<FGameObject> enemies;
ArrayList<FDoor> doors;

int gridSize = 64;

float zoom = 1.2;

PVector spawnPos = new PVector(0, 0);

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
  recordedPositions = new ArrayList<PVector>();

  loadAssets();

  Fisica.init(this);

  loadScene(scene);
}

void loadAssets() {
  font = createFont("ARCADECLASSIC.TTF", 40);
  textFont(font);

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
    PImage img = loadImage("CyberLab_ExPack1/Animations/MainCharacter/hit00" + i + ".png");
    hitRightImgs[i] = scaleImage(img, img.width * scaleFactor, img.height * scaleFactor);
    hitLeftImgs[i] = scaleImage(reverseImage(img), img.width * scaleFactor, img.height * scaleFactor);
  }

  goombaImgs = new PImage[] {
    scaleImage(loadImage("Enemies/goomba0.png"), gridSize, gridSize),
    scaleImage(loadImage("Enemies/goomba1.png"), gridSize, gridSize)
  };

  hammerBroRightImgs = new PImage[] {
    scaleImage(loadImage("Enemies/hammerbro0.png"), gridSize, gridSize),
    scaleImage(loadImage("Enemies/hammerbro1.png"), gridSize, gridSize)
  };
  hammerBroLeftImgs = new PImage[] {
    scaleImage(reverseImage(loadImage("Enemies/hammerbro0.png")), gridSize, gridSize),
    scaleImage(reverseImage(loadImage("Enemies/hammerbro1.png")), gridSize, gridSize)
  };
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
  CUBE_IMG = scaleImage(loadImage("cube.png"), gridSize * 3/4, gridSize * 3/4);

  DOOR_LEFT_IMGS = new PImage[4];
  DOOR_RIGHT_IMGS = new PImage[4];
  for (int i = 0; i < 4; i++) {
    DOOR_LEFT_IMGS[i] = scaleImage(loadImage("door/door" + (i + 1) + ".png"), gridSize, gridSize * 2);
    DOOR_RIGHT_IMGS[i] = scaleImage(reverseImage(loadImage("door/door" + (i + 1) + ".png")), gridSize, gridSize * 2);
  }

  STAR_IMGS = new PImage[13];
  for (int i = 0; i < 13; i++) {
    STAR_IMGS[i] = scaleImage(loadImage("star/star" + (i + 1) + ".png"), gridSize * 6/4, gridSize * 6/4);
  }

  LAVA_IMGS = new PImage[6];
  for (int i = 0; i < 6; i++) {
    LAVA_IMGS[i] = scaleImage(loadImage("OGTerrain/lava" + i + ".png"), gridSize, gridSize);
  }
}

void loadScene(int newScene) {
  scene = newScene;

  switch (scene) {
    case INTRO_SCENE:
      introSceneSetup();
      break;
    case GAME_SCENE:
      gameSceneSetup();
      break;
    case GAMEOVER_SCENE:
      gameOverSceneSetup();
      break;
  }
}

void draw() {
  switch (scene) {
    case INTRO_SCENE:
      introSceneDraw();
      break;
    case GAME_SCENE:
      gameSceneDraw();
      break;
    case GAMEOVER_SCENE:
      gameOverSceneDraw();
      break;
  }
}

void keyPressed() {
  switch (scene) {
    case INTRO_SCENE:
      introSceneKeyPressed();
      break;
    case GAME_SCENE:
      gameSceneKeyPressed();
      break;
    case GAMEOVER_SCENE:
      gameOverSceneKeyPressed();
      break;
  }
}

void keyReleased() {
  switch (scene) {
    case INTRO_SCENE:
      introSceneKeyReleased();
      break;
    case GAME_SCENE:
      gameSceneKeyReleased();
      break;
    case GAMEOVER_SCENE:
      gameOverSceneKeyReleased();
      break;
  }
}

void mousePressed() {
  switch (scene) {
    case INTRO_SCENE:
      introSceneMousePressed();
      break;
    case GAME_SCENE:
      gameSceneMousePressed();
      break;
    case GAMEOVER_SCENE:
      gameOverSceneMousePressed();
      break;
  }
}

void mouseReleased() {
  switch (scene) {
    case INTRO_SCENE:
      introSceneMouseReleased();
      break;
    case GAME_SCENE:
      gameSceneMouseReleased();
      break;
    case GAMEOVER_SCENE:
      gameOverSceneMouseReleased();
      break;
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

void startRecording() {
  recordedPositions.clear();
  isRecording = true;
  recordStartFrame = frameCount;
}

void stopRecording() {
  isRecording = false;
  if (recordedPositions.size() > 0) {
    player.setPosition(recordedPositions.get(0).x, recordedPositions.get(0).y);
  }
}

void spawnGhost() {
  if (recordedPositions.size() == 0) return;

  if (ghost != null) {
    world.remove(ghost);
  }
  ghost = new FGhost(recordedPositions);
  world.add(ghost);
}

boolean isTileType(int x, int y, color clr) {
  if (x < 0 || x >= mapImg.width || y < 0 || y >= mapImg.height) {
    if (clr == GROUND_COLOR) return true;
  }
  if (x < 0 || x >= mapImg.width || y < 0 || y >= mapImg.height) return false;
  return mapImg.get(x, y) == clr;
}

boolean isWallTile(int x, int y) {
  return isTileType(x, y, GROUND_COLOR) || isTileType(x, y, SLIME_COLOR) ||
         isTileType(x, y, ICE_COLOR) || isTileType(x, y, BRIDGE_COLOR);
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

    float gray = (r + g + b) / 3;
    r = lerp(r, gray, 0.7);
    g = lerp(g, gray, 0.7);
    b = lerp(b, gray, 0.7);

    a *= 0.5;

    out.pixels[i] = color(r, g, b, a);
  }

  out.updatePixels();
  return out;
}
