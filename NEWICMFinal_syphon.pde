import wblut.math.*;
import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import codeanticode.syphon.*;
import codeanticode.syphon.*;

SyphonServer server;
PGraphics canvas;

float gapTime = 25000.0;

//___________________________________________________________________________
//mode1 variables
//side strings
ArrayList<Sin_string> strings = new ArrayList<Sin_string>();
int springNum = 12;

//center strings
ArrayList<Sin_string> centerStrings = new ArrayList<Sin_string>();
int centerSpringNum0 = 3;
int centerSpringNum1 = 7;
int centerSpringNum2 = 3;
int centerSpringNum3 = 3;
int sideStringNum = 6;
PImage img;
float sideStringK = 0.538;


//___________________________________________________________________________
//mode2 variables
HE_Mesh mesh;
WB_Render3D render;
WB_DebugRender3D drender;
WB_Point[] points, z;
int num;
float x;
float y;
float _x=0;
float _y=0;
void settings() {
  size(1440, 900, P3D);
  PJOGL.profile=1;
}

void setup() {

  canvas = createGraphics(1440, 900, P3D);
  server = new SyphonServer(this, "Processing Syphon");
  img = loadImage("physicalCircle.jpg");
  smooth(8);
  //set up Kinect
  kinect = new Kinect(this);
  tracker = new KinectTracker();

  WB_RandomOnSphere rs=new WB_RandomOnSphere();
  num=500;
  points =new WB_Point[num];
  for (int i=0; i<num; i++) {  
    points[i]=rs.nextPoint().mulSelf(280.0);
  }
  z=points;



  //side strings1
  for (int n = 1; n<sideStringNum; n++) {
    for (int j = 1; j<springNum+1; j++) {
      int sy = height/2;
      float sx = width/2+4;
      float sa = (j)*(2*PI/12)-0.02+0.04*n;
      float sk = -sideStringK;
      int sl = 71;
      int maxAmp = 5;
      int sPeriod = 150;
      boolean sAutoMoveState = true;
      strings.add(new Sin_string(sx, sy, sa, sk, sl, maxAmp, sPeriod, sAutoMoveState));
    }
    for (int i = 0; i<strings.size (); i++) {
      Sin_string s = strings.get(i);
      s.setupString();
    }
  }

  //side strings1
  for (int n = 1; n<sideStringNum; n++) {
    for (int j = 1; j<springNum+1; j++) {
      int sy = height/2;
      float sx = width/2+4;
      float sa = (j)*(2*PI/12)+0.30+0.04*n;
      float sk = sideStringK;
      int sl = 71;
      int maxAmp = 5;
      int sPeriod = 150;
      boolean sAutoMoveState = true;
      strings.add(new Sin_string(sx, sy, sa, sk, sl, maxAmp, sPeriod, sAutoMoveState));
    }
    for (int i = 0; i<strings.size (); i++) {
      Sin_string s = strings.get(i);
      s.setupString();
    }
  }


  //________________________________________________________________________________________________
  //center strings0
  for (int j = 3; j<centerSpringNum0+1; j++) {
    int sy = 127+j*23;
    float sx = 360-j*16;
    float sa = 0;
    float sk = 0;
    int sl = j*16+80;
    int maxAmp = 20;
    int sPeriod = 250;
    boolean sAutoMoveState = false;
    centerStrings.add(new Sin_string(sx, sy, sa, sk, sl, maxAmp, sPeriod, sAutoMoveState));
  }
  for (int i = 0; i<centerStrings.size (); i++) {
    Sin_string cs = centerStrings.get(i);
    cs.setupString();
  }


  //center strings1
  for (int j = 3; j<centerSpringNum1+1; j++) {
    int sy = 150+j*23;
    float sx = 300-j*15;
    float sa = 0;
    float sk = 0;
    int sl = j*15+140;
    int maxAmp = 20;
    int sPeriod = 250;
    boolean sAutoMoveState = false;
    centerStrings.add(new Sin_string(sx, sy, sa, sk, sl, maxAmp, sPeriod, sAutoMoveState));
  }
  for (int i = 0; i<centerStrings.size (); i++) {
    Sin_string cs = centerStrings.get(i);
    cs.setupString();
  }

  //center strings2
  for (int j = 1; j<centerSpringNum2+1; j++) {
    int sy = 311+j*23;
    float sx = 200-j*14;
    float sa = 0;
    float sk = 0;
    int sl = j*14+240;
    int maxAmp = 20;
    int sPeriod = 250;
    boolean sAutoMoveState = false;
    centerStrings.add(new Sin_string(sx, sy, sa, sk, sl, maxAmp, sPeriod, sAutoMoveState));
  }
  for (int i = 0; i<centerStrings.size (); i++) {
    Sin_string cs = centerStrings.get(i);
    cs.setupString();
  }

  //center strings3
  for (int j = 1; j<centerSpringNum3+1; j++) {
    int sy = 380+j*23;
    float sx = 170-j*12;
    float sa = 0;
    float sk = 0;
    int sl = j*12+270;
    int maxAmp = 20;
    int sPeriod = 250;
    boolean sAutoMoveState = false;
    centerStrings.add(new Sin_string(sx, sy, sa, sk, sl, maxAmp, sPeriod, sAutoMoveState));
  }
  for (int i = 0; i<centerStrings.size (); i++) {
    Sin_string cs = centerStrings.get(i);
    cs.setupString();
  }

  //________________


  //center strings6
  for (int j = 3; j<centerSpringNum1+1; j++) {
    int sy = 542+j*23;
    float sx = 190+j*15;
    float sa = 0;
    float sk = 0;
    int sl = -j*15+250;
    int maxAmp = 20;
    int sPeriod = 250;
    boolean sAutoMoveState = false;
    centerStrings.add(new Sin_string(sx, sy, sa, sk, sl, maxAmp, sPeriod, sAutoMoveState));
  }
  for (int i = 0; i<centerStrings.size (); i++) {
    Sin_string cs = centerStrings.get(i);
    cs.setupString();
  }

  //center strings5
  for (int j = 1; j<centerSpringNum2+1; j++) {
    int sy = 519+j*23;
    float sx = 160+j*14;
    float sa = 0;
    float sk = 0;
    int sl = -j*14+280;
    int maxAmp = 20;
    int sPeriod = 250;
    boolean sAutoMoveState = false;
    centerStrings.add(new Sin_string(sx, sy, sa, sk, sl, maxAmp, sPeriod, sAutoMoveState));
  }
  for (int i = 0; i<centerStrings.size (); i++) {
    Sin_string cs = centerStrings.get(i);
    cs.setupString();
  }

  //center strings4
  for (int j = 1; j<centerSpringNum3+1; j++) {
    int sy = 453+j*23;
    float sx = 142+j*8;
    float sa = 0;
    float sk = 0;
    int sl = -j*8+298;
    int maxAmp = 20;
    int sPeriod = 250;
    boolean sAutoMoveState = false;
    centerStrings.add(new Sin_string(sx, sy, sa, sk, sl, maxAmp, sPeriod, sAutoMoveState));
  }
  for (int i = 0; i<centerStrings.size (); i++) {
    Sin_string cs = centerStrings.get(i);
    cs.setupString();
  }
}

int z1=300;
int a=0;
int b=0;
float yoff = 0.0; 


//________________________________________________________________________________________________________

void draw() {
  canvas.beginDraw();
  if (b==0)a=a+2;
  else a = a-2;
  if (a>=250) b=1;
  if (a<=0)b=0;

  float times = millis()/gapTime;
  int modeCount = floor (times/2);
  float count2 = times/2 - modeCount;
  float countOdd = modeCount/2;


  if (countOdd*2 == modeCount && count2>0.9) {
    pushStyle();
    canvas.background(0);
    canvas.background(0,2);
    canvas.translate(width/2,height/2);
    
    canvas.stroke(255, 25);
    canvas.strokeWeight(8);
    canvas.noFill();
   
    float yoff=0;
     //int z1=300;
    for (int i=0; i<100; i++) {
      canvas.beginShape();   
      float xoff = 0;   
      for (float p = 0; p <=2*PI; p =p+0.01*PI) {    
        float r = map(noise(xoff, yoff), 0, 1, 200, z1); 
        canvas.vertex(r*sin(p), r*cos(p)); 
        xoff += 0.5;
        yoff += 0.5;
      }
      canvas.endShape(CLOSE);
    }
    
    if (z1<=500) {
      z1++;
    }
    popStyle();
   
  }
  
  
  if (countOdd*2 == modeCount && count2<=0.9) {
    mode2();
    a=0;
    z1=300;
   
  }
  
  else if (countOdd*2!= modeCount && count2>0.9) {
    pushStyle();
    canvas.background(0);
    canvas.background(0,2);
    canvas.translate(width/2,height/2);
    
    canvas.stroke(255, 25);
    canvas.strokeWeight(8);
    canvas.noFill();
   
    float yoff=0;
    for (int i=0; i<100; i++) {
      canvas.beginShape();   
      float xoff = 0;  
        //int z1=300;
      for (float p = 0; p <=2*PI; p =p+0.01*PI) {    
        float r = map(noise(xoff, yoff), 0, 1, 200, z1); 
        canvas.vertex(r*sin(p), r*cos(p)); 
        xoff += 0.5;
        yoff += 0.5;
      }
      canvas.endShape(CLOSE);
    } 
    if (z1<=500) {
      z1++;
    }
    popStyle();
  } else if (countOdd*2!= modeCount && count2<=0.9) {
    mode1();
    a=0;
    z1=300;
  }


  int t = tracker.getThreshold();
  canvas.fill(255);

  canvas.endDraw();
  image(canvas, 0, 0);
  server.sendImage(canvas);
  println(threshold);
}

void mode2() {
   background(0,20);
  background(0);
  pushMatrix();
  translate(width/2, height/2, 0);
  tracker.track();
  popMatrix();
  PVector v2 = tracker.getLerpedPos();

  _x=v2.x*0.999+_x*0.001;
  _y=v2.y*0.999+_y*0.001;

  create();
  //image(img, 0, 0);

  pushMatrix();
  translate(width/2, height/2, 0);
  canvas.pushMatrix();
  canvas.pushStyle();
  canvas.translate(width/2, height/2-50);
  update();
  canvas.stroke(255, 50);
  canvas.strokeWeight(4);
  canvas.noFill();

  for (int i=0; i<10; i++) {
    canvas.beginShape(); 
    
    float xoff = 0;   
    for (float p = 0; p <=2*PI; p =p+0.01*PI) {    
      float r = map(noise(xoff, yoff), 0, 1, 350, 400); 
      canvas.vertex(r*sin(p), r*cos(p)); 
      xoff += 0.01;
      yoff += 0.01;
    }
    canvas.endShape(CLOSE);
  }


  canvas.popMatrix();
  canvas.popStyle();
    
  //lightSpecular(0, 0, 1);
  directionalLight(180, 180, 180, 0, 0, -1);
  //spotLight(255, 255, 255, _x, _y, 3500, 0, 0, -1, PI, 500); 
  spotLight(255, 255, 255, map(_x, 0, width, -450, 450), map(_y, 0, height, -500, 500), 3500, 0, 0, -10, PI, 1000); 
  //print(_x, _y);   
  //specular(255, 255, 255);
  //shininess(10.0); 
  
  //render.drawEdges(mesh);
  rotateY(_x*1.0f/width*PI);
  rotateX(_y*1.0f/height*PI); 
  noStroke();
  //stroke(255);
  //strokeWeight(1);
  //fill(255);
  
  render.drawFaces(mesh);
  popMatrix();
   canvas.ellipse(_x, _y, 60, 60);
  
}

void mode1() {
  background(0);
  // canvas.fill(0, 150);
  //canvas.rect(0, 0, width, height);
  //image(img, 0, 0);

  tracker.track();
  //tracker.display();
  //side strings
  for (int i = 0; i<strings.size (); i++) {
    Sin_string s = strings.get(i);
    s.updateSpring();
    s.calcWave();
    s.renderWave();
  }


  //center strings
  for (int i = 0; i<centerStrings.size (); i++) {
    Sin_string cs = centerStrings.get(i);
    cs.updateSpring();
    cs.calcWave();
    cs.renderWave();
  }
  //canvas.ellipse(loc.x, loc.y, 3, 3);
}

void create() {
  HEC_ConvexHull creator=new HEC_ConvexHull();
  creator.setPoints(z);
  creator.setN(num);  
  mesh=new HE_Mesh(creator); 
  mesh=new HE_Mesh(new HEC_Dual(mesh));
  mesh.modify(new HEM_PunchHoles().setWidth(1));
  render=new WB_Render3D(this);
  drender=new WB_DebugRender3D(this);
}

void update() {
  float[] _x1;
  float[] _y1;
  float vx=0; 
  float vy=0; 
  _x1=new float[num];
  _y1=new float[num];
  for (int i=0; i<num; i++) {
    _x1[i]= points[i].xf();
    _y1[i]= points[i].yf();
    int rx = (int)_x-width/2;
    int ry = (int)_y-height/2; 
    float radius = dist(points[i].xf(), points[i].yf(), rx, ry);    
    if (radius < 150) {
      float angle = atan2(points[i].yf()-ry, points[i].xf()-rx);
      vx -= (150 - radius)*0.5* cos(angle + (0.7 + 0.0005 * (150 - radius)));
      vy -= (150 - radius)*0.5* sin(angle + (0.7 + 0.0005 * (150 - radius)));
    }

    _x1[i] += vx;
    _y1[i] += vy;
    vx *= 0.97;
    vy *= 0.97; 
    pushStyle();
    canvas.stroke(255);
    canvas.strokeWeight(3);
    canvas.point(_x1[i], _y1[i], points[i].zf());
    popStyle();
    z[i] = new WB_Point(points[i].xf(), points[i].yf(), points[i].zf());
  }
}  

void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
    } else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
    }
  }
}