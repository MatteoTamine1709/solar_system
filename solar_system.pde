ArrayList<Planet> planets = new ArrayList();
ArrayList<Planet> planets_futur = new ArrayList();
int pause = 0;
int trajectory = 0;
int show_attraction_radius = 0;
int in_creation = 0;
Slider slider;

void setup() {
  fullScreen();
  slider = new Slider(new PVector(0, 0), new PVector(500, 30), 3000, 0, 1, color(255));
}

void update_planets() {
  for (int i = 0; i < planets.size(); i++) {
    if (planets.get(i).in_creation == 0) {
      if (planets.get(i).is_fix == false) {
        textSize(32);
        fill(planets.get(i).c);
        text("x : " + planets.get(i).vel.x, 100, 100 + i * 200);
        text("y : " + planets.get(i).vel.y, 100, 200 + i * 200);
      }
      planets = planets.get(i).update(planets);
      planets.get(i).move();
    }
    planets.get(i).display(planets);
  } 
}

void draw() {
  background(0);
  update_planets();
  if (trajectory == 1)
    display_trajectory();
  slider.display();
}

void keyPressed() {
  if (keyCode == RIGHT) {
    println("right");
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
    if (pause == 0)
      noLoop();
    else
      loop();
    pause ^= 1;
  }
  if (key == 't')
    trajectory ^= 1;
  if (key == 'r')
    show_attraction_radius ^= 1;
}

void mouseClicked() {
  if (slider.hover())
    return;
  for (int i = 0; i < planets.size(); i++)
    if (planets.get(i).hover()) {
      planets.get(i).in_creation = 1;
      return;
    }
  if (in_creation == 0)
    create_new_planet();
  in_creation = 1;
}

void create_new_planet() {
  planets.add(new Planet());
}
