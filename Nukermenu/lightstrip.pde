/*
 * LED-System: Light Strip
 *
 * Controls the LED Light Strip.
 *
 * Notes:
 *  The strip of pixels is subdivided into groups, so we turn a certain group of
 *  pixels on or off in each step instead of doing each pixel individually.
 */

#include <LPD6803.h>
#include <TimerOne.h>
 
// Basic Strip Setup
int dataPin = 10;
int clockPin = 11;
int pixelMaxCPU = 50;
int pixelsPerGroup = 2;
int pixelGroups = 10;

// Settings
int s_p1_stepdelay = 200;
int s_p1_stepcount = 10;
int s_p2_stepdelay = 200;
int s_p2_stepcount = 10;

// Progress
int ls_lasttime = 0;
int p1_step = 0;
int p1_timeleft = 0;
int p2_step = 0;
int p2_timeleft = 0;

// Prepare the Pixel Strip Library
LPD6803 strip = LPD6803(20, dataPin, clockPin);

void setup_ls()
{
    // Initialize the strip
    strip.setCPUmax(pixelMaxCPU);
    strip.begin();
    strip.show(); // Set everything to off
    
    display("Strip Ready");
}

void loop_ls(byte p1, byte p2) {
    int diff = millis() - ls_lasttime; // How much time has past since the last loop
    if (p1) p1_dostep(diff);
    if (p2) p2_dostep(diff);
    ls_lasttime = millis(); // Record the time before returning
}

// Reset all pixels in the strip to being off.
void resetStrip() {
    for(int i=0;i < strip.numPixels();i++) {
        strip.setPixelColor(i, 0, 0, 0);
    }
    strip.show();
}

// Changes color of given group to given r/g/b vales.
void setGroupColor(int gnum, int r, int g, int b) {
    int start = pixelsPerGroup * gnum;
    
    for (int p=start;p<(start+pixelsPerGroup); p++) {
        strip.setPixelColor(p, r, g, b);
    }
    strip.show();
}

void p1_dostep(int timediff) {
    p1_timeleft -= timediff; // Update time remaining
    if (p1_timeleft <= 0) {
        if (p1_step == 0) {
            resetStrip();
        }
        else {
            setGroupColor(p1_step-1, 255, 255, 0);
        }
        
        // If we did the last step, start over, otherwise increment step count.
        if (p1_step >= s_p1_stepcount) p1_step = 0;
        else p1_step++;
          
        // Reset time remaining till next step
        p1_timeleft = s_p1_stepdelay;
    }
}

void p2_dostep(int timediff) {
    p2_timeleft -= timediff; // Update time remaining
    if (p2_timeleft <= 0) {
        if (p2_step == 0) {
            resetStrip();
        }
        else {
            setGroupColor(pixelGroups-p2_step, 255, 255, 0);
        }
        
        // If we did the last step, start over, otherwise increment step count.
        if (p2_step >= s_p2_stepcount) p2_step = 0;
        else p2_step++;
          
        // Reset time remaining till next step
        p2_timeleft = s_p2_stepdelay;
    }
}
