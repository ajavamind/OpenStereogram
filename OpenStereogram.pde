/*
 * Processing implementation of OpenStereogram project
 * Converted to Processing from Java for desktop by Andy Modla 2017
 * Project  -- http://gfcaprojects.googlepages.com/openstereogram
 * Code -- https://code.google.com/archive/p/openstereogram/
 * License -- https://opensource.org/licenses/BSD-3-Clause
 */

PImage screen;
PImage depthMap;
PImage texturePattern;
StereogramGenerator stereogramGenerator;
ImageManipulator imageManipulator;
int saveCounter = 0;

void setup() {
  size(640, 480, P2D);
  //size(640, 960, P2D);
  stereogramGenerator = new StereogramGenerator();
  imageManipulator = new ImageManipulator();
  
  //depthMap = loadImage("./depthMaps/Struna.jpg");
  depthMap = loadImage("./depthMaps/Izba3.jpg");
  
  //texturePattern = loadImage("./texturePatterns/RAND7.jpg");
  //texturePattern = loadImage("./images/flower_640x480.jpg");
  //texturePattern = loadImage("./images/flower_64x48.jpg");
  texturePattern = loadImage("./images/flower_83x62.jpg");
  image(depthMap, 0, 0);
  image(texturePattern, 0, depthMap.height);
  //screen = generateSIRD();
  //screen = generateTexturedSIRD();
  screen = stereogramGenerator.generateTexturedSIRD(
    depthMap, texturePattern, 
    640, 480, 
    14f, 2.5f, 
    12f, 0f, 
    72, 72);
  // TEXT not converted to Processing
  // Test ImageManipulator
  //screen = imageManipulator.resizeDepthMap(depthMap, 800, 600);
  //screen = imageManipulator.generateTextDepthMap("ASDF", 150, 640, 480);
}

void draw() {
  background(0);
  image(screen, 0, 0);
}

void keyPressed() {
  //println("key="+key + " keyCode="+keyCode);
  if (keyCode == 'X') { // clear screen
    background(0);
    //} else if (keyCode >= '0' && keyCode <= '9') 
    //} else if (keyCode == 'C') {   // clear start
  } else if (keyCode == 'S') {  // save screen image
    saveFrame("data/myStereograms/stereogram"+saveCounter+".png");
    saveCounter++;
  } else if (key == '+') {   
    //updateDelta(extra);
  } else if (key == '-') {   
    //updateDelta(-extra);
  }
}

public PImage generateSIRD() {
  PImage depthMap = loadImage("./depthMaps/Struna.jpg");
  PImage stereogram = stereogramGenerator.generateSIRD(
    depthMap, 
    // black, white, red
    //color(0,0,0), color(255,255,255), color(0xFF0000), 
    // red, green, blue
    color(255,0,0), color(0,255,0), color(0,0,255), 
    0.5f, 
    640, 480, 
    14f, 2.5f, 
    12f, 0f, 
    72);

  return stereogram;
}

public PImage generateTexturedSIRD() {
  PImage depthMap = loadImage("./depthMaps/Struna.jpg");
  PImage texturePattern = loadImage("./texturePatterns/RAND7.jpg");

  final PImage stereogram = stereogramGenerator.generateTexturedSIRD(
    depthMap, texturePattern, 
    640, 480, 
    14f, 2.5f, 
    12f, 0f, 
    72, 72);

  return stereogram;
}