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
int s_m1_z1_redpin = 2;
int s_m1_z1_bluepin = 3;
int s_m1_z2_redpin = 4;
int s_m1_z2_bluepin = 5;
int s_m2_stepdelay = 99;
int s_m2_stepcount = 99;
int s_m3_stepdelay = 99;
int s_m3_stepcount = 99;

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
  pinMode(s_m1_z1_bluepin, OUTPUT);
  pinMode(s_m1_z1_redpin, OUTPUT);
  pinMode(s_m1_z2_bluepin, OUTPUT);
  pinMode(s_m1_z2_redpin, OUTPUT);
  
  // Default to off
  zone_reset(0); // Not the intentended use of this function, but it works 0=)
  
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
        if (z1) digitalWrite(s_m1_z1_redpin, HIGH);
        if (z2) digitalWrite(s_m1_z2_redpin, HIGH);
        if (z3) { /* Nothing yet... */ } 
        break;
      case 1:
      case 3:
      case 5:
        // Red Light Off
        if (z1) digitalWrite(s_m1_z1_redpin, LOW);
        if (z2) digitalWrite(s_m1_z2_redpin, LOW);
        if (z3) { /* Nothing yet... */ } 
        break;
      case 8:
      case 10:
      case 12:
        // Blue Light On
        if (z1) digitalWrite(s_m1_z1_bluepin, HIGH);
        if (z2) digitalWrite(s_m1_z2_bluepin, HIGH);
        if (z3) { /* Nothing yet... */ } 
        break;
      case 9:
      case 11:
      case 13:
        // Blue Light Off
        if (z1) digitalWrite(s_m1_z1_bluepin, LOW);
        if (z2) digitalWrite(s_m1_z2_bluepin, LOW);
        if (z3) { /* Nothing yet... */ } 
        break;
      case 6:
      case 7:
      case 14:
      case 15:
          break; // Intentional extra delay
    }
    // If we did the last step, start over, otherwise increment step count.
    if (m1_step > s_m1_stepcount) m1_step = 0;
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
      default:
        break; /* Nothing yet... */
    }
    // If we did the last step, start over, otherwise increment step count.
    if (m2_step > s_m2_stepcount) m2_step = 0;
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
      default:
        break; /* Nothing yet... */
    }
    // If we did the last step, start over, otherwise increment step count.
    if (m3_step > s_m3_stepcount) m3_step = 0;
    else m3_step++;
      
    // Reset time remaining till next step
    m3_timeleft = s_m3_stepdelay;
  }
}

/* Reset mode lights to default settings based on given zone, or 0 for all zones. */
void m1_reset(int zone)
{
  #if DEBUG_RST_DIS
  Serial.print("Reset called. Mode: 1 Zone: "); Serial.println(zone);
  #endif
  switch(zone)
  {
    case 1:
      digitalWrite(s_m1_z1_redpin, LOW);
      digitalWrite(s_m1_z1_bluepin, LOW);
      break;
    case 2:
      digitalWrite(s_m1_z2_redpin, LOW);
      digitalWrite(s_m1_z2_bluepin, LOW);
      break;
    case 3:
      break; /* Nothing yet... */
    case 0:
      m1_step = 0;
      m1_timeleft = 0;
      m1_reset(1);
      m1_reset(2);
      m1_reset(3);
      break;
  }
}

void m2_reset(int zone)
{
  #if DEBUG_RST_DIS
  Serial.print("Reset called. Mode: 2 Zone: "); Serial.println(zone);
  #endif
  switch(zone)
  {
    case 1:
      break; /* Nothing yet... */
    case 2:
      break; /* Nothing yet... */
    case 3:
      break; /* Nothing yet... */
    case 0:
      m2_step = 0;
      m2_timeleft = 0;
      m2_reset(1);
      m2_reset(2);
      m2_reset(3);
      break;
  }
}

void m3_reset(int zone)
{
  #if DEBUG_RST_DIS
  Serial.print("Reset called. Mode: 3 Zone: "); Serial.println(zone);
  #endif
  switch(zone)
  {
    case 1:
      break; /* Nothing yet... */
    case 2:
      break; /* Nothing yet... */
    case 3:
      break; /* Nothing yet... */
    case 0:
      m3_step = 0;
      m3_timeleft = 0;
      m3_reset(1);
      m3_reset(2);
      m3_reset(3);
      break;
  }
}

/* Reset the given zone on all modes at once */
void zone_reset(int zone)
{
  #if DEBUG_RST_DIS
  Serial.print("Reset called. Mode: 0 Zone: "); Serial.println(zone);
  #endif
  m1_reset(zone);
  m2_reset(zone);
  m3_reset(zone);
}