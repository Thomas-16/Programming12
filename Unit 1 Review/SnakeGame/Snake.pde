class Snake {
  private Vector2Int pos;
  private ArrayList<Vector2Int> body; // Arraylist of the snake body from head to end
  private boolean isBlue;
  
  public Snake(boolean isBlue) {
    this.isBlue = isBlue;
    this.body = new ArrayList<Vector2Int>();
    
    if(isBlue) {
      pos = new Vector2Int(1, 3);
      body.add(pos);
      body.add(add(pos, -1, 0));
      body.add(add(pos, -2, 0));
    } else {
      pos = new Vector2Int(8, 12);
      body.add(pos);
      body.add(add(pos, 1, 0));
      body.add(add(pos, 2, 0));
    }
    
  }
}
