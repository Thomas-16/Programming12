
final int INTRO_SCENE = 0;
final int GAME_SCENE = 1;
final int GAMEOVER_SCENE = 2;

int scene = 0;

void setup() {
  size(1200, 800);
  
  introSceneSetup();
}

void draw() {
  switch(scene) {
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

void switchScene(int newScene) {
  scene = newScene;
  
  switch(scene) {
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

void keyPressed() {
  if(scene == GAME_SCENE)
    gameSceneKeyPressed();
}

void mousePressed() {
  switch(scene) {
    case INTRO_SCENE:
      introMousePressed();
      break;
    case GAME_SCENE:
      break;
    case GAMEOVER_SCENE:
      gameoverMousePressed();
      break;
  }
}

void mouseReleased() {
  switch(scene) {
    case INTRO_SCENE:
      introMouseReleased();
      break;
    case GAME_SCENE:
      break;
    case GAMEOVER_SCENE:
      gameoverMouseReleased();
      break;
  }
}
