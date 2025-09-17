public class Vector2Int {
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

Vector2Int add(Vector2Int one, Vector2Int other) {
  return new Vector2Int(one.x + other.x, one.y + other.y);
}

Vector2Int add(Vector2Int one, int x, int y) {
  return new Vector2Int(one.x + x, one.y + y);
}

Vector2Int sub(Vector2Int one, Vector2Int other) {
  return new Vector2Int(one.x - other.x, one.y - other.y);
}

Vector2Int sub(Vector2Int one, int x, int y) {
  return new Vector2Int(one.x - x, one.y - y);
}

Vector2Int mult(Vector2Int one, int value) {
  return new Vector2Int(one.x * value, one.y * value);
}

Vector2Int div(Vector2Int one, int value) {
  return new Vector2Int(one.x / value, one.y / value);
}

public Vector2Int vector2IntOne() { return new Vector2Int(1, 1); }
public Vector2Int vector2IntZero() { return new Vector2Int(0, 0); }
public Vector2Int vector2IntUp() { return new Vector2Int(0, -1); }
public Vector2Int vector2IntDown() { return new Vector2Int(0, 1); }
public Vector2Int vector2IntLeft() { return new Vector2Int(-1, 0); }
public Vector2Int vector2IntRight() { return new Vector2Int(1, 0); }
