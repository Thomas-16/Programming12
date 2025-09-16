class Vector2Int {
  public int x, y;
  
  public Vector2Int(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public boolean equals(Vector2Int other) {
    return this.x == other.x && this.y == other.y;
  }
  
  public void add(Vector2Int other) {
    this.x += other.x;
    this.y += other.y;
  }
  
  public void add(int x, int y) {
    this.x += x;
    this.y += y;
  }
  
  public void sub(Vector2Int other) {
    this.x -= other.x;
    this.y -= other.y;
  }
  
  public void sub(int x, int y) {
    this.x -= x;
    this.y -= y;
  }
  
  public void mult(int value) {
    this.x *= value;
    this.y *= value;
  }
  
  public void div(int value) {
    this.x /= value;
    this.y /= value;
  }
  
  public float sqrMag() {
    return pow(x, 2) + pow(y, 2);
  }
  
  public float mag() {
    return sqrt(this.sqrMag());
  }
}
