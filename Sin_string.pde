
class Sin_string {
  float[] yvalues; 
  ArrayList ellipses = new ArrayList();
  PVector ellipsePos;
  int stringLength = 72;



  float maxEllipseX = 0;
  float minEllipseX = width;
  float maxEllipseY = 0;
  float minEllipseY = 0;

  //how the line looks like
  int xspacing = 2;   // How far apart should each horizontal location be spaced
  int w;              // Width of entire wave
  int ellipseR = 2;
  float ellipseX = 0;
  float ellipseY = 0;
  float stringY = height/2; //where the sin_wave sit in Y range
  float stringX = width/2;
  float stringK = 0;
  float rotateAngle = 0;

  float theta = 0.0;  // Start angle at 0
  float period = 250.0;  // How many pixels before the wave repeats
  float dx;  // Value for incrementing X, a function of period and xspacing

  //constants for string
  float M = 0.8;   // Mass
  float K = 0.1;   // Spring constant
  float D = 0.90;  // Damping
  float R = 0;   // Rest position
  float maxDis = 10;//the amplitude would be the original+/- maxDis;

  // Spring simulation variables
  float ps = R;    // Position
  float vs = 0.0;  // Velocity
  float as = 0;    // Acceleration
  float f = 0;     // Force

  boolean move = false;   // If mouse down and over
  boolean autoMoveState = false;
  boolean moveState = false; //if austoMoveState = true, it has move state to determine move or not randomly

  //constructor
  //_angle = rotate angle
  //_k the slope for the string
  Sin_string(float _x, float _y, float _angle, float _k, int _l, int _maxDis, int _period, boolean _autoMoveState) {
    stringX = _x;
    stringY = _y;
    stringK = _k;
    stringLength =_l;
    rotateAngle = _angle;
    maxDis = _maxDis;
    period = _period;
    autoMoveState = _autoMoveState;
  }

  void setupString() {
    w = 20+16;
    dx = (TWO_PI / period) * xspacing;
    //yvalues = new float[w/xspacing];
    yvalues = new float[stringLength];
  }


  void updateSpring() {
    if (move != true) {
      f = -K * (ps - R);    // f=-ky
      as = f / M;           // Set the acceleration, f=ma == a=f/m
      vs = D * (vs + as);   // Set the velocity
      ps = ps + vs;         // Updated position
    }
    if (abs(vs) < 0.1) {
      vs = 0.0;
    }
    // Set and constrain the position of top bar
    //PVector mousePos = new PVector(mouseX, mouseY);
    //PVector pmousePos = new PVector(pmouseX, pmouseY);

    if (move&&autoMoveState == false) {
      PVector disLoc = PVector.sub(loc, ploc);
      ps = disLoc.mag();
      ps = constrain(ps, R-maxDis, R+maxDis);
    }
    if (move&&autoMoveState == true && moveState == true) {
      ps = random(0, maxDis);
    }

    //----------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------
    //determining move or not
    if (autoMoveState == true) {
      float randomness = random(0, 1);
      if (randomness>0.95) moveState = true;
      if (randomness<=0.95)moveState = false;
      if (moveState && vs == 0) {
        move = true;
      }
      if (!moveState ) {
        move = false;
      }
    }
    
    if (autoMoveState==false) {
      for (int i = 0; i<ellipses.size (); i++) {
        //y1:minEllipseY; y2: maxEllipseY;
        //x1:minEllipseX; x2; maxEllipseX;
        float dis = abs(((minEllipseY-maxEllipseY)*loc.x+(maxEllipseX-minEllipseX)*loc.y+(maxEllipseY-minEllipseY)*minEllipseX+(minEllipseX-maxEllipseX)*minEllipseY)/
          sqrt(sq(minEllipseY-maxEllipseY)+sq(maxEllipseX-minEllipseX)));

        if (dis<20&& loc.x>minEllipseX && loc.x<maxEllipseX  ) 
        {
          move = true;
        } else {
          move = false;
        }
      }
    }
  }

  void calcWave() {
    // Increment theta (try different values for 'angular velocity' here
    theta += 0.02;

    // For every x value, calculate a y value with sine function
    float x = theta;
    for (int i = 0; i < yvalues.length; i++) {
      yvalues[i] = sin(x)*ps;
      x+=dx;
    }
  }

  void renderWave() {
    noStroke();
    fill(255);

    pushMatrix();
    //translate(width/2, height/2);
    translate(stringX, stringY);
    rotate(-rotateAngle);
    for (int x = 0; x < yvalues.length; x++) {
      float offy = stringK*x;
      //float offy = 0;
      ellipsePos =new PVector(288+x*xspacing, (offy+yvalues[x]));
      fill(255);
      ellipse(ellipsePos.x, ellipsePos.y, ellipseR, ellipseR);
      ellipsePos.rotate(-rotateAngle);
      PVector center = new PVector(stringX, stringY);
      ellipsePos.add(center);

      if (ellipsePos.x<minEllipseX)
      {
        minEllipseX = ellipsePos.x;
        minEllipseY = ellipsePos.y;
      }
      if (ellipsePos.x>maxEllipseX)
      {
        maxEllipseX = ellipsePos.x;
        maxEllipseY = ellipsePos.y;
      }
      if (ellipses.size()<yvalues.length) {
        ellipses.add(ellipsePos);
      }
    }
    popMatrix();
  }
}