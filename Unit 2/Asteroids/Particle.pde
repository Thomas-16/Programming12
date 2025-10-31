class Particle extends GameObject {
  private float lifetime;
  private float maxLifetime;
  private float size;
  private float alpha;
  private color col;
  private float drag;
  private float gravity;
  private int sides;

  public Particle(float x, float y, float vx, float vy, color col, float size, float lifetime) {
    super(x, y, vx, vy);

    colorMode(HSB, 360, 100, 100);
    float h = hue(col) + random(-16, 16);
    float s = saturation(col);
    float b = brightness(col) + random(-12, 12);

    h = (h + 360) % 360;
    b = constrain(b, 0, 100);

    this.col = color(h, s, b);
    colorMode(RGB, 255, 255, 255);

    this.size = size;
    this.lifetime = lifetime;
    this.maxLifetime = lifetime;
    this.drag = 0.99;
    this.gravity = 0;
    this.sides = (int) random(3, 6);
  }

  public Particle(PVector pos, PVector vel, color col, float size, float lifetime) {
    this(pos.x, pos.y, vel.x, vel.y, col, size, lifetime);
  }

  public void setDrag(float drag) {
    this.drag = drag;
  }

  public void setGravity(float gravity) {
    this.gravity = gravity;
  }

  public void update() {
    pos.add(vel);
    vel.mult(drag);
    vel.y += gravity;

    lifetime--;
    if(lifetime <= 0) {
      shouldBeDeleted = true;
    }

    // edge handling - wrap around
    if(pos.x > width) pos.sub(width, 0);
    if(pos.x < 0) pos.add(width, 0);
    if(pos.y > height) pos.sub(0, height);
    if(pos.y < 0) pos.add(0, height);
  }

  public void draw() {
    float lifeRatio = lifetime / maxLifetime;
    alpha = 255 * lifeRatio;

    fill(col, alpha);
    noStroke();
    polygon(pos.x, pos.y, size * lifeRatio, sides);
  }
}

void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
