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
 
// Pin Settings
const int dataPin = 10;
const int clockPin = 11;

// Settings
const int pixelMaxCPU = 50;
const int pixelGroups = 10;
const int pixelsPerGroup = 2;
const int s_p1_stepdelay = 200;
const int s_p1_stepcount = pixelGroups+1;
const int s_p2_stepdelay = 200;
const int s_p2_stepcount = pixelGroups+1;
const int s_p3_stepdelay = 200;
const int s_p3_stepcount = (pixelGroups / 2) + 1;
const int s_p4_stepdelay = 200;
const int s_p4_stepcount = 1;
const int s_p5_stepdelay = 200;
const int s_p5_stepcount = 11;
const int s_p6_stepdelay = 200;
const int s_p6_stepcount = 1;

// Progress & Internals
int ls_lasttime = 0;
int p1_step = 0;
int p1_timeleft = 0;
int p2_step = 0;
int p2_timeleft = 0;
int p3_step = 0;
int p3_timeleft = 0;
int p4_step = 0;
int p4_timeleft = 0;
int p5_step = 0;
int p5_timeleft = 0;
int p6_step = 0;
int p6_timeleft = 0;
const int rmid = pixelGroups / 2;

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

void loop_ls(boolean p1, boolean p2, boolean p3,boolean p4, boolean p5,boolean p6) {
    int diff = millis() - ls_lasttime; // How much time has past since the last loop
    if (p1) p1_dostep(diff);
    if (p2) p2_dostep(diff);
    if (p3) p3_dostep(diff);
    if (p4) p4_dostep(diff);
    if (p5) p5_dostep(diff);
    if (p6) p6_dostep(diff);
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
        if (p1_step == 0) { resetStrip(); }
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
        if (p2_step == 0) { resetStrip(); }
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

void p3_dostep(int timediff) {
    p3_timeleft -= timediff; // Update time remaining
    if (p3_timeleft <= 0) {
        if (p3_step == 0) { resetStrip(); }
        else {
            int offset = p3_step - 1;
            setGroupColor((s_p3_stepcount-1)-offset, 255, 255, 0);
            setGroupColor((s_p3_stepcount)+offset, 255, 255, 0);
        }
        
        // If we did the last step, start over, otherwise increment step count.
        if (p3_step >= s_p3_stepcount) p3_step = 0;
        else p3_step++;
          
        // Reset time remaining till next step
        p3_timeleft = s_p3_stepdelay;
    }
}

void p4_dostep(int timediff) {
    p4_timeleft -= timediff; // Update time remaining
    if (p4_timeleft <= 0) {
        resetStrip(); // Always reset the strip on each step
        if (p4_step == 0) {
            for (int i=0;i<rmid;i++) {
                setGroupColor(i, 255, 255, 0);
            }
        }
        else {
            for (int i=rmid;i<pixelGroups;i++) {
                setGroupColor(i, 255, 255, 0);
            }
        }
        
        // If we did the last step, start over, otherwise increment step count.
        if (p4_step >= s_p4_stepcount) p4_step = 0;
        else p4_step++;
          
        // Reset time remaining till next step
        p4_timeleft = s_p4_stepdelay;
    }
}

void p5_dostep(int timediff) {
    p5_timeleft -= timediff; // Update time remaining
    if (p5_timeleft <= 0) {        
        switch (p5_step) {
            case 1:
            case 3:
            case 5:
                for (int i=0;i<rmid;i++) {
                    setGroupColor(i, 255, 255, 0);
                }
                break;
            case 7:
            case 9:
            case 11:
                for (int i=rmid;i<pixelGroups;i++) {
                    setGroupColor(i, 255, 255, 0);
                }
                break;
            default:
                resetStrip();
                break;
        }
        
        // If we did the last step, start over, otherwise increment step count.
        if (p5_step >= s_p5_stepcount) p5_step = 0;
        else p5_step++;
          
        // Reset time remaining till next step
        p5_timeleft = s_p5_stepdelay;
    }
}

void p6_dostep(int timediff) {
    p6_timeleft -= timediff; // Update time remaining
    if (p6_timeleft <= 0) {
        resetStrip(); // Always reset the strip on each step
        for (int i=0;i<pixelGroups;i++) {
            if ((i % 2) == p6_step) {
                setGroupColor(i, 255, 255, 0);
            }
        }
        
        // If we did the last step, start over, otherwise increment step count.
        if (p6_step >= s_p6_stepcount) p6_step = 0;
        else p6_step++;
          
        // Reset time remaining till next step
        p6_timeleft = s_p6_stepdelay;
    }
}

// Clear current progress and set back to inital values
void ls_clear_progress() {
    p1_step = 0;
    p1_timeleft = 0;
    p2_step = 0;
    p2_timeleft = 0;
    p3_step = 0;
    p3_timeleft = 0;
    p4_step = 0;
    p4_timeleft = 0;
    p5_step = 0;
    p5_timeleft = 0;
    p6_step = 0;
    p6_timeleft = 0;
}
