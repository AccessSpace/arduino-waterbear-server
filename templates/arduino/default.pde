#include <Servo.h> 
 
Servo myservo;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
 
int pos = 0;    // variable to store the servo position 
const int LED_Green_pin    = 8; // LEDs
const int push_button_pin  = 12;
const int servo_pin        = 3;
const int pot_pin          = A0;
//Global Varibles 
//globals//


void dispense()
{
  myservo.write(180);              // tell servo to go to 180 degrees 
  delay(1000);
  myservo.write(0);              // tell servo to go to 0 degrees 
  delay(500);
}

//Defintions of Broadcasts
//def//


void loop()
{ 
  //loop//    
}



void setup()
{ 
  Serial.begin(9600);
  Serial.println("setup");

  myservo.attach(servo_pin);
  myservo.write(0); 
  
  pinMode(LED_Green_pin, OUTPUT);
  pinMode(push_button_pin, INPUT);  

  //setup//
}


void any()  //never called
{ 
  //any//    
}

