
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
// PARTICLE EFFECTS


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
  ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
  for (GameObject go : gameObjects) {
    if (go instanceof Asteroid) asteroids.add((Asteroid) go);
  }

  for (int i = 0; i < asteroids.size(); i++) {
    Asteroid a = asteroids.get(i);
    for (int k = i + 1; k < asteroids.size(); k++) {
      Asteroid b = asteroids.get(k);

      // simple circle check
      PVector n = PVector.sub(b.pos, a.pos);
      float dist = n.mag();
      if (dist > a.maxSize * 0.5f + b.maxSize * 0.5f) continue;

      // proper collision check
      if (!polyPolyCollision(a.pos, a.vertices, b.pos, b.vertices)) continue;

      n.div(dist); // normalize

      // Relative velocity
      PVector rv = PVector.sub(b.vel, a.vel);
      float velAlongNormal = rv.dot(n);
      if (velAlongNormal > 0) continue; // moving apart already

      // assume masses are 1
      float restitution = 1.0; // perfectly elastic collisions
      float j = -(1 + restitution) * velAlongNormal / 2.0f;

      PVector impulse = PVector.mult(n, j);
      a.vel.sub(impulse);
      b.vel.add(impulse);
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
