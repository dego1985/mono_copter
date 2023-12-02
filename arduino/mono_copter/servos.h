class Servos{
  const int MAX_SIGNAL = 1850;
  const int MIN_SIGNAL = 380;
  const int NEUTRAL_SIGNAL = (1700 + 380) / 2 - 100;
  Servo myservo[6];
public:
  Servos(){
  }
  void setup(){
    Serial.println("servos: setup start");
    
    myservo[0].attach(10);
    myservo[1].attach(11);
    myservo[2].attach(12);
    myservo[3].attach(13);
    myservo[4].attach(14);
    myservo[5].attach(15);

    Serial.println("servos: Writing maximum output.");
    myservo[0].writeMicroseconds(MAX_SIGNAL);
    Serial.println("servos: Wait 2 seconds.");
    delay(5000);
    Serial.println("servos: Writing minimum output");
    myservo[0].writeMicroseconds(MIN_SIGNAL);
    Serial.println("servos: Wait 2 seconds. Then motor starts");
    delay(5000);
  
    Serial.println("set servos 1,2,3 to 90 degree ");
    myservo[1].write(90);
    myservo[2].write(90);
    myservo[3].write(90);

    Serial.println("servos: setup end");

  }
  void update(float throttle1, float angle1, float angle2, float angle3){
    throttle1 = NEUTRAL_SIGNAL + (throttle1 - MIN_SIGNAL) * 0.7;
    myservo[0].writeMicroseconds(throttle1);
    myservo[1].write(angle1 + 90);
    myservo[2].write(angle2 + 90);
    myservo[3].write(angle3 + 90);
  }
};
