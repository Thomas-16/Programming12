int currentLevel = 1;
boolean pendingNextLevel = false;

void gameSceneSetup() {
  loadLevel(currentLevel);
}

void gameSceneDraw() {
  drawBackground();

  for (FGameObject gameObject : terrain) {
    gameObject.update();
  }
  for (FGameObject gameObject : enemies) {
    gameObject.update();
  }
  for (FDoor door : doors) {
    door.update();
  }
  player.update();

  if (pendingNextLevel) {
    pendingNextLevel = false;
    nextLevel();
    return;
  }

  if (isRecording) {
    recordedPositions.add(new PVector(player.getX(), player.getY()));
    if (frameCount - recordStartFrame >= RECORD_DURATION) {
      stopRecording();
    }
  }

  if (ghost != null) {
    ghost.update();
    if (ghost.isFinished()) {
      world.remove(ghost);
      ghost = null;
    }
  }

  world.step();

  float levelWidth = mapImg.width * gridSize;
  float levelHeight = mapImg.height * gridSize;
  float viewWidth = width / zoom;
  float viewHeight = height / zoom;
  float camX = constrain(player.getX(), viewWidth/2, levelWidth - viewWidth/2) - gridSize/2;
  float camY = constrain(player.getY(), viewHeight/2, levelHeight - viewHeight/2) - gridSize/2;

  pushMatrix();
  scale(zoom);
  translate(-camX + viewWidth/2, -camY + viewHeight/2);

  world.draw();
  // world.drawDebug();

  drawTextInWorld();

  popMatrix();

  drawGameUI();
}

void drawTextInWorld() {
  textAlign(LEFT);
  textSize(50);
  fill(#cfd2ff);
  textLeading(60);

  if (currentLevel == 2) {
    text("Press R  to start recording your movement\nPress P  to play it.", 150, 150);
  }
}

void drawGameUI() {
  rectMode(CORNER);
  
  float barWidth = 200;
  float barHeight = 20;
  float x = width - barWidth - 20;
  float y = 20;

  fill(40);
  noStroke();
  rect(x, y, barWidth, barHeight);

  if (isRecording) {
    float progress = map(frameCount - recordStartFrame, 0, RECORD_DURATION, 0, 1);
    progress = 1 - progress;
    fill(255, 70, 70);
    rect(x, y, barWidth * progress, barHeight);
  } else if (ghost != null && !ghost.isFinished()) {
    float progress = map(ghost.getPlaybackIndex(), 0, ghost.getPositionCount(), 0, 1);
    progress = 1 - progress;
    fill(70, 150, 255);
    rect(x, y, barWidth * progress, barHeight);
  }

  fill(255);
  textAlign(LEFT);
  textSize(30);
  text("Level " + currentLevel, 20, 35);
}

void gameSceneKeyPressed() {
  if (key == 'W' || key == 'w') wDown = true;
  if (key == 'A' || key == 'a') aDown = true;
  if (key == 'S' || key == 's') sDown = true;
  if (key == 'D' || key == 'd') dDown = true;

  if (key == 'R' || key == 'r') {
    if (isRecording) {
      stopRecording();
    } else {
      startRecording();
    }
  }

  if (key == 'P' || key == 'p') {
    if (isRecording) stopRecording();
    spawnGhost();
  }
}

void gameSceneKeyReleased() {
  if (key == 'W' || key == 'w') wDown = false;
  if (key == 'A' || key == 'a') aDown = false;
  if (key == 'S' || key == 's') sDown = false;
  if (key == 'D' || key == 'd') dDown = false;
}

void gameSceneMousePressed() {
}

void gameSceneMouseReleased() {
}

void loadLevel(int level) {
  currentLevel = level;
  pendingNextLevel = false;

  terrain.clear();
  enemies.clear();
  doors.clear();
  ghost = null;
  isRecording = false;
  recordedPositions.clear();

  mapImg = loadImage("level" + level + ".png");

  world = new FWorld(Integer.MIN_VALUE, Integer.MIN_VALUE, Integer.MAX_VALUE, Integer.MAX_VALUE);
  world.setGravity(0, 400);

  FCompound ground = new FCompound();
  HashMap<Integer, FButton> buttonsByCode = new HashMap<Integer, FButton>();

  for (int y = 0; y < mapImg.height; y++) {
    for (int x = 0; x < mapImg.width; x++) {
      color c = mapImg.get(x, y);

      if (c == SPAWN_COLOR) {
        spawnPos.set(x*gridSize, y*gridSize);
        continue;
      }

      FBox box = null;

      if (c == GROUND_COLOR) {
        boolean n = isTileType(x, y - 1, GROUND_COLOR);
        boolean s = isTileType(x, y + 1, GROUND_COLOR);
        boolean e = isTileType(x + 1, y, GROUND_COLOR);
        boolean w = isTileType(x - 1, y, GROUND_COLOR);
        boolean ne = isTileType(x + 1, y - 1, GROUND_COLOR);
        boolean nw = isTileType(x - 1, y - 1, GROUND_COLOR);
        boolean se = isTileType(x + 1, y + 1, GROUND_COLOR);
        boolean sw = isTileType(x - 1, y + 1, GROUND_COLOR);

        PImage texture = GROUND_CENTER;
        if (!n && !s && !e && !w) texture = GROUND_ALONE;
        else if (!n && !s && !w && e) texture = GROUND_ONEDEEP_LEFT;
        else if (!n && !s && w && !e) texture = GROUND_ONEDEEP_RIGHT;
        else if (!n && !s && w && e) texture = GROUND_ONEDEEP_CENTER;
        else if (!n && s && !e && !w) texture = GROUND_PILLAR_TOP;
        else if (n && !s && !e && !w) texture = GROUND_PILLAR_BOTTOM;
        else if (n && s && !e && !w) texture = GROUND_PILLAR_CENTER;
        else if (!n && !e) texture = GROUND_NE;
        else if (!n && !w) texture = GROUND_NW;
        else if (!s && !e) texture = GROUND_SE;
        else if (!s && !w) texture = GROUND_SW;
        else if (!n) texture = GROUND_N;
        else if (!s) texture = GROUND_S;
        else if (!e) texture = GROUND_E;
        else if (!w) texture = GROUND_W;
        else if (n && e && !ne) texture = GROUND_INNER_NE;
        else if (n && w && !nw) texture = GROUND_INNER_NW;
        else if (s && e && !se) texture = GROUND_INNER_SE;
        else if (s && w && !sw) texture = GROUND_INNER_SW;

        box = new FBox(gridSize, gridSize);
        box.attachImage(texture);
        box.setName("ground");
      }
      else if (c == SLIME_COLOR) {
        box = new FBox(gridSize, gridSize);
        box.attachImage(SLIME);
        box.setRestitution(2);
        box.setName("slime");
      }
      else if (c == ICE_COLOR) {
        box = new FBox(gridSize, gridSize);
        box.attachImage(ICE);
        box.setFriction(0);
        box.setName("ice");
      }

      if (box == null) {
        if (c == SPIKE_COLOR) {
          FBox visual = new FBox(gridSize, gridSize);
          visual.attachImage(SPIKE);
          visual.setSensor(true);
          visual.setStatic(true);
          visual.setStroke(0, 0, 0, 0);
          visual.setPosition(x*gridSize, y*gridSize);
          visual.setGrabbable(false);
          world.add(visual);

          float hitboxHeight = gridSize * 0.4;
          box = new FBox(gridSize * 0.6, hitboxHeight);
          box.setName("spike");
          box.setStatic(true);
          box.setNoFill();
          box.setNoStroke();
          box.setPosition(x*gridSize, y*gridSize + hitboxHeight/2);
          box.setGrabbable(false);
          world.add(box);
        }
        else if (c == TRUNK_COLOR) {
          box = new FBox(gridSize, gridSize);
          box.attachImage(TRUNK);
          box.setSensor(true);
          box.setStatic(true);
          box.setStroke(0, 0, 0, 0);
          box.setPosition(x*gridSize, y*gridSize);
          box.setGrabbable(false);
          world.add(box);
        }
        else if (c == LEAF_COLOR) {
          boolean s = isTileType(x, y + 1, TRUNK_COLOR);
          boolean eLeaf = isTileType(x + 1, y, LEAF_COLOR);
          boolean wLeaf = isTileType(x - 1, y, LEAF_COLOR);

          PImage texture = LEAF_CENTER;
          if (s) texture = TREE_INTERSECT;
          else if (!wLeaf && eLeaf) texture = LEAF_W;
          else if (wLeaf && !eLeaf) texture = LEAF_E;
          else if (wLeaf && eLeaf) texture = LEAF_CENTER;

          box = new FBox(gridSize, gridSize);
          box.setSensor(true);
          box.attachImage(texture);
          box.setStatic(true);
          box.setStroke(0, 0, 0, 0);
          box.setPosition(x*gridSize, y*gridSize);
          box.setGrabbable(false);
          world.add(box);
        }
        else if (c == BRIDGE_COLOR) {
          FBridge bridge = new FBridge(x*gridSize, y*gridSize, BRIDGE);
          bridge.setStatic(true);
          bridge.setStroke(0, 0, 0, 0);
          bridge.setGrabbable(false);
          world.add(bridge);
          terrain.add(bridge);
        }
        else if (c == LAVA_COLOR) {
          FLava lava = new FLava(x*gridSize, y*gridSize);
          lava.setStatic(true);
          lava.setStroke(0, 0, 0, 0);
          lava.setGrabbable(false);
          world.add(lava);
          world.add(lava.getVisual());
          terrain.add(lava);
        }
        else if (c == ONEWAY_COLOR) {
          color leftColor = x > 0 ? mapImg.get(x-1, y) : 0;
          boolean leftIsOneway = leftColor == ONEWAY_COLOR;

          PImage platformTexture = leftIsOneway ? ONEWAY_RIGHT : ONEWAY_LEFT;

          FOneWayPlatform platform = new FOneWayPlatform(x*gridSize, y*gridSize, platformTexture);
          platform.setStatic(true);
          platform.setStroke(0, 0, 0, 0);
          platform.setGrabbable(false);
          world.add(platform);
          terrain.add(platform);
        }
        else if (c == BUTTON_COLOR) {
          FButton button = new FButton(x*gridSize, y*gridSize);
          button.setStatic(true);
          button.setStroke(0, 0, 0, 0);
          button.setGrabbable(false);
          world.add(button);
          terrain.add(button);

          if (y > 0) {
            color codeColor = mapImg.get(x, y - 1);
            buttonsByCode.put(codeColor, button);
          }
        }
        else if (c == CUBE_COLOR) {
          FBox cube = new FBox(gridSize * 3/4, gridSize * 3/4);
          cube.setPosition(x*gridSize, y*gridSize);
          cube.attachImage(CUBE_IMG);
          cube.setStroke(0, 0, 0, 0);
          cube.setDensity(0.5);
          cube.setFriction(1);
          cube.setGrabbable(false);
          cube.setRotatable(false);
          cube.setName("cube");
          world.add(cube);
        }
        else if (c == STAR_COLOR) {
          FStar star = new FStar(x*gridSize, y*gridSize);
          star.setStroke(0, 0, 0, 0);
          star.setGrabbable(false);
          world.add(star);
          terrain.add(star);
        }
        else if (c == GOOMBA_COLOR) {
          FGoomba goomba = new FGoomba(x*gridSize, y*gridSize);
          goomba.setStroke(0, 0, 0, 0);
          goomba.setGrabbable(false);
          world.add(goomba);
          enemies.add(goomba);

          int leftWall = x - 1;
          while (leftWall >= 0) {
            color pixelColor = mapImg.get(leftWall, y);
            if (pixelColor == GROUND_COLOR || pixelColor == SLIME_COLOR || pixelColor == ICE_COLOR || pixelColor == BRIDGE_COLOR) {
              break;
            }
            leftWall--;
          }

          int rightWall = x + 1;
          while (rightWall < mapImg.width) {
            color pixelColor = mapImg.get(rightWall, y);
            if (pixelColor == GROUND_COLOR || pixelColor == SLIME_COLOR || pixelColor == ICE_COLOR || pixelColor == BRIDGE_COLOR) {
              break;
            }
            rightWall++;
          }

          FBox leftSensor = new FBox(gridSize/6, gridSize);
          leftSensor.setPosition(leftWall*gridSize + gridSize/2, y*gridSize);
          leftSensor.setStatic(true);
          leftSensor.setSensor(true);
          leftSensor.setName("wall");
          leftSensor.setNoStroke();
          leftSensor.setNoFill();
          world.add(leftSensor);

          FBox rightSensor = new FBox(gridSize/6, gridSize);
          rightSensor.setPosition(rightWall*gridSize - gridSize/2, y*gridSize);
          rightSensor.setStatic(true);
          rightSensor.setSensor(true);
          rightSensor.setName("wall");
          rightSensor.setNoStroke();
          rightSensor.setNoFill();
          world.add(rightSensor);
        }
        else if (c == THWOMP_COLOR) {
          FThwomp thwomp = new FThwomp(x*gridSize + gridSize/2, y*gridSize + gridSize/2);
          thwomp.setGrabbable(false);
          world.add(thwomp);
          enemies.add(thwomp);
        }
        else if (c == HAMMER_BRO_COLOR) {
          FHammerBro hammerBro = new FHammerBro(x*gridSize, y*gridSize);
          hammerBro.setStroke(0, 0, 0, 0);
          hammerBro.setGrabbable(false);
          world.add(hammerBro);
          enemies.add(hammerBro);

          int leftWall = x - 1;
          while (leftWall >= 0) {
            color pixelColor = mapImg.get(leftWall, y);
            if (pixelColor == GROUND_COLOR || pixelColor == SLIME_COLOR || pixelColor == ICE_COLOR || pixelColor == BRIDGE_COLOR) {
              break;
            }
            leftWall--;
          }

          int rightWall = x + 1;
          while (rightWall < mapImg.width) {
            color pixelColor = mapImg.get(rightWall, y);
            if (pixelColor == GROUND_COLOR || pixelColor == SLIME_COLOR || pixelColor == ICE_COLOR || pixelColor == BRIDGE_COLOR) {
              break;
            }
            rightWall++;
          }

          FBox leftSensor = new FBox(gridSize/6, gridSize);
          leftSensor.setPosition(leftWall*gridSize + gridSize/2, y*gridSize);
          leftSensor.setStatic(true);
          leftSensor.setSensor(true);
          leftSensor.setName("wall");
          leftSensor.setNoStroke();
          leftSensor.setNoFill();
          world.add(leftSensor);

          FBox rightSensor = new FBox(gridSize/6, gridSize);
          rightSensor.setPosition(rightWall*gridSize - gridSize/2, y*gridSize);
          rightSensor.setStatic(true);
          rightSensor.setSensor(true);
          rightSensor.setName("wall");
          rightSensor.setNoStroke();
          rightSensor.setNoFill();
          world.add(rightSensor);
        }
        continue;
      }

      box.setStatic(true);
      box.setStroke(0, 0, 0, 0);
      box.setPosition(x*gridSize, y*gridSize);
      box.setGrabbable(false);
      ground.addBody(box);
    }
  }

  // Second pass for doors
  for (int y = 0; y < mapImg.height; y++) {
    for (int x = 0; x < mapImg.width; x++) {
      color c = mapImg.get(x, y);

      if (c == DOOR_COLOR) {
        boolean isTopOfDoor = y == 0 || mapImg.get(x, y - 1) != DOOR_COLOR;
        if (!isTopOfDoor) continue;

        color leftColor = x > 0 ? mapImg.get(x - 1, y) : 0;
        color rightColor = x < mapImg.width - 1 ? mapImg.get(x + 1, y) : 0;

        boolean isLeft = false;
        color codeColor = 0;

        if (leftColor != DOOR_COLOR && leftColor != 0 && alpha(leftColor) > 0) {
          isLeft = true;
          codeColor = leftColor;
        }
        else if (rightColor != DOOR_COLOR && rightColor != 0 && alpha(rightColor) > 0) {
          isLeft = false;
          codeColor = rightColor;
        }

        FButton button = buttonsByCode.get(codeColor);
        if (button != null) {
          FDoor door = new FDoor(x * gridSize, y * gridSize, button, isLeft);
          door.setStatic(true);
          door.setStroke(0, 0, 0, 0);
          door.setGrabbable(false);
          world.add(door);
          doors.add(door);
        }
      }
    }
  }

  ground.setStatic(true);
  ground.setName("ground");
  ground.setGrabbable(false);
  world.add(ground);

  player = new FPlayer((int)spawnPos.x, (int)spawnPos.y);
  world.add(player);
  world.add(player.getFootSensor());
}

void nextLevel() {
  if (currentLevel >= totalLevels) {
    loadScene(GAMEOVER_SCENE);
  } else {
    loadLevel(currentLevel + 1);
  }
}
