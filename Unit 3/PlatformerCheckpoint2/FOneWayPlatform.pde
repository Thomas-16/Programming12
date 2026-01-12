class FOneWayPlatform extends FGameObject {
    private boolean playerDropping = false;
    private FBox collider = null;

    public FOneWayPlatform(int x, int y) {
        super(x, y, gridSize);
        this.attachImage(BRIDGE);
        this.setSensor(true);
        this.setName("platform");
    }

    public void update() {
        float playerBottom = player.getY() + gridSize/2;
        float platformTop = this.getY() - gridSize/2;

        if (sDown && collider != null) {
            playerDropping = true;
        }

        // reset dropping state
        if (playerDropping && playerBottom < platformTop - 10) {
            playerDropping = false;
        }

        boolean shouldHaveCollider = playerBottom <= platformTop + 5 && !playerDropping;

        if (shouldHaveCollider && collider == null) {
            // spawn collider
            collider = new FBox(gridSize, gridSize);
            collider.setPosition(this.getX(), this.getY());
            collider.setStatic(true);
            collider.setName("platform_collider");
            collider.setSensor(false);
            collider.setNoStroke();
            collider.setNoFill();
            collider.setGrabbable(false);
            world.add(collider);
        } else if (!shouldHaveCollider && collider != null) {
            // delete collider
            world.remove(collider);
            collider = null;
        }
    }
}
