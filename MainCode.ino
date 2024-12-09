#include <Adafruit_MotorShield.h>
#include <Servo.h>
//#include <EEPROM.h>

Adafruit_MotorShield AFMS = Adafruit_MotorShield();

Adafruit_DCMotor *Motor1 = AFMS.getMotor(1); // motor 1 = gripper
Adafruit_DCMotor *Motor2 = AFMS.getMotor(2); // motor 2 = gripper up/down
Adafruit_DCMotor *Motor3 = AFMS.getMotor(3); // motor 3 = whole body up/down
Adafruit_DCMotor *Motor4 = AFMS.getMotor(4); // motor 4 = base (left/right)

Adafruit_MS_PWMServoDriver pwm = Adafruit_MS_PWMServoDriver();
//Adafruit_MS_PWMServoDriver *pwm;

#define SERVO_1 0
#define SERVO_2 1

// initial servo setups

#define SERVO_MIN 150
#define SERVO_MAX 600

// initial setups

int valpot1;
int newpos1;
int currentval;
int newthe1;

int valpot2;
int newpos2;
int currentval2;
int newthe2;

int valpot3;
int newpos3;
int currentval3;
int newthe3;

int valpot4;
int newpos4;
int currentval4;
int newthe4;

int home1;
int home2;
int home3;
int home4;
int home5;
int home6;


// final values needed, given from MATLAB

int the1; 
int the2;
int the3;
int the4;
int the5;
int the6; 



void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
 // while(!Serial){ // unlock once you are ready to get information from MATLAB
   // ;
 // }

  Serial.println("Arduino ready");

  if (!AFMS.begin(1000)) {         // create with the default frequency 1.6KHz
    Serial.println("Could not find Motor Shield. Check wiring.");
    while (1);
  }
  Serial.println("Motor Shield found.");

}

void loop() {
  uint8_t i;

  /////// Moving robot to home position

  // capturing current location
  valpot1 = analogRead(A8);
  newpos1 = map(valpot1,0,1023,0,180);
  delay(500);
  Serial.println(newpos1);

  //newthe1 = map(the1,0,1024,0,255);
  // home 1 is a temp value, this will be set once testing is complete and we are satisfied with a good starting point
  home1 = 80;
  while (newpos1 != home1){
    while (newpos1 < home1){
      Motor1->setSpeed(150);
      Motor1->run(FORWARD);
      //delay(100);
      currentval = analogRead(A8);
      newpos1 = map(currentval,0,1023,0,180);
      delay(25);
      Serial.println(newpos1);
    }
      Motor1->run(RELEASE);
      delay(500);

      while (newpos1 > home1){
      Motor1->setSpeed(150);
      Motor1->run(BACKWARD);
      //delay(100);
      currentval = analogRead(A8);
      newpos1 = map(currentval,0,1023,0,180);
      delay(25);
      Serial.println(newpos1);
      }
      Motor1->run(RELEASE);
      delay(500);
  }

  // Moving next motor to position

    valpot2 = analogRead(A9);
    newpos2 = map(valpot2,0,1023,0,180);
    delay(500);
    Serial.println(newpos2);

    home2 = 70;
    //newthe2 = map(the2,0,1024,0,255);

   while (newpos2 != home2){
    while (newpos2 < home2){
      Motor2->setSpeed(150);
      Motor2->run(FORWARD);
      //delay(100);
      currentval2 = analogRead(A9);
      newpos2 = map(currentval,0,1023,0,180);
      delay(25);
    }
      Motor2->run(RELEASE);
      delay(500);

      while (newpos2 > home2){
      Motor2->setSpeed(150);
      Motor2->run(BACKWARD);
      //delay(100);
      currentval2 = analogRead(A9);
      newpos2 = map(currentval2,0,1023,0,180);
      delay(25);
      }
      Motor2->run(RELEASE);
      delay(500);
  }

  
  // Moving next motor to position

    valpot3 = analogRead(A10);
    newpos3 = map(valpot3,0,1023,0,180);
    delay(500);
    home3 = 40;
    //newthe3 = map(the3,0,1024,0,255);

  while (newpos3 != home3){
    while (newpos3 < home3){
      Motor3->setSpeed(150);
      Motor3->run(FORWARD);
      //delay(100);
      currentval3 = analogRead(A10);
      newpos3 = map(currentval3,0,1023,0,180);
      delay(25);
    }
      Motor3->run(RELEASE);
      delay(500);

      while (newpos3 > home3){
      Motor3->setSpeed(150);
      Motor3->run(BACKWARD);
      //delay(100);
      currentval3 = analogRead(A10);
      newpos3 = map(currentval3,0,1023,0,180);
      delay(25);
      }
      Motor3->run(RELEASE);
      delay(500);
  }

  // Moving next motor to position

    valpot4 = analogRead(A11);
    newpos4 = map(valpot4,0,1023,0,180);
    delay(500);
    home4 = 100;
    //newthe4 = map(the4,0,1024,0,255);

    while (newpos4 != home4){
    while (newpos4 < home4){
      Motor4->setSpeed(150);
      Motor4->run(FORWARD);
      //delay(100);
      currentval4 = analogRead(A11);
      newpos4 = map(currentval4,0,1023,0,180);
      delay(25);
    }
      Motor4->run(RELEASE);
      delay(500);

      while (newpos4 > home4){
      Motor4->setSpeed(150);
      Motor4->run(BACKWARD);
      //delay(100);
      currentval4 = analogRead(A11);
      newpos4 = map(currentval4,0,1023,0,180);
      delay(25);
      }
      Motor4->run(RELEASE);
      delay(500);
  }


  
// Moving servos back home

    // Servo 5
    home5 = 90;
    setServoAngle(0,home5);

    // Servo 6
    home6 = 90;
    setServoAngle(1,home6);



 //////// After capturing first image to calculate angles, move on to the following code

    //Servo 6
    //the6 = desired angle to sweep away and move the rest of the robot
    the6 = 20;
    setServoAngle(1,the6);


 // capturing current location
  valpot1 = analogRead(A8);
  newpos1 = map(valpot1,0,1023,0,180);
  delay(500);
  Serial.println(newpos1);

  newthe1 = map(the1,0,1024,0,255);
  while (newpos1 != newthe1){
    while (newpos1 < newthe1){
      Motor1->setSpeed(150);
      Motor1->run(FORWARD);
      //delay(100);
      currentval = analogRead(A8);
      newpos1 = map(currentval,0,1023,0,180);
      delay(25);
      Serial.println(newpos1);
    }
      Motor1->run(RELEASE);
      delay(500);

      while (newpos1 > newthe1){
      Motor1->setSpeed(150);
      Motor1->run(BACKWARD);
      //delay(100);
      currentval = analogRead(A8);
      newpos1 = map(currentval,0,1023,0,180);
      delay(25);
      Serial.println(newpos1);
      }
      Motor1->run(RELEASE);
      delay(500);
  }

  // Moving next motor to position

    valpot2 = analogRead(A9);
    newpos2 = map(valpot2,0,1023,0,180);
    delay(500);
    Serial.println(newpos2);
    newthe2 = map(the2,0,1024,0,255);

   while (newpos2 != newthe2){
    while (newpos2 < newthe2){
      Motor2->setSpeed(150);
      Motor2->run(FORWARD);
      //delay(100);
      currentval2 = analogRead(A9);
      newpos2 = map(currentval,0,1023,0,180);
      delay(25);
    }
      Motor2->run(RELEASE);
      delay(500);

      while (newpos2 > newthe2){
      Motor2->setSpeed(150);
      Motor2->run(BACKWARD);
      //delay(100);
      currentval2 = analogRead(A9);
      newpos2 = map(currentval2,0,1023,0,180);
      delay(25);
      }
      Motor2->run(RELEASE);
      delay(500);
  }

  
  // Moving next motor to position

    valpot3 = analogRead(A10);
    newpos3 = map(valpot3,0,1023,0,180);
    delay(500);
    home3 = 40;
    //newthe3 = map(the3,0,1024,0,255);

  while (newpos3 != newthe3){
    while (newpos3 < newthe3){
      Motor3->setSpeed(150);
      Motor3->run(FORWARD);
      //delay(100);
      currentval3 = analogRead(A10);
      newpos3 = map(currentval3,0,1023,0,180);
      delay(25);
    }
      Motor3->run(RELEASE);
      delay(500);

      while (newpos3 > newthe3){
      Motor3->setSpeed(150);
      Motor3->run(BACKWARD);
      //delay(100);
      currentval3 = analogRead(A10);
      newpos3 = map(currentval3,0,1023,0,180);
      delay(25);
      }
      Motor3->run(RELEASE);
      delay(500);
  }

  // Moving next motor to position

    valpot4 = analogRead(A11);
    newpos4 = map(valpot4,0,1023,0,180);
    delay(500);
    newthe4 = map(the4,0,1024,0,255);

    while (newpos4 != newthe4){
    while (newpos4 < newthe4){
      Motor4->setSpeed(150);
      Motor4->run(FORWARD);
      //delay(100);
      currentval4 = analogRead(A11);
      newpos4 = map(currentval4,0,1023,0,180);
      delay(25);
    }
      Motor4->run(RELEASE);
      delay(500);

      while (newpos4 > newthe4){
      Motor4->setSpeed(150);
      Motor4->run(BACKWARD);
      //delay(100);
      currentval4 = analogRead(A11);
      newpos4 = map(currentval4,0,1023,0,180);
      delay(25);
      }
      Motor4->run(RELEASE);
      delay(500);
  }


    //Servo 5 getting final value to lineup correctly
    //newthe5 = value given from camera
    setServoAngle(1,newthe5);


    //Servo 6 now inserting into socket
    //newthe6 = value given from camera 
    setServoAngle(1,newthe6);








}
  // Servo function
  void setServoAngle(uint8_t servoChannel, int angle) {
  // Map angle to pulse length
  uint16_t pulseLength = map(angle, 0, 180, SERVO_MIN, SERVO_MAX);

  // Set PWM signal for the servo
  pwm.setPWM(servoChannel, 0, pulseLength);
  }




