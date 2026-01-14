class FGoomba extends FGameObject {
    private int frame;
    private int direction;
    private final int SPEED = 100;

    public FGoomba(int x, int y) {
        super(x, y, gridSize);

        frame = 0;
        direction = -1;
        this.setVelocity(direction * SPEED, 0);

        this.setRotatable(false);
        this.setNoFill();
        this.setNoStroke();
        this.setDensity(1);
        this.setFriction(0);
        this.setName("goomba");
        this.attachImage(goombaImgs[0]);
    }

    public void update() {
        handleMovement();
        animate();
    }

    private void handleMovement() {
        this.setVelocity(direction * SPEED, this.getVelocityY());

        ArrayList<FContact> contacts = this.getContacts();
        for (FContact contact : contacts) {
            if(contact.contains("wall") && frameCount > frameRate) {
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
            if (frame >= goombaImgs.length) frame = 0;
        }

        this.attachImage(goombaImgs[frame]);
    }
}