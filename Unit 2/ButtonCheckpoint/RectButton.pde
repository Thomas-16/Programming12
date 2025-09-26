class RectButton {
  private int x, y;
  private int w, h;
  private color buttonColor;
  private color outlineColor;
  private color hoveringOutlineColor;
  private color hoveringColor;
  private color clickingButtonColor;
  private int outlineWidth;
  private int roundness;
  
  private String labelText;
  private PImage labelImage;
  private int textSize;
  private color textColor;
  
  
  private Runnable onClick; // onClick callback
  private boolean isBeingPressed;
  
  RectButton(int x, int y, int w, int h, color buttonColor, color outlineColor, color hoveringColor,  color hoveringOutlineColor, color clickingButtonColor, int outlineWidth, int roundness, PImage labelImage) {
    this(x, y, w, h, buttonColor, outlineColor, hoveringColor, hoveringOutlineColor, clickingButtonColor, outlineWidth, roundness);
    this.labelImage = labelImage;
    this.labelImage = scaleImage(this.labelImage, w - roundness, h - roundness);
  }
  
  RectButton(int x, int y, int w, int h, color buttonColor, color outlineColor, color hoveringColor,  color hoveringOutlineColor, color clickingButtonColor, int outlineWidth, int roundness, String labelText, int textSize, color textColor) {
    this(x, y, w, h, buttonColor, outlineColor, hoveringColor, hoveringOutlineColor, clickingButtonColor, outlineWidth, roundness);
    this.labelText = labelText;
    this.textSize = textSize;
    this.textColor = textColor;
  }
  
  RectButton(int x, int y, int w, int h, color buttonColor, color outlineColor, color hoveringColor, color hoveringOutlineColor, color clickingButtonColor, int outlineWidth, int roundness) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.buttonColor = buttonColor;
    this.outlineColor = outlineColor;
    this.hoveringColor = hoveringColor;
    this.hoveringOutlineColor = hoveringOutlineColor;
    this.clickingButtonColor = clickingButtonColor;
    this.outlineWidth = outlineWidth;
    this.roundness = roundness;
  }
  
  public void draw() {
    color currentOutlineColor = isHoveredOver() ? hoveringOutlineColor : outlineColor;
    color currentButtonColor = isBeingPressed ? lerpColor(clickingButtonColor, buttonColor, 0.4) : (isHoveredOver() ? hoveringColor : buttonColor);
    
    stroke(currentOutlineColor);
    strokeWeight(outlineWidth);
    if(alpha(currentButtonColor) == 0)
      noFill();
    else
      fill(currentButtonColor);
    rectMode(CENTER);
    rect(x, y, w, h, roundness);
    
    if(labelImage != null) {
      imageMode(CENTER);
      image(labelImage, x, y);
    } else if(labelText != null && !labelText.equals("")) {
      textSize(textSize);
      textAlign(CENTER, CENTER);
      fill(isHoveredOver() ? buttonColor : textColor);
      text(labelText, x, y);
    }
  }
  
  public void setOutlineColor(color outlineColor) {
    this.outlineColor = outlineColor;
  }
  
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
