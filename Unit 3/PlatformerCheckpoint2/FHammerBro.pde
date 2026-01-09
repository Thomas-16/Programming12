class FHammerBro extends FGameObject {
    private int frame;
    private int direction;
    private final int SPEED = 100;
    private final float THROW_DISTANCE = 400;
    private final int THROW_COOLDOWN = 90;
    private int lastThrowFrame;

    public FHammerBro(int x, int y) {
        super(x, y, gridSize);

        frame = 0;
        direction = -1;
        lastThrowFrame = 0;
        this.setVelocity(direction * SPEED, 0);

        this.setRotatable(false);
        this.setNoFill();
        this.setNoStroke();
        this.setDensity(1);
        this.setFriction(0);
        this.setName("hammerbro");
        this.attachImage(hammerBroRightImgs[0]);
    }

    public void update() {
        handleMovement();
        animate();
        tryThrowHammer();
    }

    private void handleMovement() {
        this.setVelocity(direction * SPEED, this.getVelocityY());

        ArrayList<FContact> contacts = this.getContacts();
        for (FContact contact : contacts) {
            if (contact.contains("wall") && frameCount > 120) {
                float contactX = contact.getX();
                if ((direction == -1 && contactX < this.getX()) || (direction == 1 && contactX > this.getX())) {
                    direction *= -1;
                }
                break;
            }
        }
    }

    private void animate() {
        if (frameCount % 10 == 0) {
            frame++;
            if (frame >= hammerBroRightImgs.length) frame = 0;
        }

        if (direction == 1) {
            this.attachImage(hammerBroRightImgs[frame]);
        } else {
            this.attachImage(hammerBroLeftImgs[frame]);
        }
    }

    private void tryThrowHammer() {
        // Check cooldown
        if (frameCount - lastThrowFrame < THROW_COOLDOWN) return;

        // Check distance to player
        float dx = player.getX() - this.getX();
        float dy = player.getY() - this.getY();
        float distance = sqrt(dx * dx + dy * dy);

        if (distance < THROW_DISTANCE) {
            throwHammer();
            lastThrowFrame = frameCount;
        }
    }

    private void throwHammer() {
        FBox hammer = new FBox(gridSize / 2, gridSize / 2);
        hammer.setPosition(this.getX(), this.getY() - gridSize / 2);
        hammer.setNoFill();
        hammer.setNoStroke();
        hammer.setName("hammer");
        hammer.setGrabbable(false);
        hammer.setSensor(true);

        // Attach image based on throw direction (toward player)
        int throwDir = (player.getX() > this.getX()) ? 1 : -1;
        if (throwDir == 1) {
            hammer.attachImage(HAMMER_IMG_RIGHT);
        } else {
            hammer.attachImage(HAMMER_IMG_LEFT);
        }

        // Set velocity for arc toward player
        hammer.setVelocity(throwDir * 200, -350);
        hammer.setAngularVelocity(throwDir * 15);

        world.add(hammer);
    }
}
