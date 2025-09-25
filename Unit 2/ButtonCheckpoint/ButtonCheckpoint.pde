
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
      fill(textColor);
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
  
  public  color getButtonColor() { return buttonColor; }
}

RectButton button1, button2;

PImage clashKingImg;

void setup() {
  size(800, 800);
  
  clashKingImg = loadImage("clash_king.png");
  
  button1 = new RectButton(200, 200, 200, 180, color(#205dd6), color(#173673), color(#698fdb), color(#192f5c), color(#2457bd), 6, 3, clashKingImg);
  button2 = new
}

void draw() {
  background(255);
  
  button1.draw();
  button2.draw();
}

void mousePressed() {
  button1.mousePressed();
  button2.mousePressed();
}
void mouseReleased() {
  button1.mouseReleased();
  button2.mouseReleased();
}

PImage scaleImage(PImage src, int w, int h) {
  PImage out = createImage(w, h, ARGB);
  out.loadPixels();
  src.loadPixels();

  for (int y = 0; y < h; y++) {
    int sy = int(y * src.height / (float) h); 
    for (int x = 0; x < w; x++) {
      int sx = int(x * src.width / (float) w);
      out.pixels[y * w + x] = src.pixels[sy * src.width + sx];
    }
  }
  out.updatePixels();
  return out;
}
