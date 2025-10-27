
boolean won;

RectButton backButton;

Gif winGif, loseGif;

void gameOverSetup() {
  backButton = new RectButton(width/2, 700, 390, 100, color(0), color(0), color(255), color(100, 100), 4, 2);
  backButton.setOnClick(() -> {
    switchScene(INTRO_SCENE);
  });
  
  winGif = new Gif("frame_", "_delay-0.1s.gif", width/2, height/2, 400, 300, 20, 1);
  loseGif = new Gif("frame_", "_delay-0.07s.gif", width/2, height/2, 400, 300, 27, 3);
  
}

void gameOverDraw() {
  imageMode(CORNER);
  image(backgroundPG, 0, 0);
  
  // title text
  fill(255);
  textSize(85);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width/2, 190);
  
  // button
  pushStyle();
  tint(255);
  backButton.draw();
  popStyle();

  // button text
  fill(255);
  textSize(36);
  textAlign(CENTER, CENTER);
  text("BACK", width/2, 700);
  
  // gif
  if(won)
    winGif.draw();
  else 
    loseGif.draw();
  
}

void gameOverSceneMousePressed() {
  backButton.mousePressed();
}

void gameOverSceneMouseReleased() {
  backButton.mouseReleased();
}
