 //<>// //<>// //<>// //<>// //<>// //<>//

class LightSource {

  PVector pos;
  PImage flashlight;
  PImage original;
  float angle;
  int numRays;
  Ray[] rays;
  Shape lightSourceOutline;

  LightSource(float x, float y, float w, float h, float a, int n) {
    angle = a;
    numRays = n;
    pos = new PVector(x, y);

    lightSourceOutline = new Rectangle(rectPoints(x, y, w, h), color(255, 0));
    original = loadImage("flashlight.png");
    flashlight = original.copy();
    flashlight.resize((int)w, (int)h);

    initFirstRays();
  }

  void initFirstRays() {
    rays = new Ray[numRays];
    float spacing = angle/ (float)numRays;
    Boundary outLight = lightSourceOutline.bounds.get(2);
    PVector mid = PVector.add(outLight.b, outLight.a).div(2);
    float tempx, tempy, ang;
    int count = rays.length;
    while (count > 0) {
      if (count == 1) {
        rays[0] = new Ray(mid.x, mid.y, lightSourceOutline.heading.heading(), 50, atmosphereIndex, true);
        break;
      }
      tempx = map(count, rays.length, 0, outLight.a.x, mid.x);
      tempy = map(count, rays.length, 0, outLight.a.y, mid.y);
      ang = map(count, rays.length, 0, angle/2, -spacing/2);
      rays[count-1] = new Ray(tempx, tempy, lightSourceOutline.heading.heading()+ang, 50, atmosphereIndex, true);
      tempx = map(count, rays.length, 0, outLight.b.x, mid.x);
      tempy = map(count, rays.length, 0, outLight.b.y, mid.y);
      rays[count-2] = new Ray(tempx, tempy, lightSourceOutline.heading.heading()-ang, 50, atmosphereIndex, true);
      count -= 2;
    }
  }

  void show() {
    if (lightSourceOutline.selected)
      lightSourceOutline.showSelected();
    for (Ray r : rays) {
      r.show();
    }
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(lightSourceOutline.heading.heading());
    imageMode(CENTER);
    image(flashlight, 0, 0);
    popMatrix();
  }

  void update() {
    lightSourceOutline.update();
    pos = new PVector(lightSourceOutline.xpos, lightSourceOutline.ypos);
    initFirstRays();
    flashlight = original.copy();
    float w = PVector.dist(lightSourceOutline.bounds.get(1).a, lightSourceOutline.bounds.get(1).b);
    float h = PVector.dist(lightSourceOutline.bounds.get(0).a, lightSourceOutline.bounds.get(0).b);
    if (w >= 5 && h >= 5)
      flashlight.resize((int)w, (int)h);
  }

  void shine(ArrayList<Ray> lightRays, ArrayList<Doodad> doos, int layer) {
    if (layer > 100) 
      return;
    //println(layer);
    //need to keep track of the closest point that each ray intersects.
    ArrayList<Ray> continuedRays = new ArrayList<Ray>();
    for (Ray r : lightRays) {
      PVector closestPoint = null;
      Doodad closestDoodad = null;
      Boundary closestBoundary = null;
      float record = offscreen;
      for (Doodad d : doos) {
        for (Boundary b : d.shape.bounds) {
          PVector pt = r.cast(b);
          if (pt != null) {
            float dist = pos.dist(pt); 
            if (dist < record && !(abs(pt.x-r.start.x) > 0.01 && abs(pt.y-r.start.y) > 0.01)) {
              record = dist;
              closestPoint = pt;
              closestDoodad = d;
              closestBoundary = b;
            }
          }
        }
      }
      r.end = closestPoint;
      //println("  "+r.start);
      //println("  "+closestPoint);

      if (debug) {
        println("stop here"); //<>//
      }

      if (r.end != null && closestBoundary != null && closestDoodad != null) {
        PVector start = r.end.copy();
        if (r.outside) { //ray comes from outside and goes into object
          PVector[] newRay = snellsLaw(r, closestBoundary, closestDoodad.index);
          if (newRay[1].x != 1) {
            continuedRays.add(new Ray(start.x, start.y, newRay[0].heading(), 50, r.index, true));
          } else {
            continuedRays.add(new Ray(start.x, start.y, newRay[0].heading(), 50, closestDoodad.index, false));
          }
        } else { //ray comes from inside and goes into atmosphere
          PVector[] newRay = snellsLaw(r, closestBoundary, atmosphereIndex);
          if (newRay[1].x != 1) {
            continuedRays.add(new Ray(start.x, start.y, newRay[0].heading(), 50, closestDoodad.index, false));
          } else {
            continuedRays.add(new Ray(start.x, start.y, newRay[0].heading(), 50, atmosphereIndex, true));
          }
        }
      }
    }

    //after you call shine on those rays, show the rays
    if (continuedRays.size() > 0) {
      shine(continuedRays, doos, layer+1);
      for (Ray r : continuedRays) {
        r.show();
      }
    }
  }
}


// https://www.scratchapixel.com/lessons/3d-basic-rendering/introduction-to-shading/reflection-refraction-fresnel
// https://math.stackexchange.com/questions/13261/how-to-get-a-reflection-vector
PVector[] snellsLaw(Ray r, Boundary b, float bIndex) {
  PVector boundDir = PVector.sub(b.a, b.b).normalize();
  PVector boundaryNormal = (r.dir.cross(boundDir)).cross(boundDir).normalize();

  float incidentAngle = PI-PVector.angleBetween(boundaryNormal, r.dir);
  float criticalAngle = asin(bIndex/r.index);

  if (incidentAngle > criticalAngle) {
    return new PVector[]{PVector.sub(r.dir, PVector.mult(boundaryNormal, PVector.dot(r.dir, boundaryNormal)*2)), new PVector(-1, 0)};
  }

  float eta = r.index/bIndex;
  float c1 = cos(incidentAngle);
  float c2 = sqrt(1-eta*eta*sin(incidentAngle)*sin(incidentAngle));
  PVector bn = boundaryNormal.copy().normalize();
  return new PVector[]{PVector.sub(PVector.mult(PVector.add(r.dir, PVector.mult(bn, c1)), eta), PVector.mult(bn, c2)), new PVector(1, 0)};
}
