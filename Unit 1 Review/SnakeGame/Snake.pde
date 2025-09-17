class Snake {
  private Vector2Int pos;
  private ArrayList<Vector2Int> body; // Arraylist of the snake body from head to end
  private Dir dir;
  
  public Snake(boolean isBlue) {
    this.body = new ArrayList<Vector2Int>();
    
    if(isBlue) {
      pos = new Vector2Int(3, 1);
      body.add(pos);
      body.add(add(pos, -1, 0));
      body.add(add(pos, -2, 0));
      dir = Dir.RIGHT;
    } else {
      pos = new Vector2Int(20, 14);
      body.add(pos);
      body.add(add(pos, 1, 0));
      body.add(add(pos, 2, 0));
      dir = Dir.LEFT;
    }
    
  }
  
  public void move() {
    Vector2Int moveDir = getDirVector(this.dir);
    
    // move head piece
    body.get(0).add(moveDir);
    
    // move end piece to the gap we just made
    Vector2Int end = body.get(body.size() - 1);
    end.x = body.get(0).x - moveDir.x;
    end.y = body.get(0).y - moveDir.y;
    
    // move it in the arraylist too
    body.remove(body.size() - 1);
    body.add(1, end);
  }
  
  public void changeDir(Dir dir) { this.dir = dir; }
  
  public ArrayList<Vector2Int> getBody() { return body; }
  
}


public Vector2Int getDirVector(Dir dir) {
  switch(dir) {
    case UP:
      return vector2IntUp();
    case DOWN:
      return vector2IntDown();
    case LEFT:
      return vector2IntLeft();
    case RIGHT:
      return vector2IntRight();
    default:
      return vector2IntZero();
  }
}
