#include <Wire.h>

#define SDA_PIN 14
#define SCL_PIN 15
#define I2C_ADDR 0x30

uint8_t status = 1;
uint8_t x = 120;
uint8_t y = 200;

void receiveEvent(int len) {

  while (Wire.available()) {
    char c = Wire.read();
    Serial.print("Received: ");
    Serial.println(c);
  }
}

void requestEvent() {

  uint8_t packet[4];

  packet[0] = status;
  packet[1] = x;
  packet[2] = y;
  packet[3] = status ^ x ^ y;   // checksum

  Wire.write(packet, 4);
}

void setup() {

  Serial.begin(115200);

  Wire.begin(I2C_ADDR, SDA_PIN, SCL_PIN, 100000);

  Wire.onReceive(receiveEvent);
  Wire.onRequest(requestEvent);

  Serial.println("ESP32 Ready");
}

void loop() {
}