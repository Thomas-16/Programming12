color blueColor = #2170d9;
color redColor = #e3442b;

int gridSize = 80;

// Grid 2d array for the game space
int[][] grid = new int[16][10];
// 0 means empty
// 1 means blue
// 2 means red

Snake redSnake, blueSnake;
Vector2Int foodPos;

void setup() {
  size(1280, 800);
}

void draw() {
  background(#d9bc93);
  
  update();
  drawSnake();
}

void update() {
  
}

void drawSnake() {
  
}
