
class FPlayer extends FGameObject {
    private int frame;
    private int direction;
    private FBox footSensor;

    public FPlayer(int x, int y) {
        super(x, y, gridSize);

        this.setNoFill();
        this.setGrabbable(false);
        this.setNoStroke();
        this.setFriction(2.2);
        this.setDensity(1);
        this.setRotatable(false);
        this.setName("player");

        frame = 0;
        direction = 1;

        this.attachImage(idleRightImgs[0]);

        footSensor = new FBox(gridSize * 0.8, gridSize * 0.2);
        footSensor.setSensor(true);
        footSensor.setNoFill();
        footSensor.setNoStroke();
        footSensor.setName("footSensor");
        footSensor.setPosition(x, y + gridSize/2);
    }

    public FBox getFootSensor() {
        return footSensor;
    }

    public void die() {
        this.setPosition((int)spawnPos.x, (int)spawnPos.y);
    }

    public void update() {
        footSensor.setPosition(this.getX(), this.getY() + gridSize/2);

        handleInput();
        handleAnimation();
        handleGoombaCollision();
        handleHammerBroCollision();
        handleThwompCollision();
        if (isTouching("spike") || isTouching("hammer"))
            die();
    }

    private void handleGoombaCollision() {
        ArrayList<FContact> contacts = this.getContacts();
        for (FContact contact : contacts) {
            if (contact.contains("goomba")) {
                FBody goomba = null;
                if (contact.getBody1().getName().equals("goomba")) {
                    goomba = contact.getBody1();
                } else if (contact.getBody2().getName().equals("goomba")) {
                    goomba = contact.getBody2();
                }

                if (goomba == null) continue;

                world.remove(goomba);
                enemies.remove(goomba);

                if (this.getY() < goomba.getY() - gridSize/2) {
                    this.setVelocity(this.getVelocityX(), -350);
                } else {
                    die();
                }
                break;
            }
        }
    }

    private void handleHammerBroCollision() {
        ArrayList<FContact> contacts = this.getContacts();
        for (FContact contact : contacts) {
            if (contact.contains("hammerbro")) {
                FBody hammerBro = null;
                if (contact.getBody1().getName().equals("hammerbro")) {
                    hammerBro = contact.getBody1();
                } else if (contact.getBody2().getName().equals("hammerbro")) {
                    hammerBro = contact.getBody2();
                }

                if (hammerBro == null) continue;

                world.remove(hammerBro);
                enemies.remove(hammerBro);

                if (this.getY() < hammerBro.getY() - gridSize/2) {
                    this.setVelocity(this.getVelocityX(), -350);
                } else {
                    die();
                }
                break;
            }
        }
    }

    private void handleThwompCollision() {
        ArrayList<FContact> contacts = this.getContacts();
        for (FContact contact : contacts) {
            if (contact.contains("thwomp")) {
                FBody thwomp = null;
                if (contact.getBody1().getName().equals("thwomp")) {
                    thwomp = contact.getBody1();
                } else if (contact.getBody2().getName().equals("thwomp")) {
                    thwomp = contact.getBody2();
                }

                if (thwomp == null) continue;

                if (((FThwomp) thwomp).getState() == 1 && this.getY() > thwomp.getY() + gridSize) {
                    die();
                }
                break;
            }
        }
    }

    private void handleInput() {
        float vx = this.getVelocityX();
        if (aDown) vx = -200;
        if (dDown) vx = 200;
        this.setVelocity(vx, this.getVelocityY());

        if(wDown && canJump())
            this.setVelocity(this.getVelocityX(), -430);
    }
    private boolean canJump() {
        ArrayList<FContact> contacts = footSensor.getContacts();
        for (FContact contact : contacts) {
            FBody other = contact.getBody1() == footSensor ? contact.getBody2() : contact.getBody1();
            if (other != null) {
                if (!other.isSensor() && !other.getName().equals("player")) return true;
            }
        }
        return false;
    }

    private void handleAnimation() {
        float vx = this.getVelocityX();
        boolean isGrounded = this.getContacts().size() > 0;

        if (vx > 0) direction = 1;
        else if (vx < 0) direction = -1;

        PImage[] targetImgs;
        if (!isGrounded) {
            // Jumping
            if (direction == 1) {
                targetImgs = jumpRightImgs;
            } else {
                targetImgs = jumpLeftImgs;
            }
        } else if (abs(vx) > 10) {
            // Running
            if (direction == 1) {
                targetImgs = runRightImgs;
            } else {
                targetImgs = runLeftImgs;
            }
        } else {
            // Idle
            if (direction == 1) {
                targetImgs = idleRightImgs;
            } else {
                targetImgs = idleLeftImgs;
            }
        }

        if (currentImgs != targetImgs) {
            currentImgs = targetImgs;
            frame = 0;
        }

        if (frameCount % 10 == 0) {
            frame++;
            if (frame >= currentImgs.length) frame = 0;
        }

        this.attachImage(currentImgs[frame]);
    }
}