color btnFill = color(20, 35, 70, 220);
color btnOutline = color(0, 180, 220);
color btnHoverOutline = color(120, 220, 255);
color btnClickFill = color(0, 100, 140);
int btnOutlineW = 3;
int btnCornerRadius = 6;

int introButtonW = 140;
int introButtonH = 50;
int introButtonGap = 30;
int introButtonY;

RectButton[] levelButtons;

void introSceneSetup() {
  introButtonY = height / 2 + 100;

  int totalRowWidth = introButtonW * totalLevels + introButtonGap * (totalLevels - 1);
  int startX = (width - totalRowWidth) / 2 + introButtonW / 2;

  levelButtons = new RectButton[totalLevels];
  for (int i = 0; i < totalLevels; i++) {
    int xPos = startX + i * (introButtonW + introButtonGap);
    levelButtons[i] = new RectButton(xPos, introButtonY, introButtonW, introButtonH,
      btnFill, btnOutline, btnHoverOutline, btnClickFill, btnOutlineW, btnCornerRadius);
  }

  for (int i = 0; i < levelButtons.length; i++) {
    final int level = i;
    levelButtons[i].setOnClick(() -> {
      loadScene(GAME_SCENE);
      loadLevel(level + 1);
    });
  }
}

void introSceneDraw() {
  drawBackground();

  textAlign(CENTER);

  textSize(92);
  fill(0, 180, 220, 30);
  text("PLATFORMER GAME", width/2, height/2 - 120);
  fill(0, 180, 220, 60);
  text("PLATFORMER GAME", width/2, height/2 - 120);

  textSize(90);
  fill(255);
  text("PLATFORMER GAME", width/2, height/2 - 120);

  textSize(24);
  fill(150, 200, 220);
  text("Select a level to begin", width/2, height/2 - 40);

  for (RectButton button : levelButtons) {
    button.draw();
  }

  int totalRowWidth = introButtonW * totalLevels + introButtonGap * (totalLevels - 1);
  int startX = (width - totalRowWidth) / 2 + introButtonW / 2;
  for (int i = 0; i < totalLevels; i++) {
    int xPos = startX + i * (introButtonW + introButtonGap);
    textAlign(CENTER, CENTER);
    textSize(22);
    fill(255);
    text("Level " + (i + 1), xPos, introButtonY);
  }
}

void introSceneMousePressed() {
  for (RectButton button : levelButtons) {
    button.mousePressed();
  }
}

void introSceneMouseReleased() {
  for (RectButton button : levelButtons) {
    button.mouseReleased();
  }
}

void introSceneKeyPressed() {
}

void introSceneKeyReleased() {
}
