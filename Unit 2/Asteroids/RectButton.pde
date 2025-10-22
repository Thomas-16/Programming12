
class RectButton {
  private int x, y;
  private int w, h;
  private color buttonColor;
  private color outlineColor;
  private color hoveringOutlineColor;
  private color clickingButtonColor;
  private int outlineWidth;
  private int roundness;
  
  private int buttonNum;
  
  private Runnable onClick; // onClick callback
  private boolean isBeingPressed;
  
  RectButton(int x, int y, int w, int h, color buttonColor, color outlineColor, color hoveringOutlineColor, color clickingButtonColor, int outlineWidth, int roundness) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.buttonColor = buttonColor;
    this.outlineColor = outlineColor;
    this.hoveringOutlineColor = hoveringOutlineColor;
    this.clickingButtonColor = clickingButtonColor;
    this.outlineWidth = outlineWidth;
    this.roundness = roundness;
  }
  
  public void draw() {
    color currentOutlineColor = isHoveredOver() ? hoveringOutlineColor : outlineColor;
    color currentButtonColor = isBeingPressed ? lerpColor(clickingButtonColor, buttonColor, 0.4) : buttonColor;
    
    stroke(currentOutlineColor);
    strokeWeight(outlineWidth);
    if(alpha(currentButtonColor) == 0)
      noFill();
    else
      fill(currentButtonColor);
    rectMode(CENTER);
    rect(x, y, w, h, roundness);
  }
  
  public void setOutlineColor(color outlineColor) {
    this.outlineColor = outlineColor;
  }
  public void setButtonNum(int buttonNum) { this.buttonNum = buttonNum; }
  public int getButtonNum() { return this.buttonNum; }
  
  public void setOnClick(Runnable onClick) {
    this.onClick = onClick;
  }
  public void mouseReleased() {
    isBeingPressed = false;
    if(onClick != null && isHoveredOver())
      onClick.run();
  }
  public void mousePressed() {
    if(isHoveredOver())
      isBeingPressed = true;
  }
  private boolean isHoveredOver() {
    return mouseX < x + w/2 + outlineWidth/2 && mouseX > x - w/2 - outlineWidth/2 && mouseY < y + h/2 + outlineWidth/2 && mouseY > y - h/2 - outlineWidth/2;
  }
  
  public color getButtonColor() { return buttonColor; }
}
