
final int INTRO_SCENE = 0;
final int GAME_SCENE = 1;
final int GAMEOVER_SCENE = 2;

int scene = INTRO_SCENE;

void setup() {
  size(1200, 800);
  
  introSceneSetup();
  gameSceneSetup();
  gameOverSceneSetup();
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

void keyPressed() {
  gameSceneKeyPressed();
}
