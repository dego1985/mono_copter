class Receiver{
  int channel[16]; //chごとのデータ
  int state = 0;   //受信状態を格納する変数
  int cnt = 0;     //カウント変数
  byte buff[25];   //受信データ用バッファ
  byte data;       //シリアルデータを格納する変数
public:
  Receiver(){
  }
  void setup(){
    Serial.println("receiver: setup start");
//    gpio_set_function(5, GPIO_FUNC_UART);
//     (5, GPIO_OVERRIDE_INVERT);
    Serial2.setTX(4);
    Serial2.setRX(5);
    Serial2.begin(100000, SERIAL_8E2); // S-BUS
    Serial.println("receiver: setup end");
  }
  bool update(){
    if (Serial2.available() > 0)
    {
      data = Serial2.read();
      //Serial.println(data, HEX);
  
      if ((data == 0x0F) && (state == 0)) //0x0F(先頭データ)を受信したらその後のデータを受信
      {
        state = 1;        //受信フラグをON
        buff[cnt] = data; //バッファに一時的に格納
        cnt++;            //カウントアップ
      }
      else if ((state == 1) && (cnt < 23))
      {
        buff[cnt] = data; //バッファに一時的に格納
        cnt++;            //カウントアップ
      }
      else if ((state == 1) && (cnt == 23) && (data == 0x00)) //25byte受け取った後、値を更新
      {
        state = 0;        //受信フラグをOFF
        buff[cnt] = data; //バッファに一時的に格納
        cnt = 0;          //カウントリセット
  
        //値の更新
        channel[0]  = ((buff[1]       | buff[2]  << 8)                  & 0x07FF);
        channel[1]  = ((buff[2]  >> 3 | buff[3]  << 5)                  & 0x07FF);
        channel[2]  = ((buff[3]  >> 6 | buff[4]  << 2 | buff[5] << 10)  & 0x07FF);
        channel[3]  = ((buff[5]  >> 1 | buff[6]  << 7)                  & 0x07FF);
        channel[4]  = ((buff[6]  >> 4 | buff[7]  << 4)                  & 0x07FF);
        channel[5]  = ((buff[7]  >> 7 | buff[8]  << 1 | buff[9] << 9)   & 0x07FF);
        channel[6]  = ((buff[9]  >> 2 | buff[10] << 6)                  & 0x07FF);
        channel[7]  = ((buff[10] >> 5 | buff[11] << 3)                  & 0x07FF);
        channel[8]  = ((buff[12]      | buff[13] << 8)                  & 0x07FF);
        channel[9]  = ((buff[13] >> 3 | buff[14] << 5)                  & 0x07FF);
        channel[10] = ((buff[14] >> 6 | buff[15] << 2 | buff[16] << 10) & 0x07FF);
        channel[11] = ((buff[16] >> 1 | buff[17] << 7)                  & 0x07FF);
        channel[12] = ((buff[17] >> 4 | buff[18] << 4)                  & 0x07FF);
        channel[13] = ((buff[18] >> 7 | buff[19] << 1 | buff[20] << 9)  & 0x07FF);
        channel[14] = ((buff[20] >> 2 | buff[21] << 6)                  & 0x07FF);
        channel[15] = ((buff[21] >> 5 | buff[22] << 3)                  & 0x07FF);
        return true;
      }
      else {
        //各変数をリセット
        cnt = 0;
        state = 0;
      }
    }
    return false;
  }
  int get_channel(int n){
    return channel[n];
  }
  void print(){
    for (int i = 0; i < 8; i++) {
      Serial.print(get_channel(i), DEC);
      Serial.print(" ");
    }
    Serial.println();
  }
};
