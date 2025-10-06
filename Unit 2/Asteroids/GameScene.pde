
// input
boolean leftDown, rightDown, upDown, downDown;
boolean spaceDown;

// Game objects
Spaceship player;

ArrayList<GameObject> gameObjects;


int lastShotTime;



void gameSetup() {
  gameObjects = new ArrayList<GameObject>();
  
  player = new Spaceship(width/2, height/2);
  gameObjects.add(player);
  
}

void gameDraw() {
  
  handleInput();
  
  pruneGameObjects();
  updateGameObjects();
  drawGameObjects();
}

void handleInput() {
  if(spaceDown && millis() - lastShotTime > 1000)  {
    gameObjects.add(new Bullet(player.pos, player.dir));
    lastShotTime = millis();
  }
}

void pruneGameObjects() {
  for(int i = 0; i < gameObjects.size(); i++) {
    if(gameObjects.get(i).shouldBeDeleted) {
      gameObjects.remove(i);
      i--;
    }
  }
}
void updateGameObjects() {
  for(GameObject gameObj : gameObjects) {
    gameObj.update();
  }
}
void drawGameObjects() {
  for(GameObject gameObj : gameObjects) {
    gameObj.draw();
  }
}

void gameSceneKeyPressed() {
  if(keyCode == LEFT) leftDown = true;
  if(keyCode == RIGHT) rightDown = true;
  if(keyCode == UP) upDown = true;
  if(keyCode == DOWN) downDown = true;
  if(key == ' ') spaceDown = true;
}

void gameSceneKeyReleased() {
  if(keyCode == LEFT) leftDown = false;
  if(keyCode == RIGHT) rightDown = false;
  if(keyCode == UP) upDown = false;
  if(keyCode == DOWN) downDown = false;
  if(key == ' ') spaceDown = false;
}
