


#include <AnalogEvent.h>
#include <ButtonEvent.h>
#include <TimedEvent.h>
#include <LedControl.h>

//Pins for the Ardumoto
const int servo_1_pin = 5;
const int servo_2_pin = 6;


int pwm_a = 3;  //PWM control for motor outputs 1 and 2 is on digital pin 3
int pwm_b = 11;  //PWM control for motor outputs 3 and 4 is on digital pin 11
int dir_a = 12;  //direction control for motor outputs 1 and 2 is on digital pin 12
int dir_b = 13;  //direction control for motor outputs 3 and 4 is on digital pin 13


//Pins for the Access Space Waterbear Arduino Setup 
const int ir_distance_1_pin  = A0;   // IR distance sensor 1
const int ir_distance_2_pin  = A1; // IR distance sensor 2
const int light_sensor_1_pin = A2; // Light Sensor 1
const int light_sensor_2_pin = A4; // Light Sensor 2 //middle sensor currently not wired in
const int LED_Green_pin    = 10; // LEDs
const int LED_Under_pin    = 9; // LEDs

const String moving = "moving";

const String searching = "searching";

const int start_button_pin   = 4;
const int push_button_pin    = 4;
const int cutoff_pin         = 5;
const int bumper_1_pin       = 6;  // Bumper Button
const int bumper_2_pin       = 4;

//Variables
long   iSchedTime              = 0;
const  long start_button_pause = 1000;

String current_motion_state    = "stop";
String current_prog_state      = "init";
String current_mode            = "init";

int    speed_output_min        = 210;
int    speed_output_max        = 250;
int    speed_setting_max       = 10;
int    speed_setting_current   = 1;
int    speed_output_current    = 0;
int    speed_setting_turning   = 1;
int    speed_output_turning    = 0;

int calc_speed_output(int speed)
{
  Serial.print("calc_speed_output ");
  Serial.print(speed);
  
  int output = 0;
  if(speed > 0)
  {
    if (speed < speed_setting_max)
    {
      output = (speed * ((speed_output_max - speed_output_min) / speed_setting_max)) + speed_output_min;
    }
    else
    {
      output = speed_output_max;
    }
  }
  else
  {
    output = 0;
  }
  
  Serial.print(" output=");
  Serial.print(output);
  Serial.println();
  
  return output;
}

void set_speed(int speed)
{
  Serial.println("set_speed");

  speed_output_current = calc_speed_output(speed); 
  speed_setting_current = speed;
}

int distance_calc(int iIrVal)
{
  Serial.println("distance_calc ");

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
  Serial.println("bot_forward");
  if(current_prog_state == "running")
  {
    digitalWrite(dir_a, HIGH);
    analogWrite(pwm_a, speed_output_current);
    digitalWrite(dir_b, HIGH);
    analogWrite(pwm_b, speed_output_current);
    current_motion_state = "forward"; 
  }
}

void bot_backward()
{
  Serial.println("bot_backward");
  if(current_prog_state == "running")
  {
    digitalWrite(dir_a, LOW);
    analogWrite(pwm_a, speed_output_current);
    digitalWrite(dir_b, LOW);
    analogWrite(pwm_b, speed_output_current);
    current_motion_state = "backward"; 
  }
}

void bot_clockwise()
{
  Serial.println("bot_clockwise");
  if(current_prog_state == "running")
  {
    digitalWrite(dir_a, LOW);
    analogWrite(pwm_a, speed_output_turning);
    digitalWrite(dir_b, HIGH);
    analogWrite(pwm_b, speed_output_turning);
    current_motion_state = "clockwise";
  }
}

void bot_anticlockwise()
{
  Serial.println("bot_anticlockwise");
  if(current_prog_state == "running")
  {
    digitalWrite(dir_a, HIGH);
    analogWrite(pwm_a, speed_output_turning);
    digitalWrite(dir_b, LOW);
    analogWrite(pwm_b, speed_output_turning);
    current_motion_state = "anticlockwise";
  }
}

void bot_stop()
{
  Serial.println("bot_stop");
  digitalWrite(dir_a, HIGH);
  analogWrite(pwm_a, 0);
  digitalWrite(dir_b, HIGH);
  analogWrite(pwm_b, 0);
  current_motion_state = "stop";
}


void bot_clockwise_timed(TimerInformation* Sender)
{
  Serial.println("bot_clockwise_timed");
  bot_clockwise();
}

void bot_anticlockwise_timed(TimerInformation* Sender)
{
  Serial.println("bot_anticlockwise_timed");
  bot_anticlockwise();
}

void bot_backward_timed(TimerInformation* Sender)
{
  Serial.println("bot_backward_timed");
  bot_backward();
}

void bot_forward_timed(TimerInformation* Sender)
{

  Serial.println("bot_forward_timed");
  bot_forward();
}

void bot_stop_timed(TimerInformation* Sender)
{
  Serial.println("bot_stop_timed");
  bot_stop();
}


void onModeChange(String newmode)
{
current_mode = newmode;
//onModeChange//
}

void changeToMovingMode(TimerInformation* Sender){
   onModeChange("moving");
}

void changeToSearchingMode(TimerInformation* Sender){
  onModeChange("searching");
}


void onChange(AnalogPortInformation* Sender)
{
  Serial.print("onChange ");
  Serial.print(Sender->pin);
  Serial.print(" value=");
  Serial.println(Sender->value);
  
//onChange//
}


void onDown(ButtonInformation* Sender)
{
  Serial.println("onDown");
  Serial.println(Sender->pin);
  if(current_prog_state != "init")
  {
    //onDown//
  }
}

void onUp(ButtonInformation* Sender)
{
  Serial.println("onUp");
  Serial.println(Sender->pin);
//onUp//
}

void onHold(ButtonInformation* Sender)
{
  Serial.println("onHold");
  Serial.println(Sender->pin);
//onHold//
}

void onDouble(ButtonInformation* Sender)
{
  Serial.println("onDouble");
  Serial.println(Sender->pin);
//onDouble//
}


void cutoff_onUp(ButtonInformation* Sender)
{
  current_motion_state = "cutoff";
  bot_stop();
}


void cutoff_onHold(ButtonInformation* Sender)
{
  if(current_motion_state == "cutoff")
  {
    //current_motion_state = "starting";
    //TimedEvent.addDelayed(start_button_pause, onStartTime);
  }
}

void start_bot()
{
  Serial.println("start_bot");

  iSchedTime = 0;

  AnalogEvent.addAnalogPort(ir_distance_1_pin,  onChange, 10);
  AnalogEvent.addAnalogPort(ir_distance_2_pin,  onChange, 10);
  AnalogEvent.addAnalogPort(light_sensor_1_pin, onChange, 10);
  AnalogEvent.addAnalogPort(light_sensor_2_pin, onChange, 10);
  
  ButtonEvent.addButton(push_button_pin,       //button pin
                        onDown,   //onDown event function
                        onUp,     //onUp event function
                        onHold,   //onHold event function
                        1000,     //hold time in milliseconds
                        onDouble, //onDouble event function
                        200);     //double time interval
  
  
  ButtonEvent.addButton(bumper_1_pin,       //button pin
                        onDown,   //onDown event function
                        onUp,     //onUp event function
                        onHold,   //onHold event function
                        1000,     //hold time in milliseconds
                        onDouble, //onDouble event function
                        200);     //double time interval
  
  /*
  ButtonEvent.addButton(cutoff_pin,       //button pin
                        onDown,   //onDown event function
                        cutoff_onUp,     //onUp event function
                        cutoff_onHold,   //onHold event function
                        1000,     //hold time in milliseconds
                        onDouble, //onDouble event function
                        200);     //double time interval
  */                       
  
  LedControl.stopBlink(LED_Green_pin);
  LedControl.turnOn(LED_Under_pin);
  
  current_prog_state = "running";
  
  
  
  //any//                      
}


void onStartTime(TimerInformation* Sender)
{
  Serial.println("onStartTime");
  start_bot();
}



void onStartDown(ButtonInformation* Sender)
{
  Serial.println("onStartDown");
  
  if (Sender->pin == start_button_pin && current_prog_state == "init")
  {
    Serial.println("starting");
    current_prog_state = "starting";
    TimedEvent.addDelayed(start_button_pause, onStartTime);
    LedControl.stopBlink(LED_Green_pin);
    LedControl.startBlink(LED_Green_pin, 100);
  }
}

void loop()
{
  iSchedTime = 0;
  AnalogEvent.loop();
  TimedEvent.loop();
  ButtonEvent.loop();
  LedControl.loop();
}

void setup()
{ 
  Serial.begin(9600);
  Serial.println("setup");
  
  pinMode(LED_Green_pin, OUTPUT);
  pinMode(LED_Under_pin, OUTPUT);
  

  
  LedControl.startBlink(LED_Green_pin, 500);
  
  pinMode(pwm_a, OUTPUT);  //Set control pins to be outputs
  pinMode(pwm_b, OUTPUT);
  pinMode(dir_a, OUTPUT);
  pinMode(dir_b, OUTPUT);
 
  bot_stop();
    
  speed_output_turning = calc_speed_output(speed_setting_turning); 
  set_speed(speed_setting_current);
  
  
  //setup//
  
  ButtonEvent.addButton(start_button_pin,       //button pin
                        onStartDown,   //onStartDown event function 
                        //change to another event but use status to check 
                        //which runs and the other should be null
                        onUp,     //onUp event function
                        onHold,   //onHold event function
                        1000,     //hold time in milliseconds
                        onDouble, //onDouble event function
                        200);     //double time interval
  
  //TimedEvent.addDelayed(start_button_pause, onStartTime);                      
}

