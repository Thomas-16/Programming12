class FGhost extends FGameObject {
    private ArrayList<PVector> positions;
    private int playbackIndex;
    private int frame;
    private int direction;
    private boolean finished;
    private PImage[] currentGhostImgs;

    public FGhost(ArrayList<PVector> recordedPositions) {
        super((int)recordedPositions.get(0).x, (int)recordedPositions.get(0).y, gridSize);

        this.positions = new ArrayList<PVector>(recordedPositions);
        this.playbackIndex = 0;
        this.frame = 0;
        this.direction = 1;
        this.finished = false;
        this.currentGhostImgs = ghostIdleRightImgs;

        this.setNoFill();
        this.setGrabbable(false);
        this.setStatic(true);
        this.setNoStroke();
        this.setFriction(2.2);
        this.setDensity(1);
        this.setRotatable(false);
        this.setName("ghost");

        this.attachImage(ghostIdleRightImgs[0]);
    }

    public boolean isFinished() {
        return finished;
    }

    public int getPlaybackIndex() {
        return playbackIndex;
    }

    public int getPositionCount() {
        return positions.size();
    }

    public void update() {
        if (finished || playbackIndex >= positions.size()) {
            finished = true;
            return;
        }

        PVector pos = positions.get(playbackIndex);

        float vx = 0;
        float vy = 0;
        if (playbackIndex > 0) {
            vx = pos.x - positions.get(playbackIndex - 1).x;
            vy = pos.y - positions.get(playbackIndex - 1).y;
        }

        this.setPosition(pos.x, pos.y);
        playbackIndex++;

        handleAnimation(vx, vy);
    }

    private void handleAnimation(float vx, float vy) {
        boolean isGrounded = this.getContacts().size() > 0;

        if (vx > 0) direction = 1;
        else if (vx < 0) direction = -1;

        PImage[] targetImgs;
        if (!isGrounded && vy < 0) {
            // Jumping (going up)
            if (direction == 1) {
                targetImgs = ghostJumpRightImgs;
            } else {
                targetImgs = ghostJumpLeftImgs;
            }
        } else if (!isGrounded && vy >= 0) {
            // Falling (going down)
            if (direction == 1) {
                targetImgs = ghostFallRightImgs;
            } else {
                targetImgs = ghostFallLeftImgs;
            }
        } else if (abs(vx) > 0.5) {
            if (direction == 1) {
                targetImgs = ghostRunRightImgs;
            } else {
                targetImgs = ghostRunLeftImgs;
            }
        } else {
            if (direction == 1) {
                targetImgs = ghostIdleRightImgs;
            } else {
                targetImgs = ghostIdleLeftImgs;
            }
        }

        if (currentGhostImgs != targetImgs) {
            currentGhostImgs = targetImgs;
            frame = 0;
        }

        if (frameCount % 10 == 0) {
            frame++;
            if (frame >= currentGhostImgs.length) frame = 0;
        }

        this.attachImage(currentGhostImgs[frame]);
    }
}
