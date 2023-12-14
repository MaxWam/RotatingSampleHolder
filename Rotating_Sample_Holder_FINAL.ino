#include <AccelStepper.h>
#include <ezButton.h>

// WRITTEN BY MAX WAMSLEY (DONGMAO ZHANG LAB @ MISSISSIPPI STATE UNIVERSITY) FOR NEMA 17 STEPPER MOTOR WITH TB6600 DRIVER //


// sets the pin values for the motor and motor type
//User-defined values
long receivedSteps = 0; //Number of steps
long receivedSpeed = 0; //Steps / second
long receivedAcceleration = 0; //Steps / second^2
char receivedCommand;
float state;
int ScanSteps, Number_of_Scans, isSet = 0;
float ScanDelay;
ezButton limitSwitch(7);  // create ezButton object that attach to pin 7;

#define stepPin 3
#define dirPin 2
#define motorInterfaceType 1
#define maxSpeed 5000
#define Acceleration 5000
#define startingSteps 845

int directionMultiplier = 1; // = 1: positive direction, = -1: negative direction
bool newData, track, sample2 = false; // booleans for new data

//defines the stepper motor based on the values
AccelStepper stepper1 = AccelStepper(motorInterfaceType, stepPin, dirPin);

// setup Serial port and initial messages
void setup() {

  limitSwitch.setDebounceTime(50); // set debounce time to 50 milliseconds
  
  Serial.begin(115200);                     //set baud rate to 9600
  
  stepper1.setMaxSpeed(maxSpeed);              //steps/second
  stepper1.setAcceleration(Acceleration);          //steps/second squared  
  stepper1.setCurrentPosition(0);         //set starting position to 0 (assuming they correctly setup)
  stepper1.setMinPulseWidth(20);
  stepper1.disableOutputs();              //disable motor outputs to save power
}

// loop to check for text in SM
void loop() {

    //Constantly looping through these 2 functions.
    //We only use non-blocking commands, so something else (should also be non-blocking) can be done during the movement of the motor
  if (Serial.available() > 0) {  //POSSIBLE REMOVE THE 0, BECAUSE IT WORKED W/O B4
    
    receivedCommand = Serial.read(); // pass the char value to the receivedCommand
    newData = true; //indicate that there is a new data by setting this bool to true
    
    if (newData == true) {  //only enter this if there is a command received

        switch (receivedCommand){
          // r case rotates to sample 2 if at sample 1 or to sample 1 if at sample 2
          case 'r':   //function to rotate motor 180 degrees
              
            if(sample2 == false){  //if current sample is 1, move forward
              RunTheMotor(1600);  //move the motor

              sample2 = true; //we are now at 2nd sample
                  
              Serial.print("Current sample: "); //display the current sampling position 
              Serial.println(2);
            }
            else{                 //if current sample is 2, move back
              RunTheMotor(-1600);  //move the motor

              sample2 = false; //we are now at 1st sample
                                
              Serial.print("Current sample: "); //display the current sampling position 
              Serial.println(1);  
            }

            break; //leave the rotate case

          case 'h':   //function to home (90 deg) motor
            
            RunTheMotor(startingSteps);
            stepper1.setCurrentPosition(0); //set setup position to 0
            Serial.println("Holder has been rotated 90 degrees");

            break;

          case 's':   //loop Number of Scans for Scan time
            if(isSet == 3){
              Serial.println("Scan started.");
              int count = 1;
              for(int i = 0; i < Number_of_Scans; i++){
                Serial.println(count);
                RunTheMotor(ScanSteps / 0.1125); 
                delay(ScanDelay * 1000);
                count++;
              }
            }
            else{
              Serial.println("Please set parameter before scan");
            }
              
            break;    //end of case to rotate 90
            
          case 'l':   //function to move left 10 steps
            RunTheMotor(-5);
            Serial.println("Motor moved left");
            break;    

          case 'm':   //function to move right 10 steps            
            RunTheMotor(5);
            Serial.println("Motor moved right");            
            break;    //end of case to rotate 90
          
          case 'n':   //function to set variables
            if(isSet != 3){
              while(track == false){
                state = Serial.parseFloat();
                if(isSet == 0){
                  ScanSteps = int(state);
                }
                else if(isSet == 1){
                  Number_of_Scans = int(state);
                }
                else if(isSet == 2){
                  ScanDelay = state;
                }
                if(state != 0){
                  track = true;
                }
              }
              track = false;
              if((isSet == 0) && (ScanSteps != 0)){
                isSet = 1;
                Serial.print("Scan steps set");
              }
              else if((isSet == 1) && (Number_of_Scans != 0)){
                isSet = 2;
                Serial.print("Number of Scans set");
              }
              else if((isSet == 2) && (ScanDelay != 0)){
                isSet = 3;
                Serial.print("Scan delay set");
              }
            }
            else{
              Serial.println("Please reset parameters first");
            }
            break;    //end of case to rotate 90

          case 'z':   //function to reset variables
            ScanSteps = 0;
            Number_of_Scans = 0; 
            ScanDelay = 0;           
            Serial.println("Scan time and Number of Scans have been reset");
            isSet = 0;
            break;
      }       
    }
  }    
}
// run the motor
void RunTheMotor(int s){
  stepper1.enableOutputs(); //enable pins
  stepper1.move(s); 
  stepper1.runToPosition(); //step the motor (this will step the motor by 1 step at each loop)  
  stepper1.disableOutputs(); //disable outputs
  delay(100);
}


