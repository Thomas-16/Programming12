int[][] cellOffsets = {
  {-1, -1},
  {0, -1},
  {1, -1},
  {-1, 0},
  {0, 0},
  {1, 0},
  {-1, 1},
  {0, 1},
  {1, 1}
};



void updateSpatialLookup(PVector[] points, float radius) {
  // Initialize spatial lookup array
  spatialLookup = new Entry[points.length];
  startIndices = new HashMap<Long, Integer>();
  
  // Create spatial lookup entries (unordered)
  for (int i = 0; i < points.length; i++) {
    PVector cellCoord = positionToCellCoord(points[i], radius);
    long cellHash = hashCell(cellCoord);
    long cellKey = getKeyFromHash(cellHash, points.length);
    spatialLookup[i] = new Entry(i, cellKey);
  }
  
  // Sort by cell key
  Arrays.sort(spatialLookup, new Comparator<Entry>() {
    public int compare(Entry a, Entry b) {
      return Long.compare(a.cellKey, b.cellKey);
    }
  });
  
  // Calculate start indices for each unique cell key
  for (int i = 0; i < points.length; i++) {
    long key = spatialLookup[i].cellKey;
    long keyPrev = (i == 0) ? Long.MAX_VALUE : spatialLookup[i - 1].cellKey;
    
    if (key != keyPrev) {
      startIndices.put(key, i);
    }
  }
}


PVector positionToCellCoord(PVector point, float radius) {
  int cellX = (int)(point.x / radius);
  int cellY = (int)(point.y / radius);
  return new PVector(cellX, cellY);
}

// Converts a cell's coordinate to a single number
// Hash collisions are unavoidable but whatever
long hashCell(PVector cell) {
  long a = (long)cell.x * 15823;
  long b = (long)cell.y * 973733;
  return a + b;
}

long getKeyFromHash(long hash, int tableLength) {
  return hash % (tableLength * 2);
}


class Entry {
  int particleIndex;
  long cellKey;
  
  Entry(int particleIndex, long cellKey) {
    this.particleIndex = particleIndex;
    this.cellKey = cellKey;
  }
}
