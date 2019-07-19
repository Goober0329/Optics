 //<>// //<>// //<>// //<>//

class Doodad {

  Shape shape = null;
  String material;
  float index;

  //range: 1-6?
  color[] colors = new color[]{color(#DAB8F0), color(#B8E7F0), color(#D8F0B8), color(#F0B8E3)};

  // for all predefined shapes
  Doodad(String type, String material) {
    index = getMaterialIndex(material);
    this.material = material;
    if (matOption8.isSelected() && (!menu.material8IsValid || material.length() == 0))
      this.material = "Create Your Own";
    float t = (index-1)/5;

    switch(type) {
    case "rectangle":
      shape = new Rectangle(rectPoints(width/2, height/2, 150, 72), lerpColors(colors, t));
      break;
    case "ellipse":
      shape = new Ellipse(ellipPoints(width/2, height/2, 400, 250), lerpColors(colors, t));
      break;
    case "triangle":
      shape = new Triangle(triPoints(width/2, height/2, 150), lerpColors(colors, t));
      break;
    case "lens":
      shape = new Lens(lensPoints(width/2, height/2, 300, 400, 200, 30, 30, 1, 1), lerpColors(colors, t));
      break;
    }
  }

  // for user created shapes
  Doodad(ArrayList<PVector> points, boolean createShape, String material) {
    this.index = getMaterialIndex(material);
    this.material = material;
    if (matOption8.isSelected() && (!menu.material8IsValid || material.length() == 0))
      this.material = "Create Your Own";
    float t = (index-1)/5;

    if (createShape) {
      shape = new Shape(points, lerpColors(colors, t));
    } else {
      shape = new boundaryShape(points, color(back, 0));
    }
  }

  void show() {
    shape.show();
    if (shape.selected && !(shape instanceof boundaryShape)) {
      textAlign(CENTER, BOTTOM);
      text("Material: "+material+"\n"+"Index: "+index, shape.xpos, shape.ypos);
    }
  }

  void update() {
    shape.update();
  }

  float getMaterialIndex(String material) {
    switch(material) {
    case "vaccum":
      return float(matOption1Index.getText());
    case "atmosphere":
      return float(matOption2Index.getText());
    case "water":
      return float(matOption3Index.getText());
    case "glass":
      return float(matOption4Index.getText());
    case "zirconia":
      return float(matOption5Index.getText());
    case "diamond":
      return float(matOption6Index.getText());
    case "poly":
      return float(matOption7Index.getText());
    }
    if (menu.index8IsValid)
      return float(matOption8Text.getText());
    return 1;
  }
}




// https://gist.github.com/Tetr4/3c7a4eddb78ae537c995
color lerpColors(color[] colors, float t) {
  int start = (int)(t*(colors.length-1));
  if (start == colors.length-1) {
    return colors[colors.length-1];
  }

  color before = colors[start];
  color after = colors[start+1];

  float localT = (t - ((float) start/ (colors.length - 1))) * (colors.length - 1);
  return lerpColor(before, after, localT);
}
