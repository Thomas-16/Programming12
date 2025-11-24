
RectButton playButton;


void introSetup() {
  playButton = new RectButton(width/2, 550, 140, 80, color(255, 140, 0), color(255, 100, 0), color(255, 200, 100), color(200, 100, 0), 3, 8);
  playButton.setOnClick(() -> {
    switchScene(GAME_SCENE);
  });
}

void introDraw() {
  background(#faebd7);
  
  playButton.draw();
  
  fill(#7d4305);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("PLAY", width/2, 550);
  
  fill(#7d4305);
  textSize(80);
  text("DERPY TENNIS GAME", width/2, 250);
}


void introSceneMousePressed() {
  playButton.mousePressed();
}

void introSceneMouseReleased() {
  playButton.mouseReleased();
}
