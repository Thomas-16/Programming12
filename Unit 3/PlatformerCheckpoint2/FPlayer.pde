
class FPlayer extends FGameObject {
    private int frame;
    private int direction;

    public FPlayer(int x, int y) {
        super(x, y, gridSize);

        this.setNoFill();
        this.setGrabbable(false);
        this.setNoStroke();
        this.setFriction(2.2);
        this.setDensity(1);
        this.setRotatable(false);
        this.setName("player");

        frame = 0;
        direction = 1;

        this.attachImage(idleRightImgs[0]);
    }

    public void die() {
        this.setPosition(0, 0);
    }

    public void update() {
        handleInput();
        handleAnimation();
        handleGoombaCollision();
        if (isTouching("spike"))
            die();
    }

    private void handleGoombaCollision() {
        ArrayList<FContact> contacts = this.getContacts();
        for (FContact contact : contacts) {
            if (contact.contains("goomba")) {
                FBody goomba = null;
                if (contact.getBody1().getName().equals("goomba")) {
                    goomba = contact.getBody1();
                } else if (contact.getBody2().getName().equals("goomba")) {
                    goomba = contact.getBody2();
                }

                if (goomba == null) continue;

                world.remove(goomba);
                enemies.remove(goomba);

                if (this.getY() < goomba.getY() - gridSize/2) {
                    this.setVelocity(this.getVelocityX(), -350);
                } else {
                    die();
                }
                break;
            }
        }
    }

    private void handleInput() {
        float vx = this.getVelocityX();
        if (aDown) vx = -200;
        if (dDown) vx = 200;
        this.setVelocity(vx, this.getVelocityY());

        ArrayList<FContact> contacts = this.getContacts();
        int contactCount = contacts.size();
        if(contactCount > 0 && wDown && !contacts.get(0).getBody1().isSensor() && !contacts.get(0).getBody2().isSensor())
            this.setVelocity(this.getVelocityX(), -450);
    }

    private void handleAnimation() {
        float vx = this.getVelocityX();
        boolean isGrounded = this.getContacts().size() > 0;

        if (vx > 0) direction = 1;
        else if (vx < 0) direction = -1;

        PImage[] targetImgs;
        if (!isGrounded) {
            // Jumping
            if (direction == 1) {
                targetImgs = jumpRightImgs;
            } else {
                targetImgs = jumpLeftImgs;
            }
        } else if (abs(vx) > 10) {
            // Running
            if (direction == 1) {
                targetImgs = runRightImgs;
            } else {
                targetImgs = runLeftImgs;
            }
        } else {
            // Idle
            if (direction == 1) {
                targetImgs = idleRightImgs;
            } else {
                targetImgs = idleLeftImgs;
            }
        }

        if (currentImgs != targetImgs) {
            currentImgs = targetImgs;
            frame = 0;
        }

        if (frameCount % 10 == 0) {
            frame++;
            if (frame >= currentImgs.length) frame = 0;
        }

        this.attachImage(currentImgs[frame]);
    }
}