class FLava extends FGameObject {
    private int frame;
    
    public FLava(int x, int y) {
        super(x,y);
        
        frame = floor(random(1) * LAVA_IMGS.length);
        this.attachImage(LAVA_IMGS[frame]);
    }

    public void update() {
        if(frameCount % 20 == 0) frame++;
        if (frame == LAVA_IMGS.length) frame = 0;
        this.attachImage(LAVA_IMGS[frame]);

        if (isTouching("player")) {
            player.die();
        }
    }
}