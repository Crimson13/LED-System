/*
 * LED-System: Wii Nunchuck
 *
 * Code to query the state of the Wii Nunchuck and return wheres its pointing
 * at and what buttons are being pressed.
 */

#include <Wire.h>
#include "nunchuck_funcs.h"

// Debug Defintions (Set at compile time)
#define DEBUG_NC_POS 0 // Print nunchuck position information to serial (WARNING: This is very spammy.)
#define DEBUG_NC_VER 0 // Print raw nunchuck information to serial every loop (WARNING: This is very spammy.)

byte accx,accy,zbut,cbut;
int ledPin = 13;
int lastpos = 0;
int th = 60; // Threshold

void setup_nc()
{
  nunchuck_setpowerpins();
  nunchuck_init(); // send the initilization handshake
  nunchuck_calibrate(); 
  numchuck_manual_calibrate(123,132);
    
  display("Nunchuck Ready");
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
      #if DEBUG_NC_POS
      Serial.println("pos: center");
      #endif
      return lastpos = 0;
    }
    else if (y == -1) {
      #if DEBUG_NC_POS
      Serial.println("pos: up");
      #endif
      return lastpos = 1;
    }
    else if (y == 1) {
      #if DEBUG_NC_POS
      Serial.println("pos: down");
      #endif
      return lastpos = 3;  
    }
  }
  else if (x == -1) {
    if (y == 0) {
      #if DEBUG_NC_POS
      Serial.println("pos: left");
      #endif
      return lastpos = 4;
    } 
    else if (y == -1) {
      #if DEBUG_NC_POS
      Serial.println("pos: upleft");
      #endif
      // If the last pos was either then return the lastpos,
      // otherwise set to the up/down rather than left/right.
      if ((lastpos == 1) || (lastpos == 4)) return lastpos;
      else return lastpos = 1;
    } 
    else if (y == 1) {
      #if DEBUG_NC_POS
      Serial.println("pos: downleft");
      #endif
      // If the last pos was either then return the lastpos,
      // otherwise set to the up/down rather than left/right.
      if ((lastpos == 3) || (lastpos == 4)) return lastpos;
      else return lastpos = 3;
    }
  } 
  else if (x == 1) {
    if (y == 0) {
      #if DEBUG_NC_POS
      Serial.println("pos: right");
      #endif
      return lastpos = 2;
    } 
    else if (y == -1) {
      #if DEBUG_NC_POS
      Serial.println("pos: upright");
      #endif
      // If the last pos was either then return the lastpos,
      // otherwise set to the up/down rather than left/right.
      if ((lastpos == 1) || (lastpos == 2)) return lastpos;
      else return lastpos = 1;
    } 
    else if (y == 1) {
      #if DEBUG_NC_POS
      Serial.println("pos: downright");
      #endif
      // If the last pos was either then return the lastpos,
      // otherwise set to the up/down rather than left/right.
      if ((lastpos == 3) || (lastpos == 2)) return lastpos;
      else return lastpos = 3;
    }
  } 
  else {
    #if DEBUG_NC_POS
    Serial.println("pos: error");
    #endif
    return lastpos = -1;
  }

  #if DEBUG_NC_VER
  Serial.print("NCDebug>>");
  Serial.print("accx: "); Serial.print((byte)accx,DEC);
  Serial.print("\taccy: ");Serial.print((byte)accy,DEC);
  Serial.print("\tzbut: "); Serial.print((byte)zbut,DEC);
  Serial.print("\tcbut: "); Serial.println((byte)cbut,DEC);
  nunchuck_print_data();
  #endif
}

