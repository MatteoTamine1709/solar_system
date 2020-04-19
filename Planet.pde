class Planet {
  PVector pos;
  PVector speed;
  PVector acc;
  PVector vel;
  float gravity; // in N/kg
  float mass; // in 10^26kg
  color c;
  float radius;
  boolean is_fix = false;
  boolean will_die = false;
  float attraction_radius;
  int in_creation = 0;
  Menu settings_menu;

  Planet() {
    this.pos = new PVector(mouseX, mouseY);
    this.speed = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.vel = new PVector(0, 0);
    this.c = color(random(255), random(255), random(255));
    this.in_creation = 1;
    this.settings_menu = init_menu();
  }

  Planet(PVector pos_, PVector vel_, float g_, float m_, color c_) {
    this.pos = pos_;
    this.speed = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.vel = vel_;
    this.gravity = g_;
    this.mass = m_;
    this.c = c_;
    this.radius = this.gravity * this.mass;
    this.attraction_radius = this.radius * 5;
    this.settings_menu = init_menu();
  }

  boolean hover() {
    return (dist(mouseX, mouseY, this.pos.x, this.pos.y) < this.radius / 2);
  }

  void apply_settings() {
    this.mass = this.settings_menu.sliders.get(0).get_value();
    this.gravity = this.settings_menu.sliders.get(1).get_value();
    this.vel.x = this.settings_menu.sliders.get(2).get_value();
    this.vel.y = this.settings_menu.sliders.get(3).get_value();
    this.radius = this.settings_menu.sliders.get(4).get_value();
    this.attraction_radius = this.gravity * this.mass * 5; 
  }
  
  void display_attraction_radius() {
    noFill();
    stroke(255);
    strokeWeight(3);
    ellipse(this.pos.x, this.pos.y, this.attraction_radius, this.attraction_radius);
    PVector dir = this.vel.copy();
    dir.normalize();
    line(this.pos.x, this.pos.y, this.pos.x + dir.x * 50, this.pos.y + dir.y * 50);
  }

  void display(ArrayList<Planet> planet_list) {
    if (this.in_creation == 1) {
      this.apply_settings(); 
    }
    for (int i = 0; i < planet_list.size(); i++) {
      Planet c_planet = planet_list.get(i);
      if (c_planet != this && dist(this.pos.x, this.pos.y, c_planet.pos.x, c_planet.pos.y) < (c_planet.radius + this.radius) / 2) {
        planet_list.remove(this);
        planet_list.remove(c_planet);
      }
    }
    noStroke();
    if (this.vel.x == 0 && this.vel.y == 0)
      stroke(100);
    ellipseMode(CENTER);
    fill(c);
    ellipse(this.pos.x, this.pos.y, this.radius, this.radius);
    if (show_attraction_radius == 1)
      display_attraction_radius();
    if (this.in_creation == 1) {
      this.settings_menu.display();
      display_trajectory();
      display_attraction_radius();
    }
  }

  ArrayList<Planet> update(ArrayList<Planet> planet_list) {
    if (this.in_creation == 1)
      return (planet_list);
    Planet c_planet;
    if (is_fix == true)
      return (planet_list);
    for (int i = 0; i < planet_list.size(); i++) {
      c_planet = planet_list.get(i);
      if (c_planet.in_creation == 0 && c_planet != this &&
        dist(this.pos.x, this.pos.y, c_planet.pos.x, c_planet.pos.y) < (c_planet.radius + this.radius) / 2) {
        this.will_die = true;
        c_planet.will_die = true;
      }
      if (c_planet.in_creation == 0 && c_planet != this &&
        dist(this.pos.x, this.pos.y, c_planet.pos.x, c_planet.pos.y) < (this.radius + c_planet.attraction_radius) / 2) {
        float masses = this.mass * c_planet.mass;
        PVector force_dir = new PVector((c_planet.pos.x - this.pos.x), (c_planet.pos.y - this.pos.y));
        force_dir.normalize();
        float force = masses / pow(dist(this.pos.x, this.pos.y, c_planet.pos.x, c_planet.pos.y), 2);
        force_dir.mult(force);
        this.vel.add(force_dir);
      }
    }
    return (planet_list);
  }

  void check_bounds() {
    if (this.pos.x > width)
      this.pos.x = 0;
    if (this.pos.x < 0)
      this.pos.x = width;
    if (this.pos.y > height)
      this.pos.y = 0;
    if (this.pos.y < 0)
      this.pos.y = height;
  }

  void move() {
    if (this.in_creation == 1)
      return;
    this.pos.add(this.vel);
    this.check_bounds();
  }

  Planet clone() {
    Planet p = new Planet(this.pos.copy(), this.vel.copy(), this.gravity, this.mass, this.c);
    return (p);
  }
}


Menu init_menu() {
  Menu menu = new Menu();
  //MASS
  menu.add_slider(new Slider(new PVector(mouseX + 20, mouseY + 20), new PVector(100, 20), 30, 0, 1, color(100)));
  //gravity
  menu.add_slider(new Slider(new PVector(mouseX + 20, mouseY + 60), new PVector(100, 20), 20, 0, 1, color(120)));
  //vel_x
  menu.add_slider(new Slider(new PVector(mouseX + 20, mouseY + 100), new PVector(100, 20), 10, -10, 1, color(140)));
  //vel_y
  menu.add_slider(new Slider(new PVector(mouseX + 20, mouseY + 140), new PVector(100, 20), 10, -10, 1, color(160)));
  //radius
  menu.add_slider(new Slider(new PVector(mouseX + 20, mouseY + 180), new PVector(100, 20), 300, 0, 1, color(180)));
  return (menu);
}

void display_trajectory() {
  Planet p;
  PVector p_pos;
  planets_futur = new ArrayList<Planet>();
  for (int i = 0; i < planets.size(); i++)
    planets_futur.add(planets.get(i).clone());
  for (int i = 0; i < (int) slider.get_value(); i++) {
    for (int j = 0; j < planets_futur.size(); j++) {
      p = planets_futur.get(j);
      if (p.in_creation == 0) {
        p_pos = p.pos.copy();
        if (!p.will_die) {
          planets_futur = p.update(planets_futur);
          p.move();
          strokeWeight(3);
          stroke(p.c);
          if (dist(p_pos.x, p_pos.y, p.pos.x, p.pos.y) < 500)
            line(p_pos.x, p_pos.y, p.pos.x, p.pos.y);
        }
        if (p.will_die)
          planets.get(j).will_die = true;
      }
    }
  }
}
