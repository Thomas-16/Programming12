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

ArrayList<PVector> leftStartPos = new ArrayList<PVector>();
ArrayList<PVector> rightStartPos = new ArrayList<PVector>();
ArrayList<PVector> topStartPos = new ArrayList<PVector>();
ArrayList<PVector> leftTargetPos = new ArrayList<PVector>();
ArrayList<PVector> rightTargetPos = new ArrayList<PVector>();
ArrayList<PVector> topTargetPos = new ArrayList<PVector>();

void pattern2Setup() {
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
      leftPosArr.add(pos.copy());
      rightPosArr.add(pos.copy());
      topPosArr.add(pos.copy());
      
      leftStartPos.add(pos.copy());
      rightStartPos.add(pos.copy());
      topStartPos.add(pos.copy());
    }
  }
  
  for(double x = -300 -130.27; x <= width + 300; x += 260.54) {
    for(double y = -300 -151.31 + 76.97; y <= height + 300; y += 151.31) {
      PVector pos = new PVector((float)x, (float)y);
      leftPosArr.add(pos.copy());
      rightPosArr.add(pos.copy());
      topPosArr.add(pos.copy());
      
      leftStartPos.add(pos.copy());
      rightStartPos.add(pos.copy());
      topStartPos.add(pos.copy());
    }
  }
  
  calculateTargetPositions();
  cycleStartTime = millis();
}

void calculateTargetPositions() {
  leftTargetPos.clear();
  rightTargetPos.clear();
  topTargetPos.clear();
  
  for(int i = 0; i < leftStartPos.size(); i++) {
    PVector leftTarget = leftStartPos.get(i).copy();
    leftTarget.x += cos(radians(150)) * targetDistance;
    leftTarget.y += sin(radians(150)) * targetDistance;
    leftTargetPos.add(leftTarget);
    
    PVector rightTarget = rightStartPos.get(i).copy();
    rightTarget.x += cos(radians(30)) * targetDistance;
    rightTarget.y += sin(radians(30)) * targetDistance;
    rightTargetPos.add(rightTarget);
    
    PVector topTarget = topStartPos.get(i).copy();
    topTarget.x += cos(radians(-90)) * targetDistance;
    topTarget.y += sin(radians(-90)) * targetDistance;
    topTargetPos.add(topTarget);
  }
}

void drawPattern2() {
  double currentTime = millis();
  double elapsedTime = currentTime - cycleStartTime;
  
  if (isMoving) {
    t = elapsedTime / moveDuration;
    
    if (t >= 1.0) {
      t = 1.0;
      isMoving = false;
      cycleStartTime = currentTime;
      
      // snap in place so it doesnt overshoot
      for(int i = 0; i < leftPosArr.size(); i++) {
        leftPosArr.set(i, leftTargetPos.get(i));
        rightPosArr.set(i, leftTargetPos.get(i));
        topPosArr.set(i, leftTargetPos.get(i));
      }
    }
    
    // Move shapes by lerping
    for(int i = 0; i < leftPosArr.size(); i++) {
      leftPosArr.set(i, PVector.lerp(leftStartPos.get(i), leftTargetPos.get(i), (float)t));
      rightPosArr.set(i, PVector.lerp(rightStartPos.get(i), rightTargetPos.get(i), (float)t));
      topPosArr.set(i, PVector.lerp(topStartPos.get(i), topTargetPos.get(i), (float)t));
    }
  } else {
    // Pausing
    if (elapsedTime >= pauseDuration) {
      // Set current positions as new start positions
      for(int i = 0; i < leftPosArr.size(); i++) {
        leftStartPos.set(i, leftPosArr.get(i).copy());
        rightStartPos.set(i, rightPosArr.get(i).copy());
        topStartPos.set(i, topPosArr.get(i).copy());
      }
      
      // Calculate new targets from the new start positions
      calculateTargetPositions();
      
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
