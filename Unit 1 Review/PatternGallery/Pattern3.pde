
PShape leftShape, rightShape, topShape;
ArrayList<PVector> leftPosArr = new ArrayList<PVector>();
ArrayList<PVector> rightPosArr = new ArrayList<PVector>();
ArrayList<PVector> topPosArr = new ArrayList<PVector>();

double targetDistance = 151.3;
double moveDuration = 2000;
double pauseDuration = 500;

double cycleStartTime = 0;
double t = 0;
boolean isMoving = true;

ArrayList<PVector> leftOriginalPos = new ArrayList<PVector>();
ArrayList<PVector> rightOriginalPos = new ArrayList<PVector>();
ArrayList<PVector> topOriginalPos = new ArrayList<PVector>();
ArrayList<PVector> leftTargetPos = new ArrayList<PVector>();
ArrayList<PVector> rightTargetPos = new ArrayList<PVector>();
ArrayList<PVector> topTargetPos = new ArrayList<PVector>();

ArrayList<Float> leftDelays = new ArrayList<Float>();
ArrayList<Float> rightDelays = new ArrayList<Float>();
ArrayList<Float> topDelays = new ArrayList<Float>();
float maxDelay = 1000;

void pattern3Setup() {
  color leftColor = color(#85d079);
  color rightColor = color(#41ac90);
  color topColor = color(#ece862);
  color outlineColor = color(#297071);
  
  leftShape = createShape();
  leftShape.beginShape();
  leftShape.fill(leftColor);
  leftShape.stroke(outlineColor);
  leftShape.strokeWeight(2);
  leftShape.vertex(0, 0);
  leftShape.vertex(0, 100);
  leftShape.vertex(-44.44, 100-25.66);
  leftShape.vertex(-44.44, 25.66);
  leftShape.vertex(-85.83, 0);
  leftShape.vertex(-85.83, -51.32);
  leftShape.endShape(CLOSE);
  leftShape.setFill(leftColor);
  
  topShape = copyAndRotateShape(leftShape, radians(120));
  topShape.beginShape();
  topShape.fill(topColor);
  topShape.stroke(outlineColor);
  topShape.strokeWeight(2);
  topShape.endShape();
  
  rightShape = copyAndRotateShape(topShape, radians(120));
  rightShape.beginShape();
  rightShape.fill(rightColor);
  rightShape.stroke(outlineColor);
  rightShape.strokeWeight(2);
  rightShape.endShape();
  
  // init pos arrays
  for(double x = -300; x <= width + 300; x += 260.54) {
    for(double y = -300; y <= height + 300; y += 151.31) {
      PVector pos = new PVector((float)x, (float)y);
      leftOriginalPos.add(pos.copy());
      rightOriginalPos.add(pos.copy());
      topOriginalPos.add(pos.copy());
      
      leftPosArr.add(pos.copy());
      rightPosArr.add(pos.copy());
      topPosArr.add(pos.copy());
    }
  }
  
  for(double x = -300 -130.27; x <= width + 300; x += 260.54) {
    for(double y = -300 -151.31 + 76.97; y <= height + 300; y += 151.31) {
      PVector pos = new PVector((float)x, (float)y);
      leftOriginalPos.add(pos.copy());
      rightOriginalPos.add(pos.copy());
      topOriginalPos.add(pos.copy());
      
      leftPosArr.add(pos.copy());
      rightPosArr.add(pos.copy());
      topPosArr.add(pos.copy());
    }
  }
  
  calculateTargetPositions();
  calculateDelays();
  
  cycleStartTime = millis();
}

void calculateTargetPositions() {
  leftTargetPos.clear();
  rightTargetPos.clear();
  topTargetPos.clear();
  
  // Calculate targets from original positions
  for(int i = 0; i < leftOriginalPos.size(); i++) {
    PVector leftTarget = leftOriginalPos.get(i).copy();
    leftTarget.x += cos(radians(150)) * targetDistance;
    leftTarget.y += sin(radians(150)) * targetDistance;
    leftTargetPos.add(leftTarget);
    
    PVector rightTarget = rightOriginalPos.get(i).copy();
    rightTarget.x += cos(radians(30)) * targetDistance;
    rightTarget.y += sin(radians(30)) * targetDistance;
    rightTargetPos.add(rightTarget);
    
    PVector topTarget = topOriginalPos.get(i).copy();
    topTarget.x += cos(radians(-90)) * targetDistance;
    topTarget.y += sin(radians(-90)) * targetDistance;
    topTargetPos.add(topTarget);
  }
}

void drawPattern3() {
  double currentTime = millis();
  double elapsedTime = currentTime - cycleStartTime;
  
  if (isMoving) {
    boolean allFinished = true;
    
    for(int i = 0; i < leftPosArr.size(); i++) {
      float leftT = (float)((elapsedTime - leftDelays.get(i)) / moveDuration);
      float rightT = (float)((elapsedTime - rightDelays.get(i)) / moveDuration);
      float topT = (float)((elapsedTime - topDelays.get(i)) / moveDuration);
      
      leftT = constrain(leftT, 0, 1);
      rightT = constrain(rightT, 0, 1);
      topT = constrain(topT, 0, 1);
      
      leftT = easeInOut(leftT);
      rightT = easeInOut(rightT);
      topT = easeInOut(topT);
      
      // Lerp each shape
      leftPosArr.set(i, PVector.lerp(leftOriginalPos.get(i), leftTargetPos.get(i), leftT));
      rightPosArr.set(i, PVector.lerp(rightOriginalPos.get(i), rightTargetPos.get(i), rightT));
      topPosArr.set(i, PVector.lerp(topOriginalPos.get(i), topTargetPos.get(i), topT));
      
      if (leftT < 1.0 || rightT < 1.0 || topT < 1.0) {
        allFinished = false;
      }
    }
    
    if (allFinished) {
      isMoving = false;
      cycleStartTime = currentTime;
    }
  } else {
    // Pausing
    if (elapsedTime >= pauseDuration) {
      // Reset to original positions
      for(int i = 0; i < leftPosArr.size(); i++) {
        leftPosArr.set(i, leftOriginalPos.get(i).copy());
        rightPosArr.set(i, rightOriginalPos.get(i).copy());
        topPosArr.set(i, topOriginalPos.get(i).copy());
      }
      
      isMoving = true;
      cycleStartTime = currentTime;
      t = 0;
    }
  }
  
  // Draw all shapes
  pushMatrix();
  
  for(PVector pos : leftPosArr) {
    pushMatrix();
    translate(pos.x, pos.y);
    shape(leftShape);
    popMatrix();
  }
  
  for(PVector pos : rightPosArr) {
    pushMatrix();
    translate(pos.x, pos.y);
    shape(rightShape);
    popMatrix();
  }
  
  for(PVector pos : topPosArr) {
    pushMatrix();
    translate(pos.x, pos.y);
    shape(topShape);
    popMatrix();
  }
  
  popMatrix();
}

void calculateDelays() {
  leftDelays.clear();
  rightDelays.clear();
  topDelays.clear();
  
  float centerX = width / 2.0;
  float centerY = height / 2.0;
  float maxDistance = dist(0, 0, centerX, centerY);
  
  for(int i = 0; i < leftOriginalPos.size(); i++) {
    // Calculate distance from center
    float leftDist = dist(leftOriginalPos.get(i).x, leftOriginalPos.get(i).y, centerX, centerY);
    float rightDist = dist(rightOriginalPos.get(i).x, rightOriginalPos.get(i).y, centerX, centerY);
    float topDist = dist(topOriginalPos.get(i).x, topOriginalPos.get(i).y, centerX, centerY);
    
    // Calculate delay
    leftDelays.add((leftDist / maxDistance) * maxDelay);
    rightDelays.add((rightDist / maxDistance) * maxDelay);
    topDelays.add((topDist / maxDistance) * maxDelay);
  }
}

float easeInOut(float t) {
  return -(cos(PI * t) - 1) / 2;
}
