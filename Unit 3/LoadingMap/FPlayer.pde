
class FPlayer extends FBox {
    public FPlayer() {
        super(gridSize, gridSize);

        this.setFillColor(#2159ff);
        this.setGrabbable(false);
        this.setNoStroke();
    }

    public void update() {
        int vx = 0;
        if (aDown) vx = -100;
        if (dDown) vx = 100;
        this.setVelocity(vx, this.getVelocityY());

        int contactCount = this.getContacts().size();
        if(contactCount > 0 && wDown) this.setVelocity(this.getVelocityX(), -150);
    }
}