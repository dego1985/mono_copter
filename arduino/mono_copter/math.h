#pragma once
#include <quaternion_type.h>

const float degree_to_radian = PI/180;
inline void norm_theta(float & theta){
  if(theta > 180){
    theta -= 360;
  }else if(theta < -180){
    theta += 360;
  }
}

void print_q(quat_t q, int length=4){
  Serial.print(q.w, length);
  Serial.print(",");
  Serial.print(q.v.x, length);
  Serial.print(",");
  Serial.print(q.v.y, length);
  Serial.print(",");
  Serial.print(q.v.z, length);
}
void print_v(quat_t q, int length=4){
  Serial.print(q.v.x, length);
  Serial.print(",");
  Serial.print(q.v.y, length);
  Serial.print(",");
  Serial.print(q.v.z, length);
}
