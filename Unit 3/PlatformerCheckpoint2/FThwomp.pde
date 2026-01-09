class FThwomp extends FGameObject {
    private int state;
    private float startY;
    private float returnSpeed = 2.0;

    public FThwomp(int x, int y) {
        super(x, y, gridSize * 2);

        state = 0;
        startY = y;

        this.setRotatable(false);
        this.setNoFill();
        this.setNoStroke();
        this.setName("thwomp");
        this.setStatic(true);
        this.attachImage(THWOMP_IMG_0);
    }

    public void update() {
        switch(state) {
            case 0: // Stationary
                if (player.getY() > this.getY() && player.getY() < this.getY() + 8*gridSize && player.getX() > getX()-gridSize && player.getX() < getX()+gridSize) {
                    state = 1;
                    setStatic(false);
                    attachImage(THWOMP_IMG_1);
                }
                break;
            case 1: // Falling
                if (isTouching("ground") && abs(getVelocityY()) < 1) {
                    state = 2;
                    setStatic(true);
                    attachImage(THWOMP_IMG_0);
                }
                break;
            case 2: // Returning
                float currentY = getY();
                if (currentY > startY) {
                    setPosition(getX(), currentY - returnSpeed);
                } else {
                    setPosition(getX(), startY);
                    state = 0;
                }
                break;
        }

        this.setVelocity(0, getVelocityY());
    }

    public int getState() { return state; }


}