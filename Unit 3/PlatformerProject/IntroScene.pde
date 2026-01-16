
int introButtonW = 150;
int introButtonH = 50;
int introButtonGap = 50;
int introButtonY = 600;

color introFillCol = color(70, 180, 140);
color introOutlineCol = color(30, 90, 70);
color introHoverOutlineCol = color(255, 220, 0);
color introClickFillCol = color(40, 140, 110);
int introOutlineW = 4;
int introCornerRadius = 8;

RectButton[] levelButtons;

void introSceneSetup() {
  int totalRowWidth = introButtonW * totalLevels + introButtonGap * (totalLevels - 1);
  int startX = (width - totalRowWidth) / 2;

  levelButtons = new RectButton[totalLevels];
  for (int i = 0; i < totalLevels; i++) {
    int xPos = startX + i * (introButtonW + introButtonGap);
    levelButtons[i] = new RectButton(xPos, introButtonY, introButtonW, introButtonH,
      introFillCol, introOutlineCol, introHoverOutlineCol, introClickFillCol, introOutlineW, introCornerRadius);
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
  // background(50);
  drawBackground();

  textAlign(CENTER);
  textSize(80);
  fill(255);
  text("Platformer Game", width/2, 200);

  for (RectButton button : levelButtons) {
    button.draw();
  }

  int totalRowWidth = introButtonW * totalLevels + introButtonGap * (totalLevels - 1);
  int startX = (width - totalRowWidth) / 2;
  for (int i = 0; i < totalLevels; i++) {
    int xPos = startX + i * (introButtonW + introButtonGap);
    textAlign(CENTER, CENTER);
    textSize(30);
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
