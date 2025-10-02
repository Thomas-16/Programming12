
Spaceship player;

void gameSetup() {
  player = new Spaceship();
}

void gameDraw() {
  player.update();
  player.draw();
}
