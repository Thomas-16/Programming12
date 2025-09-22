color blueColor = #2170d9;
color redColor = #e3442b;

color bgColor = #d9bc93;

int gridSize = 50;
int gridWidth, gridHeight;

Snake blueSnake, redSnake;
Vector2Int foodPos;
boolean foodExists;

PImage foodImg;

int frames;

void gameSceneSetup() {
  frames = 0;
  blueSnake = new Snake(true);
  redSnake = new Snake(false);
  
  gridWidth = width / gridSize;
  gridHeight = height / gridSize;
  
  foodImg = scaleImage(loadImage("apple.png"), gridSize, gridSize);
}

void gameSceneDraw() {
  background(bgColor);
  
  if(frames % 6 == 0)
    update();
    
    
  if(frames % 480 == 0 && !foodExists) {
    spawnFood();
  }
    
  drawSnakes();
  drawFood();
  
  frames++;
}

void update() {
  blueSnake.move();
  redSnake.move();
  
  // check collisions
  handleCollisions();
}

void drawSnakes() {
  rectMode(CORNER);
  noStroke();
  for(Vector2Int pos : blueSnake.getBody()) {
    fill(blueColor);
    rect(pos.x * gridSize, pos.y * gridSize, gridSize, gridSize);
  }
  
  for(Vector2Int pos : redSnake.getBody()) {
    fill(redColor);
    rect(pos.x * gridSize, pos.y * gridSize, gridSize, gridSize);
  }
}
void drawFood() {
  image(foodImg, foodPos.x * gridSize, foodPos.y * gridSize);
}

void spawnFood() {
  foodPos = new Vector2Int(int(random(0, gridWidth + 1)), int(random(0, gridHeight + 1)));
  while(arrayListContainsPos(blueSnake.getBody(), foodPos) || arrayListContainsPos(redSnake.getBody(), foodPos)) {
    foodPos = new Vector2Int(int(random(0, gridWidth + 1)), int(random(0, gridHeight + 1)));
  }
  foodExists = true;
}

void handleCollisions() {
  for(Vector2Int pos : blueSnake.getBody()) {
    // if a body pos of the blue snake is the same as the head pos of the red snake
    if(pos.equals(redSnake.getBody().get(0))) {
      // red lost
      winner = 1;
      switchScene(GAMEOVER_SCENE);
      return;
    }
  }
  for(Vector2Int pos : redSnake.getBody()) {
    // if a body pos of the red snake is the same as the head pos of the blue snake
    if(pos.equals(blueSnake.getBody().get(0))) {
      // blue lost
      winner = 2;
      switchScene(GAMEOVER_SCENE);
      return;
    }
  }
  
  for(int i = 1; i < blueSnake.getBody().size(); i++) {
    // if a body pos of the blue snake is the same as the head pos of itself
    if(blueSnake.getBody().get(i).equals(blueSnake.getBody().get(0))) {
      // blue lost
      winner = 2;
      switchScene(GAMEOVER_SCENE);
      return;
    }
  }
  for(int i = 1; i < redSnake.getBody().size(); i++) {
    // if a body pos of the red snake is the same as the head pos of itself
    if(redSnake.getBody().get(i).equals(redSnake.getBody().get(0))) {
      // red lost
      winner = 1;
      switchScene(GAMEOVER_SCENE);
      return;
    }
  }
}

void gameSceneKeyPressed() {
  if((key == 'w' || key == 'W') && canMoveInDir(blueSnake, Dir.UP)) blueSnake.changeDir(Dir.UP);
  if((key == 'a' || key == 'A') && canMoveInDir(blueSnake, Dir.LEFT)) blueSnake.changeDir(Dir.LEFT);
  if((key == 's' || key == 'S') && canMoveInDir(blueSnake, Dir.DOWN)) blueSnake.changeDir(Dir.DOWN);
  if((key == 'd' || key == 'D') && canMoveInDir(blueSnake, Dir.RIGHT)) blueSnake.changeDir(Dir.RIGHT);
  
  if(keyCode == UP && canMoveInDir(redSnake, Dir.UP)) redSnake.changeDir(Dir.UP);
  if(keyCode == DOWN && canMoveInDir(redSnake, Dir.DOWN)) redSnake.changeDir(Dir.DOWN);
  if(keyCode == LEFT && canMoveInDir(redSnake, Dir.LEFT)) redSnake.changeDir(Dir.LEFT);
  if(keyCode == RIGHT && canMoveInDir(redSnake, Dir.RIGHT)) redSnake.changeDir(Dir.RIGHT);
}

boolean canMoveInDir(Snake snake, Dir targetDir) {
  Vector2Int cantGoInDirVec = sub(snake.getBody().get(1), snake.getBody().get(0));
  Dir cantGoInDir = vectorToDir(cantGoInDirVec);
  
  return targetDir != cantGoInDir;
}

Dir vectorToDir(Vector2Int vec) {
  if(vec.equals(vector2IntUp())) {
    return Dir.UP;
  }
  else if(vec.equals(vector2IntDown())) {
    return Dir.DOWN;
  }
  else if(vec.equals(vector2IntLeft())) {
    return Dir.LEFT;
  }
  else if(vec.equals(vector2IntRight())) {
    return Dir.RIGHT;
  }
  else {
    return Dir.UP;
  }
}

boolean arrayListContainsPos(ArrayList<Vector2Int> list, Vector2Int pos) {
  for(Vector2Int p : list) {
    if(p.equals(pos)) return true;
  }
  return false;
}

PImage scaleImage(PImage src, int w, int h) {
  PImage out = createImage(w, h, ARGB);
  out.loadPixels();
  src.loadPixels();

  for (int y = 0; y < h; y++) {
    int sy = int(y * src.height / (float) h); 
    for (int x = 0; x < w; x++) {
      int sx = int(x * src.width / (float) w);
      out.pixels[y * w + x] = src.pixels[sy * src.width + sx];
    }
  }
  out.updatePixels();
  return out;
}
