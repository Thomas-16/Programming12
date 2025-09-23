import processing.sound.*;

RectButton playButton;
PFont font;

SoundFile introMusic;

void introSceneSetup() {
  frameRate(60);
  playButton = new RectButton(width/2, 600, 140, 80, #d18645, #e0a570, #966a42, #b8753b, 4, 8);
  
  playButton.setOnClick(() -> {
    introMusic.stop();
    switchScene(1);
  });
  
  font = createFont("Heavitas.ttf", 40);
  
  introMusic = new SoundFile(this, "MUSIC.mp3");
  introMusic.loop();
}

void introSceneDraw() {
  background(bgColor);

  playButton.draw();
  
  // play button
  textFont(font);
  strokeWeight(7);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("PLAY", width/2, 600);
  
  // title text shadow
  fill(0,0,0, 80);
  textSize(200);
  text("SNAKE", width/2+5, 230+5);
  
  // title text
  fill(#a1601f);
  textSize(200);
  text("SNAKE", width/2, 230);
}

void introMousePressed() {
  playButton.mousePressed();
}
void introMouseReleased() {
  playButton.mouseReleased();
}
