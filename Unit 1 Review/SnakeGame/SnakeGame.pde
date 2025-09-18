color blueColor = #2170d9;
color redColor = #e3442b;

int gridSize = 50;

Snake blueSnake, redSnake;
Vector2Int foodPos;

int frames;

void setup() {
  frames = 0;
  size(1200, 800);
  
  blueSnake = new Snake(true);
  redSnake = new Snake(false);
}

void draw() {
  background(#d9bc93);
  
  handleInput();
  
  if(frames % 6 == 0)
    update();
    
  drawSnakes();
  
  frames++;
}

void handleInput() {
  if(keyPressed) {
    if(key == 'w' || key == 'W') blueSnake.changeDir(Dir.UP);
    if(key == 'a' || key == 'A') blueSnake.changeDir(Dir.LEFT);
    if(key == 's' || key == 'S') blueSnake.changeDir(Dir.DOWN);
    if(key == 'd' || key == 'D') blueSnake.changeDir(Dir.RIGHT);
    
    if(keyCode == UP) redSnake.changeDir(Dir.UP);
    if(keyCode == DOWN) redSnake.changeDir(Dir.DOWN);
    if(keyCode == LEFT) redSnake.changeDir(Dir.LEFT);
    if(keyCode == RIGHT) redSnake.changeDir(Dir.RIGHT);
    
  }
}

void update() {
  blueSnake.move();
  redSnake.move();
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
