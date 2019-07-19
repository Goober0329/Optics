
class Ray {

  int offscreen = 1000;

  PVector start = null;
  PVector dir = null;
  PVector end = null;
  int bright;

  float index;
  boolean outside;

  Ray(float x, float y, float angle, int br, float ind, boolean out) {
    start = new PVector(x, y);
    dir = PVector.fromAngle(angle);
    bright = br;
    index = ind;
    outside = out;
  }

  void show() {
    stroke(bright);
    if (end != null) {
      line(this.start.x, this.start.y, end.x, end.y);
    } else {
      line(this.start.x, this.start.y, this.start.x+this.dir.x*offscreen, this.start.y+this.dir.y*offscreen);
    }
  }

  // https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
  PVector cast(Boundary wall) {
    PVector toReturn = null;

    float x1 = wall.a.x;
    float y1 = wall.a.y;
    float x2 = wall.b.x;
    float y2 = wall.b.y; 

    float x3 = start.x;
    float y3 = start.y;
    float x4 = start.x+dir.x;
    float y4 = start.y+dir.y;
    float m = (y4-y3)/(x4-x3);

    float denom = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);
    if (denom == 0) {
      //println(toReturn);
      return null;
    }
    float t = ((x1-x3)*(y3-y4)-(y1-y3)*(x3-x4))/denom;
    float u = -((x1-x2)*(y1-y3)-(y1-y2)*(x1-x3))/denom;
    if (t > 0 && t < 1 && u > 0) {
      float px = x1+t*(x2-x1);
      float py = y1+t*(y2-y1);
      if (px == start.x && py == start.y) {
        //println(toReturn);
        return null;
      }
      toReturn = new PVector(px, py);
    }

    //check if it hits the wall end points exactly.
    int todo; //I don't think this is working correctly. Occasionally the ray still goes straight through the material. 
    // It could be due to it hitting and enpoint exactly or it could be something else.

    if (y4-y1 == m*(x4-x1)) {
      toReturn = new PVector(x1, y1);
    } else if (y4-y2 == m*(x4-x2)) {
      toReturn = new PVector(x2, y2);
    }

    //println(toReturn);
    return toReturn;
  }
}
