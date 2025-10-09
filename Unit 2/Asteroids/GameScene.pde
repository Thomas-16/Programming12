
// input
boolean leftDown, rightDown, upDown, downDown;
boolean spaceDown;

// Game objects
Spaceship player;

ArrayList<GameObject> gameObjects;


int lastShotTime;

// TODO:
// starry background?
// ghosting for certain objects


void gameSetup() {
  gameObjects = new ArrayList<GameObject>();
  
  gameObjects.add(new Asteroid(3));
  gameObjects.add(new Asteroid(3));
  gameObjects.add(new Asteroid(3));
  gameObjects.add(new Asteroid(3));
  gameObjects.add(new Asteroid(3));
  gameObjects.add(new Asteroid(3));
  gameObjects.add(new Asteroid(3));
  gameObjects.add(new Asteroid(3));
  gameObjects.add(new Asteroid(3));
  gameObjects.add(new Asteroid(3));
  gameObjects.add(new Asteroid(3));
  
  player = new Spaceship(width/2, height/2);
  gameObjects.add(player);
  
}

void gameDraw() {
  
  handleInput();
  
  pruneGameObjects();
  updateGameObjects();
  
  resolveAsteroidCollisions();
  
  drawGameObjects();
}

void handleInput() {
  if(spaceDown && millis() - lastShotTime > 800)  {
    gameObjects.add(new Bullet(player.pos, player.dir));
    lastShotTime = millis();
  }
}

void pruneGameObjects() {
  for(int i = 0; i < gameObjects.size(); i++) {
    if(gameObjects.get(i).shouldBeDeleted) {
      gameObjects.remove(i);
      i--;
    }
  }
}
void updateGameObjects() {
  for(GameObject gameObj : gameObjects) {
    gameObj.update();
  }
}
void drawGameObjects() {
  for(GameObject gameObj : gameObjects) {
    gameObj.draw();
  }
}

// https://gafferongames.com/post/collision_response_and_coulomb_friction/
void resolveAsteroidCollisions() {
  ArrayList<Asteroid> asts = new ArrayList<Asteroid>();
  for (GameObject go : gameObjects) {
    if (go instanceof Asteroid) asts.add((Asteroid) go);
  }

  float restitution = 1.0; // perfectly elastic

  for (int i = 0; i < asts.size(); i++) {
    Asteroid a = asts.get(i);
    for (int k = i + 1; k < asts.size(); k++) {
      Asteroid b = asts.get(k);

      // circle check
      float ra = a.maxSize * 0.5f;
      float rb = b.maxSize * 0.5f;

      PVector n = PVector.sub(b.pos, a.pos);
      float distSq = n.magSq();
      float r = ra + rb;
      if (distSq > r * r) continue;  // too far apart

      // Not colliding
      if (!polyPolyCollision(a.pos, a.vertices, b.pos, b.vertices)) continue;

      float dist = sqrt(distSq);
      n.div(dist); // normalize

      // Relative velocity
      PVector rv = PVector.sub(b.vel, a.vel);
      float velAlongNormal = rv.dot(n);
      if (velAlongNormal > 0) continue; // moving apart already

      // assume masses are 1
      float j = -(1 + restitution) * velAlongNormal / 2.0f;

      PVector impulse = PVector.mult(n, j);
      a.vel.sub(impulse); // v1 -= j * n
      b.vel.add(impulse); // v2 += j * n
    }
  }
}


void gameSceneKeyPressed() {
  if(keyCode == LEFT) leftDown = true;
  if(keyCode == RIGHT) rightDown = true;
  if(keyCode == UP) upDown = true;
  if(keyCode == DOWN) downDown = true;
  if(key == ' ') spaceDown = true;
}

void gameSceneKeyReleased() {
  if(keyCode == LEFT) leftDown = false;
  if(keyCode == RIGHT) rightDown = false;
  if(keyCode == UP) upDown = false;
  if(keyCode == DOWN) downDown = false;
  if(key == ' ') spaceDown = false;
}
