// Settings
int s_m1_stepdelay = 75; // Temp Note: Crim lowered this to 30 on the old system.
int s_m1_stepcount = 15;
int s_m1_z1_redpin = 2;
int s_m1_z1_bluepin = 3;

// Progress
int lasttime = 0;
int m1_step = 0;
int m1_timeleft = 0;

void setup_li()
{
  pinMode(s_m1_z1_bluepin, OUTPUT);
  pinMode(s_m1_z1_redpin, OUTPUT);
}

void loop_li(byte m1, byte m2, byte m3, byte z1, byte z2, byte z3)
{
  int diff = millis() - lasttime; // How much time has past since the last loop
  if (m1) m1_dostep(z1, z2, z3, diff);
  lasttime = millis() // Record the time before returning
}

void m1_dostep(byte z1, byte z2, byte z3, int timediff)
{
  m1_timeleft -= timediff; // Update time remaining
  
  if (m1_timeleft <= 0) {
    switch (m1_step) {
      case 0:
      case 2:
      case 4:
        // Red Light On
        if (z1) digitalWrite(s_m1_z1_redpin, HIGH);
        if (z2) { /* Nothing yet... */ } 
        if (z3) { /* Nothing yet... */ } 
        break;
      case 1:
      case 3:
      case 5:
        // Red Light Off
        if (z1) digitalWrite(s_m1_z1_redpin, LOW);
        if (z2) { /* Nothing yet... */ } 
        if (z3) { /* Nothing yet... */ } 
        break;
      case 8:
      case 10:
      case 12:
        // Blue Light On
        if (z1) digitalWrite(s_m1_z1_bluepin, HIGH); // turn the blue light on
        if (z2) { /* Nothing yet... */ } 
        if (z3) { /* Nothing yet... */ } 
        break;
      case 9:
      case 11:
      case 13:
        // Blue Light Off
        if (z1) digitalWrite(s_m1_z1_bluepin, LOW);
        if (z2) { /* Nothing yet... */ } 
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
