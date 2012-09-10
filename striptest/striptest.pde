#include <LPD6803.h>
#include <TimerOne.h>

// Basic Pixel Setup
int dataPin = 2;
int clockPin = 3;
int pixelMaxCPU = 50;

// Pattern Setup
int s_groupcount = 10;
int s_m1_stepdelay = 200;
int s_m1_stepcount = 10;

// Prepare the Pixel Strip Library
LPD6803 strip = LPD6803(20, dataPin, clockPin);

// Current Progress
int lasttime = 0;
int m1_step = 0;
int m1_timeleft = 0;


// Setup: Ran when program is loaded.
void setup()
{
    // Initialize the strip
    strip.setCPUmax(pixelMaxCPU);
    strip.begin();
    strip.show(); // Set everything to off
}

// Changes color of given group to given r/g/b vales.
void setGroupColor(int gnum, int r, int g, int b) {
    int led = 2 * gnum;
    
    strip.setPixelColor(led, r, g, b);
    strip.setPixelColor(led+1, r, g, b);
    strip.show();
}

// Main program loop
void loop() {
    int diff = millis() - lasttime; // How much time has past since the last loop
    m1_dostep(diff);
    lasttime = millis(); // Record the time before returning
    
    delay(1); // TODO: Remove when merging with main program
}

void m1_dostep(int timediff) {
    m1_timeleft -= timediff; // Update time remaining
    if (m1_timeleft <= 0) {
        if (m1_step == 0) {
            for(int i=0;i < s_groupcount;i++) {
                setGroupColor(i, 0, 0, 0);
            }
        }
        else {
            setGroupColor(m1_step-1, 255, 255, 0);
        }
        
        // If we did the last step, start over, otherwise increment step count.
        if (m1_step >= s_m1_stepcount) m1_step = 0;
        else m1_step++;
          
        // Reset time remaining till next step
        m1_timeleft = s_m1_stepdelay;
    }
}
