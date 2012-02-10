// Settings
int s_m1_z1_stepdelay = 75;
int s_m1_z1_stepcount = 15;
int s_m1_z1_redpin = 2;
int s_m1_z1_bluepin = 3;

// Progress
int m1_z1_step = 0;
int m1_z1_stepsleft = 0;

void setup_li()
{
  pinMode(s_m1_z1_bluepin, OUTPUT);
  pinMode(s_m1_z1_redpin, OUTPUT);
}

void loop_li(byte m1, byte m2, byte m3, byte z1, byte z2, byte z3)
{
  if (m1) m1_dostep(z1, z2, z3);
}

void m1_dostep(byte z1, byte z2, byte z3)
{  
  if (z1)
  {
    m1_z1_stepsleft--;
    if (m1_z1_stepsleft <= 0) {
      switch (m1_z1_step) {
        case 0:
        case 2:
        case 4:
          // Red Light On
          digitalWrite(s_m1_z1_redpin, HIGH);
          break;
        case 1:
        case 3:
        case 5:
          // Red Light Off
          digitalWrite(s_m1_z1_redpin, LOW); 
          break;
        case 8:
        case 10:
        case 12:
          // Blue Light On
          digitalWrite(s_m1_z1_bluepin, HIGH); // turn the blue light on
          break;
        case 9:
        case 11:
        case 13:
          // Blue Light Off
          digitalWrite(s_m1_z1_bluepin, LOW);
          break;
        case 6:
        case 7:
        case 14:
        case 15:
          break; // Nothing happens.
      }
      // If we did last step, start over, otherwise increment step count.
      if (m1_z1_step > s_m1_z1_stepcount) m1_z1_step = 0;
      else m1_z1_step++;
      
      // Reset remaining steps
      m1_z1_stepsleft = s_m1_z1_stepdelay;
    }
  }
  if (z2)
  {
    // Empty
  }
  if (z3)
  {
    // Empty
  }
}
