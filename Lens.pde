//<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
class Lens extends Shape {

  Lens(ArrayList<PVector> points, color c) {
    super(points, c);
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
    int step = bounds.size()/4;
    xpos = lerp(bounds.get(0).a.x, bounds.get(step*2).a.x, 0.5);
    ypos = lerp(bounds.get(0).a.y, bounds.get(step*2).a.y, 0.5);
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

    // Giant try catch block. It's ugly, but necessary because I can't find all of the bugs.... :(
    try {
      int step = bounds.size()/4;
      float h = PVector.dist(bounds.get(0).a, bounds.get(step*2).a);
      PVector lc = threePointCenter(bounds.get(step*4-1).a, bounds.get(step*3).a, bounds.get(step*2).b);
      float lr = (lc == null ? -1 : PVector.dist(lc, bounds.get(step*3).a));
      PVector rc = threePointCenter(bounds.get(0).b, bounds.get(step).a, bounds.get(step*2-1).a);
      float rr = (rc == null ? -1 : PVector.dist(rc, bounds.get(step).a));
      float lw = PVector.dist(bounds.get(0).a, bounds.get(0).b);
      float rw = PVector.dist(bounds.get(0).a, bounds.get(step*4-1).a);
      float minConDist = 10;
      int lcon = (rc == null ? 0 : ((rc.x-bounds.get(step).a.x > minConDist) ? 1 : ((rc.x-bounds.get(step).a.x < -minConDist) ? -1 : 0)));
      int rcon = (lc == null ? 0 : ((lc.x-bounds.get(step*3).a.x > minConDist) ? -1 : ((lc.x-bounds.get(step*3).a.x < -minConDist) ? 1 : 0)));
      float newLW = lw, newRW = rw, newH = h, newLR = lr, newRR = rr;

      float delta = 0;
      if (which == 0 || which == step*2) { // change in height, not in radius
        PVector center = PVector.add(bounds.get(0).a, bounds.get(step*2).a).div(2);
        delta = dist(nx, ny, center.x, center.y) - dist(bounds.get(which).a.x, bounds.get(which).a.y, center.x, center.y);
        newH = h + delta*2;

        PVector[] intersects = twoCircleIntersect(lc, lr, rc, rr);
        if (intersects != null && newH >= intersects[0].dist(intersects[1]) && intersects[0].dist(intersects[1]) >= h) { // do intersect
          newH = intersects[0].dist(intersects[1]);
          newLW = 0;
          newRW = 0;
        } else { // adjust width as necessary depending on newH and the calculated linear intersects with each circle.
          float scale = newH/h;
          PVector offset, p1, p2, intersect;
          boolean cont = true;

          // newLW 
          center = PVector.add(bounds.get(0).a, bounds.get(step*2).a).div(2);
          p1 = new PVector(lerp(center.x, bounds.get(step*2).a.x, scale), lerp(center.y, bounds.get(step*2).a.y, scale));
          offset = heading.copy().mult(-5);
          p2 = new PVector(lerp(PVector.add(center, offset).x, bounds.get(step*2-1).a.x, scale), lerp(PVector.add(center, offset).y, bounds.get(step*2-1).a.y, scale));
          if (rc != null) {
            intersect = circleLineClosestIntersect(p1, p2, rc, rr, p2);
          } else {
            intersect = lineLineIntersection(p1, p2, bounds.get(step).a, bounds.get(step).b);
          }

          if (intersect != null && cont) {
            newLW = intersect.dist(p1);
          } else {
            newH = h;
            newLW = lw;
            newRW = rw;
            cont = false;
          }

          // newRW
          center = PVector.add(bounds.get(0).a, bounds.get(step*2).a).div(2);
          p1 = new PVector(lerp(center.x, bounds.get(step*2).a.x, scale), lerp(center.y, bounds.get(step*2).a.y, scale));
          offset = heading.copy().mult(5);
          p2 = new PVector(lerp(PVector.add(center, offset).x, bounds.get(step*2).b.x, scale), lerp(PVector.add(center, offset).y, bounds.get(step*2).b.y, scale));
          if (lc != null) {
            intersect = circleLineClosestIntersect(p1, p2, lc, lr, p2);
          } else {
            intersect = lineLineIntersection(p1, p2, bounds.get(step*3).a, bounds.get(step*3).b);
          }
          if (intersect != null && cont) {
            newRW = intersect.dist(p1);
          } else {
            newH = h;
            newLW = lw;
            newRW = rw;
            cont = false;
          }
        }
      }

      PVector nxny = new PVector(nx, ny);
      int newLCON = lcon;
      if (which == step) { // change in right radius only (left lens)
        PVector top = bounds.get(step*2-1).a;
        PVector right = PVector.add(bounds.get(0).b, top).div(2);
        float distPlane = right.x-nxny.x;
        if (abs(distPlane) < minConDist) {
          newLCON = 0;
        } else {
          if (distPlane < 0) {
            newLCON = -1;
          } else {
            newLCON = 1;
          }
          PVector newCenter = threePointCenter(bounds.get(0).b, nxny, bounds.get(step*2-1).a);
          newRR = newCenter.dist(nxny);
          if (abs(newRR-h/2) < 0.3) {
            newRR = h/2;
          }
        }
      }

      int newRCON = rcon;
      if (which == step*3) { // change in left radius only (right lens)
        PVector top = bounds.get(step*2).b;
        PVector right = PVector.add(bounds.get(step*4-1).a, top).div(2);
        float distPlane = right.x-nxny.x;
        if (abs(distPlane) < minConDist) {
          newRCON = 0;
        } else {
          if (distPlane < 0) {
            newRCON = 1;
          } else {
            newRCON = -1;
          }
          PVector newCenter = threePointCenter(bounds.get(step*4-1).a, nxny, bounds.get(step*2).b);
          newLR = newCenter.dist(nxny);
          if (abs(newLR-h/2) < 0.3) {
            newLR = h/2;
          }
        }
      }

      bounds = new ArrayList<Boundary>();
      ArrayList<PVector> points = lensPoints(xpos, ypos, newH, newLR, newRR, newLW, newRW, newLCON, newRCON); //TODO change out the integers
      float head = heading.heading();
      for (int i = 0; i < points.size()-1; i++) {
        bounds.add(new Boundary(points.get(i).copy(), points.get(i+1).copy()));
      }

      changeGrab(xpos, ypos);
      resetHeading();
      rotateTo(xpos+cos(head)*20, ypos+sin(head)*20);
      updateShape();
    } 
    catch (Exception e) {
      println("Warning: an exception occured, but at least your program didn't crash!");
    }
  }
}

// http://paulbourke.net/geometry/circlesphere/
PVector threePointCenter(PVector p1, PVector p2, PVector p3) {
  float ma = (p2.y-p1.y)/(p2.x-p1.x);
  float mb = (p3.y-p2.y)/(p3.x-p2.x);
  if (Float.isInfinite(ma) || Float.isInfinite(mb)) {
    return null;
  }
  float x = (ma*mb*(p1.y-p3.y) + mb*(p1.x+p2.x) - ma*(p2.x+p3.x))/(2*(mb-ma));
  float y = (-1/ma)*(x-(p1.x+p2.x)/2)+(p1.y+p2.y)/2;
  return new PVector(x, y);
}

// http://paulbourke.net/geometry/circlesphere/
// http://paulbourke.net/geometry/circlesphere/circle_intersection.py
PVector[] twoCircleIntersect(PVector c0, float r0, PVector c1, float r1) {
  if (c0 == null || c1 == null) {
    return null;
  }
  float d = c0.dist(c1);
  if (d > r0 + r1 || d < abs(r1-r0) || (d == 0 && r0 == r1)) 
    return null;
  float Dx = c1.x-c0.x;
  float Dy = c1.y - c0.y;
  float chorddistance = (r0*r0 - r1*r1 + d*d)/(2*d);
  float halfchordlength = sqrt(r0*r0 - chorddistance*chorddistance);
  PVector chordmidpoint = new PVector(c0.x + (chorddistance*Dx)/d, c0.y + (chorddistance*Dy)/d);
  PVector I1 = new PVector(chordmidpoint.x + (halfchordlength*Dy)/d, chordmidpoint.y - (halfchordlength*Dx)/d);
  float theta1 = degrees(atan2(I1.y-c0.y, I1.x-c0.x));
  PVector I2 = new PVector(chordmidpoint.x - (halfchordlength*Dy)/d, chordmidpoint.y + (halfchordlength*Dx)/d);
  float theta2 = degrees(atan2(I2.y-c0.y, I2.x-c0.x));
  if (theta2 > theta1) {
    PVector temp = I1.copy();
    I1 = I2.copy();
    I2 = temp.copy();
  }
  return new PVector[]{I1, I2};
}

// http://paulbourke.net/geometry/circlesphere/
PVector circleLineClosestIntersect(PVector p1, PVector p2, PVector p3, float r, PVector closestTo) {
  float a = pow((p2.x-p1.x), 2)+pow((p2.y-p1.y), 2);
  float b = 2*((p2.x-p1.x)*(p1.x-p3.x)+(p2.y-p1.y)*(p1.y-p3.y));
  float c = p3.x*p3.x+p3.y*p3.y+p1.x*p1.x+p1.y*p1.y-2*(p3.x*p1.x+p3.y*p1.y)-r*r;
  float sqr = b*b-4*a*c;
  if (sqr < 0) {
    return null;
  } else if (sqr == 0) {
    float u = -b/2/a;
    return new PVector(p1.x+(u)*(p2.x-p1.x), p1.y+(u)*(p2.y-p1.y));
  } else {
    float u1 = (-b + sqrt(sqr))/2/a;
    float u2 = (-b - sqrt(sqr))/2/a;
    PVector temp1 = new PVector(p1.x+(u1)*(p2.x-p1.x), p1.y+(u1)*(p2.y-p1.y));
    PVector temp2 = new PVector(p1.x+(u2)*(p2.x-p1.x), p1.y+(u2)*(p2.y-p1.y));
    if (temp1.dist(closestTo) < temp2.dist(closestTo)) {
      return temp1;
    } else {
      return temp2;
    }
  }
}

PVector lineLineIntersection(PVector A, PVector B, PVector C, PVector D) 
{ 
  // Line AB represented as a1x + b1y = c1 
  float a1 = B.y - A.y; 
  float b1 = A.x - B.x; 
  float c1 = a1*(A.x) + b1*(A.y); 

  // Line CD represented as a2x + b2y = c2 
  float a2 = D.y - C.y; 
  float b2 = C.x - D.x; 
  float c2 = a2*(C.x)+ b2*(C.y); 

  float determinant = a1*b2 - a2*b1; 

  if (determinant == 0) { 
    // The lines are parallel. This is simplified 
    // by returning a pair of FLT_MAX 
    return null;
  } else { 
    float x = (b2*c1 - b1*c2)/determinant; 
    float y = (a1*c2 - a2*c1)/determinant; 
    return new PVector(x, y);
  }
} 

ArrayList<PVector> lensPoints(float x, float y, float h, float lr, float rr, float lw, float rw, int lcon, int rcon) {

  ArrayList<PVector> toReturn = new ArrayList<PVector>();
  int numSections = 100;
  float tempx, tempy, angleStart = 0, angleEnd = 0;

  //bottom middle
  tempx = 0;
  tempy = h/2;
  toReturn.add(new PVector(tempx+x, tempy+y));

  //left lens
  if (lcon == 1) {
    angleStart = -asin((h/2)/rr)+PI;
    angleEnd = asin((h/2)/rr)+PI;
  } else if (lcon == -1) {
    angleStart = asin((h/2)/rr);
    angleEnd = -asin((h/2)/rr);
  }
  for (int i = 0; i <= numSections/2; i++) {
    if (lcon == 0) {
      tempx = -lw;
      tempy = map(i, 0, numSections/2, h/2, -h/2);
    } else {
      float a = map(i, 0, numSections/2, angleStart, angleEnd);
      tempx = rr*cos(a)-rr*cos(angleStart)-lw;
      tempy = rr*sin(a);
    }
    toReturn.add((new PVector(tempx+x, tempy+y)));
  }

  //top middle
  tempx = 0;
  tempy = -h/2;
  toReturn.add((new PVector(tempx+x, tempy+y)));

  //right lens

  if (rcon == 1) {
    angleStart = -asin((h/2)/lr);
    angleEnd = asin((h/2)/lr);
  } else if (rcon == -1) {
    angleStart = asin((h/2)/lr)+PI;
    angleEnd = -asin((h/2)/lr)+PI;
  } 
  for (int i = 0; i <= numSections/2; i++) {
    if (rcon == 0) {
      tempx = rw;
      tempy = map(i, 0, numSections/2, -h/2, h/2);
    } else {
      float a = map(i, 0, numSections/2, angleStart, angleEnd);
      tempx = lr*cos(a)-lr*cos(angleStart)+rw;
      tempy = lr*sin(a);
    }
    toReturn.add((new PVector(tempx+x, tempy+y)));
  }

  //bottom middle
  tempx = 0;
  tempy = h/2;
  toReturn.add((new PVector(tempx+x, tempy+y)));

  return toReturn;
}
