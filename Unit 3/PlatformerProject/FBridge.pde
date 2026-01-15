class FBridge extends FGameObject {
    private boolean triggered = false;
    private int triggeredFrame = 0;
    private int fallDelay = 20;

    public FBridge(int x, int y, PImage texture) {
        super(x, y, gridSize);
        this.attachImage(texture);
    }

    public void update() {
        if (!triggered && isTouching("player")) {
            triggered = true;
            triggeredFrame = frameCount;
        }

        if (triggered && frameCount - triggeredFrame >= fallDelay) {
            this.setStatic(false);
            this.setSensor(true);
        }

        if (this.getY() > 2 * mapImg.height * gridSize) world.remove(this);
    }
}
