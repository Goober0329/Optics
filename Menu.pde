//<>// //<>// //<>// //<>// //<>// //<>//

float atmosphereIndex = 1;


class Menu {
  GAbstractControl[] controls;
  float travelDistance = 240;
  float distanceTraveled = 0;
  int dir = 0;
  int pos = 1;

  String[] objectTypes = new String[]{"rectangle", "ellipse", "triangle", "lens", "create", "boundary"};
  String object = objectTypes[0];
  String[] materialTypes = new String[]{"vaccum", "atmosphere", "water", "glass", "zirconia", "diamond", "poly", "create"};
  String material = materialTypes[0];
  boolean index8IsValid = false;
  boolean material8IsValid = false;
  boolean changed = false;

  int numRays = 1;
  float rayAngle = 0;

  Menu() {
    createGUI();
    controls = new GAbstractControl[]{menuButton, lightButton, objectButton, deleteButton, templabel1, templabel2, templabel3, matOption1, 
      matOption2, matOption3, matOption4, matOption5, matOption6, matOption7, matOption8matText, 
      matOption8, matOption1Index, matOption2Index, matOption3Index, matOption4Index, matOption5Index, 
      matOption6Index, matOption7Index, matOption8Text, objectType1, objectType2, shapeType1, shapeType2, 
      shapeType3, shapeType4, shapeType5, numberRaysLabel, raySpreadLabel, numberRaysSlider, rayAngleSlider};
  }

  void update() {
    if (pos == 0) {
      float vel = map(distanceTraveled, 0, travelDistance, 10, 0.5);
      distanceTraveled += vel;
      vel *= dir;
      for (GAbstractControl c : controls) {
        c.moveTo(c.getX()+vel, c.getY());
      }
      boolean gotThere = distanceTraveled >= travelDistance;
      if (gotThere) {
        distanceTraveled = 0;
        pos = dir;
        dir *= -1;
      }
    }

    if (changed) {
      createOwn = false;
      createBoundaries = false;
      createObjectButton(object);
      controls[2] = objectButton;
      changed = false;
    }
  }

  void makeDoodad() {
    if (object == "create") {
      createOwn = true;
      tempPoints.clear();
    } else if (object == "boundary") {
      createBoundaries = true;
      tempPoints.clear();
    } else {
      doodads.add(new Doodad(object, material));
    }
  }

  void makeLight() {
    lightsources.add(new LightSource(width/2, height/2, 100, 35, rayAngle, numRays));
  }

  void setMaterial(int num) {
    if (num == 7) {
      material = matOption8matText.getText();
    } else {
      material = materialTypes[num];
    }
  }

  void setObject(int num) {
    object = objectTypes[num];
  }

  void setRays(int num) {
    numRays = num;
  }

  void setAngle(float a) {
    rayAngle = a;
  }

  void menuButtonClicked() {
    switch(pos) {
    case -1:
      dir = 1;
      pos = 0;
      break;
    case 0:
      dir *= -1;
      distanceTraveled = travelDistance-distanceTraveled;
      break;
    case 1:
      dir = -1;
      pos = 0;
      break;
    }
  }

  boolean mouseOverMenu() {
    return mouseX < menuButton.getX()+menuButton.getWidth();
  }
}


@SuppressWarnings("unused")
  public void menuButtonClicked(GImageButton source, GEvent event) {
  menu.menuButtonClicked();
}

@SuppressWarnings("unused")
  public void objectButtonClicked(GImageButton source, GEvent event) {
  menu.makeDoodad();
  println("object pressed");
}

@SuppressWarnings("unused")
  public void lightButtonClicked(GImageButton source, GEvent event) {
  menu.makeLight();
  println("light pressed");
}

@SuppressWarnings("unused")
  public void deleteButtonClicked(GImageButton source, GEvent event) {
  for (int i = lightsources.size()-1; i >= 0; i--) {
    if (lightsources.get(i).lightSourceOutline.selected) {
      lightsources.remove(i);
    }
  }

  for (int i = doodads.size()-1; i >= 0; i--) {
    if (doodads.get(i).shape.selected) {
      doodads.remove(i);
    }
  }
}

@SuppressWarnings("unused")
  public void matOption1Selected(GOption source, GEvent event) { //_CODE_:matOption1:488670:
  println("matOption1 - GOption >> GEvent." + event + " @ " + millis());
  menu.setMaterial(0);
} //_CODE_:matOption1:488670:

@SuppressWarnings("unused")
  public void matOption2Selected(GOption source, GEvent event) { //_CODE_:matOption2:497123:
  println("matOption2 - GOption >> GEvent." + event + " @ " + millis());
  menu.setMaterial(1);
} //_CODE_:matOption2:497123:

@SuppressWarnings("unused")
  public void matOption3Selected(GOption source, GEvent event) { //_CODE_:matOption3:969052:
  println("matOption3 - GOption >> GEvent." + event + " @ " + millis());
  menu.setMaterial(2);
} //_CODE_:matOption3:969052:

@SuppressWarnings("unused")
  public void matOption4Selected(GOption source, GEvent event) { //_CODE_:matOption4:794207:
  println("matOption4 - GOption >> GEvent." + event + " @ " + millis());
  menu.setMaterial(3);
} //_CODE_:matOption4:794207:

@SuppressWarnings("unused")
  public void matOption5Selected(GOption source, GEvent event) { //_CODE_:matOption5:540344:
  println("matOption5 - GOption >> GEvent." + event + " @ " + millis());
  menu.setMaterial(4);
} //_CODE_:matOption5:540344:

@SuppressWarnings("unused")
  public void matOption6Selected(GOption source, GEvent event) { //_CODE_:matOption6:505314:
  println("matOption6 - GOption >> GEvent." + event + " @ " + millis());
  menu.setMaterial(5);
} //_CODE_:matOption6:505314:

@SuppressWarnings("unused")
  public void matOption7Selected(GOption source, GEvent event) { //_CODE_:matOption7:742384:
  println("matOption7 - GOption >> GEvent." + event + " @ " + millis());
  menu.setMaterial(6);
} //_CODE_:matOption7:742384:

@SuppressWarnings("unused")
  public void matOption8Selected(GOption source, GEvent event) { //_CODE_:matOption8:673340:
  println("matOption8 - GOption >> GEvent." + event + " @ " + millis());
  menu.setMaterial(7);
} //_CODE_:matOption8:673340:


public void matOption8TextChanged(GTextField source, GEvent event) { //_CODE_:matOption8Text:384066:
  println("matOption8Text - GTextField >> GEvent." + event + " @ " + millis());
  String temp = source.getText();
  String[] match = match(temp, "^([1-5][.]([0-9]{1,3})?)$|^([1-5])$");
  if (match == null) {
    if (temp.length() > 0) {
      source.setLocalColor(2, color(255, 0, 0));
      menu.index8IsValid = false;
    }
  } else {
    source.setLocalColor(2, color(0));
    menu.index8IsValid = true;
    if (matOption8.isSelected()) {
      menu.setMaterial(7);
    }
  }
} //_CODE_:matOption8Text:384066:


public void matOption8matTextChanged(GTextField source, GEvent event) { //_CODE_:matOption8Text:384066:
  println("matOption8matText - GTextField >> GEvent." + event + " @ " + millis());
  String temp = source.getText();
  String[] match = match(temp, "^(\\w+ ?)+\\w*$");
  if (match == null) {
    if (temp.length() > 0) {
      source.setLocalColor(2, color(255, 0, 0));
      menu.material8IsValid = false;
    }
  } else {
    source.setLocalColor(2, color(0));
    menu.material8IsValid = true;
  }
} //_CODE_:matOption8Text:384066:


@SuppressWarnings("unused")
  public void objectType1Selected(GOption source, GEvent event) { //_CODE_:objectType1:211519:
  println("option1 - GOption >> GEvent." + event + " @ " + millis());
  menu.setObject(5);
  menu.changed = true;
} //_CODE_:objectType1:211519:

@SuppressWarnings("unused")
  public void objectType2Selected(GOption source, GEvent event) { //_CODE_:objectType2:916695:
  println("objectType2 - GOption >> GEvent." + event + " @ " + millis());
  for (int i = 26; i <= 30; i++) {
    if (((GOption)menu.controls[i]).isSelected()) {
      menu.setObject(i-26);
      menu.changed = true;
      break;
    }
  }
} //_CODE_:objectType2:916695:

@SuppressWarnings("unused")
  public void shapeType1Selected(GOption source, GEvent event) { //_CODE_:shapeType1:832326:
  println("shapeType1 - GOption >> GEvent." + event + " @ " + millis());
  if (objectType1.isSelected())
    return;
  menu.setObject(0);
  menu.changed = true;
} //_CODE_:shapeType1:832326:

@SuppressWarnings("unused")
  public void shapeType2Selected(GOption source, GEvent event) { //_CODE_:shapeType2:598383:
  println("shapeType2 - GOption >> GEvent." + event + " @ " + millis());
  if (objectType1.isSelected())
    return;
  menu.setObject(1);
  menu.changed = true;
} //_CODE_:shapeType2:598383:

@SuppressWarnings("unused")
  public void shapeType3Selected(GOption source, GEvent event) { //_CODE_:shapeType3:825583:
  println("shapeType3 - GOption >> GEvent." + event + " @ " + millis());
  if (objectType1.isSelected())
    return;
  menu.setObject(2);
  menu.changed = true;
} //_CODE_:shapeType3:825583:

@SuppressWarnings("unused")
  public void shapeType4Selected(GOption source, GEvent event) { //_CODE_:shapeType4:339043:
  println("shapeType4 - GOption >> GEvent." + event + " @ " + millis());
  if (objectType1.isSelected())
    return;
  menu.setObject(3);
  menu.changed = true;
} //_CODE_:shapeType4:339043:

@SuppressWarnings("unused")
  public void shapeType5Selected(GOption source, GEvent event) { //_CODE_:shapeType5:290871:
  println("shapeType5 - GOption >> GEvent." + event + " @ " + millis());
  if (objectType1.isSelected())
    return;
  menu.setObject(4);
  menu.changed = true;
} //_CODE_:shapeType5:290871:



public void numberRaysSliderChanged(GSlider source, GEvent event) { //_CODE_:numberRaysSlider:766807:
  println("numberRaysSlider - GSlider >> GEvent." + event + " @ " + millis());
  menu.setRays(source.getValueI());
  for (LightSource l : lightsources) {
    if (l.lightSourceOutline.selected) {
      l.numRays = source.getValueI();
    }
  }
} //_CODE_:numberRaysSlider:766807:

public void rayAngleSliderChanged(GSlider source, GEvent event) { //_CODE_:rayAngleSlider:483554:
  println("rayAngleSlider - GSlider >> GEvent." + event + " @ " + millis());
  menu.setAngle(radians(source.getValueF()));
  for (LightSource l : lightsources) {
    if (l.lightSourceOutline.selected) {
      l.angle = radians(source.getValueF());
    }
  }
} //_CODE_:rayAngleSlider:483554:



void createObjectButton(String objectType) {
  int hbbsize = 40;
  int hbbspacing = 50;
  int hbby = 10;
  float xyratio = (float)960/720;
  hbby += hbbspacing;
  if (objectButton != null)
    objectButton.dispose();
  objectButton = null;
  objectButton = new GImageButton(this, 250, hbby, hbbsize*xyratio, hbbsize, new String[] { objectType+"1.png", objectType+"2.png", objectType+"3.png" }, "mask.png" ); //these one's will change based on what object type is selected.
  objectButton.addEventHandler(this, "objectButtonClicked");
}

// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI() {
  int scheme = 6;

  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(scheme);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Refraction Simulation");

  // HHOMEBREW MENU BUTTONS
  int hbbsize = 40;
  int hbbspacing = 50;
  int hbby = 10;
  float xyratio = (float)960/720;
  menuButton = new GImageButton(this, 250, hbby, hbbsize*xyratio, hbbsize, new String[] { "menu1.png", "menu2.png", "menu3.png" }, "mask.png" );
  menuButton.addEventHandler(this, "menuButtonClicked");
  createObjectButton("rectangle");
  hbby += hbbspacing*2;
  lightButton = new GImageButton(this, 250, hbby, hbbsize*xyratio, hbbsize, new String[] { "light1.png", "light2.png", "light2.png" }, "mask.png" );
  lightButton.addEventHandler(this, "lightButtonClicked");
  hbby += hbbspacing;
  deleteButton = new GImageButton(this, 250, hbby, hbbsize*xyratio, hbbsize, new String[] { "delete1.png", "delete2.png", "delete3.png" }, "mask.png" );
  deleteButton.addEventHandler(this, "deleteButtonClicked");


  // SECTION LABELS
  templabel1 = new GLabel(this, 20, 10, 220, 20);
  templabel1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  templabel1.setText("Material Section");
  templabel1.setTextBold();
  templabel1.setLocalColorScheme(scheme);
  templabel1.setOpaque(false);
  templabel2 = new GLabel(this, 20, 210, 220, 20);
  templabel2.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  templabel2.setText("Object Selection");
  templabel2.setTextBold();
  templabel2.setLocalColorScheme(scheme);
  templabel2.setOpaque(false);
  templabel3 = new GLabel(this, 20, 390, 220, 20);
  templabel3.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  templabel3.setText("Light Source");
  templabel3.setTextBold();
  templabel3.setLocalColorScheme(scheme);
  templabel3.setOpaque(false);

  // MATERIAL CHOICE
  materialOptions = new GToggleGroup();
  matOption1 = new GOption(this, 20, 30, 140, 20);
  matOption1.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  matOption1.setText("Vaccum");
  matOption1.setTextBold();
  matOption1.setLocalColorScheme(scheme);
  matOption1.setOpaque(false);
  matOption1.addEventHandler(this, "matOption1Selected");
  matOption2 = new GOption(this, 20, 50, 140, 20);
  matOption2.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  matOption2.setText("Atmosphere");
  matOption2.setTextBold();
  matOption2.setLocalColorScheme(scheme);
  matOption2.setOpaque(false);
  matOption2.addEventHandler(this, "matOption2Selected");
  matOption3 = new GOption(this, 20, 70, 140, 20);
  matOption3.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  matOption3.setText("Water");
  matOption3.setTextBold();
  matOption3.setLocalColorScheme(scheme);
  matOption3.setOpaque(false);
  matOption3.addEventHandler(this, "matOption3Selected");
  matOption4 = new GOption(this, 20, 90, 140, 20);
  matOption4.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  matOption4.setText("Glass (fused silica)");
  matOption4.setTextBold();
  matOption4.setLocalColorScheme(scheme);
  matOption4.setOpaque(false);
  matOption4.addEventHandler(this, "matOption4Selected");
  matOption5 = new GOption(this, 20, 110, 140, 20);
  matOption5.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  matOption5.setText("Cubic Zirconia");
  matOption5.setTextBold();
  matOption5.setLocalColorScheme(scheme);
  matOption5.setOpaque(false);
  matOption5.addEventHandler(this, "matOption5Selected");
  matOption6 = new GOption(this, 20, 130, 140, 20);
  matOption6.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  matOption6.setText("Diamond");
  matOption6.setTextBold();
  matOption6.setLocalColorScheme(scheme);
  matOption6.setOpaque(false);
  matOption6.addEventHandler(this, "matOption6Selected");
  matOption7 = new GOption(this, 20, 150, 140, 20);
  matOption7.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  matOption7.setText("Polycarbonate");
  matOption7.setTextBold();
  matOption7.setLocalColorScheme(scheme);
  matOption7.setOpaque(false);
  matOption7.addEventHandler(this, "matOption7Selected");
  matOption8 = new GOption(this, 20, 170, 20, 20);
  matOption8.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  matOption8.setText("");
  matOption8.setTextBold();
  matOption8.setLocalColorScheme(scheme);
  matOption8.setOpaque(false);
  matOption8.addEventHandler(this, "matOption8Selected");
  matOption8matText = new GTextField(this, 35, 170, 135, 20, G4P.SCROLLBARS_NONE);
  matOption8matText.setLocalColorScheme(scheme);
  matOption8matText.setText("Create Your Own");
  matOption8matText.setOpaque(false);
  matOption8matText.addEventHandler(this, "matOption8matTextChanged");

  materialOptions.addControl(matOption1);
  materialOptions.addControl(matOption2);
  materialOptions.addControl(matOption3);
  materialOptions.addControl(matOption4);
  materialOptions.addControl(matOption5);
  materialOptions.addControl(matOption6);
  materialOptions.addControl(matOption7);
  materialOptions.addControl(matOption8);
  matOption1.setSelected(true);

  matOption1Index = new GLabel(this, 180, 30, 60, 20);
  matOption1Index.setText("1.00");
  matOption1Index.setTextBold();
  matOption1Index.setLocalColorScheme(scheme);
  matOption1Index.setOpaque(false);
  matOption2Index = new GLabel(this, 180, 50, 60, 20);
  matOption2Index.setText("1.000293");
  matOption2Index.setTextBold();
  matOption2Index.setLocalColorScheme(scheme);
  matOption2Index.setOpaque(false);
  matOption3Index = new GLabel(this, 180, 70, 60, 20);
  matOption3Index.setText("1.330");
  matOption3Index.setTextBold();
  matOption3Index.setLocalColorScheme(scheme);
  matOption3Index.setOpaque(false);
  matOption4Index = new GLabel(this, 180, 90, 60, 20);
  matOption4Index.setText("1.458");
  matOption4Index.setTextBold();
  matOption4Index.setLocalColorScheme(scheme);
  matOption4Index.setOpaque(false);
  matOption5Index = new GLabel(this, 180, 110, 60, 20);
  matOption5Index.setText("2.16");
  matOption5Index.setTextBold();
  matOption5Index.setLocalColorScheme(scheme);
  matOption5Index.setOpaque(false);
  matOption6Index = new GLabel(this, 180, 130, 60, 20);
  matOption6Index.setText("2.417");
  matOption6Index.setTextBold();
  matOption6Index.setLocalColorScheme(scheme);
  matOption6Index.setOpaque(false);
  matOption7Index = new GLabel(this, 180, 150, 60, 20);
  matOption7Index.setText("2.60");
  matOption7Index.setTextBold();
  matOption7Index.setLocalColorScheme(scheme);
  matOption7Index.setOpaque(false);
  matOption8Text = new GTextField(this, 180, 170, 60, 20, G4P.SCROLLBARS_NONE);
  matOption8Text.setLocalColorScheme(scheme);
  matOption8Text.setOpaque(false);
  matOption8Text.addEventHandler(this, "matOption8TextChanged");

  // OBJECT CHOICE
  objectType = new GToggleGroup();
  objectType1 = new GOption(this, 20, 230, 120, 20);
  objectType1.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  objectType1.setText("Boundary");
  objectType1.setTextBold();
  objectType1.setLocalColorScheme(scheme);
  objectType1.setOpaque(false);
  objectType1.addEventHandler(this, "objectType1Selected");
  objectType2 = new GOption(this, 20, 250, 120, 20);
  objectType2.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  objectType2.setText("Shape");
  objectType2.setTextBold();
  objectType2.setLocalColorScheme(scheme);
  objectType2.setOpaque(false);
  objectType2.addEventHandler(this, "objectType2Selected");
  objectType.addControl(objectType1);
  objectType.addControl(objectType2);
  objectType2.setSelected(true);

  // SHAPE CHOICE
  shapeType = new GToggleGroup();
  shapeType1 = new GOption(this, 40, 270, 120, 20);
  shapeType1.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  shapeType1.setText("Rectangle");
  shapeType1.setTextBold();
  shapeType1.setLocalColorScheme(scheme);
  shapeType1.setOpaque(false);
  shapeType1.addEventHandler(this, "shapeType1Selected");
  shapeType2 = new GOption(this, 40, 290, 120, 20);
  shapeType2.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  shapeType2.setText("Ellipse");
  shapeType2.setTextBold();
  shapeType2.setLocalColorScheme(scheme);
  shapeType2.setOpaque(false);
  shapeType2.addEventHandler(this, "shapeType2Selected");
  shapeType3 = new GOption(this, 40, 310, 120, 20);
  shapeType3.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  shapeType3.setText("Triangle");
  shapeType3.setTextBold();
  shapeType3.setLocalColorScheme(scheme);
  shapeType3.setOpaque(false);
  shapeType3.addEventHandler(this, "shapeType3Selected");
  shapeType4 = new GOption(this, 40, 330, 120, 20);
  shapeType4.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  shapeType4.setText("Lens");
  shapeType4.setTextBold();
  shapeType4.setLocalColorScheme(scheme);
  shapeType4.setOpaque(false);
  shapeType4.addEventHandler(this, "shapeType4Selected");
  shapeType5 = new GOption(this, 40, 350, 120, 20);
  shapeType5.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  shapeType5.setText("Create Your Own");
  shapeType5.setTextBold();
  shapeType5.setLocalColorScheme(scheme);
  shapeType5.setOpaque(false);
  shapeType5.addEventHandler(this, "shapeType5Selected");
  shapeType.addControl(shapeType1);
  shapeType.addControl(shapeType2);
  shapeType.addControl(shapeType3);
  shapeType.addControl(shapeType4);
  shapeType.addControl(shapeType5);
  shapeType1.setSelected(true);

  // NUMBER OF RAYS
  numberRaysLabel = new GLabel(this, 20, 420, 110, 20);
  numberRaysLabel.setText("Number of Rays");
  numberRaysLabel.setTextBold();
  numberRaysLabel.setLocalColorScheme(scheme);
  numberRaysLabel.setOpaque(false);
  numberRaysSlider = new GSlider(this, 130, 410, 110, 40, 8.0);
  numberRaysSlider.setShowValue(true);
  numberRaysSlider.setShowLimits(true);
  numberRaysSlider.setLimits(1, 1, 15);
  numberRaysSlider.setNbrTicks(10);
  numberRaysSlider.setNumberFormat(G4P.INTEGER, 0);
  numberRaysSlider.setLocalColorScheme(scheme);
  numberRaysSlider.setOpaque(false);
  numberRaysSlider.addEventHandler(this, "numberRaysSliderChanged");

  // RAY SPREAD
  raySpreadLabel = new GLabel(this, 20, 460, 110, 20);
  raySpreadLabel.setText("Spread (degrees)");
  raySpreadLabel.setTextBold();
  raySpreadLabel.setLocalColorScheme(scheme);
  raySpreadLabel.setOpaque(false);
  rayAngleSlider = new GSlider(this, 130, 450, 110, 40, 8.0);
  rayAngleSlider.setShowValue(true);
  rayAngleSlider.setShowLimits(true);
  rayAngleSlider.setLimits(0.0, 0.0, 45.0);
  rayAngleSlider.setNbrTicks(15);
  rayAngleSlider.setNumberFormat(G4P.DECIMAL, 1);
  rayAngleSlider.setLocalColorScheme(scheme);
  rayAngleSlider.setOpaque(false);
  rayAngleSlider.addEventHandler(this, "rayAngleSliderChanged");
}

// Variable declarations 
// autogenerated do not edit
GImageButton menuButton; 
GImageButton objectButton;
GImageButton lightButton;
GImageButton deleteButton;
GLabel templabel1; 
GLabel templabel2; 
GLabel templabel3; 
GToggleGroup materialOptions; 
GOption matOption1; 
GOption matOption2; 
GOption matOption3; 
GOption matOption4; 
GOption matOption5; 
GOption matOption6; 
GOption matOption7; 
GTextField matOption8matText;
GOption matOption8; 
GLabel matOption1Index; 
GLabel matOption2Index; 
GLabel matOption3Index; 
GLabel matOption4Index; 
GLabel matOption5Index; 
GLabel matOption6Index; 
GLabel matOption7Index; 
GTextField matOption8Text; 
GToggleGroup objectType; 
GOption objectType1; 
GOption objectType2; 
GToggleGroup shapeType; 
GOption shapeType1; 
GOption shapeType2; 
GOption shapeType3; 
GOption shapeType4; 
GOption shapeType5; 
GLabel numberRaysLabel; 
GLabel raySpreadLabel; 
GSlider numberRaysSlider; 
GSlider rayAngleSlider; 
