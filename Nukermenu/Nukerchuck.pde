/*
 * WiiChuckDemo -- 
 *
 * 2008 Tod E. Kurt, http://thingm.com/
 *
 */

#include <Wire.h>
#include "nunchuck_funcs.h"

byte ncdebug=0;

int lastpos=0;

byte accx,accy,zbut,cbut;
int ledPin = 13;
int th = 60;


void setup_nc()
{
   // Serial.begin(19200);
    nunchuck_setpowerpins();
    nunchuck_init(); // send the initilization handshake
    nunchuck_calibrate(); 
    numchuck_manual_calibrate(123,132);
    
    if (ncdebug == 1) Serial.print("WiiChuckDemo ready\n");
}

byte nc_z() { return zbut; }
byte nc_c() { return cbut; }

int loop_nc()
{
  // Position:
  // 0 = Center
  // 1 = Up
  // 2 = Right
  // 3 = Down
  // 4 = Left
  // -1 = Error

  nunchuck_get_data();

  accx  = nunchuck_accelx(); // ranges from approx 70 - 182
  accy  = nunchuck_accely(); // ranges from approx 65 - 173
  zbut = nunchuck_zbutton();
  cbut = nunchuck_cbutton(); 
        
  int x = nunchuck_digitalx(th);
  int y = nunchuck_digitaly(th);	

  if (x == 0) {
    if (y == 0) {
      if (ncdebug == 1) Serial.println("center");
      return lastpos = 0;
    }
    else if (y == -1) {
      if (ncdebug == 1) Serial.println("up");
      return lastpos = 1;
    }
    else if (y == 1) {
      if (ncdebug == 1) Serial.println("down");
      return lastpos = 3;  
    }
  }
  else if (x == -1) {
    if (y == 0) {
      if (ncdebug == 1) Serial.println("left");
      return lastpos = 4;
    } 
    else if (y == -1) {
      if (ncdebug == 1) Serial.println("upleft");
      // If the last pos was either then return the lastpos,
      // otherwise set to the up/down rather than left/right.
      if ((lastpos == 1) || (lastpos == 4)) return lastpos;
      else return lastpos = 1;
    } 
    else if (y == 1) {
      if (ncdebug == 1) Serial.println("downleft");
      // If the last pos was either then return the lastpos,
      // otherwise set to the up/down rather than left/right.
      if ((lastpos == 3) || (lastpos == 4)) return lastpos;
      else return lastpos = 3;
    }
  } 
  else if (x == 1) {
    if (y == 0) {
      if (ncdebug == 1) Serial.println("right");
      return lastpos = 2;
    } 
    else if (y == -1) {
      if (ncdebug == 1) Serial.println("upright");
      // If the last pos was either then return the lastpos,
      // otherwise set to the up/down rather than left/right.
      if ((lastpos == 1) || (lastpos == 2)) return lastpos;
      else return lastpos = 1;
    } 
    else if (y == 1) {
      if (ncdebug == 1) Serial.println("downright");
      // If the last pos was either then return the lastpos,
      // otherwise set to the up/down rather than left/right.
      if ((lastpos == 3) || (lastpos == 2)) return lastpos;
      else return lastpos = 3;
    }
  } 
  else {
    if (ncdebug == 1) Serial.println("error");
    return lastpos = -1;
  }

            
  // Serial.print("accx: "); Serial.print((byte)accx,DEC);
  //Serial.print("\taccy: "); Serial.print((byte)accy,DEC);
  //Serial.print("\tzbut: "); Serial.print((byte)zbut,DEC);
  //Serial.print("\tcbut: "); Serial.println((byte)cbut,DEC);
  //nunchuck_print_data();
}

