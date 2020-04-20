class Checkbox {
  PVector pos;
  PVector size;
  color c;
  boolean value;
  int timer = 0;
  boolean timer_start = false;
  
  Checkbox(PVector pos_, PVector size_, color c_) {
    this.pos = pos_;
    this.size = size_;
    this.c = c_;
  }
  
  boolean hover() {
    return (mouseX > this.pos.x && mouseX < this.pos.x + this.size.x &&
            mouseY > this.pos.y && mouseY < this.pos.y + this.size.y);
  }
  
  void clicked() {
    this.timer++;
    if (this.timer >= 30) {
      this.timer = 0;
      this.timer_start = false;
    }
    if (this.hover() && mousePressed && this.timer_start == false) {
      this.timer_start = true;
      if (this.value)
        this.value = false;
      else
        this.value = true;
    }
  }
  
  boolean get_value() {
    return (this.value);
  }
  
  void display() {
    this.clicked();
    rectMode(CORNER);
    fill(this.c);
    noStroke();
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
    textSize(16);
    fill(0);
    textAlign(CENTER, CENTER);
    if (this.value)
      text("V", this.pos.x + this.size.x / 2, this.pos.y + this.size.y / 2);
  }
}
