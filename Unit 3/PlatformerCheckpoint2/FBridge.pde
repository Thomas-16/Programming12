class FBridge extends FGameObject {
    public FBridge() {
        super();
        
        this.attachImage(BRIDGE);
    }

    public void update() {
        if (isTouching("player")) {
            this.setStatic(false);
        }
    }
}