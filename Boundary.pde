class Boundary {
  PVector a, b;

  Boundary(PVector a, PVector b) {
    this.a = a;
    this.b = b;
  }

  void show(boolean show) {
    stroke(255);
    if (show)
      line(a.x, a.y, b.x, b.y);
  }

  void setA(float x, float y) {
    a.set(x, y);
  }

  void setB(float x, float y) {
    b.set(x, y);
  }
}

/**
 *
 *
 *
 *
 **/
class boundaryShape extends Shape {

  boolean released = true;

  boundaryShape(ArrayList<PVector> points, color c) {
    super();
    this.fill = c;
    //translate points to Boundaries
    bounds = new ArrayList<Boundary>();
    for (int i = 0; i < points.size()-1; i++) {
      bounds.add(new Boundary(points.get(i).copy(), points.get(i+1).copy()));
    }
    updateCenter();
    updateShape();
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
    ellipse(bounds.get(0).a.x, bounds.get(0).a.y, 5, 5);
    ellipse(bounds.get(bounds.size()-1).b.x, bounds.get(bounds.size()-1).b.y, 5, 5);

    //orientation
    noFill();
    stroke(0);
    strokeWeight(1);
    line(xpos, ypos, xpos+heading.x*50, ypos+heading.y*50);
  }

  void update() {
    setState();
    switch(state) {
    case STAY:
      break;
    case ROTATE:
      rotateTo(mouseX, mouseY);
      break;
    case SLIDE:
      moveTo(mouseX, mouseY);
      break;
    }
    updateCenter();
    updateShape();
  }

  // for boundaries, just show if it has been selected. Boundaries will be immutable once made.
  void setSelected() {
    boolean near = nearBoundaries();
    if (mousePressed && near && released) {
      selected = true;
    } else if (mousePressed && !near && released) {
      selected = false;
    }
    released = !mousePressed;
  }

  // state order: rotate, slide, grow, adjust
  int setState() {
    setSelected();

    if (mousePressed && keyPressed && keyCode == CONTROL) { // check ROTATE
      if (state != ROTATE && selected) {
        state = ROTATE;
      }
    } else if (mousePressed) { // check SLIDE
      if (state != SLIDE && selected) {
        state = SLIDE;
        mouseGrabX = mouseX;
        mouseGrabY = mouseY;
      }
    } else { // nothing
      state = STAY;
    }

    if (state != STAY) {
      selected = true;
    } else if (mousePressed && state == STAY && !menu.mouseOverMenu()) {
      selected = false;
    }

    return -1;
  }

  boolean nearBoundaries() {
    for (Boundary b : bounds) {
      float dist = distToLineSeg(b.a, b.b, new PVector(mouseX, mouseY));
      if (dist < 10)
        return true;
    }
    return false;
  }
}



// https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
// Grumdrig
float distToLineSeg(PVector v, PVector w, PVector p) {
  // Return minimum distance between line segment vw and point p
  float l2 = PVector.dist(v, w)*PVector.dist(v, w);  // i.e. |w-v|^2 -  avoid a sqrt
  if (l2 == 0.0) return PVector.dist(p, v);   // v == w case
  // Consider the line extending the segment, parameterized as v + t (w - v).
  // We find projection of point p onto the line. 
  // It falls where t = [(p-v) . (w-v)] / |w-v|^2
  // We clamp t from [0,1] to handle points outside the segment vw.
  float t = max(0, min(1, PVector.dot(PVector.sub(p, v), PVector.sub(w, v)) / l2));
  PVector projection = PVector.add(v, PVector.sub(w, v).mult(t));  // Projection falls on the segment
  return PVector.dist(p, projection);
}
