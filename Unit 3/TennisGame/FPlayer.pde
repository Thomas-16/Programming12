
int jumpImpulseForce = 6000;

class FPlayer extends FBox {

  private FBox racket;
  private boolean onGround;
  private boolean swinging;
  private int swingTimer;
  private float racketAngle;
  private boolean facingLeft;
  

  public FPlayer(int x, int y, int w, int h) {
    super(w, h);

    this.setPosition(x, y);
    this.setFill(100, 150, 255);
    this.setDensity(1);
    this.setRotatable(false);
    this.setDamping(0);
    this.setRestitution(0);
    this.setFriction(1);

    racket = new FBox(20, 90);
    racket.setFill(255, 200, 100);
    racket.setSensor(true);
    racket.setGrabbable(false);
    racket.setRotatable(true);

    onGround = false;
    swinging = false;
    swingTimer = 0;
    racketAngle = 0;
    facingLeft = false;
  }

  void update() {
    checkGround();
    updateRacket();
  }

  void checkGround() {
    onGround = this.getY() > height - 100;
  }

  void jump() {
    if (onGround) {
      this.addImpulse(0, -jumpImpulseForce);
      onGround = false;
    }
  }

  void swing() {
    if (!swinging) {
      swinging = true;
      swingTimer = 0;
    }
  }

  void updateRacket() {
    float direction = facingLeft ? -1 : 1;

    if (swinging) {
      swingTimer++;
      float swingProgress = swingTimer / 15.0;
      racketAngle = direction * sin(swingProgress * PI) * PI * 0.6;

      if (swingTimer > 15) {
        swinging = false;
        swingTimer = 0;
      }
    } else {
      racketAngle = lerp(racketAngle, 0, 0.2);
    }

    float racketHandleY = this.getY() - 55;
    float racketCenterOffsetY = 35;

    float racketX = this.getX() + sin(racketAngle) * racketCenterOffsetY;
    float racketY = racketHandleY - cos(racketAngle) * racketCenterOffsetY;

    racket.setPosition(racketX, racketY);
    racket.setRotation(racketAngle);
  }
}
