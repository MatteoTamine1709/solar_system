ArrayList<Planet> planets = new ArrayList();
ArrayList<Planet> planets_futur = new ArrayList();
int pause = 0;
int trajectory = 0;
int show_attraction_radius = 0;
int in_creation = 0;
float zoom = 1;

Slider slider;

void setup() {
  fullScreen();
  slider = new Slider(new PVector(0, 0), new PVector(500, 30), 3000, 0, 1, color(255));
}

void update_planets() {
  int index = 0;
  for (int i = 0; i < planets.size(); i++) {
    if (planets.get(i).in_creation == 0 && pause == 0) {
      if (planets.get(i).is_fix == false) {
        textAlign(CORNER, CORNER);
        textSize(32);
        fill(planets.get(i).c);
        text("x : " + planets.get(i).vel.x, 100, 100 + index * 200);
        text("y : " + planets.get(i).vel.y, 100, 200 + index * 200);
        index++;
      }
      planets = planets.get(i).update(planets);
      planets.get(i).move();
    }
    planets.get(i).display(planets);
  } 
}

void draw() {
  background(0);
  textSize(32);
  fill(255);
  text(frameRate, width - 100, 30);
  text(zoom, width - 100, 60);
  update_planets();
  if (trajectory == 1)
    display_trajectory();
  slider.display();
}

void keyPressed() {
  if (keyCode == RIGHT) {
    for (int i = 0; i < 100; i++) {
      update_planets();
    }
  }
  if (keyCode == ENTER) {
    for (int i = 0; i < planets.size(); i++) {
      if (planets.get(i).in_creation == 1) {
        planets.get(i).in_creation = 0;
      }
    }
    in_creation = 0;
  }
  if (key == ' ') {
    pause ^= 1;
  }
  if (key == 't') {
    trajectory ^= 1;
  }
  if (key == 'r')
    show_attraction_radius ^= 1;
  if (key == '+') {
    zoom += 0.1;
  }
  if (key == '-') {
    zoom -= 0.1;
    if (zoom == 0)
      zoom = 0.1;
  }
}

void mouseClicked() {
  if (slider.hover())
    return;
  for (int i = 0; i < planets.size(); i++)
    if (planets.get(i).hover() && !planets.get(i).settings_menu.hover()) {
      planets.get(i).in_creation = 1;
      return;
    }
  if (in_creation == 0)
    create_new_planet();
}

void create_new_planet() {
  planets.add(new Planet());
  in_creation = 1;
}
