/*
 * LED-System: Lights
 *
 * Controls the LED Lights based on the active modes and zones.
 */
 
// Debug Defintions (Set at compile time)
#define DEBUG_RST_DIS 0 // Print when a reset is called to serial.
#define DEBUG_STP_M1 0 // Print mode 1 step debug info to serial every loop. (WARNING: This is very spammy.)
#define DEBUG_STP_M2 0 // Print mode 2 step debug info to serial every loop. (WARNING: This is very spammy.)
#define DEBUG_STP_M3 0 // Print mode 3 step debug info to serial every loop. (WARNING: This is very spammy.)

// Settings
int s_m1_stepdelay = 75;
int s_m1_stepcount = 15;
int s_m2_stepdelay = 150;
int s_m2_stepcount = 3;
int s_m3_stepdelay = 150;
int s_m3_stepcount = 1;
int s_z1_redpin = 2;
int s_z1_bluepin = 3;
int s_z2_redpin = 4;
int s_z2_bluepin = 5;

// Progress
int lasttime = 0;
int m1_step = 0;
int m1_timeleft = 0;
int m2_step = 0;
int m2_timeleft = 0;
int m3_step = 0;
int m3_timeleft = 0;

void setup_li()
{
  pinMode(s_z1_bluepin, OUTPUT);
  pinMode(s_z1_redpin, OUTPUT);
  pinMode(s_z2_bluepin, OUTPUT);
  pinMode(s_z2_redpin, OUTPUT);
  
  reset_zone(0,1); // Force a full reset on all light zones so they start off
  
  display("Lights Ready");
}

void loop_li(byte m1, byte m2, byte m3, byte z1, byte z2, byte z3)
{
  int diff = millis() - lasttime; // How much time has past since the last loop
  if (m1) m1_dostep(z1, z2, z3, diff);
  if (m2) m2_dostep(z1, z2, z3, diff);
  if (m3) m3_dostep(z1, z2, z3, diff);
  lasttime = millis(); // Record the time before returning
}

/* Progress the pattern for each mode */
void m1_dostep(byte z1, byte z2, byte z3, int timediff)
{
  #if DEBUG_STP_M1
  Serial.print("M1Debug>>");
  Serial.print("step: "); Serial.print(m1_step);
  Serial.print("timeleft: "); Serial.print(m1_timeleft);
  Serial.print("z1: "); Serial.print(z1);
  Serial.print("z2: "); Serial.print(z2);
  Serial.print("z3: "); Serial.print(z3);
  Serial.print("timediff: "); Serial.println(timediff);
  #endif
  
  m1_timeleft -= timediff; // Update time remaining
  if (m1_timeleft <= 0) {
    switch (m1_step) {
      case 0:
      case 2:
      case 4:
        // Red Light On
        if (z1) digitalWrite(s_z1_redpin, HIGH);
        if (z2) digitalWrite(s_z2_redpin, HIGH);
        if (z3) { /* Nothing yet... */ } 
        break;
      case 1:
      case 3:
      case 5:
        // Red Light Off
        if (z1) digitalWrite(s_z1_redpin, LOW);
        if (z2) digitalWrite(s_z2_redpin, LOW);
        if (z3) { /* Nothing yet... */ } 
        break;
      case 8:
      case 10:
      case 12:
        // Blue Light On
        if (z1) digitalWrite(s_z1_bluepin, HIGH);
        if (z2) digitalWrite(s_z2_bluepin, HIGH);
        if (z3) { /* Nothing yet... */ } 
        break;
      case 9:
      case 11:
      case 13:
        // Blue Light Off
        if (z1) digitalWrite(s_z1_bluepin, LOW);
        if (z2) digitalWrite(s_z2_bluepin, LOW);
        if (z3) { /* Nothing yet... */ } 
        break;
      case 6:
      case 7:
      case 14:
      case 15:
          break; // Intentional extra delay
    }
    // If we did the last step, start over, otherwise increment step count.
    if (m1_step >= s_m1_stepcount) m1_step = 0;
    else m1_step++;
      
    // Reset time remaining till next step
    m1_timeleft = s_m1_stepdelay;
  }
}

void m2_dostep(byte z1, byte z2, byte z3, int timediff)
{
  #if DEBUG_STP_M2
  Serial.print("M2Debug>>");
  Serial.print("step: "); Serial.print(m2_step);
  Serial.print("timeleft: "); Serial.print(m2_timeleft);
  Serial.print("z1: "); Serial.print(z1);
  Serial.print("z2: "); Serial.print(z2);
  Serial.print("z3: "); Serial.print(z3);
  Serial.print("timediff: "); Serial.println(timediff);
  #endif
  
  m2_timeleft -= timediff; // Update time remaining
  if (m2_timeleft <= 0) {
    switch (m2_step) {
      case 0:
        // Red Light on
        if (z1) digitalWrite(s_z1_redpin, HIGH);
        if (z2) digitalWrite(s_z2_redpin, HIGH);
        if (z3) { /* Nothing yet... */ } 
        break;
      case 1:
        // Red Light off
        if (z1) digitalWrite(s_z1_redpin, LOW);
        if (z2) digitalWrite(s_z2_redpin, LOW);
        if (z3) { /* Nothing yet... */ } 
        break;
      case 2:
        // Blue Light on
        if (z1) digitalWrite(s_z1_bluepin, HIGH);
        if (z2) digitalWrite(s_z2_bluepin, HIGH);
        if (z3) { /* Nothing yet... */ } 
        break;
      case 3:
        // Blue Light off
        if (z1) digitalWrite(s_z1_bluepin, LOW);
        if (z2) digitalWrite(s_z2_bluepin, LOW);
        if (z3) { /* Nothing yet... */ } 
        break;
      default:
        break; /* Nothing yet... */
    }
    // If we did the last step, start over, otherwise increment step count.
    if (m2_step >= s_m2_stepcount) m2_step = 0;
    else m2_step++;
      
    // Reset time remaining till next step
    m2_timeleft = s_m2_stepdelay;
  }
}

void m3_dostep(byte z1, byte z2, byte z3, int timediff)
{
  #if DEBUG_STP_M2
  Serial.print("M2Debug>>");
  Serial.print("step: "); Serial.print(m3_step);
  Serial.print("timeleft: "); Serial.print(m3_timeleft);
  Serial.print("z1: "); Serial.print(z1);
  Serial.print("z2: "); Serial.print(z2);
  Serial.print("z3: "); Serial.print(z3);
  Serial.print("timediff: "); Serial.println(timediff);
  #endif
  
  m3_timeleft -= timediff; // Update time remaining
  if (m3_timeleft <= 0) {
    switch (m3_step) {
      case 0:
        // Both lights on
        if (z1) {
          digitalWrite(s_z1_redpin, HIGH);
          digitalWrite(s_z1_bluepin, HIGH);
        }
        if (z2) {
          digitalWrite(s_z2_redpin, HIGH);
          digitalWrite(s_z2_bluepin, HIGH);
        }
        if (z3) { /* Nothing yet... */ }
        break;
      case 1:
        // Both lights off
        if (z1) {
          digitalWrite(s_z1_redpin, LOW);
          digitalWrite(s_z1_bluepin, LOW);
        }
        if (z2) {
          digitalWrite(s_z2_redpin, LOW);
          digitalWrite(s_z2_bluepin, LOW);
        }
        if (z3) { /* Nothing yet... */ } 

        break;
    }
    // If we did the last step, start over, otherwise increment step count.
    if (m3_step >= s_m3_stepcount) m3_step = 0;
    else m3_step++;
      
    // Reset time remaining till next step
    m3_timeleft = s_m3_stepdelay;
  }
}

/* Reset the pins to offfor the given zone. 0 for all, force to turn them on first */
void reset_zone(int zone) { return reset_zone(zone, 0); }
void reset_zone(int zone, byte force)
{
  #if DEBUG_RST_DIS
  Serial.print("Reset called. Zone: "); Serial.print(zone);
  Serial.print(" Force: ");  Serial.println((byte)force,DEC);
  #endif
  switch(zone) {
    case 0:
      reset_zone(1, force);
      reset_zone(2, force);
      reset_zone(3, force);
      break;
    case 1:
      if (force) {
        digitalWrite(s_z1_redpin, HIGH);
        digitalWrite(s_z1_bluepin, HIGH);
      }
      digitalWrite(s_z1_redpin, LOW);
      digitalWrite(s_z1_bluepin, LOW);
      break;
    case 2:
      if (force) {
        digitalWrite(s_z2_redpin, LOW);
        digitalWrite(s_z2_bluepin, LOW);
      }
      digitalWrite(s_z2_redpin, LOW);
      digitalWrite(s_z2_bluepin, LOW);
      break;
    case 3:
      if (force) {
      }
      /* Nothing yet */
      break;
  }
}
