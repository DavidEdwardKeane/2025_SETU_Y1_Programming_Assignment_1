/* * * *
 **           Name: David Keane
 ** Student Number: W20114756
 **          Title: Flame
 **        Summary: Mouse interactions to turn up/down/on/off a flame made from rotating overlapping circles
 */



void setup() {
  size(840, 840); // High divisibility for animation application
  background(0);
}


// Initial variable declarations
int segments = 1; // How many segments in our circles initially
float offset = 0; // Offset for rotation animation
float offsetStep = 0.005; // How much to change the rotation speed per interation

// Instructions
String[] instructions = { // Make an array for iterating instruction text content
  "Left click to add flame",
  "Right click to turn it down",
  "Middle click for instant on/off"
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

void drawEllipses(int x1, int y1, int ellipseWidth, int ellipseHeight, int spread) { // Just drawing circles at the moment, but allow for ellipses. x1 and y1 for origin of draw.

  noFill();
  float angle = TWO_PI / segments; // Entire circle is 2 pi, so cut up into our segments

  for (int i = 1; i <= segments; i++) {
    // Using trigonometry (cos/sin) to find the points on the circle
    float x2 = cos((angle + offset/i) * i) * spread;
    float y2 = sin((angle + offset/i) * i) * spread;

    // Randomise colours and transparency within restraints.
    // The increment size (iS - modified in mousePressed()) biases left clicks to red and right clicks to blue.
    stroke(
      random(iS, iS*2), // Red increases depending on intensity
      random(20, 80), // Green
      random(150-iS, 255-iS), // Blue decreases with intensity
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

  while (toggle < 2) { // Just dealing with left / right alignment and xy position of draw. Adds while()
    int numberItems = instructions.length;
    for (int i = 0; i<numberItems; i++) {
      String currentText = instructions[i];
      if (toggle==1) { // Cases for the right-hand text
        textAlign(RIGHT);
        xyPlacement = width - tI;
        currentText = currentText.length() + " characters"; // Needed to use a string method somehow
      }
      text(currentText, xyPlacement+(random(1, iS/20)), height/2+(4+i)*tI); // Add flickering text position based on the current increment size (flame intensity)
    }
    toggle++;
  }
}

void mouseAnimation() {
  drawEllipses(mouseX, mouseY, iS/3, iS/3, mouseRadius); // Add a mini version of the main animation as a mouse animation.
}

void mousePressed() { // Left to increase increment size, right to decrease, middle to toggle high / low
  if (mouseButton==LEFT) {
    if (iS<maximum) {
      iS += iS/3; // Manual gearing.
    }
    segments++;
  } else if (mouseButton==RIGHT) {
    if (iS>minimum) {
      iS -= iS/12;  // The gearing here is manual also.
    }
    segments = segments--;
  } else { // Middle click toggles
    if (iS<=averageTemp) { // if low, set high
      segments = 40;
      iS = highTemp;
    } else if (iS>averageTemp) { // if high, set low
      segments = 1;
      iS = lowTemp;
    }
  }
}
