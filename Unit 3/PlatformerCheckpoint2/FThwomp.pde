class FThwomp extends FGameObject {
    private int state;

    public FThwomp(int x, int y) {
        super(x, y, gridSize * 2);

        state = 0;

        this.setRotatable(false);
        this.setNoFill();
        this.setNoStroke();
        this.setDensity(1);
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
                }
                break;
            case 1: // Falling
                break;
            case 2: // Returning
                break;
        }

        this.setVelocity(0, getVelocityY());
    }


}