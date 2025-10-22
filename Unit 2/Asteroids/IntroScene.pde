
PGraphics backgroundPG;

RectButton playButton;

void introSetup() {
  playButton = new RectButton(width/2, 600, 380, 100, color(0), color(0), color(255), color(100, 100), 4, 2);
  
  backgroundPG = createGraphics(width, height);
  backgroundPG.beginDraw();
  backgroundPG.background(0, 0, 0);
  
  // stars
  for (int i = 0; i < 3000; i++) {
    float x = random(width);
    float y = random(height);
    float alpha = random(60, 180);
    float size = random(0.6, 2.8);
    
    color c = color(255, 245, 220);
    backgroundPG.noStroke();
    if (random(100) < 8) {
      backgroundPG.fill(c, alpha*2);
      backgroundPG.ellipse(x, y, size*1.5, size*1.5);
    } else {
      backgroundPG.fill(c, alpha);
      backgroundPG.ellipse(x, y, size, size);
    }
  }
  
  backgroundPG.endDraw();
  backgroundPG.filter(BLUR, 0.8);
}

void introDraw() {
  image(backgroundPG, 0, 0);
  
  // title text PG
  //fill(0);
  //noStroke();
  //rectMode(CENTER);
  //rect(width/2, 300, 1000, 180);
  
  // title text
  fill(255);
  textSize(85);
  textAlign(CENTER, CENTER);
  text("ASTEROIDS", width/2, 300);
  
  // button and button text
  playButton.draw();
  
  fill(255);
  textSize(36);
  textAlign(CENTER, CENTER);
  text("PLAY", width/2, 600);
}

void introSceneMousePressed() {
  playButton.mousePressed();
}

void introSceneMouseReleased() {
  playButton.mouseReleased();
}
