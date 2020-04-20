class Planet {
  PVector pos;
  PVector vel;
  float gravity; // in N/kg
  float mass; // in 10^26kg
  color c;
  float radius;
  boolean is_fix = false;
  boolean will_die = false;
  float attraction_radius;
  int in_creation = 0;
  float zoom_level;
  Menu settings_menu;

  Planet() {
    this.pos = new PVector(mouseX, mouseY);
    this.vel = new PVector(0, 0);
    this.c = color(random(255), random(255), random(255));
    this.in_creation = 1;
    this.zoom_level = zoom;
    this.settings_menu = init_menu();
  }

  Planet(PVector pos_, PVector vel_, float g_, float m_, color c_) {
    this.pos = pos_;
    this.vel = vel_;
    this.gravity = g_;
    this.mass = m_;
    this.c = c_;
    this.radius = 0;
    this.attraction_radius = 0;
    this.radius = this.gravity * this.mass;
    this.attraction_radius = this.radius * 5;
    this.settings_menu = init_menu();
  }

  Planet(PVector pos_, PVector vel_, float g_, float m_, color c_, float radius_, float att_) {
    this.pos = pos_;
    this.vel = vel_;
    this.gravity = g_;
    this.mass = m_;
    this.c = c_;
    this.radius = radius_;
    this.attraction_radius = att_;
    this.settings_menu = init_menu();
  }

  boolean hover() {
    return (dist(mouseX, mouseY, this.pos.x, this.pos.y) < this.radius / 2);
  }

  void apply_settings() {
    this.mass = this.settings_menu.sliders.get(0).get_value();
    this.gravity = this.settings_menu.sliders.get(1).get_value();
    float force = this.settings_menu.sliders.get(4).get_value();
    this.vel.x = this.settings_menu.sliders.get(2).get_value() * force;
    this.vel.y = this.settings_menu.sliders.get(3).get_value() * force;
    this.radius = this.settings_menu.sliders.get(5).get_value();
    this.attraction_radius = this.gravity * 5;
    this.is_fix = this.settings_menu.checkboxes.get(0).get_value();
  }

  void display_attraction_radius() {
    pushMatrix();
    translate(width / 2, height / 2);
    scale(zoom - this.zoom_level + 1, zoom - this.zoom_level + 1);
    translate(-width / 2, -height / 2);
    noFill();
    stroke(255);
    strokeWeight(3);
    ellipse(this.pos.x, this.pos.y, this.attraction_radius, this.attraction_radius);
    PVector dir = this.vel.copy();
    dir.normalize();
    line(this.pos.x, this.pos.y, this.pos.x + dir.x * 50, this.pos.y + dir.y * 50);
    popMatrix();
  }

  void display(ArrayList<Planet> planet_list) {
    pushMatrix();
    translate(width / 2, height / 2);
    scale(zoom - this.zoom_level + 1, zoom - this.zoom_level + 1);
    translate(-width / 2, -height / 2);
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
    if (this.is_fix)
      stroke(100);
    ellipseMode(CENTER);
    fill(c);
    ellipse(this.pos.x, this.pos.y, this.radius, this.radius);
    popMatrix();
    if (show_attraction_radius == 1)
      display_attraction_radius();
    if (this.in_creation == 1) {
      pushMatrix();
      translate(width / 2, height / 2);
      scale(zoom - this.zoom_level + 1, zoom - this.zoom_level + 1);
      translate(-width / 2, -height / 2);
      this.settings_menu.display();
      popMatrix();
      if (!this.is_fix) {
        display_trajectory();
        display_attraction_radius();
      }
    }
  }

  ArrayList<Planet> update(ArrayList<Planet> planet_list) {
    if (this.in_creation == 1)
      return (planet_list);
    if (this.is_fix == true)
      return (planet_list);
    Planet c_planet;
    for (int i = 0; i < planet_list.size(); i++) {
      c_planet = planet_list.get(i);
      if (c_planet.in_creation == 0 && this.in_creation == 0 && c_planet != this &&
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
    if (this.in_creation == 1 || this.is_fix)
      return;
    this.pos.add(this.vel);
    //this.check_bounds();
  }

  Planet clone() {
    Planet p = new Planet(this.pos.copy(), this.vel.copy(), this.gravity, this.mass, this.c, this.radius, this.attraction_radius);
    p.is_fix = this.is_fix;
    p.zoom_level = this.zoom_level;
    return (p);
  }
}


Menu init_menu() {
  Menu menu = new Menu();
  //MASS
  menu.add_slider(new Slider(new PVector(mouseX + 20, mouseY + 20), new PVector(200, 20), 1000, 0, 1, color(100)));
  //gravity
  menu.add_slider(new Slider(new PVector(mouseX + 20, mouseY + 60), new PVector(200, 20), 500, 0, 1, color(120)));
  //vel_x
  menu.add_slider(new Slider(new PVector(mouseX + 20, mouseY + 100), new PVector(200, 20), 1, -1, 1, color(140)));
  //vel_y
  menu.add_slider(new Slider(new PVector(mouseX + 20, mouseY + 140), new PVector(200, 20), 1, -1, 1, color(160)));
  //force
  menu.add_slider(new Slider(new PVector(mouseX + 20, mouseY + 180), new PVector(200, 20), 500, 0, 1, color(160)));
  //radius
  menu.add_slider(new Slider(new PVector(mouseX + 20, mouseY + 220), new PVector(200, 20), 1000 / 8, 0, 1, color(180)));
  //is_fix
  menu.add_checkbox(new Checkbox(new PVector(mouseX + 20, mouseY + 260), new PVector(30, 30), color(200)));
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
      if (!p.is_fix) {
        pushMatrix();
        translate(width / 2, height / 2);
        scale(zoom - p.zoom_level + 1, zoom - p.zoom_level + 1);
        translate(-width / 2, -height / 2);
        p_pos = p.pos.copy();
        popMatrix();
        if (!p.will_die) {
          planets_futur = p.update(planets_futur);
          p.move();
          strokeWeight(3);
          stroke(p.c);
          if (dist(p_pos.x, p_pos.y, p.pos.x, p.pos.y) < 500) {
            pushMatrix();
            translate(width / 2, height / 2);
            scale(zoom - p.zoom_level + 1, zoom - p.zoom_level + 1);
            translate(-width / 2, -height / 2);
            line(p_pos.x, p_pos.y, p.pos.x, p.pos.y);
            popMatrix();
          }
        }
        if (p.will_die)
          planets.get(j).will_die = true;
      }
    }
  }
}
