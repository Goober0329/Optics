import g4p_controls.*;
import java.util.*;

/**
 GLOBAL VARIABLES
 **/

//BASE VARIABLES
color back = color(245);
color line = color(51);

//SHAPE VARIABLES
ArrayList<Doodad> doodads;
boolean createOwn = false;
boolean createBoundaries = false;

//LIGHT VARIABLES
ArrayList<LightSource> lightsources;
int offscreen = 99999;

ArrayList<PVector> tempPoints = null;


//MENU VARIABLES
Menu menu;

void setup() {
  size(800, 500, P2D);
  background(back);
  smooth();

  menu = new Menu();
  tempPoints = new ArrayList<PVector>();
  doodads = new ArrayList<Doodad>();
  lightsources = new ArrayList<LightSource>();
}

void draw() {
  background(back);

  menu.update();

  if (createOwn || createBoundaries) {
    noStroke();
    fill(line);
    ellipse(mouseX, mouseY, 5, 5);
    connectPoints(tempPoints);
  }

  for (LightSource l : lightsources) {
    l.shine(new ArrayList<Ray>(Arrays.asList(l.rays)), doodads, 1);
    l.show();
    l.update();
  }

  for (Doodad d : doodads) {
    d.show();
    d.update();
  }
}


// connects the points being drawn
void connectPoints(ArrayList<PVector> points) {
  stroke(line);
  if (points != null) {
    int s = points.size();
    if (s == 1) {
      line(points.get(0).x, points.get(0).y, mouseX, mouseY);
    } else if (s > 1) {
      for (int i = 0; i < points.size()-1; i++) {
        line(points.get(i).x, points.get(i).y, points.get(i+1).x, points.get(i+1).y);
      }
      line(points.get(s-1).x, points.get(s-1).y, mouseX, mouseY);
    }
  }
}
