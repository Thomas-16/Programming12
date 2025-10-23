
boolean won;

RectButton backButton;

void gameOverSetup() {
  backButton = new RectButton(width/2, 600, 390, 100, color(0), color(0), color(255), color(100, 100), 4, 2);
  backButton.setOnClick(() -> {
    switchScene(INTRO_SCENE);
  });
  
  
}

void gameOverDraw() {
  image(backgroundPG, 0, 0);
  
  // title text
  fill(255);
  textSize(85);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width/2, 290);
  
  // subtitle text
  String subTitleText;
  if(won) {
    fill(#3ecf65);
    subTitleText = "YOU WON!";
  } else {
    fill(#db2e2e);
    subTitleText = "YOU LOST!";
  }
  textSize(40);
  text(subTitleText, width/2, 420);
  
  // button
  pushStyle();
  tint(255);
  backButton.draw();
  popStyle();

  // button text
  fill(255);
  textSize(36);
  textAlign(CENTER, CENTER);
  text("BACK", width/2, 600);
  
}

void gameOverSceneMousePressed() {
  backButton.mousePressed();
}

void gameOverSceneMouseReleased() {
  backButton.mouseReleased();
}
