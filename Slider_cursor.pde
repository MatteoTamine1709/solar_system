int CIRCLE = 0;
int RECTANGLE = 1;

class SliderCursor {
  int shape;
  color c_idle;
  color c_hover;
  PVector pos;
  PVector size;

  SliderCursor(PVector pos_, PVector size_, int shape_, color idle_, color hover_) {
    this.shape = shape_;
    this.c_idle = idle_;
    this.c_hover = hover_;
    this.pos = pos_;
    this.size = size_;
  }
  
  boolean hover() {
    return (mouseX > this.pos.x - this.size.x / 2 && mouseX < this.pos.x + this.size.x / 2 &&
            mouseY > this.pos.y - this.size.y / 2 && mouseY < this.pos.y + this.size.y / 2);
  }
  
  void clicked() {
    if (mousePressed) {
      this.pos.x = mouseX;
      this.pos.y = mouseY + this.size.y / 2;
    }
  }
  
  void display() {
    fill(this.c_idle);
    if (this.hover())
      fill(this.c_hover);
    if (this.shape == CIRCLE) {
      ellipseMode(CENTER);
      ellipse(this.pos.x, this.pos.y, this.size.x, this.size.y);
    } else if (shape == RECTANGLE) {
      rectMode(CENTER);
      rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
    }
  }
}
