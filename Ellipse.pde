 //<>// //<>//
class Ellipse extends Shape {
  Ellipse(ArrayList<PVector> points, color c) {
    super(points, c);
  }

  void showSelected() {
    //vertices
    fill(0);
    noStroke();
    for (int i = 0; i < bounds.size(); i += bounds.size()/4) {
      ellipse(bounds.get(i).a.x, bounds.get(i).a.y, 5, 5);
    }
    //orientation
    noFill();
    stroke(0);
    strokeWeight(1);
    line(xpos, ypos, xpos+heading.x*50, ypos+heading.y*50);
  }

  //returns the vertex that the mouse is on. -1 else
  int nearVertex() {
    int thresh = 15;
    float dist = 999999;
    float closestDist = dist;
    int toReturn = -1;
    // only check 4 points.
    for (int i = 0; i < bounds.size(); i+=bounds.size()/4) {
      dist = dist(bounds.get(i).a.x, bounds.get(i).a.y, mouseX, mouseY);
      if (dist < closestDist) { 
        toReturn = i;
        closestDist = dist;
      }
    }

    if (state == ADJUST || state == GROW || (closestDist < thresh && state == STAY)) {
      return toReturn;
    } else {
      return -1;
    }
  }

  // adjusts width and height of ellipse based on vertex choosen
  void adjustVertex(int which, float nx, float ny, boolean grow) {
    if (grow) {
      super.adjustVertex(which, nx, ny, grow);
      return;
    }

    int step = bounds.size()/4;
    float h, w;
    w = dist(bounds.get(0).a.x, bounds.get(0).a.y, bounds.get(step*2).a.x, bounds.get(step*2).a.y);
    h = dist(bounds.get(step).a.x, bounds.get(step).a.y, bounds.get(step*3).a.x, bounds.get(step*3).a.y);

    float delta = dist(nx, ny, xpos, ypos) - dist(xpos, ypos, bounds.get(which).a.x, bounds.get(which).a.y);
    if (which == 0 || which == step*2) {
      w += delta;
    } else {
      h += delta;
    }

    bounds = new ArrayList<Boundary>();
    ArrayList<PVector> points = ellipPoints(xpos, ypos, h, w);
    float head = heading.heading();
    for (int i = 0; i < points.size()-1; i++) {
      bounds.add(new Boundary(points.get(i).copy(), points.get(i+1).copy()));
    }

    changeGrab(xpos, ypos);
    resetHeading();
    rotateTo(xpos+cos(head)*20, ypos+sin(head)*20);
    updateShape();
  }
}

// https://www.mathopenref.com/coordparamellipse.html
ArrayList<PVector> ellipPoints(float x, float y, float h, float w) {
  ArrayList<PVector> toReturn = new ArrayList<PVector>();
  int numSections = 100;
  for (int i = 0; i <= numSections; i++) {
    float tempx = (w/2)*cos(TWO_PI*i/numSections);
    float tempy = (h/2)*sin(TWO_PI*i/numSections);
    toReturn.add((new PVector(tempx+x, tempy+y)));
  }
  return toReturn;
}
