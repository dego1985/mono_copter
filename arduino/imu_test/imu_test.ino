#include <Wire.h>
#include <Servo.h>
#include "imu.h"
#include "pico/stdlib.h"

IMU_BMX055 imu;
const float radian_to_angle = 180/PI;
void setup() {

//  Serial.begin(115200); // Terminal
  Serial.begin(2000000); // Terminal
  Serial.println("start setup");
  Serial.println("start setup end");
}
void loop() {
}

void setup1() {
  // Wire(Arduino-I2C)の初期化
  Wire1.setSDA(6);
  Wire1.setSCL(7);
  Wire1.begin();
  Serial.println("start setup1");
  
  delay(1000);
  imu.setup();
//  imu.calib();
  Serial.println("start setup1 end");
  delay(1000);
}

int loop1_counter = 0;
float gx = 0;
float gy = 0;
float gz = 0;
void loop1() {
  // get sensor
  imu.update();
  Serial.print("s,");
  imu.print();
//  imu.print_raw();
  Serial.println();
}
