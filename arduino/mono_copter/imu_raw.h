#pragma once

#include "math.h"

class IMU_BMX055_BASE {
    const byte Addr_Accl = 0x19;
    const byte Addr_Gyro = 0x69;
    const byte Addr_Mag = 0x13;


    quat_t acc_bias = {0, -0.34355038,  1.0456041 , -0.24428251};
    quat_t gyro_bias = {0, 0, 0, 0 };
    quat_t mag_bias = {0, 229.12825 ,  118.218315, -143.08875 };

  public:
    quat_t acc_raw;
    quat_t gyro_raw;
    quat_t mag_raw;
    quat_t gyro;
    quat_t mag;
    quat_t acc;
    quat_t gravity;
    
  private:
    void BMX055_Init()
    {
      //------------------------------------------------------------//
      Wire1.beginTransmission(Addr_Accl);
      Wire1.write(0x0F); // Select PMU_Range register
//      Wire1.write(0x03);   // Range = +/- 2g
      Wire1.write(0x0C);   // Range = +/- 16g
      Wire1.endTransmission();
      delay(100);
      //------------------------------------------------------------//
      Wire1.beginTransmission(Addr_Accl);
      Wire1.write(0x10);  // Select PMU_BW register
//      Wire1.write(0x08);  // Bandwidth = 7.81 Hz
      Wire1.write(0x0F);  // Bandwidth = 1000 Hz
      Wire1.endTransmission();
      delay(100);
      //------------------------------------------------------------//
      Wire1.beginTransmission(Addr_Accl);
      Wire1.write(0x11);  // Select PMU_LPW register
      Wire1.write(0x00);  // Normal mode, Sleep duration = 0.5ms
      Wire1.endTransmission();
      delay(100);
      //------------------------------------------------------------//
      Wire1.beginTransmission(Addr_Gyro);
      Wire1.write(0x0F);  // Select Range register
//      Wire1.write(0x04);  // Full scale = +/- 125 degree/s
      Wire1.write(0x00);  // Full scale = +/- 2000 degree/s
      Wire1.endTransmission();
      delay(100);
      //------------------------------------------------------------//
      Wire1.beginTransmission(Addr_Gyro);
      Wire1.write(0x10);  // Select Bandwidth register
//      Wire1.write(0x07);  // ODR = 100 Hz
      Wire1.write(0x02);  // ODR = 1000 Hz
      Wire1.endTransmission();
      delay(100);
      //------------------------------------------------------------//
      Wire1.beginTransmission(Addr_Gyro);
      Wire1.write(0x11);  // Select LPM1 register
      Wire1.write(0x00);  // Normal mode, Sleep duration = 2ms
      Wire1.endTransmission();
      delay(100);
      //------------------------------------------------------------//
      Wire1.beginTransmission(Addr_Mag);
      Wire1.write(0x4B);  // Select Mag register
      Wire1.write(0x00);  // suspend
      Wire1.endTransmission();
      delay(100);
      //------------------------------------------------------------//
      Wire1.beginTransmission(Addr_Mag);
      Wire1.write(0x4B);  // Select Mag register
      Wire1.write(0x83);  // Soft reset
      Wire1.endTransmission();
      delay(100);
      //------------------------------------------------------------//
      Wire1.beginTransmission(Addr_Mag);
      Wire1.write(0x4B);  // Select Mag register
      Wire1.write(0x01);  // Soft reset
      Wire1.endTransmission();
      delay(100);
      //------------------------------------------------------------//
      Wire1.beginTransmission(Addr_Mag);
      Wire1.write(0x4C);  // Select Mag register
//      Wire1.write(0x00);  // Normal Mode, ODR = 10 Hz
      Wire1.write(0x28);  // Normal Mode, ODR = 20 Hz
      Wire1.endTransmission();
      //------------------------------------------------------------//
      Wire1.beginTransmission(Addr_Mag);
      Wire1.write(0x4E);  // Select Mag register
      Wire1.write(0x84);  // X, Y, Z-Axis enabled
      Wire1.endTransmission();
      //------------------------------------------------------------//
      Wire1.beginTransmission(Addr_Mag);
      Wire1.write(0x51);  // Select Mag register
//      Wire1.write(0x04);  // No. of Repetitions for X-Y Axis = 9
      Wire1.write(0x17);  // No. of Repetitions for X-Y Axis = 47
      Wire1.endTransmission();
      //------------------------------------------------------------//
      Wire1.beginTransmission(Addr_Mag);
      Wire1.write(0x52);  // Select Mag register
//      Wire1.write(0x16);  // No. of Repetitions for Z-Axis = 15?
      Wire1.write(0x52);  // No. of Repetitions for Z-Axis = 83
      Wire1.endTransmission();
    }
    void BMX055_Accl()
    {
      float xAccl = 0.00;
      float yAccl = 0.00;
      float zAccl = 0.00;
      unsigned int data[6];
      for (int i = 0; i < 6; i++)
      {
        Wire1.beginTransmission(Addr_Accl);
        Wire1.write((2 + i));// Select data register
        Wire1.endTransmission();
        Wire1.requestFrom(Addr_Accl, 1);// Request 1 byte of data
        // Read 6 bytes of data
        // xAccl lsb, xAccl msb, yAccl lsb, yAccl msb, zAccl lsb, zAccl msb
        if (Wire1.available() == 1)
          data[i] = Wire1.read();
      }
      // Convert the data to 12-bits
      xAccl = ((data[1] * 256) + (data[0] & 0xF0)) / 16;
      if (xAccl > 2047)  xAccl -= 4096;
      yAccl = ((data[3] * 256) + (data[2] & 0xF0)) / 16;
      if (yAccl > 2047)  yAccl -= 4096;
      zAccl = ((data[5] * 256) + (data[4] & 0xF0)) / 16;
      if (zAccl > 2047)  zAccl -= 4096;
//      const float lsb2acc = 9.80 * 0.00098; // range = +/-2g
      const float lsb2acc = 9.80 * 0.00781; // range = +/-16g
      xAccl = xAccl * lsb2acc;
      yAccl = yAccl * lsb2acc;
      zAccl = zAccl * lsb2acc;
      acc_raw = quat_t(0, xAccl, yAccl, zAccl);
      acc = acc_raw - acc_bias;
    }
    //=====================================================================================//
    void BMX055_Gyro()
    {
      float xGyro = 0.00;
      float yGyro = 0.00;
      float zGyro = 0.00;
  
      unsigned int data[6];
      for (int i = 0; i < 6; i++)
      {
        Wire1.beginTransmission(Addr_Gyro);
        Wire1.write((2 + i));    // Select data register
        Wire1.endTransmission();
        Wire1.requestFrom(Addr_Gyro, 1);    // Request 1 byte of data
        // Read 6 bytes of data
        // xGyro lsb, xGyro msb, yGyro lsb, yGyro msb, zGyro lsb, zGyro msb
        if (Wire1.available() == 1)
          data[i] = Wire1.read();
      }
      // Convert the data
      xGyro = (data[1] * 256) + data[0];
      if (xGyro > 32767)  xGyro -= 65536;
      yGyro = (data[3] * 256) + data[2];
      if (yGyro > 32767)  yGyro -= 65536;
      zGyro = (data[5] * 256) + data[4];
      if (zGyro > 32767)  zGyro -= 65536;

      const float k = 1 / 16.4;
      xGyro = xGyro * k; //  Full scale = +/- 125 degree/s
      yGyro = yGyro * k; //  Full scale = +/- 125 degree/s
      zGyro = zGyro * k; //  Full scale = +/- 125 degree/s

      xGyro *= degree_to_radian; //  to radian
      yGyro *= degree_to_radian; //  to radian
      zGyro *= degree_to_radian; //  to radian

      gyro_raw = quat_t(0, xGyro, yGyro, zGyro);
      gyro = gyro_raw - gyro_bias;
    }
    //=====================================================================================//
    void BMX055_Mag()
    {
      int   xMag  = 0;
      int   yMag  = 0;
      int   zMag  = 0;
      unsigned int data[8];
      for (int i = 0; i < 8; i++)
      {
        Wire1.beginTransmission(Addr_Mag);
        Wire1.write((0x42 + i));    // Select data register
        Wire1.endTransmission();
        Wire1.requestFrom(Addr_Mag, 1);    // Request 1 byte of data
        // Read 6 bytes of data
        // xMag lsb, xMag msb, yMag lsb, yMag msb, zMag lsb, zMag msb
        if (Wire1.available() == 1)
          data[i] = Wire1.read();
      }
      // Convert the data
      yMag = ((data[1] << 5) | (data[0] >> 3));
      if (yMag > 4095)  yMag -= 8192;
      xMag = ((data[3] << 5) | (data[2] >> 3));
      if (xMag > 4095)  xMag -= 8192;
      xMag = -xMag;
      zMag = ((data[5] << 7) | (data[4] >> 1));
      if (zMag > 16383)  zMag -= 32768;

      mag_raw = quat_t(0, xMag, yMag, zMag);
      mag = mag_raw - mag_bias;
    }
    //=====================================================================================//
    void measure_gravity()
    {
      gravity = quat_t(0,0,0,0);
      const int n = 1000;
      for(int i = 0 ; i < n ; ++i){
        BMX055_Accl();
        gravity += acc;
        delay(1);
      }
      gravity /= n;
      Serial.print("gravity: ");
      Serial.print("[");
      Serial.print(gravity.v.x, 6);
      Serial.print(",");
      Serial.print(gravity.v.y, 6);
      Serial.print(",");
      Serial.print(gravity.v.z, 6);
      Serial.println("]");
    }
    //=====================================================================================//
    void measure_gyro_bias()
    {
      gyro_bias = quat_t(0,0,0,0);
      const int n = 1000;
      for(int i = 0 ; i < n ; ++i){
        BMX055_Gyro();
        gyro_bias += gyro_raw;
        delay(1);
      }
      gyro_bias /= n;
      Serial.print("gyro bias: ");
      Serial.print("[");
      Serial.print(gyro_bias.v.x, 6);
      Serial.print(",");
      Serial.print(gyro_bias.v.y, 6);
      Serial.print(",");
      Serial.print(gyro_bias.v.z, 6);
      Serial.println("]");

    }
    //=====================================================================================//

  public:
    IMU_BMX055_BASE() {
    }
    void setup() {
      Serial.println("imu: setup start");
      Serial.println("imu: init");
      BMX055_Init();
      measure_gyro_bias();
      measure_gravity();
      Serial.println("imu: setup end");
    }
    void update() {
      BMX055_Accl();
      BMX055_Gyro();
      BMX055_Mag();
    }
};
