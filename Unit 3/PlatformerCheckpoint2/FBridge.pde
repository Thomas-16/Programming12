class FBridge extends FGameObject {
    public FBridge(int x, int y) {
        super(x, y, gridSize);
        
        this.attachImage(BRIDGE);
    }

    public void update() {
        if (isTouching("player")) {
            this.setStatic(false);
            this.setSensor(true);
        }
    }
}