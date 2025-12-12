
class FPlayer extends FGameObject {
    public FPlayer() {
        super();

        this.setFillColor(#2159ff);
        this.setGrabbable(false);
        this.setNoStroke();
        this.setFriction(2.2);
        this.setDensity(1);
        this.setName("player");
    }

    public void update() {
        handleInput();
        if (isTouching("spike"))
            this.setPosition(0, 0);
    }

    private void handleInput() {
        float vx = this.getVelocityX();
        if (aDown) vx = -200;
        if (dDown) vx = 200;
        this.setVelocity(vx, this.getVelocityY());

        ArrayList<FContact> contacts = this.getContacts();
        int contactCount = contacts.size();
        if(contactCount > 0 && wDown && !contacts.get(0).getBody1().isSensor() && !contacts.get(0).getBody2().isSensor())
            this.setVelocity(this.getVelocityX(), -400);
    }
}