// Include Libraries
#include <esp_now.h>
#include <WiFi.h>

// Variables to Split Data
char receivedChars[32];
char tempChars[32]; 
boolean newData = false;

// ESP NOW
char dir[32] = {0};
int vel = 0;
int buzzer = 0;
bool state = false;

// MAC Address of Astrobot ESP32
uint8_t broadcastAddress[] = {0x94, 0xE6, 0x86, 0x02, 0x6C, 0x4C};

// Define a data structure
typedef struct struct_message {
  char dir[32];
  int vel;
  bool state;
} struct_message;

// Create a structured object
struct_message ESP_Data;

// Peer info
esp_now_peer_info_t peerInfo;

// Callback function called when data is sent
void OnDataSent(const uint8_t *mac_addr, esp_now_send_status_t status) {
 // Serial.print("\r\nLast Packet Send Status:\t");
  //Serial.println(status == ESP_NOW_SEND_SUCCESS ? "Delivery Success" : "Delivery Fail");
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

  // Register the send callback
  esp_now_register_send_cb(OnDataSent);

  // Register peer
  memcpy(peerInfo.peer_addr, broadcastAddress, 6);
  peerInfo.channel = 0;
  peerInfo.encrypt = false;

  // Add peer
  if (esp_now_add_peer(&peerInfo) != ESP_OK) {
    Serial.println("Failed to add peer");
    return;
  }
}

void loop() {
  // Function to Receive Data
  recvWithStartEndMarkers();
  
  if (newData == true){
      strcpy(tempChars, receivedChars);
      
      // Parse Serial Port Input
      parseData();
   
      // Assign Variables to struct
      strcpy(ESP_Data.dir,dir);
      ESP_Data.vel = vel;
      ESP_Data.state = state;
      
      // Send message via ESP-NOW
      esp_err_t result = esp_now_send(broadcastAddress, (uint8_t *) &ESP_Data, sizeof(ESP_Data));

      // Write In Serial Port
      //showParsedData();
         
      newData = false; 

      delay(20);
  }
}

void recvWithStartEndMarkers(){
    static boolean recvInProgress = false;
    static byte ndx = 0;
    char startMarker = '<';
    char endMarker = '>';
    char rc;

    while (Serial.available() > 0 && newData == false){
        rc = Serial.read();

        if (recvInProgress == true){
            if (rc != endMarker){
                receivedChars[ndx] = rc;
                ndx++;
                if (ndx >= 32){
                    ndx = 32 - 1;
                }
            }
            else{
                receivedChars[ndx] = '\0'; // terminate the string
                recvInProgress = false;
                ndx = 0;
                newData = true;
            }
        }

        else if (rc == startMarker){
            recvInProgress = true;
        }
    }
}

void parseData(){  
  
    char * strtokIndx;
     
    strtokIndx = strtok(tempChars, "/");
    strcpy(dir, strtokIndx);
    
    strtokIndx = strtok(NULL, "/"); 
    vel = atoi(strtokIndx); 
    
    strtokIndx = strtok(NULL, "/"); 
    buzzer = atoi(strtokIndx);  

    if (buzzer == 1){
        state = true;
    }
    else if (buzzer == 0){
        state = false;
    }
}

void showParsedData() {
    Serial.print("Robot moved ");
    Serial.print(dir);
    Serial.print(" at ");
    Serial.println(vel);
    Serial.print("Buzzer ");
    Serial.println(buzzer);
}
