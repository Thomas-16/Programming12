
int scene = 0;
final int INTRO_SCENE = 0;
final int GAME_SCENE = 1;
final int GAME_OVER_SCENE = 2;

void setup() {
  size(1200, 900, P2D);
  
  gameOverSetup();
  gameSetup();
  introSetup();
}

void draw() {
  background(0);
  
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
