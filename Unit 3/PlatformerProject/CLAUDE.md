# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a 2D platformer game built with Processing (Java) using the Fisica physics library (Box2D wrapper). The game features tile-based levels loaded from pixel maps, physics-based player movement, multiple enemy types, and a ghost recording/playback system.

## Architecture

### Core Structure
- **PlatformerProject.pde** - Main entry point containing game loop (`setup()`, `draw()`), asset loading, level parsing, input handling, and camera system
- **FGameObject.pde** - Base class extending Fisica's `FBox`, provides `update()` and `isTouching()` methods for all game entities

### Entity Classes (all extend FGameObject)
- **FPlayer** - Player with animations, input handling, jump/death logic
- **FGoomba** - Walking enemy that bounces off walls
- **FThwomp** - Falling crusher with 3-state machine (idle/falling/returning)
- **FHammerBro** - Walks and throws hammer projectiles at player
- **FGhost** - Plays back recorded player positions
- **FBridge** - Collapsible platform
- **FOneWayPlatform** - Drop-through platform (dynamically enables/disables collider)
- **FLava** - Animated hazard

### Level System
Levels are defined in `data/map.png` as a pixel art image. Each pixel color maps to a tile type.

The level loader auto-selects directional textures (corners, edges) based on neighboring tiles.

### Key Constants
- Window: 1600x1000, 120 FPS, P2D renderer
- Grid size: 64 pixels
- Physics gravity: 400 units down
- Player: 200 px/s horizontal, 470 px/s jump

### Controls
- WASD - Movement (W=jump, S=drop through platforms)
- R - Start/stop recording (max 480 frames)
- P - Play ghost recording

### Asset Structure
```
data/
├── map.png              # Level layout
├── background.png
├── Player/              # Player sprites (idle, jump, run animations)
├── Enemies/             # Goomba, Thwomp, HammerBro sprites
└── OGTerrain/           # Terrain textures with directional variants
```
