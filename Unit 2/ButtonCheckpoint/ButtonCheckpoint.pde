
RectButton button1, button2;
Gif gif1;

PImage clashKingImg;

void setup() {
  size(800, 800);
  
  clashKingImg = loadImage("clash_king.png");
  
  button1 = new RectButton(200, 200, 200, 180, color(#205dd6), color(#173673), color(#698fdb), color(#192f5c), color(#2457bd), 6, 3, clashKingImg);
  button2 = new RectButton(200, 600, 220, 160, color(#a45ed6), color(#68219c), color(#7d39ad),  color(#7540a1), color(#4e1d75), 6, 3, "TEXT", 80, color(#7d39ad));

  gif1 = new Gif("frame_", "_delay-0.03s.gif", 200, 600, 220, 160, 72, 4);
}

void draw() {
  background(255);
  
  button1.draw();
  button2.draw();
  
  gif1.draw();
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
