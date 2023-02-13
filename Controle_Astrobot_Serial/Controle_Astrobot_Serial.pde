// Importing Libraries
import processing.serial.*;
import controlP5.*;

// Creating Objects
Serial serial; 
ControlP5 cp5; 
Textarea SerialData;

// Variables
String Port = "";
String data;
String dir = "N";
String read;
int Speed = 0;
int Buzzer = 0;
boolean Connected = false;

void setup() {
 
  // Graphic Setup
  size(600,500);
  PFont font = createFont("Arial", 25, false); 
 
  cp5 = new ControlP5(this);
      
   // Text Area
     SerialData = cp5.addTextarea("SerialData")
    .setPosition(300,375)
    .setSize(250,100)
    .setFont(createFont("arial",22))
    .setLineHeight(14)
    .setColor(color(0,0,0))
    .setColorBackground(color(255,100))
    .setColorForeground(color(255,100))
    .setText("");
     
   // ListBox
    cp5.addScrollableList("SelectSerial")
   .setPosition(20,80)
   .setSize(200, 100)
   .setBarHeight(40)
   .setItemHeight(40)
   .addItems(Serial.list())
   .setType(ControlP5.LIST);
    
   // Speed Control
   cp5.addSlider("Speed")
  .setPosition(340,275)
  .setSize(180, 30)
  .setRange(0,256)
  .setValue(0)
  .setColorLabel(#3269c2)
  .setFont(font)
  .setCaptionLabel("");
  
   // Up Arrow Button
   cp5.addButton("UpArrow")
   .setValue(128)
   .setPosition(360,85)
   .setImages(loadImage("UpArrow.png"),loadImage("UpArrow.png"),loadImage("UpArrow.png"))
   .updateSize();
   
    // Down Arrow Button
   cp5.addButton("DownArrow")
   .setValue(128)
   .setPosition(360,149)
   .setImages(loadImage("DownArrow.png"),loadImage("DownArrow.png"),loadImage("DownArrow.png"))
   .updateSize();
   
    // Right Arrow Button
   cp5.addButton("RightArrow")
   .setValue(128)
   .setPosition(424,149)
   .setImages(loadImage("RightArrow.png"),loadImage("RightArrow.png"),loadImage("RightArrow.png"))
   .updateSize();
   
    // Left Arrow Button
   cp5.addButton("LeftArrow")
   .setValue(128)
   .setPosition(296,149)
   .setImages(loadImage("LeftArrow.png"),loadImage("LeftArrow.png"),loadImage("LeftArrow.png"))
   .updateSize();
   
   // Buzzer Button
   cp5.addButton("Buzzer")
   .setValue(128)
   .setPosition(515,90)
   .setImages(loadImage("Buzzer.png"),loadImage("Buzzer.png"),loadImage("Buzzer.png"))
   .updateSize();
    
   // Connect Button
   cp5.addButton("Connect")
  .setPosition(20,300)
  .setSize(175, 40)
  .setFont(font)
  .setCaptionLabel("Connect");
  
  // Disconnect Button
   cp5.addButton("Disconnect")
  .setPosition(20,350)
  .setSize(175, 40)
  .setFont(font)
  .setCaptionLabel("Disconnect");
  
   // Refresh Button
   cp5.addButton("Refresh")
  .setPosition(20,400)
  .setSize(175, 40)
  .setFont(font)
  .setCaptionLabel("Refresh");
  
  textFont(font);
}

void draw() {
  background(136,136,136);
  fill(255,255,255);
  textSize(40);
  text("Astrobot Serial", 160, 40);
  textSize(30);
  text("Move",360,75);
  text("Buzzer",500,75);
  text("Serial Readings",325,350);
  text("Velocity",380,250);
  
  Speed = int(cp5.getController("Speed").getValue());
  
  if (Connected){
      read = serial.readString();
      if (read != null){
          SerialData.setText(read);
      }
  }
}

// Serial Connection
String SelectSerial(int n) {
  Port = (String)cp5.get(ScrollableList.class,"SelectSerial").getItem(n).get("text");
  return Port;
}

// Connect to Serial Port
void Connect() {
    if (Serial.list().length != 0){      
        if(Port != ""){   
          if (!Connected){          
             serial = new Serial(this, Port, 115200);
             Connected = true;
             println("Connected");
           }
          else {
             println("Already connected");      
          }
        }
    } 
    else {
      println("Can't connect");      
    }
}

// Disconnect From Serial
void Disconnect() {
   if (Connected){
      serial.stop();
      Connected = false;
      println("Disconnected");
     }
   else {
     println("Already disconnected");   
   }
}

// Refresh available serial ports
void Refresh() {
  Port = "";
  cp5.get(ScrollableList.class, "SelectSerial").setItems(Serial.list());
}

// Up Arrow Click
void UpArrow() {
     if (Connected){
        dir = "F";
        data = "<" + dir + "/" + str(Speed) + "/" + str(Buzzer) + ">";
        println(data);
        delay(50);
        serial.write(data);
        println("Moving forward at " + Speed + " speed");
     }
}

// Down Arrow Click
void DownArrow() {
     if (Connected){
        dir = "B";
        data = "<" + dir + "/" + str(Speed) + "/" + str(Buzzer) + ">";
        println(data);
        delay(50);
        serial.write(data);
        println("Moving backward at " + Speed + " speed");
     }
}

// Right Arrow Click
void RightArrow() {
     if (Connected){
        dir = "R";
        data =  "<" + dir + "/" + str(Speed) + "/" + str(Buzzer) + ">";
        println(data);
        delay(50);
        serial.write(data);
        println("Moving right at " + Speed + " speed");
     }
}

// Left Arrow Click
void LeftArrow() {
     if (Connected){
        dir = "L";
        data = "<" + dir + "/" + str(Speed) + "/" + str(Buzzer) + ">";
        println(data);
        delay(50);
        serial.write(data);
        println("Moving left at " + Speed + " speed");
     }
}

// Buzzer Click
void Buzzer() {
     if (Connected){     
        Buzzer = 1;
        dir = "N";
        data = "<" + dir + "/" + str(Speed) + "/" + str(Buzzer) + ">";
        println(data);
        delay(50);
        serial.write(data);
        println("Buzzer ON");
     }
}

// Key pressed
void keyPressed() {
    if (key == '+') {
       if (Speed < 256){
         Speed = Speed + 1;   
         cp5.getController("Speed").setValue(Speed);
       }
    }
    else if (key == '-') {
       if (Speed > 0){
         Speed = Speed - 1; 
         cp5.getController("Speed").setValue(Speed);
       }
    }
    if (Connected){
       if (key == CODED) {
          if (keyCode == UP) {
              dir = "F";
              println("Moving forward at " + Speed + " speed");
          } 
          else if (keyCode == DOWN) {
              dir = "B";
              println("Moving backward at " + Speed + " speed");
          } 
          else if (keyCode == RIGHT) {
              dir = "R";
              println("Moving right at " + Speed + " speed");
          }
          else if (keyCode == LEFT) {
              dir = "L";
              println("Moving left at " + Speed + " speed");
          }
        else if (key == '0') {
             Buzzer = 1;
             println("Buzzer ON");    
        }
          data = "<" + dir + "/" + str(Speed) + "/" + str(Buzzer) + ">";
          println(data);
          delay(50);
          serial.write(data);
       }
    Buzzer = 0;
    dir = "N";
    }
}
