class Particle extends GameObject {
  private float lifetime;
  private float maxLifetime;
  private float size;
  private float alpha;
  private color col;
  private float drag;
  private float gravity;

  public Particle(float x, float y, float vx, float vy, color col, float size, float lifetime) {
    super(x, y, vx, vy);
    this.col = col;
    this.size = size;
    this.lifetime = lifetime;
    this.maxLifetime = lifetime;
    this.drag = 0.98;
    this.gravity = 0;
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
    circle(pos.x, pos.y, size * lifeRatio);
  }
}
