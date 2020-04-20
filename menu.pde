class Menu {
  ArrayList<Slider> sliders = new ArrayList<Slider>();
  ArrayList<Checkbox> checkboxes = new ArrayList<Checkbox>();
  Menu() {
  }

  void display() {
    for (int i = 0; i < sliders.size(); i++) {
      this.sliders.get(i).display();
    }
    for (int i = 0; i < checkboxes.size(); i++) {
      this.checkboxes.get(i).display();
    }
  }
  
  boolean hover() {
    for (int i = 0; i < sliders.size(); i++) {
      if (this.sliders.get(i).hover())
        return (true);
    }
    for (int i = 0; i < checkboxes.size(); i++) {
      if (this.checkboxes.get(i).hover())
        return (true);
    }
    return (false);
  }

  void add_slider(Slider slider) {
    this.sliders.add(slider);
  }
  
  void add_checkbox(Checkbox checbox) {
    this.checkboxes.add(checbox);
  }
}
