import ketai.sensors.*;

class ComplementaryFilter {
  // The values of a and b would be respect this condition:
  // a + b = 1
  private float a, b;
  float last;

  ComplementaryFilter( float a )
  {
    this.a = a;
    b  = 1 - a;
    last  =  0; 
  }
  
  public float compute( float curr )
  {
    last = a*last + b*curr; // Complementary filter equation
    return last; // The  value of last is saved inside class
  }
};

class PingPong
{
  private float x, y, speedX, speedY;
  private float accelY;
  private float diam, rectSize;
  
  PingPong()
  {
    this.diam = 10;
    this.rectSize = 200;
  }

  public void reset()
  {
    this.x = width/2;
    this.y = height/2;
    this.speedX = random(3, 5);
    this.speedY = random(3, 5);
  }
  
  public void play( float accelerometerY )
  {
    this.accelY = map(accelerometerY, -10, 10, 25, 800);
    
    ellipse(this.x, this.y, this.diam, this.diam);
    rect(0, 0, 20, height);   
    rect(width - 30, this.accelY - this.rectSize/2, 10, this.rectSize);
  
    this.x += this.speedX;
    this.y += this.speedY;
  
    // if ball hits movable bar, invert X direction
    if( this.x > width - 30 && this.x < width -20 && y > this.accelY - this.rectSize/2 && y < this.accelY + this.rectSize/2 )
       this.speedX = this.speedX * -1;
  
    // if ball hits wall, change direction of X
    if(this.x < 25)
    {
      this.speedX *= -1.1;
      this.speedY *= 1.1;
      this.x += this.speedX;
    }
    
    // if ball hits up or down, change direction of Y   
    if( this.y > height || this.y < 0 )
      this.speedY *= -1;  
  }
};


PingPong game;
KetaiSensor sensor;
ComplementaryFilter filter;
float accelerometerX, accelerometerY, accelerometerZ;

void setup()
{
  orientation(PORTRAIT);
  fullScreen();
  fill(0, 255, 0);
  
  filter = new ComplementaryFilter(0.85);
  sensor = new KetaiSensor(this);
  game = new PingPong();
  sensor.start();
  game.reset();
}

void draw()
{ 
  background(0);
  game.play(accelerometerY);
}

void mousePressed()
{
  game.reset();
}

void onAccelerometerEvent(float x, float y, float z)
{
  accelerometerY = filter.compute(y);  
  accelerometerX = x;
  accelerometerZ = z;
}
