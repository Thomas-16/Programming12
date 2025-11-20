import fisica.*;

// TODOs:
// Borders
// Collisions - double bounce
// A racket


FWorld world;

FPlayer player1, player2;
FCircle ball;
FBox net;
FBox floor;

PImage ballImg, heartImg;

int playerMovingVel = 375;

boolean wPressed, aPressed, dPressed;
boolean upPressed, leftPressed, rightPressed;

FPlayer lastTouchedBallPlayer;

int lives1, lives2;

void setup() {
  size(1200, 800);
  
  lives1 = 3;
  lives2 = 3;
  
  ballImg = loadImage("ball.png");
  ballImg.resize(35, 35);
  
  heartImg = loadImage("heart.png");
  heartImg.resize(40, 40);

  Fisica.init(this);

  setupWorld();
}

void setupWorld() {
  world = new FWorld();
  world.setGravity(0, 900);
  world.setEdges(color(0,0,0,0));

  // Floor
  floor = new FBox(width, 80);
  floor.setPosition(width/2, height);
  floor.setStatic(true);
  floor.setFill(100, 200, 100);
  floor.setFriction(1);
  world.add(floor);

  // net
  net = new FBox(10, 150);
  net.setPosition(width/2, height - 115);
  net.setStatic(true);
  net.setFill(255, 255, 255);
  world.add(net);

  // Player 1 (left side)
  player1 = new FPlayer(200, 600, 60, 80);
  world.add(player1);
  world.add(player1.racket);

  // Player 2 (right side)
  player2 = new FPlayer(1000, 600, 60, 80);
  player2.facingLeft = true;
  world.add(player2);
  world.add(player2.racket);

  spawnBall();
}

void spawnBall() {
  if (ball != null) {
    world.remove(ball);
  }

  ball = new FCircle(35);
  ball.setPosition(width/2, 200);
  ball.setFill(255, 255, 0);
  ball.setRestitution(1);
  ball.setDensity(0.8);
  
  float random = random(1);
  
  if(random > 0.5) {
    ball.setVelocity(200, 0);
    lastTouchedBallPlayer = player1;
  } else {
    ball.setVelocity(-200, 0);
    lastTouchedBallPlayer = player2;
  }
  
  ball.attachImage(ballImg);
  world.add(ball);
}

void draw() {
  background(135, 206, 235);

  // Handle continuous movement
  if (aPressed) {
    player1.setVelocity(-playerMovingVel, player1.getVelocityY());
  } else if (dPressed) {
    player1.setVelocity(playerMovingVel, player1.getVelocityY());
  } else {
    player1.setVelocity(0, player1.getVelocityY());
  }

  if (leftPressed) {
    player2.setVelocity(-playerMovingVel, player2.getVelocityY());
  } else if (rightPressed) {
    player2.setVelocity(playerMovingVel, player2.getVelocityY());
  } else {
    player2.setVelocity(0, player2.getVelocityY());
  }

  player1.update();
  player2.update();

  checkBallHit(player1);
  checkBallHit(player2);
  
  checkCollisions();

  // Respawn ball if it falls off screen
  if (ball.getY() > height + 100) {
    spawnBall();
  }

  world.step();
  world.draw();
  
  drawUI();
  imageMode(CORNER);
}

void drawUI() {
  imageMode(CENTER);
  
  // player 1 lives
  pushMatrix();
  translate(35, 35);

  for(int i = 0; i < lives1; i++) {
    pushMatrix();
    translate(i * 55, 0);

    fill(0);
    stroke(255);
    strokeWeight(3);
    image(heartImg, 0, 0);
    strokeWeight(1);

    popMatrix();
  }
  
  popMatrix();
  
  // player 2 lives
  pushMatrix();
  translate(width-35, 35);

  for(int i = lives2-1; i >= 0 ; i--) {
    pushMatrix();
    translate(-i * 55, 0);

    fill(0);
    stroke(255);
    strokeWeight(3);
    image(heartImg, 0, 0);
    strokeWeight(1);

    popMatrix();
  }
  
  popMatrix();
}

void checkBallHit(FPlayer player) {
  if (player.swinging) {
    if (player.racket.isTouchingBody(ball)) {
      float direction = player.facingLeft ? -1 : 1;

      float velocityX = direction * 500 + random(-50, 50) + (player.getVelocityX() / 3f);
      float velocityY = -700 + random(-50, 50) + (player.getVelocityY() / 3f);

      ball.setVelocity(velocityX, velocityY);

      player.swinging = false;
    }
  }
}

void checkCollisions() {
  if(ball.isTouchingBody(net)) {
    loseLife(lastTouchedBallPlayer == player1 ? 1 : 2);
  }
  
  if(ball.isTouchingBody(player1)) {
    loseLife(1);
  }
  if(ball.isTouchingBody(player2)) {
    loseLife(2);
  }
}

void loseLife(int player) {
  if(player == 1) {
    lives1--;
  } else {
    lives2--;
  }

  if (lives1 == 0 || lives2 == 0) {
    // gameOver();
    return;
  }
  spawnBall();
}

void keyPressed() {
  // Player 1 controls (WASD + Space)
  if (key == 'w' || key == 'W') {
    player1.jump();
  }
  if (key == ' ') {
    player1.swing();
  }
  if (key == 'a' || key == 'A') {
    aPressed = true;
  }
  if (key == 'd' || key == 'D') {
    dPressed = true;
  }

  // Player 2 controls (Arrow keys + Enter)
  if (keyCode == UP) {
    player2.jump();
  }
  if (keyCode == ENTER || keyCode == RETURN) {
    player2.swing();
  }
  if (keyCode == LEFT) {
    leftPressed = true;
  }
  if (keyCode == RIGHT) {
    rightPressed = true;
  }

  // Respawn ball with R
  if (key == 'r' || key == 'R') {
    spawnBall();
  }
}

void keyReleased() {
  // Player 1
  if (key == 'a' || key == 'A') {
    aPressed = false;
  }
  if (key == 'd' || key == 'D') {
    dPressed = false;
  }

  // Player 2
  if (keyCode == LEFT) {
    leftPressed = false;
  }
  if (keyCode == RIGHT) {
    rightPressed = false;
  }
}
