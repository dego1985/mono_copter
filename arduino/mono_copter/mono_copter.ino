#include <Wire.h>
#include <Servo.h>
#include "receiver.h"
#include "servos.h"
#include "imu.h"
#include "pico/stdlib.h"

Receiver receiver;
Servos servos;
IMU_BMX055 imu;
const float radian_to_angle = 180 / PI;
void setup()
{

    Serial.begin(115200); // Terminal
    Serial.println("start setup");
    receiver.setup();
    Serial.println("start setup end");
}
void loop()
{
    bool updated = receiver.update();
    if (updated)
    {
        // receiver.print();
    }
}

void setup1()
{
    pinMode(16, OUTPUT);
    digitalWrite(16, LOW);
    delay(100);
    digitalWrite(16, HIGH);
    delay(100);

    // Wire(Arduino-I2C)の初期化
    Wire1.setSDA(6);
    Wire1.setSCL(7);
    Wire1.begin();
    Serial.println("start setup1");

    servos.setup();
    imu.setup();
    Serial.println("start setup1 end");
    delay(1000);
}
void get_steering(float &yaw, float &pitch, float &roll, int &throttle)
{
    const float beta = 1.0 / 600.0;
    yaw = -(receiver.get_channel(0) - 1030) * beta;
    pitch = (receiver.get_channel(1) - 1030) * beta;
    roll = -(receiver.get_channel(3) - 1030) * beta;
    throttle = receiver.get_channel(2);
}
int loop1_counter = 0;
float gx = 0;
float gy = 0;
float gz = 0;
void loop1()
{

    // get sensor
    imu.update();
    float gx0 = imu.imu.gyro.v.x;
    float gy0 = imu.imu.gyro.v.y;
    float gz0 = imu.imu.gyro.v.z;
    gx = 0.7 * gx + 0.3 * gx0;
    gy = 0.7 * gy + 0.3 * gy0;
    gz = 0.7 * gz + 0.3 * gz0;
    quat_t q = imu.q;
    quat_t v = imu.v;

    //  imu.print_quat_acc();
    //  imu.print_line();
    //  imu.print_gyro();
    //  imu.print_quat();

    // get receiver
    float yaw_rx, pitch_rx, roll_rx;
    int throttle;
    get_steering(yaw_rx, pitch_rx, roll_rx, throttle);

    // receiver.print();

    float yaw = 0;
    float pitch = 0;
    float roll = 0;
    // zero angular velocity
    float alpha = radian_to_angle * 0.5 / constrain(throttle / 1600.0, 0.1, 1);
    yaw = alpha * gz;
    pitch = alpha * gx;
    roll = alpha * gy;

    // zero velocity
    float alpha2 = radian_to_angle * 0.5 / constrain(throttle / 1600.0, 0.1, 1);
    yaw += 0;
    pitch = alpha2 * gx;
    roll = alpha2 * gy;

    // zero angle
    float gamma = radian_to_angle * 2.0 / constrain(throttle / 1600.0, 0.1, 1);
    yaw += gamma * q.v.z;
    pitch += gamma * q.v.x;
    roll += gamma * q.v.y;

    // receiver
    float lambda = radian_to_angle * 1.0 / constrain(throttle / 1600.0, 0.1, 1);
    yaw += lambda * yaw_rx;
    pitch -= lambda * pitch_rx;
    roll -= lambda * roll_rx;

    float angle_max = 40;
    const float angle1_0 = -5;  // right
    const float angle2_0 = -10; // left
    const float angle3_0 = -0;  // foward
    const float angle4_0 = 0;

    float angle1 = angle1_0;
    float angle2 = angle2_0;
    float angle3 = angle3_0;

    angle1 += constrain(-yaw + pitch - 0.5 * roll, -angle_max, angle_max);
    angle2 += constrain(-yaw - pitch - 0.5 * roll, -angle_max, angle_max);
    angle3 += constrain(-yaw + roll, -angle_max, angle_max);

    float throttle1 = throttle;
    servos.update(throttle1, angle1, angle2, angle3);
}
