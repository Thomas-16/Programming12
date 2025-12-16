
class FPlayer extends FGameObject {
    private int frame;
    private int direction;

    public FPlayer() {
        super();

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
        if (isTouching("spike"))
            die();
    }

    private void handleInput() {
        float vx = this.getVelocityX();
        if (aDown) vx = -200;
        if (dDown) vx = 200;
        this.setVelocity(vx, this.getVelocityY());

        ArrayList<FContact> contacts = this.getContacts();
        int contactCount = contacts.size();
        if(contactCount > 0 && wDown && !contacts.get(0).getBody1().isSensor() && !contacts.get(0).getBody2().isSensor())
            this.setVelocity(this.getVelocityX(), -400);
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