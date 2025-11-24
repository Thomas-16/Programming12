
RectButton backButton;

void gameOverSetup() {
  backButton = new RectButton(width/2, 550, 140, 80, color(255, 140, 0), color(255, 100, 0), color(255, 200, 100), color(200, 100, 0), 3, 8);
  backButton.setOnClick(() -> {
    switchScene(INTRO_SCENE);
  });
}

void gameOverDraw() {
  background(#faebd7);
  
  backButton.draw();
  
  fill(#7d4305);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("BACK", width/2, 550);
  
  textSize(80);
  text("GAME OVER", width/2, 250);
  
  textSize(60);
  if(player1Won) {
    fill(#2176ff);
    text("BLUE WON", width/2, 330);
  } else {
    fill(#ff2521);
    text("RED WON", width/2, 330);
  }
}


void gameOverSceneMousePressed() {
  backButton.mousePressed();
}
void gameOverSceneMouseReleased() {
  backButton.mouseReleased();
}
