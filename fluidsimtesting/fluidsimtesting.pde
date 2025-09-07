import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.stream.IntStream;

PVector[] positions;
PVector[] velocities;
float[] densities;
PVector[] predictedPositions;

int gridCellsX;
int gridCellsY;

Entry[] spatialLookup;
HashMap<Long, Integer> startIndices;

float particleSize = 0.02;  // In simulation units
float particleSpacing = 0.04;
int numParticles = 1400;

float collisionDamping = 0.67;
float gravity = 0;
float smoothingRadius = 0.45;  // In simulation units
float mass = 1;

float targetDensity = 2.7;
float pressureMultiplier = 5;

float viscosityStrength = 0.04;

float interactionRadius = 0.5;
float interactionStrength = 60;

float maxSpeed = 2;
float minDistance = 0.01;
float maxForce = 600;

int lastTime = 0;

PImage bgImg;

// Simulation space dimensions
float simWidth;
float simHeight;

void setup() {
  frameRate = 120;
  
  // Experiemented with P2D renderer but it seems to be less efficient for some reason
  size(1280, 820);
  
  simWidth = 4.0 * (width/ (float) height);
  simHeight = 4.0;
  
  // Calculate grid dimensions
  gridCellsX = (int)ceil(simWidth / smoothingRadius);
  gridCellsY = (int)ceil(simHeight / smoothingRadius);
  
  bgImg = new PImage(width, height);
  
  positions = new PVector[numParticles];
  velocities = new PVector[numParticles];
  densities = new float[numParticles];
  predictedPositions = new PVector[numParticles];
  
  for(int i = 0; i < numParticles; i++) {
    positions[i] = new PVector(random(simWidth), random(simHeight));
    velocities[i] = new PVector(0, 0);
    predictedPositions[i] = positions[i].copy();
  }
  updateSpatialLookup(positions, smoothingRadius);
  updateDensities(positions);
  
  setupParticles();
  
  lastTime = millis();
}

void setupParticles() {
  int particlesPerRow = (int) sqrt(numParticles);
  int particlesPerCol = (numParticles - 1) / particlesPerRow + 1;
  float spacing = particleSize * 2 + particleSpacing;

  for(int i = 0; i < numParticles; i++) {
    float x = simWidth/2 + (i % particlesPerRow - particlesPerRow / 2f + 0.5f) * spacing;
    float y = simHeight/2 + (i / particlesPerRow - particlesPerCol / 2f + 0.5f) * spacing;
    positions[i] = new PVector(x, y);
    velocities[i] = new PVector(0, 0);
    predictedPositions[i] = positions[i].copy();
  }
  
  updateSpatialLookup(positions, smoothingRadius);
  updateDensities(positions);
  
}

void draw() {
  float deltaTime = min((millis() - lastTime) / 1000.0, 1.0/30.0);
  
  background(bgImg);
  
  noStroke();
  fill(#00aaf2);
  
  // Get mouse position in simulation space
  PVector mouseSimPos = screenToSim(new PVector(mouseX, mouseY));
  boolean isInteracting = mousePressed;
  
  // Make currentStrength final by initializing it in one statement
  final float currentStrength = mousePressed ? 
    ((mouseButton == LEFT) ? interactionStrength : -interactionStrength) : 0;
  
  // Apply forces in parallel
  IntStream.range(0, positions.length).parallel().forEach(i -> {
    // Check if particle is within interaction radius
    boolean affectedByInteraction = false;
    if (isInteracting) {
      float distToMouseSq = PVector.sub(mouseSimPos, positions[i]).magSq();
      affectedByInteraction = (distToMouseSq < interactionRadius * interactionRadius);
    }
    
    // Only apply gravity if not being interacted with
    if (!affectedByInteraction) {
      velocities[i].add(new PVector(0, gravity * deltaTime));
    }
    
    // Apply interaction force if mouse is pressed
    if (isInteracting && affectedByInteraction) {
      PVector intForce = interactionForce(mouseSimPos, interactionRadius, currentStrength, i);
      velocities[i].add(PVector.mult(intForce, deltaTime));
    }
    
    // Predict next positions
    predictedPositions[i] = PVector.add(positions[i], PVector.mult(velocities[i], 1 / 60.0));
  });
  
  // Update the spatial grid lookups
  updateSpatialLookup(predictedPositions, smoothingRadius);
  
  // update densities
  updateDensities(predictedPositions);
  
  // Calculate forces in parallel
  PVector[] pressureForces = new PVector[numParticles];
  PVector[] viscosityForces = new PVector[numParticles];
  
  IntStream.range(0, numParticles).parallel().forEach(i -> {
    pressureForces[i] = calculatePressureForce(predictedPositions, i);
    viscosityForces[i] = calculateViscosityForce(predictedPositions, i);
  });
  
  // Then apply forces sequentially
  for (int i = 0; i < numParticles; i++) {
    PVector pressureAccel = PVector.div(pressureForces[i], densities[i]);
    velocities[i].add(PVector.mult(pressureAccel, deltaTime));
    velocities[i].add(PVector.mult(viscosityForces[i], deltaTime));
  }
  
  // Update positions in parallel
  IntStream.range(0, positions.length).parallel().forEach(i -> {
    positions[i].add(PVector.mult(velocities[i], deltaTime));
    resolveCollisions(i);
  });
  
  
  // Draw interaction area indicator
  if (mousePressed) {
    noFill();
    stroke(255, 100);
    strokeWeight(2);
    PVector mouseScreenPos = simToScreen(mouseSimPos);
    float screenRadius = interactionRadius * (height / simHeight);
    circle(mouseScreenPos.x, mouseScreenPos.y, screenRadius * 2);
  }
  
  // Draw particles
  for (int i = 0; i < positions.length; i++) {
    float speed = velocities[i].mag();
    
    color particleColor = calculateParticleColor(speed);
    fill(particleColor);
    noStroke();
    
    PVector screenPos = simToScreen(positions[i]);
    float screenSize = particleSize * (height / simHeight);
    circle(screenPos.x, screenPos.y, screenSize * 2);
  }
  
  lastTime = millis();
  
  //println(frameRate);
}

float densityToPressure(float density) {
  float densityError = density - targetDensity;
  float pressure = densityError * pressureMultiplier;
  return pressure;
}

PVector calculateViscosityForce(PVector[] posArr, int particleIndex) {
  PVector viscosityForce = new PVector(0, 0);
  PVector particlePos = posArr[particleIndex];
  
  PVector centerCell = positionToCellCoord(particlePos, smoothingRadius);
  int centerX = (int)centerCell.x;
  int centerY = (int)centerCell.y;
  
  // Loop over 3x3 grid of cells
  for (int[] offset : cellOffsets) {
    int cellX = centerX + offset[0];
    int cellY = centerY + offset[1];
    
    if (cellX < 0 || cellY < 0 || cellX >= gridCellsX || cellY >= gridCellsY) continue;
    
    long cellHash = hashCell(new PVector(cellX, cellY));
    long key = getKeyFromHash(cellHash, numParticles);
    
    Integer cellStartIndex = startIndices.get(key);
    if (cellStartIndex == null) continue;
    
    // Loop over particles in this cell
    for (int i = cellStartIndex; i < spatialLookup.length; i++) {
      if (spatialLookup[i].cellKey != key) break;
      
      int neighborIndex = spatialLookup[i].particleIndex;
      if (neighborIndex == particleIndex) continue;
      
      float dist = PVector.sub(posArr[neighborIndex], particlePos).mag();
      
      if (dist > 0 && dist <= minDistance) {
        dist = minDistance;
      } else if (dist < 0 && dist >= -minDistance) {
        dist = -minDistance;
      }
      
      if (dist < smoothingRadius && dist > 0) {
        PVector velocityDiff = PVector.sub(velocities[neighborIndex], velocities[particleIndex]);
        float influence = viscosityKernel(smoothingRadius, dist);
        
        viscosityForce.add(PVector.mult(velocityDiff, 
          viscosityStrength * influence * mass / densities[neighborIndex]));
      }
    }
  }
  
  return viscosityForce;
}

PVector calculatePressureForce(PVector[] posArr, int particleIndex) {
  PVector pressureForce = new PVector(0, 0);
  PVector particlePos = posArr[particleIndex];
  
  PVector centerCell = positionToCellCoord(particlePos, smoothingRadius);
  int centerX = (int)centerCell.x;
  int centerY = (int)centerCell.y;
  
  // Loop over 3x3 grid of cells
  for (int[] offset : cellOffsets) {
    int cellX = centerX + offset[0];
    int cellY = centerY + offset[1];
    
    if (cellX < 0 || cellY < 0 || cellX >= gridCellsX || cellY >= gridCellsY) continue;
    
    long cellHash = hashCell(new PVector(cellX, cellY));
    long key = getKeyFromHash(cellHash, numParticles);
    
    Integer cellStartIndex = startIndices.get(key);
    if (cellStartIndex == null) continue;
    
    // Loop over particles in this cell
    for (int i = cellStartIndex; i < spatialLookup.length; i++) {
      if (spatialLookup[i].cellKey != key) break;
      
      int neighborIndex = spatialLookup[i].particleIndex;
      if (neighborIndex == particleIndex) continue;
      
      float distSq = PVector.sub(posArr[neighborIndex], particlePos).magSq();
      
      // Only process if within smoothing radius
      if (distSq < smoothingRadius * smoothingRadius) {
        float dist = sqrt(distSq);
        dist = max(dist, minDistance);
        
        PVector dir = dist == 0 ? getRandomDir() : 
          PVector.div(PVector.sub(posArr[neighborIndex], particlePos), dist);
        
        float slope = spikyKernelDerivative(smoothingRadius, dist);
        slope = constrain(slope, -1000, 1000);
        float density = densities[neighborIndex];
        float sharedPressure = calculateSharedPressure(density, densities[particleIndex]);
        PVector forceContribution = PVector.mult(dir, sharedPressure * slope * mass / density);
        
        //if (forceContribution.magSq() > maxForce * maxForce) {
        //  forceContribution.setMag(maxForce);
        //}
        
        pressureForce.add(forceContribution);
      }
    }
  }
  
  return pressureForce;
}

float calculateSharedPressure(float densityA, float densityB) {
  float pressureA = densityToPressure(densityA);
  float pressureB = densityToPressure(densityB);
  return (pressureA + pressureB) / 2;
}

float calculateDensity(PVector[] posArr, PVector samplePoint) {
  float density = 0;
  
  PVector centerCell = positionToCellCoord(samplePoint, smoothingRadius);
  int centerX = (int)centerCell.x;
  int centerY = (int)centerCell.y;
  
  // Loop over 3x3 grid of cells
  for (int[] offset : cellOffsets) {
    int cellX = centerX + offset[0];
    int cellY = centerY + offset[1];
    
    if (cellX < 0 || cellY < 0 || cellX >= gridCellsX || cellY >= gridCellsY) continue;
    
    long cellHash = hashCell(new PVector(cellX, cellY));
    long key = getKeyFromHash(cellHash, numParticles);
    
    Integer cellStartIndex = startIndices.get(key);
    if (cellStartIndex == null) continue;
    
    // Loop over particles in this cell
    for (int i = cellStartIndex; i < spatialLookup.length; i++) {
      if (spatialLookup[i].cellKey != key) break;
      
      int particleIndex = spatialLookup[i].particleIndex;
      float distSq = PVector.sub(posArr[particleIndex], samplePoint).magSq();
      
      if (distSq < smoothingRadius * smoothingRadius) {
        float dist = sqrt(distSq);
        float influence = poly6Kernel(smoothingRadius, dist);
        density += mass * influence;
      }
    }
  }
  
  return density;
}


void updateDensities(PVector[] posArr) {
  IntStream.range(0, numParticles).parallel().forEach(i -> {
    densities[i] = calculateDensity(posArr, posArr[i]);
  });
}
PVector interactionForce(PVector inputPos, float radius, float strength, int particleIndex) {
  PVector interactionForce = new PVector(0, 0);
  PVector offset = PVector.sub(inputPos, positions[particleIndex]);
  float sqrDist = PVector.dot(offset, offset);
  
  if(sqrDist < radius * radius) {
    float dist = sqrt(sqrDist);
    PVector dirToInputPoint = dist <= 0 ? new PVector(0, 0) : PVector.div(offset, dist);
    
    if(strength > 0) {
      // Pushing
      float centreT = 1 - dist / radius;
      interactionForce.add(PVector.mult(PVector.sub(PVector.mult(dirToInputPoint, strength), velocities[particleIndex]), centreT));
    } else {
      // Pulling
      // Only apply force if particle is trying to escape the radius
      // This creates a "soft boundary" effect
      float edgeDistance = radius - dist;
      float edgeFalloff = 1 - (edgeDistance / radius); // Stronger force near edge
      
      // Apply damping to velocity to "hold" the particles
      PVector dampingForce = PVector.mult(velocities[particleIndex], -0.8);
      
      // Only pull if particle is near the edge of the radius
      if(edgeFalloff > 0.5) {
        PVector pullForce = PVector.mult(dirToInputPoint, strength * edgeFalloff);
        interactionForce.add(pullForce);
      }
      interactionForce.add(dampingForce);
    }
  }
  
  return interactionForce;
}

void resolveCollisions(int particleIndex) {
  PVector position = positions[particleIndex];
  PVector velocity = velocities[particleIndex];
  
  // Boundaries in simulation space
  if(position.x - particleSize < 0) {
    position.x = particleSize;
    velocity.x *= -collisionDamping;
  }
  if(position.x + particleSize > simWidth) {
    position.x = simWidth - particleSize;
    velocity.x *= -collisionDamping;
  }
  if(position.y - particleSize < 0) {
    position.y = particleSize;
    velocity.y *= -collisionDamping;
  }
  if(position.y + particleSize > simHeight) {
    position.y = simHeight - particleSize;
    velocity.y *= -collisionDamping;
  }
}

color calculateParticleColor(float speed) {
  float t = constrain(speed / maxSpeed, 0, 1);
  
  if (t < 0.25) {
    // Blue to Cyan
    return lerpColor(color(0, 100, 255), color(0, 255, 255), t * 4);
  } else if (t < 0.5) {
    // Cyan to Green
    return lerpColor(color(0, 255, 255), color(0, 255, 0), (t - 0.25) * 4);
  } else if (t < 0.75) {
    // Green to Yellow
    return lerpColor(color(0, 255, 0), color(255, 255, 0), (t - 0.5) * 4);
  } else {
    // Yellow to Red
    return lerpColor(color(255, 255, 0), color(255, 50, 0), (t - 0.75) * 4);
  }
}

PVector indexTo2D(int index, int width) {
  return new PVector(index % width, index / width);
}

PVector screenToSim(PVector screenPos) {
  float x = screenPos.x * simWidth / width;
  float y = screenPos.y * simHeight / height;
  return new PVector(x, y);
}

PVector simToScreen(PVector simPos) {
  float x = simPos.x * width / simWidth;
  float y = simPos.y * height / simHeight;
  return new PVector(x, y);
}
PVector getRandomDir() {
  float angle = random(TWO_PI);
  return new PVector(cos(angle), sin(angle));
}
