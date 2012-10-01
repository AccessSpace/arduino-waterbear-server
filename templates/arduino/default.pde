#include <Servo.h> 
 
Servo myservo;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
 
int pos = 0;    // variable to store the servo position 
const int LED_Green_pin    = 10; // LEDs
const int push_button_pin    = 4;
const int servo_pin = 9;

void dispense()
{
  for(pos = 0; pos < 180; pos += 1)  // goes from 0 degrees to 180 degrees 
  {                                  // in steps of 1 degree 
    myservo.write(pos);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
  } 
  for(pos = 180; pos>=1; pos-=1)     // goes from 180 degrees to 0 degrees 
  {                                
    myservo.write(pos);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
  }
}

void loop()
{    
  //any//                      
}


void setup()
{ 
  Serial.begin(9600);
  Serial.println("setup");
  
    myservo.attach(servo_pin);
    
    pinMode(LED_Green_pin, OUTPUT);
    pinMode(push_button_pin, INPUT);  
  
  //setup//
}
