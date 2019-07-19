
class Triangle extends Shape {
  Triangle(ArrayList<PVector> points, color c) {
    super(points, c);
  }
}

ArrayList<PVector> triPoints(float x, float y, float r) {
  ArrayList<PVector> toReturn = new ArrayList<PVector>();
  for (int i = 0; i <= 3; i++) {
    toReturn.add((new PVector(x+cos(-PI/2+i*TWO_PI/3)*r, y+sin(-PI/2+i*TWO_PI/3)*r)));
  }
  return toReturn;
}
