
// input
boolean leftDown, rightDown, upDown, downDown;
boolean spaceDown;

// Game objects
Spaceship player;

int lastShotTime;
int lastUfoSpawnTime;

int lives;
final int MAX_LIVES = 3;

// TODO LIST:
// Triggering win after destroying all asteroids
// Game over scene with win or lose
//   GIF
//   Font
// Pausing
// Particle class and ParticleSystem class
//   Collision particles
//   Explosion particles
//   Thruster particles
// Teleporting to safe space
//   Teleport cooldown bar
//   Invulnerability after teleport
// Ghosting for certain objects
// Other polish effects
// Sound effects
// Shake effect


void gameSetup() {
  gameObjects.add(new UFO());
  lastUfoSpawnTime = millis() - 10000;

  player = new Spaceship(width/2, height/2);
  gameObjects.add(player);

  lives = MAX_LIVES;
  
}

void gameDraw() {
  image(backgroundPG, 0, 0);

  handleInput();
  spawnUfo();

  pruneGameObjects();
  updateGameObjects();

  resolveAsteroidCollisions();

  drawGameObjects();
  drawUI();
  
}

void drawUI() {
  // Draw lives
  pushMatrix();
  translate(40, 65);

  for(int i = 0; i < lives; i++) {
    pushMatrix();
    translate(i * 55, 0);

    fill(0);
    stroke(255);
    strokeWeight(3);
    triangle(-20, 0, 20, 0, 0, -45);
    strokeWeight(1);

    popMatrix();
  }

  popMatrix();
}

void handleInput() {
  if(spaceDown && millis() - lastShotTime > 500)  {
    gameObjects.add(new Bullet(player.pos, player.dir, true));
    lastShotTime = millis();
  }
}

void spawnUfo() {
  if(millis() - lastUfoSpawnTime < 10000) return;

  boolean ufoExists = false;
  for(GameObject obj : gameObjects) {
    if(obj instanceof UFO) {
      ufoExists = true;
      break;
    }
  }

  // Spawn UFO if none exists
  if(!ufoExists) {
    gameObjects.add(new UFO());
    lastUfoSpawnTime = millis();
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
  for (int i = 0; i < gameObjects.size(); i++) {
    if(gameObjects.get(i).shouldBeDeleted) continue;
    gameObjects.get(i).update();
  }
}
void drawGameObjects() {
  for (int i = 0; i < gameObjects.size(); i++) {
    if(gameObjects.get(i).shouldBeDeleted || gameObjects.get(i) instanceof Spaceship) continue;
    gameObjects.get(i).draw();
  }
  
  if(player != null)
    player.draw();
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
