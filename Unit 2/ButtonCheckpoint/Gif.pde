class Gif {
  private int x, y;
  private int width, height;
  private int framesPerImg;
  private int numFrames;
  
  private PImage[] images;
  private int index;
  private int frames;
  
  public Gif(String before, String after, int x, int y, int width, int height, int numFrames, int framesPerImg) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.numFrames = numFrames;
    this.framesPerImg = framesPerImg;
    this.index = 0;
    this.frames = 0;
    
    images = new PImage[numFrames];
    for(int i = 0; i < numFrames; i++) {
      images[i] = scaleImage(loadImage(before + i + after), this.width, this.height);
    }
  }
  
  public void draw() {
    imageMode(CENTER);
    if(frames % framesPerImg == 0) {
      index++;
      if(index == numFrames) index = 0;
    }
    image(images[index], this.x, this.y);
    
    frames++;
  }
  
}
