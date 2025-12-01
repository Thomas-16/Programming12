class FBomb extends FBox {
    private int timer;

    FBomb() {
        super(gridSize, gridSize);
        timer = 60;

        this.setFillColor(#fcba03);
        this.setPosition(player.getX(), player.getY());
        world.add(this);
    }


    void act() {
        timer--;
        if(timer == 0) {
            explode();
            world.remove(this);
            bomb = null;
        }
    }

    void explode() {
        for (FBox box : worldBoxes) {
            if (dist(box.getX(), box.getY(), this.getX(), this.getY()) < 80) {
                box.setStatic(false);
                PVector explosionVec = new PVector(box.getX() - this.getX(), box.getY() - this.getY());
                explosionVec.mult(1.5);

                box.addImpulse(explosionVec.x, explosionVec.y);
            }
        }

        if (dist(player.getX(), player.getY(), this.getX(), this.getY()) < 80) {
            PVector explosionVec = new PVector(player.getX() - this.getX(), player.getY() - this.getY());
            explosionVec.mult(1.5);

            player.addImpulse(explosionVec.x, explosionVec.y);
        }
    }
}