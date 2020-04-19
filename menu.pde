class Menu {
  ArrayList<Slider> sliders = new ArrayList<Slider>();
  Menu() {
  }

  void display() {
    for (int i = 0; i < sliders.size(); i++) {
      sliders.get(i).display();
    }
  }

  void add_slider(Slider slider) {
    this.sliders.add(slider);
  }
}
