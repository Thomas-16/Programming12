RectButton menuButton;

void gameOverSceneSetup() {
  int buttonY = height / 2 + 120;

  menuButton = new RectButton(width/2, buttonY, 180, 55,
    btnFill, btnOutline, btnHoverOutline, btnClickFill, btnOutlineW, btnCornerRadius);
  menuButton.setOnClick(() -> {
    loadScene(INTRO_SCENE);
  });
}

void gameOverSceneDraw() {
  drawBackground();

  textAlign(CENTER);

  textSize(82);
  fill(0, 180, 220, 30);
  text("YOU WIN!", width/2, height/2 - 100);
  fill(0, 180, 220, 60);
  text("YOU WIN!", width/2, height/2 - 100);

  textSize(80);
  fill(255);
  text("YOU WIN!", width/2, height/2 - 100);

  textSize(28);
  fill(150, 200, 220);
  text("You completed all levels!", width/2, height/2 - 20);

  menuButton.draw();

  int buttonY = height / 2 + 120;
  textAlign(CENTER, CENTER);
  textSize(22);
  fill(255);
  text("Main Menu", width/2, buttonY);
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
