//<>// //<>// //<>// //<>//
// point order during shape construction
// left, bottom, right, top

class Rectangle extends Shape {

  Rectangle(ArrayList<PVector> points, color c) {
    super(points, c);
  }

  void adjustVertex(int which, float nx, float ny, boolean grow) {
    if (grow) {
      super.adjustVertex(which, nx, ny, grow);
      return;
    }

    Boundary forw, forww, back, backk;
    PVector forwDir, backDir, intersect;
    if (which == 0) {
      forw = bounds.get(0);
      forww = bounds.get(1);
      back = bounds.get(3);
      backk = bounds.get(2);
    } else if (which == 1) {
      forw = bounds.get(1);
      forww = bounds.get(2);
      back = bounds.get(0);
      backk = bounds.get(3);
    } else if (which == 2) {
      forw = bounds.get(2);
      forww = bounds.get(3);
      back = bounds.get(1);
      backk = bounds.get(0);
    } else {
      forw = bounds.get(3);
      forww = bounds.get(0);
      back = bounds.get(2);
      backk = bounds.get(1);
    }
    forwDir = (new PVector(forw.b.x-forw.a.x, forw.b.y-forw.a.y)).normalize();
    backDir = (new PVector(back.a.x-back.b.x, back.a.y-back.b.y)).normalize();

    //vertex being moved
    forw.a.x = nx;
    forw.a.y = ny;
    back.b.x = nx;
    back.b.y = ny;

    //forward vertex being adjusted
    intersect = intersection(forw.a, PVector.add(forw.a, forwDir), forww.a, forww.b);
    if (intersect != null) {
      forw.b.x = intersect.x;
      forw.b.y = intersect.y;
      forww.a.x = intersect.x;
      forww.a.y = intersect.y;
    } else {
      println("forward intersect is null.... It shouldn't be.");
    }

    //backward vertex being adjusted
    intersect = intersection(back.b, PVector.add(back.b, backDir), backk.a, backk.b);
    if (intersect != null) {
      back.a.x = intersect.x;
      back.a.y = intersect.y;
      backk.b.x = intersect.x;
      backk.b.y = intersect.y;
    } else {
      println("backward intersect is null.... It shouldn't be.");
    }
  }
}

ArrayList<PVector> rectPoints(float x, float y, float w, float h) {
  ArrayList<PVector> toReturn = new ArrayList<PVector>();
  toReturn.add(new PVector(x-w/2, y-h/2));
  toReturn.add(new PVector(x-w/2, y+h/2));
  toReturn.add(new PVector(x+w/2, y+h/2));
  toReturn.add(new PVector(x+w/2, y-h/2));
  toReturn.add(new PVector(x-w/2, y-h/2));
  return toReturn;
}

// https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
PVector intersection(PVector b1a, PVector b1b, PVector b2a, PVector b2b) {
  float x1 = b1a.x;
  float y1 = b1a.y;
  float x2 = b1b.x;
  float y2 = b1b.y; 

  float x3 = b2a.x;
  float y3 = b2a.y;
  float x4 = b2b.x;
  float y4 = b2b.y;

  float denom = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);
  if (denom == 0) 
    return null;

  float px = ((x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4))/denom;
  float py = ((x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4))/denom;
  return new PVector(px, py);
}
