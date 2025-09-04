PVector[] positions;
PVector[] velocities;
float[] particleProperties;
float[] densities;

float particleSize = 0.02;  // In simulation units
float particleSpacing = 0.04;
int numParticles = 800;

float collisionDamping = 0.7;
float gravity = 0;
float smoothingRadius = 0.4;  // In simulation units
float mass = 1;

float targetDensity = 2.7;
float pressureMultiplier = 8;

float viscosityStrength = 0.1;

float maxSpeed = 2.5;

int lastTime = 0;

PImage bgImg;

// Simulation space dimensions
float simWidth;
float simHeight;

void setup() {
  frameRate = 120;
  size(1920, 1080);
  
  simWidth = 4.0 * (width/ (float) height);
  simHeight = 4.0;
  
  bgImg = new PImage(width, height);
  
  positions = new PVector[numParticles];
  velocities = new PVector[numParticles];
  particleProperties = new float[numParticles];
  densities = new float[numParticles];
  
  for(int i = 0; i < numParticles; i++) {
    positions[i] = new PVector(random(simWidth), random(simHeight));
    velocities[i] = new PVector(0, 0);
    particleProperties[i] = exampleFunction(positions[i]);
    
  }
  updateDensities();
  
  setupParticles();
  
  // Update background image
  bgImg.loadPixels();
  for(int pixel = 0; pixel < bgImg.width * bgImg.height; pixel++) {
    PVector screenPos = indexTo2D(pixel, width);
    PVector simPos = screenToSim(screenPos);
    
    //float density = calculateDensity(simPos);
    //color clr = lerpColor(color(0), color(#abf8ff), density/40);
    //bgImg.pixels[pixel] = clr;
    
    //bgImg.pixels[pixel] = color(map(exampleFunction(simPos), -1, 1, 0, 255));
    
    //float property = calculateProperty(simPos);
    //bgImg.pixels[pixel] = color(property * 40);
  }
  bgImg.updatePixels();
  
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
    particleProperties[i] = exampleFunction(positions[i]);
  }
  
  updateDensities();
}

void draw() {
  float deltaTime = (millis() - lastTime) / 1000.0;
  
  background(bgImg);
  
  noStroke();
  fill(#00aaf2);
  
  for (int i = 0; i < positions.length; i++) {
    velocities[i].add(new PVector(0, gravity * deltaTime));
    densities[i] = calculateDensity(positions[i]);
  }
  
  for (int i = 0; i < positions.length; i++) {
    PVector pressureForce = calculatePressureForce(i);
    PVector pressureAccel = PVector.div(pressureForce, densities[i]);
    velocities[i].add(PVector.mult(pressureAccel, deltaTime));
    
    PVector viscosityForce = calculateViscosityForce(i);
    velocities[i].add(PVector.mult(viscosityForce, deltaTime));
  }
  
  for (int i = 0; i < positions.length; i++) {
    positions[i].add(PVector.mult(velocities[i], deltaTime));
    resolveCollisions(i);
  }
  
  // Draw
  for (int i = 0; i < positions.length; i++) {
    // Calculate velocity magnitude
    float speed = velocities[i].mag();
    
    color particleColor = calculateParticleColor(speed);
    fill(particleColor);
    noStroke();
    
    // Convert to screen space for drawing
    PVector screenPos = simToScreen(positions[i]);
    float screenSize = particleSize * (height / simHeight);
    circle(screenPos.x, screenPos.y, screenSize * 2);
  }
  
  lastTime = millis();
  println(frameRate);
}

float densityToPressure(float density) {
  float densityError = density - targetDensity;
  float pressure = densityError * pressureMultiplier;
  return pressure;
}

PVector calculateViscosityForce(int particleIndex) {
  PVector viscosityForce = new PVector(0, 0);
  
  for(int i = 0; i < numParticles; i++) {
    if(particleIndex == i) continue;
    
    float dist = PVector.sub(positions[i], positions[particleIndex]).mag();
    if(dist < smoothingRadius && dist > 0) {
      PVector velocityDiff = PVector.sub(velocities[i], velocities[particleIndex]);
      float influence = viscosityKernel(smoothingRadius, dist);
      
      viscosityForce.add(PVector.mult(velocityDiff, 
        viscosityStrength * influence * mass / densities[i]));
    }
  }
  return viscosityForce;
}

PVector calculatePressureForce(int particleIndex) {
  PVector pressureForce = new PVector(0,0);
  
  for(int i = 0; i < numParticles; i++) {
    if(particleIndex == i) continue;
    
    float dist = PVector.sub(positions[i], positions[particleIndex]).mag();
    PVector dir = dist == 0 ? getRandomDir() : PVector.div(PVector.sub(positions[i], positions[particleIndex]), dist);
    
    float slope = spikyKernelDerivative(smoothingRadius, dist);
    float density = densities[i];
    float sharedPressure = calculateSharedPressure(density, densities[particleIndex]);
    pressureForce.add(PVector.mult(dir, sharedPressure * slope * mass / density));
  }
  
  return pressureForce;
}

float calculateSharedPressure(float densityA, float densityB) {
  float pressureA = densityToPressure(densityA);
  float pressureB = densityToPressure(densityB);
  return (pressureA + pressureB) / 2;
}

float calculateDensity(PVector samplePoint) {
  float density = 0;
  
  // TODO: avoid looping over every particle to calculate density
  // we only need to look at particles within the smoothing radius
  for(PVector position : positions) {
    float dist = PVector.sub(position, samplePoint).mag();
    if(dist < smoothingRadius) {
      float influence = poly6Kernel(smoothingRadius, dist);
      density += mass * influence;
    }
  }
  
  return density;
}

float calculateProperty(PVector samplePoint) {
  float property = 0;
  
  for(int i = 0; i < numParticles; i++) {
    float dist = PVector.sub(positions[i], samplePoint).mag();
    float influence = spikyKernel(smoothingRadius, dist);
    float density = densities[i];
    property += particleProperties[i] * influence * mass / density;
  }
  
  return property;
}

void updateDensities() {
  for(int i = 0; i < numParticles; i++) {
    densities[i] = calculateDensity(positions[i]);
  }
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

float exampleFunction(PVector pos) {
  return cos(pos.y * 3 - 3 + sin(pos.x * 3));
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

//float smoothingKernel(float radius, float dist) {
//  if(dist >= radius) return 0;
  
//  float volume = (PI * pow(radius, 4)) / 6;
//  return (radius - dist) * (radius - dist) / volume;
//}

//float smoothingKernelDerivative(float radius, float dist) {
//  if(dist >= radius) return 0;
  
//  float scale = 12 / (pow(radius, 4) * PI);
//  return (dist - radius) * scale;
//}

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
