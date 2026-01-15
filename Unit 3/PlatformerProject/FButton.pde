class FButton extends FGameObject {
    private boolean pressed = false;

    public FButton(int x, int y) {
        super(x, y, gridSize);
        this.attachImage(BUTTON_IMG);
        this.setSensor(true);
    }

    public void update() {
        pressed = false;
        for (Object obj : world.getBodies()) {
            FBody body = (FBody) obj;
            if (body != null && body.getName() != null && (body.getName().equals("player") || body.getName().equals("ghost") || body.getName().equals("cube"))) {
                if (isInRange(body)) {
                    pressed = true;
                }
            }
        }

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

        float buttonTop = this.getY() - gridSize / 4;
        float buttonBottom = this.getY() + gridSize / 2;
        float buttonLeft = this.getX() - (gridSize * 0.3);
        float buttonRight = this.getX() + (gridSize * 0.3);

        float detectionTop = buttonTop;
        float detectionBottom = buttonBottom + gridSize * 0.2;

        return playerBottom >= detectionTop &&
               playerBottom <= detectionBottom &&
               playerRight > buttonLeft &&
               playerLeft < buttonRight;
    }

    public boolean isPressed() {
        return pressed;
    }
}
