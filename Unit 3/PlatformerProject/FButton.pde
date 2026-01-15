class FButton extends FGameObject {
    private boolean pressed = false;

    public FButton(int x, int y) {
        super(x, y, gridSize);
        this.attachImage(BUTTON_IMG);
        this.setSensor(true);
    }

    public void update() {
        pressed = isInRange(player) || isInRange(ghost);

        if (pressed) {
            this.attachImage(BUTTON_DOWN_IMG);
        } else {
            this.attachImage(BUTTON_IMG);
        }
    }

    private boolean isInRange(FBody body) {
        float playerBottom = body.getY() + gridSize / 2;
        float playerLeft = body.getX() - gridSize / 2;
        float playerRight = body.getX() + gridSize / 2;

        float buttonTop = this.getY() - gridSize / 2;
        float buttonBottom = this.getY() + gridSize / 2;
        float buttonLeft = this.getX() - gridSize / 2;
        float buttonRight = this.getX() + gridSize / 2;

        float detectionTop = buttonTop - gridSize * 0.01;
        float detectionBottom = buttonBottom + gridSize * 0.1;

        return playerBottom >= detectionTop &&
               playerBottom <= detectionBottom &&
               playerRight > buttonLeft &&
               playerLeft < buttonRight;
    }

    public boolean isPressed() {
        return pressed;
    }
}
