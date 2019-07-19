 //<>//
void mouseReleased() {
  if (createOwn || createBoundaries) {
    float dist = -1;
    if (createOwn) {
      dist = tempPoints.size() >= 3 ? dist(tempPoints.get(0).x, tempPoints.get(0).y, mouseX, mouseY) : -1;
    }
    if (createBoundaries) {
      dist = tempPoints.size() >= 1 ? dist(tempPoints.get(tempPoints.size()-1).x, tempPoints.get(tempPoints.size()-1).y, mouseX, mouseY) : -1;
    }
    // If you are clicking on the finishing point then it is complete.
    if (dist >= 0 && dist <= 15) {
      if (createOwn) {
        tempPoints.add(tempPoints.get(0));
        doodads.add(new Doodad(tempPoints, true, menu.material));
        createOwn = false;
      }
      if (createBoundaries) {
        tempPoints.add(new PVector(mouseX, mouseY)); //technically it has at least 2 boundaries, this allows shape creation
        doodads.add(new Doodad(tempPoints, false, menu.material));
        createBoundaries = false;
      }
    } else {
      tempPoints.add(new PVector(mouseX, mouseY));
    }
  }
}



boolean debug = false;
void keyReleased() {
  if (key == 'd')
    debug = !debug;
}
