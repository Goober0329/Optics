//<>// //<>//

class Shape {
  ArrayList<Boundary> bounds;
  PShape shayp;
  color fill;

  float xpos, ypos;
  boolean selected = false;
  float mouseGrabX, mouseGrabY;

  PVector heading = new PVector(1, 0);

  final int STAY = 0, ROTATE = 1, SLIDE = 2, GROW = 3, ADJUST = 4;
  int state = STAY;

  Shape(ArrayList<PVector> points, color c) {
    this.fill = c;
    //translate points to Boundaries
    bounds = new ArrayList<Boundary>();
    for (int i = 0; i < points.size()-1; i++) {
      bounds.add(new Boundary(points.get(i).copy(), points.get(i+1).copy()));
    }
    updateCenter();
    updateShape();
  }

  Shape() {
    //only used for boundaryShape so I can redefine everything
    //ignore for all othher purposes
  }

  void show() {
    shape(shayp);
    if (selected)
      showSelected();
  }

  void showSelected() {
    //vertices
    fill(0);
    noStroke();
    for (Boundary b : bounds) {
      ellipse(b.a.x, b.a.y, 5, 5);
    }
    //orientation
    noFill();
    stroke(0);
    strokeWeight(1);
    line(xpos, ypos, xpos+heading.x*50, ypos+heading.y*50);
  }

  void update() {
    int v = setState();
    switch(state) {
    case STAY:
      break;
    case ROTATE:
      rotateTo(mouseX, mouseY);
      break;
    case SLIDE:
      moveTo(mouseX, mouseY);
      break;
    case GROW:
      adjustVertex(v, mouseX, mouseY, true);
      break;
    case ADJUST:
      adjustVertex(v, mouseX, mouseY, false);
      break;
    }

    updateCenter();
    updateShape();
  }

  void updateCenter() {
    xpos = 0;
    ypos = 0;
    for (int i = 0; i < bounds.size(); i++) {
      xpos += bounds.get(i).a.x;
      ypos += bounds.get(i).a.y;
    }
    xpos = xpos/bounds.size();
    ypos = ypos/bounds.size();
  }

  //rotates the shape by rotating each vertex around the grab point.
  void rotateTo(float mx, float my) {
    if (dist(mx, my, xpos, ypos) < 15)
      return;

    float angle = atan2(my-ypos, mx-xpos)-atan2(heading.y, heading.x);
    heading = (new PVector(mx-xpos, my-ypos)).normalize();

    float x, y, arm;
    PVector point;
    float prevAngle;
    for (Boundary b : bounds) {
      point = b.a; 
      x = point.x;
      y = point.y;
      prevAngle = atan2(y-ypos, x-xpos);
      arm = dist(xpos, ypos, x, y);
      x = arm*cos(angle+prevAngle)+xpos;
      y = arm*sin(angle+prevAngle)+ypos;
      b.setA(x, y);

      point = b.b; 
      x = point.x;
      y = point.y;
      prevAngle = atan2(y-ypos, x-xpos);
      arm = dist(xpos, ypos, x, y);
      x = arm*cos(angle+prevAngle)+xpos;
      y = arm*sin(angle+prevAngle)+ypos;
      b.setB(x, y);
    }
  }

  //returns the vertex that the mouse is on. -1 else
  int nearVertex() {
    int thresh = 15;
    float dist = 999999;
    float closestDist = dist;
    int toReturn = -1;
    for (int i = 0; i < bounds.size(); i++) {
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

  // adjusts boundaries associated with the vertex
  void adjustVertex(int which, float nx, float ny, boolean grow) {
    if (!grow) { //ADJUST INDIVIDUAL VERTTEX
      bounds.get(which).setA(nx, ny);
      if (which == 0) {
        bounds.get(bounds.size()-1).setB(nx, ny);
      } else {
        bounds.get(which-1).setB(nx, ny);
      }
    } else {  // ADJUST ALL VERTEX
      //https://math.stackexchange.com/questions/1563249/how-do-i-scale-a-triangle-given-its-cartesian-cooordinates
      //Narasimham and kccu for triangle scaling
      float mag = dist(nx, ny, xpos, ypos)/dist(bounds.get(which).a.x, bounds.get(which).a.y, xpos, ypos);
      Boundary temp;
      for (int i = 0; i < bounds.size(); i++) {
        temp = bounds.get(i);
        temp.setA(mag*(temp.a.x-xpos)+xpos, mag*(temp.a.y-ypos)+ypos);
        temp.setB(mag*(temp.b.x-xpos)+xpos, mag*(temp.b.y-ypos)+ypos);
      }
    }
  }

  //moves the shape
  void moveTo(float nx, float ny) {
    float dx = nx-mouseGrabX;
    float dy = ny-mouseGrabY;
    for (Boundary b : bounds) {
      PVector one = b.a; 
      PVector two = b.b; 
      b.setA(one.x+dx, one.y+dy);
      b.setB(two.x+dx, two.y+dy);
    }
    mouseGrabX = nx;
    mouseGrabY = ny;
  }

  // state order: rotate, slide, grow, adjust
  int setState() {
    boolean containsMouse = containsPoint(mouseX, mouseY);
    int v = nearVertex();

    if (mousePressed && keyPressed && keyCode == CONTROL && v == -1) { // check ROTATE
      if (state != ROTATE && containsMouse) {
        state = ROTATE;
      }
    } else if (mousePressed && v == -1) { // check SLIDE
      if (state != SLIDE && containsMouse) {
        state = SLIDE;
        mouseGrabX = mouseX;
        mouseGrabY = mouseY;
      }
    } else if (mousePressed && keyPressed && keyCode == CONTROL && v != -1) { // check GROW
      state = GROW;
    } else if (mousePressed && v != -1) { // check ADJUST
      state = ADJUST;
    } else { // nothing
      state = STAY;
    }

    if (state != STAY) {
      selected = true;
    } else if (mousePressed && state == STAY && !menu.mouseOverMenu()) {
      selected = false;
    }

    return v;
  }

  //create PShape for displaying
  void updateShape() {
    shayp = createShape();
    shayp.beginShape();
    shayp.stroke(line);
    shayp.fill(fill, 50);

    float u = map(bounds.get(0).a.x, 0, width, 0, 1);
    float v = map(bounds.get(0).b.y, 0, height, 0, 1);
    shayp.vertex(bounds.get(0).a.x, bounds.get(0).a.y, u, v);
    for (int i = 0; i < bounds.size(); i++) {
      u = map(bounds.get(i).b.x, 0, width, 0, 1);
      v = map(bounds.get(i).b.y, 0, height, 0, 1);
      shayp.vertex(bounds.get(i).b.x, bounds.get(i).b.y, u, v);
    }
    shayp.endShape();
  }

  // https://github.com/postspectacular/toxiclibs/blob/master/src.core/toxi/geom/Polygon2D.java
  boolean containsPoint(float px, float py) {
    int num = bounds.size();
    int i, j = num - 1;
    boolean oddNodes = false;
    for (i = 0; i < num; i++) {
      PVector vi = bounds.get(i).a;
      PVector vj = bounds.get(j).a;
      if (vi.y < py && vj.y >= py || vj.y < py && vi.y >= py) {
        if (vi.x + (py - vi.y) / (vj.y - vi.y) * (vj.x - vi.x) < px) {
          oddNodes = !oddNodes;
        }
      }
      j = i;
    }
    return oddNodes;
  }

  void changeGrab(float x, float y) {
    mouseGrabX = x;
    mouseGrabY = y;
  }

  void resetHeading() {
    heading = new PVector(1, 0);
  }

  void setBoundaries(ArrayList<Boundary> bs) {
    bounds = bs;
  }
}
