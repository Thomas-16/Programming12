class FDoor extends FGameObject {
    private FBox collider = null;
    private FButton button;
    private boolean isLeft;
    private boolean inverted;
    private int frameIndex;
    private int animationTimer = 0;
    private int animationDelay = 8;
    private float colliderX;
    private float colliderY;

    public FDoor(int x, int y, FButton button, boolean isLeft, boolean inverted) {
        super(x, y + gridSize / 2, gridSize, gridSize * 2);
        this.button = button;
        this.isLeft = isLeft;
        this.inverted = inverted;
        this.frameIndex = inverted ? 0 : 3; // Inverted starts open, normal starts closed
        this.setSensor(true);

        PImage[] imgs = isLeft ? DOOR_LEFT_IMGS : DOOR_RIGHT_IMGS;
        this.attachImage(imgs[frameIndex]);

        float colliderWidth = gridSize * 0.25;
        if (isLeft) {
            colliderX = x - gridSize / 2 + colliderWidth / 2;
        } else {
            colliderX = x + gridSize / 2 - colliderWidth / 2;
        }
        colliderY = y + gridSize / 2;

        if (!inverted) {
            spawnCollider();
        }
    }

    private void spawnCollider() {
        if (collider != null) return;
        float colliderWidth = gridSize * 0.25;
        float colliderHeight = gridSize * 2;
        collider = new FBox(colliderWidth, colliderHeight);
        collider.setPosition(colliderX, colliderY);
        collider.setStatic(true);
        collider.setGrabbable(false);
        collider.setNoFill();
        collider.setNoStroke();
        collider.setName("door");
        world.add(collider);
    }

    private void removeCollider() {
        if (collider == null) return;
        world.remove(collider);
        collider = null;
    }

    public void update() {
        animationTimer++;
        if (animationTimer < animationDelay) return;
        animationTimer = 0;

        boolean shouldOpen = inverted ? !button.isPressed() : button.isPressed();

        if (shouldOpen && frameIndex > 0) {
            frameIndex--;
        } else if (!shouldOpen && frameIndex < 3) {
            frameIndex++;
        }

        PImage[] imgs = isLeft ? DOOR_LEFT_IMGS : DOOR_RIGHT_IMGS;
        this.attachImage(imgs[frameIndex]);

        if (frameIndex == 0) {
            removeCollider();
        } else {
            spawnCollider();
        }
    }
}
