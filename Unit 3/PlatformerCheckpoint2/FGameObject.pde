class FGameObject extends FBox {

    public FGameObject() {
        super(gridSize, gridSize);
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