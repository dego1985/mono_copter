// 下記の改造版
//================================================================//
//  AE-BMX055             Arduino UNO                             //
//    VCC                    +5V                                  //
//    GND                    GND                                  //
//    SDA                    A4(SDA)                              //
//    SCL                    A5(SCL)                              //
//                                                                //
//   (JP4,JP5,JP6はショートした状態)                                //
//   http://akizukidenshi.com/catalog/g/gK-13010/                 //
//================================================================//
#pragma once
#include <quaternion_type.h>

#include "imu_raw.h"

class IMU_BMX055 {
    IMU_BMX055_BASE imu;
    unsigned long int time_micro = 0.0;
    float dt = 0.0;
    quat_t acc_u;
    quat_t acc_w;
    quat_t q = { 1, 0, 0, 0 };
    quat_t v;
    quat_t x;    
  private:
    quat_t transform_to_world(quat_t v){
      return q * v * q.conj();;
    }
    quat_t transform_to_imu(quat_t v){
      return q.conj() * v * q;;
    }
    //=====================================================================================//
    void update_pose()
    {
      // rotation
      q *= quat_t(1,0,0,0) + imu.gyro * 0.5* dt;
      q = q.norm();

      // acc
      acc_u = transform_to_world(imu.acc);
      quat_t acc_w0 = acc_w;
      acc_w = acc_u - imu.gravity;

      // velocity
      quat_t v0 = v;
      v += (acc_w + acc_w0) * 0.5 * dt;
      v *= (1 - 2.0*dt);
      x += (v + v0) * 0.5 * dt;
      x *= (1 - 0.5*dt);

      // (1 + 0.5*(A-B)B)B(1 + 0.5*B(A-B))
      // = B + (A-B) = A
      quat_t gravity_norm = imu.gravity.norm();
      quat_t acc_u_norm = acc_u.norm();
      float alpha = min(acc_u.mag() * 0.1, 1.0);
      quat_t rot = (acc_u_norm - gravity_norm) * gravity_norm * 0.5;
      q = (quat_t(1, 0, 0, 0) + rot * alpha * dt) * q;
      q = q.norm();

//
//      // correct with mag
//      m = quat_t(0, xMag, yMag, zMag);
//      if(!isinf(m.v.x) && !isinf(m.v.y) && !isinf(m.v.z) ){
//        m_init_now = q.conj() * m_init * q;
//        quat_t dq_m = (m - m_init_now) * m_init_now * 0.5 * 0.00001 + quat_t(1, 0, 0, 0);
//        q *= dq_m;
//        q = q.norm();
//      }
}
    //=====================================================================================//
    void update_time()
    {
      unsigned long int time_micro_now = micros();
      dt = 0.000001 * float(time_micro_now - time_micro);
      time_micro = time_micro_now;

      if(dt < 0){
        dt = 0;
      }else if(dt > 0.1){
        dt = 0;
      }
    }
  public:
    IMU_BMX055() {
    }
    void setup() {
      imu.setup();
    }
    void update() {
      update_time();
      imu.update();
      update_pose();
    }
    void print(){
      print_v(imu.acc_raw);   Serial.print(",");
      print_v(imu.gyro_raw);  Serial.print(",");
      print_v(imu.mag_raw);   Serial.print(",");
      print_v(imu.acc);       Serial.print(",");
      print_v(imu.gyro);      Serial.print(",");
      print_v(imu.mag);       Serial.print(",");
      print_q(q);             Serial.print(",");
      print_v(v);             Serial.print(",");
      print_v(x);             Serial.print(",");
      print_v(acc_w);
    }
};
