#include "SensorHandler.hpp"
#include <iostream>

int SensorHandler::isr_flag = 0;

SensorHandler::SensorHandler() {
  apds =  APDS9960_RPi();
  wiringPiSetup();
  wiringPiISR(APDS9960_INT, INT_EDGE_FALLING,  interruptRoutine);
  apds.init();
  apds.enableGestureSensor(true);
  _gesture_state = DEFAULT;
}

const GESTURE_STATE& SensorHandler::getGestureState() {
  if (isr_flag == 1) {
    handleGesture();
    isr_flag = 0;
  }
  return _gesture_state;
}

void SensorHandler::interruptRoutine() {
  isr_flag = 1;
}

void SensorHandler::handleGesture() {
  using namespace std;

  //if ( apds.isGestureAvailable() ) {
    switch ( apds.readGesture() ) {
      case DIR_UP:
        cout << "UP" << endl;

        if (_gesture_state == DEFAULT) {
          _gesture_state = UP;
        } else if (_gesture_state == DOWN) {
          _gesture_state = DEFAULT;
        } 
        break;
      case DIR_DOWN:
        cout << "DOWN" << endl;

        if (_gesture_state == DEFAULT) {
          _gesture_state = DOWN;
        } else if (_gesture_state == UP) {
          _gesture_state = DEFAULT;
        }
        break;
      case DIR_LEFT:
        cout << "LEFT" << endl;

        if (_gesture_state == DEFAULT) {
          _gesture_state = LEFT;
        } else if (_gesture_state == RIGHT) {
          _gesture_state = DEFAULT;
        }
        break;
      case DIR_RIGHT:
        cout << "RIGHT" << endl;

        if (_gesture_state == DEFAULT) {
          _gesture_state = RIGHT;
        } else if (_gesture_state == LEFT) {
          _gesture_state = DEFAULT;
        }
        break;
      default:
        cout << "NONE" << endl;
        break;
    }	
  //}
  //else {
    //cout << "No gesture available" << endl;
  //}
}

