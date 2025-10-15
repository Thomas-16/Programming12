
// input
boolean leftDown, rightDown, upDown, downDown;
boolean spaceDown;

// Game objects
Spaceship player;

ArrayList<GameObject> gameObjects;

PGraphics backgroundPG;

int lastShotTime;

// TODO:
// PARTICLE EFFECTS
// ghosting for certain objects


void gameSetup() {
  gameObjects = new ArrayList<GameObject>();
  
  for(int i = 0; i < 10; i++) {
    gameObjects.add(new Asteroid(3));
  }
  gameObjects.add(new UFO());
  
  player = new Spaceship(width/2, height/2);
  gameObjects.add(player);
  
  backgroundPG = createGraphics(width, height);
  backgroundPG.beginDraw();
  backgroundPG.background(0, 0, 0);
  
  // star dust
  for (int i = 0; i < 3000; i++) {
    float x = random(width);
    float y = random(height);
    float alpha = random(60, 180);
    float size = random(0.6, 2.8);
    
    color c = color(255, 245, 220);
    backgroundPG.noStroke();
    if (random(100) < 8) {
      backgroundPG.fill(c, alpha*2);
      backgroundPG.ellipse(x, y, size*1.5, size*1.5);
    } else {
      backgroundPG.fill(c, alpha);
      backgroundPG.ellipse(x, y, size, size);
    }
  }
  
  backgroundPG.endDraw();
  backgroundPG.filter(BLUR, 0.8);
  
}

void gameDraw() {
  image(backgroundPG, 0, 0);
  
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
  for (int i = 0; i < gameObjects.size(); i++) {
    if(gameObjects.get(i).shouldBeDeleted) continue;
    gameObjects.get(i).update();
  }
}
void drawGameObjects() {
  for (int i = 0; i < gameObjects.size(); i++) {
    if(gameObjects.get(i).shouldBeDeleted) continue;
    gameObjects.get(i).draw();
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
