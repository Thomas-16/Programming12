class FLava extends FGameObject {
    private int frame;
    private FBox visual;

    public FLava(int x, int y) {
        super(x, y + gridSize * 0.2, gridSize, gridSize * 0.6);
        this.setNoFill();
        this.setNoStroke();

        visual = new FBox(gridSize, gridSize);
        visual.setSensor(true);
        visual.setStatic(true);
        visual.setNoStroke();
        visual.setPosition(x, y);
        visual.setGrabbable(false);

        frame = floor(random(1) * LAVA_IMGS.length);
        visual.attachImage(LAVA_IMGS[frame]);
    }

    public FBox getVisual() {
        return visual;
    }

    public void update() {
        if(frameCount % 20 == 0) frame++;
        if (frame == LAVA_IMGS.length) frame = 0;
        visual.attachImage(LAVA_IMGS[frame]);

        if (isTouching("player")) {
            player.die();
        }
    }
}