color blueColor = #2170d9;
color redColor = #e3442b;

int gridSize = 50;

Snake blueSnake, redSnake;
Vector2Int foodPos;

void setup() {
  size(1200, 800);
  
  blueSnake = new Snake(true);
  redSnake = new Snake(false);
}

void draw() {
  background(#d9bc93);
  
  update();
  drawSnakes();
}

void update() {
  
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
