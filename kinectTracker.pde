
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

KinectTracker tracker;
Kinect kinect;

  int threshold = 800;
  PVector loc;
  PVector ploc; //previous location
  PVector lerpedLoc;
  int[] depth; 
  PImage display;
  float averageLocX = 0.0;
  float averageLocY = 0.0;
   

class KinectTracker {

  KinectTracker() {
    kinect.initDepth();
    kinect.enableMirror(true);
    //display = createImage(kinect.width, kinect.height, RGB);
    loc = new PVector(0, 0);
    ploc = new PVector(0, 0);
    lerpedLoc = new PVector(0, 0);
  }

  void track() {
    ploc = loc;
    depth = kinect.getRawDepth();
    if (depth == null) return;
    float sumX = 0;
    float sumY = 0;
    float count = 0;
    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {  
        int offset =  x + y*kinect.width;
        // Grabbing the raw depth
        int rawDepth = depth[offset];
        if (rawDepth < threshold) {
          sumX += x;
          sumY += y;
          count++;
        }
      }
    }
    // As long as we found something
    if (count != 0) {
      float mappedLocX = map(sumX/count,0,640,0,1440);
      float mappedLocY = map(sumY/count,0,480,0,900);
      averageLocX = 0.1*mappedLocX+0.9*averageLocX;
      averageLocY = 0.1*mappedLocY+0.9*averageLocY;
     loc = new PVector(averageLocX, averageLocY);
     // loc = new PVector(mappedLocX, mappedLocY);
    }
     lerpedLoc.x = PApplet.lerp(lerpedLoc.x, loc.x, 0.3f);
    lerpedLoc.y = PApplet.lerp(lerpedLoc.y, loc.y, 0.3f);
  }

float getposxDis(){
  float posxDis = loc.y - ploc.y;
  return posxDis;
}

 PVector getLerpedPos() {
    return lerpedLoc;
  }
   int getThreshold() {
    return threshold;
  }

  void setThreshold(int t) {
    threshold =  t;
  }


}