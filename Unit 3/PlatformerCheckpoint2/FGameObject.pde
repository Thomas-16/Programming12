class FGameObject extends FBox {

    public FGameObject(int x, int y, int size) {
        super(size, size);
        this.setPosition(x,y);
    }

    public void update() {
        
    }

    protected boolean isTouching(String n) {
        ArrayList<FContact> contacts = this.getContacts();
        for (FContact contact : contacts) {
            if(contact.contains(n)) {
                return true;
            }
        }
        return false;
    }
}