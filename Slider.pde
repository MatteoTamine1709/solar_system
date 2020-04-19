class Slider {
  PVector pos;
  PVector size;
  color c;
  float max;
  float min;
  float inc;
  SliderCursor cursor;

  Slider(PVector pos_, PVector size_, float max_, float min_, float inc_, color c_) {
    this.pos = pos_;
    this.size = size_;
    this.max = max_;
    this.min = min_;
    this.inc = inc_;
    this.c = c_;
    this.cursor = new SliderCursor(new PVector(this.pos.x + this.size.x / 2, this.pos.y + this.size.y / 2),
      new PVector(20, this.size.y), RECTANGLE, color(0), color(150));
  }
  
  Slider(PVector pos_, PVector size_, float max_, float min_, float inc_, color c_, SliderCursor cursor_) {
    this.pos = pos_;
    this.size = size_;
    this.max = max_;
    this.min = min_;
    this.inc = inc_;
    this.c = c_;
    this.cursor = cursor_;
  }
  
  boolean hover() {
    return (mouseX > this.pos.x && mouseX < this.pos.x + this.size.x &&
            mouseY > this.pos.y && mouseY < this.pos.y + this.size.y);
  }
  
  void display() {
    fill(this.c);
    noStroke();
    rectMode(CORNER);
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
    if (this.hover())
      this.cursor.clicked();
    this.rectify_cursor();
    this.cursor.display();
  }
  
  void rectify_cursor() {
    if (this.cursor.pos.x + this.cursor.size.x / 2 > this.pos.x + this.size.x)
      this.cursor.pos.x = this.pos.x + this.size.x - this.cursor.size.x / 2 ;
    if (this.cursor.pos.x - this.cursor.size.x / 2 < this.pos.x)
      this.cursor.pos.x = this.pos.x + this.cursor.size.x / 2 ;
    if (this.cursor.pos.y > this.pos.y + this.size.y / 2)
      this.cursor.pos.y = this.pos.y + this.size.y / 2;
    if (this.cursor.pos.y - this.cursor.size.y / 2 < this.pos.y)
      this.cursor.pos.y = this.pos.y + this.cursor.size.y;
  }
  
  float get_value() {
    float x = this.cursor.pos.x;
    x = map(x, this.pos.x, this.pos.x + this.size.x, this.min, this.max);
    return (x);
  }
}
