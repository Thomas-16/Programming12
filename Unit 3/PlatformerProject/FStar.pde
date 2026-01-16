class FStar extends FGameObject {
    private int frame = 0;
    private int animationTimer = 0;
    private int animationDelay = 5;

    public FStar(int x, int y) {
        super(x, y, gridSize);
        this.setSensor(true);
        this.setStatic(true);
        this.setName("star");
        this.attachImage(STAR_IMGS[0]);
    }

    public void update() {
        animationTimer++;
        if (animationTimer >= animationDelay) {
            animationTimer = 0;
            frame++;
            if (frame >= STAR_IMGS.length) frame = 0;
            this.attachImage(STAR_IMGS[frame]);
        }

        if (isTouching("player")) {
        }
    }
}
