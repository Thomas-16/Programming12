class Vector2Int {
  int x, y;
  
  public Vector2Int(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public boolean equals(Vector2Int other) {
    return this.x == other.x && this.y == other.y;
  }
  
  public float sqrMag() {
    return pow(x, 2) + pow(y, 2);
  }
  
  public float mag() {
    return sqrt(this.sqrMag());
  }
}
