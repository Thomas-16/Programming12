import gifAnimation.*;


int winner = 0; // 1 is blue and 2 is red

Gif gameOverGif;

RectButton backButton;

void gameOverSceneSetup() {
  gameOverGif = new Gif(this, "game-over.gif");
  gameOverGif.loop();
  
  backButton = new RectButton(width/2, 600, 140, 80, #d18645, #e0a570, #966a42, #b8753b, 4, 8);
  
  backButton.setOnClick(() -> {
    switchScene(0);
  });
}

void gameOverSceneDraw() {
  background(bgColor);
  
  // winner text
  textAlign(CENTER, CENTER);
  noStroke();
  textSize(50);
  if(winner == 1) {
    fill(blueColor);
    text("BLUE WON", width/2, 500);
  } else {
    fill(redColor);
    text("RED WON", width/2, 500);
  }
  
  // gif
  imageMode(CENTER);
  pushMatrix();
  translate(width/2, 300);
  scale(3);
  image(gameOverGif, 0, 0);
  popMatrix();
  
  backButton.draw();
  
  // back button
  textFont(font);
  strokeWeight(7);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("BACK", width/2, 600);
}

void gameoverMousePressed() {
  backButton.mousePressed();
}
void gameoverMouseReleased() {
  backButton.mouseReleased();
}
