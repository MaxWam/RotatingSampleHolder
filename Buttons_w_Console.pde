import controlP5.*; //import ControlP5 library //<>//
import processing.serial.*;

Serial port;

ControlP5 cp5; //create ControlP5 object
Textarea myTextarea;
String Step_Angle = "";
String Scan_Number = "";
String Scan_Delay = "";
String sentInput = "";

PFont button_font;
PFont title_font;
PFont status_font;
String fakeConsole = "";
String lastCommand = "N/A";

void setup() { //same as arduino program

  size(800, 800);    //window size, (width, height)

  port = new Serial(this, "COM5", 115200);  //i have connected arduino to com3, it would be different in linux and mac os

  //lets add buton to empty window

  cp5 = new ControlP5(this);

  button_font = createFont("Arial", 20);    // custom fonts for buttons and title
  title_font = createFont("Arial Bold", 28);    // custom fonts for buttons and title
  status_font = createFont("Arial Italic", 20);

  cp5.addButton("Setup")     //"red" is the name of button
    .setPosition(150, 350)  //x and y coordinates of upper left corner of button
    .setSize(200, 75)      //(width, height)
    .setFont(button_font)
    ;

  cp5.addButton("Rotate")     //"red" is the name of button                                // Copy these rows V
    .setPosition(150, 475)  //x and y coordinates of upper left corner of button           //
    .setSize(200, 75)      //(width, height)                                               //
    .setFont(button_font)                                                                  //
    ;                                                                                        // For physical button

  cp5.addButton("Left")     //"red" is the name of button                                // Copy these rows V
    .setPosition(450, 350)  //x and y coordinates of upper left corner of button           //
    .setSize(200, 75)      //(width, height)                                               //
    .setFont(button_font)                                                                  //
    ;
    
  // For physical button
  cp5.addButton("Right")     //"red" is the name of button                                // Copy these rows V
    .setPosition(450, 475)  //x and y coordinates of upper left corner of button           //
    .setSize(200, 75)      //(width, height)                                               //
    .setFont(button_font)                                                                  //
    ;

  // For physical button
  cp5.addButton("Scan")     //"red" is the name of button                                // Copy these rows V
    .setPosition(150, 225) //x and y coordinates of upper left corner of button           //
    .setSize(200, 75)      //(width, height)                                               //
    .setFont(button_font)
    ;
    
  // For physical button
  cp5.addButton("Reset")     //"red" is the name of button                                // Copy these rows V
    .setPosition(450, 225) //x and y coordinates of upper left corner of button           //
    .setSize(200, 75)      //(width, height)                                               //
    .setFont(button_font)
    ;
    
  // text input field for scan time
  cp5.addTextfield("Step_Angle")
    .setPosition(150, 115)
    .setSize(100, 40)
    .setFont(button_font)
    .setAutoClear(false)
    ;

  // text input field for Number of Scans
  cp5.addTextfield("Scan_Number")
    .setPosition(350, 115)
    .setSize(100, 40)
    .setFont(button_font)
    .setAutoClear(false)
    ;
    
  // text input field for Number of Scans
  cp5.addTextfield("Scan_Delay")
    .setPosition(550, 115)
    .setSize(100, 40)
    .setFont(button_font)
    .setAutoClear(false)
    ;

  // text area to return Serial Data
  myTextarea = cp5.addTextarea("txt")
    .setPosition(100, 625)
    .setSize(600, 60)
    .setFont(button_font)
    .setLineHeight(30)
    .setColor(color(255))
    .setColorBackground(color(255, 100))
    .setColorForeground(color(255, 100));
  ;
  myTextarea.hideScrollbar();
}


//draw shapes to GUI
void draw() {  //same as loop in arduino

  background(0, 0, 0); // background color of window (r, g, b) or (0 to 255)
  //lets give title to our window
  fill(255, 255, 255);               //text color (r, g, b)
  textFont(title_font);
  text("Inputs:", 30, 142);
  text("Rotating Sample Holder Control", 185, 50);  // ("text", x coordinate, y coordinat)
  textFont(button_font);
  textFont(status_font);
  text("After typing inputs, click 'Enter' to confirm.", 225, 87);
  text("Status:", 30, 650);
  text("Last command: " + lastCommand, 310, 600);
  fill(0, 255, 0);               //text color (r, g, b)
  text(":" + Step_Angle, 260, 140); // return text of Scan Time input
  text(":" + Scan_Number, 460, 140); // return text of Number of Scans input
  text(":" + Scan_Delay, 660, 140); // return text of Number of Scans input



  //text("Return: ", 100, 400);
  while (port.available() > 0) {
    String position = port.readString();
    if (position != null) {
      println(position);
      myTextarea.setText(position);
    }
  }
}

//lets add some functions to our buttons
//so whe you press any button, it sends perticular char over serial port

//this causes shit to fail
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class)) {
    port.write('n');
    sentInput = theEvent.getStringValue();
    port.write(sentInput);
  }
  return;
}

public String readText() {
  return port.readString();
}

void Rotate() {
  port.write('r');
  lastCommand = "Rotate";
}

void Setup() {
  port.write('h');
  lastCommand = "Setup";
}

void Left() {
  port.write('l');
  lastCommand = "Left";
}

void Right() {
  port.write('m');
  lastCommand = "Right";
}

void Scan() {
    port.write('s');
    lastCommand = "Scan";
}

void Reset() {
    port.write('z');
    lastCommand = "Reset";
}
