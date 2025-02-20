/* * * *
 **           Name: David Keane
 ** Student Number: W20114756
 **          Title: Flame
 **        Summary: Mouse interactions to turn up/down/on/off a flame made from overlapping ellipses
 
 
 
 // Specification
 *   The usual Processing class containing the setup(), draw(), etc.
 
 Sizing the display window
 
 Use of selection (if) (including use of else)
 
 Use of iteration (loops). (including nested loops)
 
 Use of bespoke methods that you define and write yourself (use examples of the different types) e.g. similar to eyes(), drawX(). e.g. drawCell(), drawBackground.
 
 Use of Processing methods *e.g. circle(), random() *etc.
 
 Use of Mouse methods e.g. mousePressed(), etc.
 
 Use of String methods (e.g. length(), charAt(), etc.).
 
 ************************************************************
 
 Allowed:
 2d primitives (e.g. circle(), quad())
 Operators (arithmetic, logic, boolean)
 Trigonometry (e.g. sin(), rotate(), translate())
 Constants (from the Processing library e.g. PI)
 Primitive Data Types (including color which allows you to store RGB values in a variable of type color)
 Data Conversion
 random()
 rotate()
 translate()
 color()
 frameCount (although not recommended)
 charAt()
 global variables
 rectMode()
 ellipseMode()
 int()
 arrays
 JOptionPane()
 
 
 Out:
 Objects (except String which is required and Swing which is allowed)
 3d Renderers
 ArrayLists (or any collection other than arrays)
 Collections
 PShape (including beginShape() and endShape())
 PImage
 Materials
 Font
 casting (NB. use of int() is allowed)
 Transforms other than those highlighted in previous section
 pushMatrix()
 popMatrix()
 PVector
 randomSeed()
 noLoop
 
 
 
 * * * */

void setup() {
  size(840, 840); // Number with highest divisibility under 1000 ( 2^3 * 3 * 5 *7 )
  background(0);
}


// Setup
int segments = 1; // How many segments in our circles
float offset = 0; // Offset for rotation animation
float offsetStep = 0.005; // How much to change the rotation speed per interation

// Instructions
String[][] instructions = { // Make a nested array for animating the instruction text
  {
    "Left click to increase the flame",
    "Right click to turn it down",
    "Middle click for instant on/off"
  },
  {"1", "2", "3"} // Leave an empty space to animate into
};

// Styles
int iS = 40; // Increment size
int tI = iS; // Title indent
color bGC = color(0); // Background colour
color hC = color(200, 100, 0); // Highlight colour

// Sizing constraints for circles
int minimum = 10;
int maximum = width*2;
int mouseRadius = iS/5;
int backgroundRadius = iS * 4;

// Set high and low temp
int highTemp = 300;
int lowTemp = 40;
int averageTemp = (highTemp + lowTemp) / 2;



void draw() {

  background(bGC);
  drawBackground();
  mouseAnimation();
  drawInstructions();
  drawTitle(); // Draw title last so that it renders on top
}

void drawBackground() {

  drawEllipses(width/2, height/2, iS*3, iS*3, backgroundRadius);
}

void drawEllipses(int x1, int y1, int ellipseWidth, int ellipseHeight, int spread) {

  noFill();
  float angle = TWO_PI / segments; // Entire circle is 2 pi, so cut up into our segments

  for (int i = 1; i <= segments; i++) {
    // Using trigonometry to find the points on the circle
    float x2 = cos((angle + offset/i) * i) * spread;
    float y2 = sin((angle + offset/i) * i) * spread;

    // Randomise colours and transparency within restraints.
    // The increment (modified in mousePressed()) biases left clicks to red and right clicks to blue.
    stroke(
      random(iS, iS*2), // Red
      random(20, 80), // Green
      random(150-iS, 255-iS), // Blue
      random(120, 255)); // Alpha / transparency

    for (int j=1; j <= segments; j++) {
      ellipse(x1+x2, y1+y2, ellipseWidth/j, ellipseHeight/j);
    }
  }

  offset += offsetStep;
}

void drawTitle() { // Static text
  fill(hC);
  textAlign(CENTER);
  textSize(18);
  text("David Keane", width/2, tI);
  textSize(24);
  text("Flame", width/2, 2*tI);
  textSize(18);
  text("W20114756", width/2, height-tI);
}

void drawInstructions() { // Draw the user instructions

  textSize(12);
  // Set up defaults. These will be overwritten based on a toggle
  int toggle = 0;
  textAlign(LEFT);
  int xyPlacement = tI;
  
  while (toggle < 2) { // Just dealing with left / right alignment and xy position of draw
    int numberItems = instructions[toggle].length;
    if (toggle==1) { // Cases for the right-hand text
      textAlign(RIGHT);
      xyPlacement = width - 4*tI;
    }

    for (int i = 0; i<numberItems; i++) {
      text(instructions[toggle][i], xyPlacement+(random(1,iS/20)), height/2+(4+i)*tI); // Add flickering position based on the current increment size (flame intensity)
    }
    toggle++;
  }
}

void mouseAnimation() {
  drawEllipses(mouseX, mouseY, iS/3, iS/3, mouseRadius); // Add a mini version of the main animation as a mouse animation.
}

void mousePressed() { // Left to increase increment size, right to decrease, middle to toggle high / low
  if (mouseButton==LEFT) {
    if (iS<maximum) { iS += iS/3; }
    segments = segments + 1;
  } else if (mouseButton==RIGHT) {
    if (iS>minimum) { iS -= iS/12; }
    segments = segments - 1;
  } else { // Middle click
    if (iS<=averageTemp) { // if low, set high
      segments = 40;
      iS = highTemp;
    } else if (iS>averageTemp) { // if high, set low
      segments = 1;
      iS = lowTemp;
    }
  }
}
