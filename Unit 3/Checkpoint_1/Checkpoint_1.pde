
import fisica.*;

//palette
color blue   = color(29, 178, 242);
color brown  = color(166, 120, 24);
color green  = color(74, 163, 57);
color red    = color(224, 80, 61);
color yellow = color(242, 215, 16);

//assets
PImage redBird;
PImage smileImg;

FPoly topPlatform; 
FPoly bottomPlatform;

PVector cloud1Pos = new PVector(-100, 200);
PVector cloud2Pos = new PVector(-300, 100);


//fisica
FWorld world;

RectButton gravityButton, spawningButton;

boolean isGravityOn = true;
boolean shouldSpawn = false;

void setup() {
  //make window
  size(800, 600);
  
  //load resources
  redBird = loadImage("red-bird.png");
  smileImg = loadImage("smile.png");
  smileImg.resize(50, 100);
  
  rectMode(CENTER);
  gravityButton = new RectButton(85, height-55, 160, 100, color(#bd5e2b), color(#301e14), color(#301e14), color(#8a4c2b), 3, 2);
  gravityButton.setOnClick(() -> {
    if(isGravityOn) 
      world.setGravity(0, 0);
    else 
      world.setGravity(0, 900);
      
    isGravityOn = !isGravityOn;
  });
  
  spawningButton = new RectButton(85, height-55 - 100 - 10, 160, 100, color(#2ec740), color(#1a401f), color(#1a401f), color(#24752e), 3, 2);
  spawningButton.setOnClick(() -> {
    shouldSpawn = !shouldSpawn;
  });
  
  //initialise world
  makeWorld();
  
  //add terrain to world
  makeTopPlatform();
  makeBottomPlatform();
}

//===========================================================================================

void makeWorld() {
  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 900);
}

//===========================================================================================


void makeTopPlatform() {
  topPlatform = new FPoly();

  //plot the vertices of this platform
  topPlatform.vertex(-100, 60);
  topPlatform.vertex(640, 240);
  topPlatform.vertex(640, 340);
  topPlatform.vertex(-100, 160);

  // define properties
  topPlatform.setStatic(true);
  topPlatform.setFillColor(brown);
  topPlatform.setFriction(0.1);
  topPlatform.setPosition(-170, 90);

  //put it in the world
  world.add(topPlatform);
}

//===========================================================================================

void makeBottomPlatform() {
  bottomPlatform = new FPoly();

  bottomPlatform.vertex(180, 500);
  bottomPlatform.vertex(280, 550);
  bottomPlatform.vertex(400, 580);
  bottomPlatform.vertex(520, 550);
  bottomPlatform.vertex(620, 500); 
  bottomPlatform.vertex(620, 600); 
  bottomPlatform.vertex(180, 600);  

  // define properties
  bottomPlatform.setStatic(true);
  bottomPlatform.setFillColor(brown);
  bottomPlatform.setFriction(0.6);
  bottomPlatform.adjustPosition(200, -50);

  // add to the world
  world.add(bottomPlatform);
}





//===========================================================================================

void draw() {
  println("x: " + mouseX + " y: " + mouseY);
  background(blue);
  
  drawCloud1();

  if (frameCount % 50 == 0 && shouldSpawn) {  //Every 20 frames ...
    makeCircle();
    makeBlob();
    makeBox();
    makeBird();
  }
  world.step();  //get box2D to calculate all the forces and new positions
  world.draw();  //ask box2D to convert this world to processing screen coordinates and draw
  
  gravityButton.draw();
  spawningButton.draw();
  
  drawCloud2();
}


void drawCloud1() {
  pushMatrix();
  translate(cloud1Pos.x, cloud1Pos.y);
  
  stroke(0);
  strokeWeight(2);
  fill(255);
  ellipse(0, 0, 200, 100);
  
  popMatrix();
  
  cloud1Pos.add(2, 0);
  if(cloud1Pos.x > width + 200) {
    cloud1Pos.set(-200, 200);
  }
}
void drawCloud2() {
  pushMatrix();
  translate(cloud2Pos.x, cloud2Pos.y);
  
  stroke(0);
  strokeWeight(2);
  fill(255);
  ellipse(0, 0, 150, 80);
  
  popMatrix();
  
  cloud2Pos.add(2.5, 0);
  if(cloud2Pos.x > width + 300) {
    cloud2Pos.set(-300, 100);
  }
}

//===========================================================================================

void makeCircle() {
  FCircle circle = new FCircle(50);
  circle.setPosition(random(100,width-100), -5);

  //set visuals
  circle.setStroke(0);
  circle.setStrokeWeight(2);
  circle.setFillColor(red);

  //set physical properties
  circle.setDensity(0.2);
  circle.setFriction(1);
  circle.setRestitution(1);

  //add to world
  world.add(circle);
}

//===========================================================================================

void makeBlob() {
  FBlob blob = new FBlob();

  //set visuals
  blob.setAsCircle(random(100,width-100), -5, 50);
  blob.setStroke(0);
  blob.setStrokeWeight(2);
  blob.setFillColor(yellow);

  //set physical properties
  blob.setDensity(0.2);
  blob.setFriction(1);
  blob.setRestitution(0.25);

  //add to the world
  world.add(blob);
}

//===========================================================================================

void makeBox() {
  FBox box = new FBox(50, 100);
  box.setPosition(random(100,width-100), -5);

  //set visuals
  box.setStroke(0);
  box.setStrokeWeight(2);
  box.setFillColor(green);

  //set physical properties
  box.setDensity(0.2);
  box.setFriction(1);
  box.setRestitution(1);
  
  box.attachImage(smileImg);
  world.add(box);
}

//===========================================================================================

void makeBird() {
  FCircle bird = new FCircle(48);
  bird.setPosition(random(100,width-100), -5);

  //set visuals
  bird.attachImage(redBird);

  //set physical properties
  bird.setDensity(0.8);
  bird.setFriction(1);
  bird.setRestitution(0.5);
  world.add(bird);
}

void mousePressed() {
  gravityButton.mousePressed();
  spawningButton.mousePressed();
}
void mouseReleased() {
  gravityButton.mouseReleased();
  spawningButton.mouseReleased();
}
