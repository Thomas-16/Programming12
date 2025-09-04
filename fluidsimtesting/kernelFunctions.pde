// ============ POLY6 KERNEL (for density) ============
// Smooth everywhere, good for density calculations
float poly6Kernel(float radius, float dist) {
  if (dist >= radius) return 0;
  
  float scale = 4.0 / (PI * pow(radius, 8));  // 2D normalization
  float diff = radius * radius - dist * dist;
  return scale * diff * diff * diff;
}

float poly6KernelDerivative(float radius, float dist) {
  if (dist >= radius) return 0;
  
  float scale = -24.0 / (PI * pow(radius, 8));  // 2D normalization
  float diff = radius * radius - dist * dist;
  return scale * dist * diff * diff;
}

// ============ SPIKY KERNEL (for pressure) ============
// Better for pressure - avoids particle clustering
float spikyKernel(float radius, float dist) {
  if (dist >= radius) return 0;
  
  float scale = 10.0 / (PI * pow(radius, 5));  // 2D normalization
  float diff = radius - dist;
  return scale * diff * diff * diff;
}

float spikyKernelDerivative(float radius, float dist) {
  if (dist >= radius) return 0;
  
  float scale = -30.0 / (PI * pow(radius, 5));  // 2D normalization
  float diff = radius - dist;
  return scale * diff * diff;
}

// ============ VISCOSITY KERNEL (for viscosity) ============
// Linear in distance, positive Laplacian everywhere
float viscosityKernel(float radius, float dist) {
  if (dist >= radius) return 0;
  
  float scale = 40.0 / (PI * pow(radius, 5));  // 2D normalization
  float term1 = -dist * dist * dist / (2 * radius * radius * radius);
  float term2 = dist * dist / (radius * radius);
  float term3 = radius / (2 * dist);
  return scale * (term1 + term2 + term3 - 1);
}

float viscosityKernelLaplacian(float radius, float dist) {
  if (dist >= radius) return 0;
  
  float scale = 40.0 / (PI * pow(radius, 5));  // 2D normalization
  return scale * (radius - dist);
}
