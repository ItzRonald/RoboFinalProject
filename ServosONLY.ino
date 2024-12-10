# include <Servo.h>

Servo M5;
Servo M6;

void setup() {

  M5.attach(8);

  M6.attach(9);

}

void loop() {


  int reading1 = analogRead(A0);
  int angle1 = map(reading1,0,1023,0,180);

  M5.write(angle1);

  int reading2 = analogRead(A1);
  int angle2 = map(reading2,0,1023,0,180);


M6.write(angle2);

}
