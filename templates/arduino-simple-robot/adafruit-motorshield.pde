


#include <AnalogEvent.h>
#include <ButtonEvent.h>
#include <TimedEvent.h>
#include <AFMotor.h>

//Adafruit Motor Shield setup
AF_DCMotor motor_l(1);  //motor numbers on the shield
AF_DCMotor motor_r(3);  //motor numbers on the shield


//Pins for the Access Space Waterbear Arduino Setup 
const int ir_distance_1_pin  = A0;   // IR distance sensor 1
const int ir_distance_2_pin  = A1; // IR distance sensor 2
const int light_sensor_1_pin = A2; // Light Sensor 1
const int LED_Green_pin    = 12; // LEDs
const int start_button_pin   = 10;
const int cutoff_pin         = 9;
const int bumper_1_pin       = 8;  // Bumper Button
const int push_button_pin    = 7;


//Variables
long   iSchedTime              = 0;
const  long start_button_pause = 5000;

String current_motion_state    = "stop";
String current_prog_state      = "init";
int    speed_output_min        = 100;
int    speed_output_max        = 255;
int    speed_setting_max       = 10;
int    speed_setting_current   = 5;
int    speed_output_current    = 0;
int    speed_setting_turning   = 1;
int    speed_output_turning    = 0;
  

int calc_speed_output(int speed)
{
  int output = 0;
  if(speed > 0)
  {
    if (speed < speed_setting_max)
    {
      output = (speed_output_max - speed_output_min) / speed_setting_max;
    }
    else
    {
      output = speed_output_max;
    }
  }
  return output;
}

void set_speed(int speed)
{
  speed_output_current = calc_speed_output(speed); 
  speed_setting_current = speed;
}


int distance_calc(int iIrVal)
{
  float fIrVal = float(iIrVal);
  float dist = 0.0;
        if (fIrVal > 0)
        {
            dist = 12343.85 * pow(fIrVal, -1.15);
        }
        else
        {
        
            dist = 100.0 * 2;
        }
        return int(dist);
}


void bot_forward()
{
  if(current_motion_state == "running")
  {
    motor_l.run(FORWARD);
    motor_l.setSpeed(speed_output_current);
    motor_r.run(FORWARD);
    motor_r.setSpeed(speed_output_current);
    current_motion_state = "forward"; 
  }
}


void bot_backward()
{
  if(current_motion_state == "running")
  {
    motor_l.run(BACKWARD);
    motor_l.setSpeed(speed_output_current);
    motor_r.run(BACKWARD);
    motor_r.setSpeed(speed_output_current);
    current_motion_state = "backward"; 
  }
}

void bot_clockwise()
{
  if(current_motion_state == "running")
  {
    motor_l.run(FORWARD);
    motor_l.setSpeed(speed_output_turning);
    motor_r.run(BACKWARD);
    motor_r.setSpeed(speed_output_turning);
    current_motion_state = "clockwise";
  }
}

void bot_anticlockwise()
{
  if(current_motion_state == "running")
  {
    motor_l.run(BACKWARD);
    motor_l.setSpeed(speed_output_turning);
    motor_r.run(FORWARD);
    motor_r.setSpeed(speed_output_turning);
    current_motion_state = "anticlockwise";
  }
}

void bot_stop()
{
  motor_l.run(RELEASE);
  motor_r.run(RELEASE);
  current_motion_state = "stop";
  
}

void bot_clockwise_timed(TimerInformation* Sender){
  bot_clockwise();
}

void bot_anticlockwise_timed(TimerInformation* Sender){
  bot_anticlockwise();
}

void bot_backward_timed(TimerInformation* Sender){
  bot_backward();
}

void bot_forward_timed(TimerInformation* Sender){
  bot_forward();
}

void bot_stop_timed(TimerInformation* Sender){
  bot_stop();
}

void onChange(AnalogPortInformation* Sender) {
//onChange//
}

void onDown(ButtonInformation* Sender) {
//onDown//
}

void onUp(ButtonInformation* Sender) {
//onUp//
}

void onHold(ButtonInformation* Sender) {
//onHold//
}

void onDouble(ButtonInformation* Sender) {
//onDouble//
}


void cutoff_onUp(ButtonInformation* Sender){
  current_motion_state = "cutoff";
  bot_stop();
}


void cutoff_onHold(ButtonInformation* Sender){
  if(current_motion_state == "cutoff")
  {
    //current_motion_state = "starting";
    //TimedEvent.addDelayed(start_button_pause, start);
  }
}

void onStartTime(TimerInformation* Sender){
start();
}

void start()
{
  iSchedTime = 0;

  AnalogEvent.addAnalogPort(ir_distance_1_pin,  onChange, 3);
  AnalogEvent.addAnalogPort(ir_distance_2_pin,  onChange, 3);
  AnalogEvent.addAnalogPort(light_sensor_1_pin, onChange, 3);
  
  
  ButtonEvent.addButton(bumper_1_pin,       //button pin
                        onDown,   //onDown event function
                        onUp,     //onUp event function
                        onHold,   //onHold event function
                        1000,     //hold time in milliseconds
                        onDouble, //onDouble event function
                        200);     //double time interval
  
  ButtonEvent.addButton(push_button_pin,       //button pin
                        onDown,   //onDown event function
                        onUp,     //onUp event function
                        onHold,   //onHold event function
                        1000,     //hold time in milliseconds
                        onDouble, //onDouble event function
                        200);     //double time interval
  
  /*ButtonEvent.addButton(cutoff_pin,       //button pin
                        onDown,   //onDown event function
                        cutoff_onUp,     //onUp event function
                        cutoff_onHold,   //onHold event function
                        1000,     //hold time in milliseconds
                        onDouble, //onDouble event function
                        200);     //double time interval
 */                       
                        
  current_motion_state = "running";
  
  //any//                      
}


void startbuttonDown(ButtonInformation* Sender)
{
  current_motion_state = "starting";
  TimedEvent.addDelayed(start_button_pause, onStartTime);
}


void loop() {
  iSchedTime = 0;
  AnalogEvent.loop();
  ButtonEvent.loop();
  TimedEvent.loop();

}

void setup() {
  
  pinMode(bumper_1_pin, INPUT);           // set pin to input
  digitalWrite(bumper_1_pin, HIGH);       // turn on pullup resistors
  
  pinMode(push_button_pin, INPUT);           // set pin to input
  digitalWrite(push_button_pin, HIGH);       // turn on pullup resistors
  
  pinMode(cutoff_pin, INPUT);           // set pin to input
  digitalWrite(cutoff_pin, HIGH);       // turn on pullup resistors
  
  
  motor_l.setSpeed(200);
  motor_l.run(RELEASE); 
  motor_r.setSpeed(200);
  motor_r.run(RELEASE); 
    
  speed_output_turning = calc_speed_output(speed_setting_turning); 
  speed_output_current = calc_speed_output(speed_setting_current);
  
  //setup//
  
  ButtonEvent.addButton(start_button_pin,       //button pin
                        startbuttonDown,   //onDown event function
                        onUp,     //onUp event function
                        onHold,   //onHold event function
                        1000,     //hold time in milliseconds
                        onDouble, //onDouble event function
                        200);     //double time interval
                        
  TimedEvent.addDelayed(start_button_pause, onStartTime);                      
}

