
class FPlayer extends FBox {
    public FPlayer() {
        super(gridSize, gridSize);

        this.setFillColor(#2159ff);
        this.setGrabbable(false);
        this.setNoStroke();
        this.setFriction(0);
        this.setDensity(1);
    }

    public void update() {
        int vx = 0;
        if (aDown) vx = -200;
        if (dDown) vx = 200;
        this.setVelocity(vx, this.getVelocityY());

        ArrayList<FContact> contacts = this.getContacts();
        int contactCount = contacts.size();
        if(contactCount > 0 && wDown && !contacts.get(0).getBody1().isSensor() && !contacts.get(0).getBody2().isSensor())
            this.setVelocity(this.getVelocityX(), -350);
    }
}