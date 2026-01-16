int gameOverButtonW = 200;
int gameOverButtonH = 60;

color gameOverFillCol = color(70, 180, 140);
color gameOverOutlineCol = color(30, 90, 70);
color gameOverHoverOutlineCol = color(255, 220, 0);
color gameOverClickFillCol = color(40, 140, 110);
int gameOverOutlineW = 4;
int gameOverCornerRadius = 8;

RectButton menuButton;

void gameOverSceneSetup() {
  int buttonY = 500;

  menuButton = new RectButton(width/2, buttonY, gameOverButtonW, gameOverButtonH,
    gameOverFillCol, gameOverOutlineCol, gameOverHoverOutlineCol, gameOverClickFillCol, gameOverOutlineW, gameOverCornerRadius);
    menuButton.setOnClick(() -> {
      loadScene(INTRO_SCENE);
    });
}

void gameOverSceneDraw() {
  // background(30);
  drawBackground();

  textAlign(CENTER);
  textSize(100);
  fill(255);
  text("Congratulations!", width/2, 200);

  textSize(40);
  fill(200);
  text("You completed all levels!", width/2, 300);

  menuButton.draw();

  textAlign(CENTER, CENTER);
  textSize(24);
  fill(255);
  text("Main Menu", width/2, 500);
}

void gameOverSceneMousePressed() {
  menuButton.mousePressed();
}

void gameOverSceneMouseReleased() {
  menuButton.mouseReleased();
}

void gameOverSceneKeyPressed() {
}

void gameOverSceneKeyReleased() {
}
