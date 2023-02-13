// Include Libraries
#include <WiFi.h>
#include <Move.h>
#include <Sound.h>
#include <esp_now.h>

// Right pins definition
const int AIN1 = 18;   // GPIO18
const int AIN2 = 05;   // GPIO05
const int PWMA = 16;   // GPIO16

// Left pins definition
const int BIN1 = 19;   // GPIO19
const int BIN2 = 23;   // GPIO23
const int PWMB = 17;   // GPIO17

// Defining Buzzer Pin
#define Buzzer 25

// Defining a data structure
typedef struct EspNowStruct {
  char dir[32];
  int vel;
  bool state;
} EspNowStruct;

// Create a structured object
EspNowStruct Data;

// Creating sound object
Sound sound(Buzzer);

// Creating Move object
Move Move(AIN1,AIN2,PWMA,BIN1,BIN2,PWMB);

// Callback function executed when data is received
void OnDataRecv(const uint8_t * mac, const uint8_t *incomingData, int len) {
  memcpy(&Data, incomingData, sizeof(Data));
  
  // Move Forward
  if (!strcmp(Data.dir,"F")){
      Move.stop();
      Move.forward(Data.vel,Data.vel);
  }
  // Move Backward
  else if (!strcmp(Data.dir,"B")){
      Move.stop();
      Move.backward(Data.vel,Data.vel);
  }
  // Move Right
  else if (!strcmp(Data.dir,"R")){
      Move.stop();
      Move.right(Data.vel,Data.vel);
  }
  // Move Left
  else if (!strcmp(Data.dir,"L")){
      Move.stop();
      Move.left(Data.vel,Data.vel);
  }

  // Buzzer
  if (Data.state){
    RandomSound(Data.state);
    Data.state = false;
  }
  
  // Delay for estability
  delay(10);
}

void setup() {
  // Set up Serial Monitor
  Serial.begin(115200);

  // Set ESP32 as a Wi-Fi Station
  WiFi.mode(WIFI_STA);

  // Initilize ESP-NOW
  if (esp_now_init() != ESP_OK) {
    Serial.println("Error initializing ESP-NOW");
    return;
  }

  // Register callback function
  esp_now_register_recv_cb(OnDataRecv);

}

void loop(){
  
}

// Random Sound Function
void RandomSound(bool played){
     if (played) {
        switch (random(1,7)){
            case 1:
              sound.surprised();
              break;
            case 2:
              sound.happy();
              break;
            case 3:
              sound.sad();
              break;
            case 4:
              sound.confused();
              break;
            case 5:    
              sound.fart();
              break;
            case 6:
              sound.pressed();
              break;
        }
     }
}
