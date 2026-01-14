class FBridge extends FGameObject {
    public FBridge(int x, int y, PImage texture) {
        super(x, y, gridSize);
        this.attachImage(texture);
    }

    public void update() {
        if (isTouching("player")) {
            this.setStatic(false);
            this.setSensor(true);
        }
    }
}
