import fisica.*;

// TODOs:
// A racket
// Mode framework

int scene = 0;
final int INTRO_SCENE = 0;
final int GAME_SCENE = 1;
final int GAME_OVER_SCENE = 2;

boolean won = false;

void setup() {
  frameRate(80);
  size(1200, 800);

  introSetup();
}

void draw() {
  switch(scene) {
    case INTRO_SCENE:
      introDraw();
      break;
    case GAME_SCENE:
      gameDraw();
      break;
    case GAME_OVER_SCENE:
      gameOverDraw();
      break;
  }
}

void switchScene(int newScene) {
  scene = newScene;
  
  switch(newScene) {
    case INTRO_SCENE:
      introSetup();
      break;
    case GAME_SCENE:
      gameSetup();
      break;
    case GAME_OVER_SCENE:
      gameOverSetup();
      break;
  }
}
void gameOver(boolean won) {
  this.won = won;
  switchScene(GAME_OVER_SCENE);
}

void keyPressed() {
  switch(scene) {
    case INTRO_SCENE:
      break;
    case GAME_SCENE:
      gameSceneKeyPressed();
      break;
    case GAME_OVER_SCENE:
      break;
  }
}
void keyReleased() {
  switch(scene) {
    case INTRO_SCENE:
      break;
    case GAME_SCENE:
      gameSceneKeyReleased();
      break;
    case GAME_OVER_SCENE:
      break;
  }
}

void mousePressed() {
  switch(scene) {
    case INTRO_SCENE:
      introSceneMousePressed();
      break;
    case GAME_SCENE:
      break;
    case GAME_OVER_SCENE:
      gameOverSceneMousePressed();
      break;
  }
}
void mouseReleased() {
  switch(scene) {
    case INTRO_SCENE:
      introSceneMouseReleased();
      break;
    case GAME_SCENE:
      break;
    case GAME_OVER_SCENE:
      gameOverSceneMouseReleased();
      break;
  }
}
