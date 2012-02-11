/*
 * LED-System: Menu System
 *
 * Controls the menu, menu navigation, and what is displayed.
 */

#include <Menu.h>
#include <MenuItem.h>
#include <SubMenu.h>
#include <SubMenuItem.h>
#include <LiquidCrystal.h>

// Debug Defintions (Set at compile time)
#define DEBUG_DIS_PTS 1   // Print display to serial
#define DEBUG_EVT_TRG 0   // Display when events are triggered
#define DEBUG_NUM_POS 0   // Position of numchuck

// Anti-Input Duplication Flags
byte achange=0;
byte zlast=0;
byte clast=0;

// On/off flags
byte m1=0;
byte m2=0;
byte m3=0;
byte z1=0;
byte z2=0;
byte z3=0;

// Prepare the menu
Menu menu = Menu(menuUsed,menuChanged);
  MenuItem menuModes = MenuItem();
    SubMenu subModes = SubMenu(menuChanged);
      SubMenuItem SubModes1 = SubMenuItem();
      SubMenuItem SubModes2 = SubMenuItem();
      SubMenuItem SubModes3 = SubMenuItem();
  MenuItem menuZones = MenuItem();
    SubMenu subZones = SubMenu(menuChanged);
      SubMenuItem SubZones1 = SubMenuItem();
      SubMenuItem SubZones2 = SubMenuItem();
      SubMenuItem SubZones3 = SubMenuItem();

// Prepare the LiquidCrystal Library
LiquidCrystal lcd(7, 8, 9, 10, 11, 12);

// Setup: Ran when program is loaded.
void setup()
{
    Serial.begin(19200);
    
    // Initialize the LCD
    lcd.begin(16, 2);
    
    // Initialize the menu
    menu.addMenuItem(menuModes);
      menuModes.addSubMenu(subModes);
        subModes.addSubMenuItem(SubModes1);
        subModes.addSubMenuItem(SubModes2);
        subModes.addSubMenuItem(SubModes3);
    menu.addMenuItem(menuZones);
      menuZones.addSubMenu(subZones);
        subZones.addSubMenuItem(SubZones1);
        subZones.addSubMenuItem(SubZones2);
        subZones.addSubMenuItem(SubZones3);
    menu.select(0);
    subModes.select(0);
    subZones.select(0);
    
    setup_nc(); // Initialize NukerChuck
    setup_li(); // Initialize Lights
    setup_cl(); // Initialize the Custom Logo
    
    display("Setup Complete");
    displaylogo("Ready");
}

/* Following functions prevent duplicate inputs by holding down the button */
byte canMenuChange()
{
  if (achange == 1) {
    achange = 0;
    return 1;
  }
  return 0;
}
byte check_z()
{
  if (nc_z()) {
    if (zlast == 0) {
      zlast = 1;
      return 1;
    }
  }
  else zlast = 0;
  return 0;
}
byte check_c()
{
  if (nc_c()) {
    if (clast == 0) {
      clast = 1;
      return 1;
    }
  }
  else clast = 0;
  return 0;
}

// Display given text to the LCD after clearing it
void display(const char text[])
{
    #if DEBUG_DIS_PTS
    Serial.print("Displaying: ");
    Serial.print(text);
    Serial.println();
    #endif
    lcd.clear();
    lcd.print(text);
}

// Display the given mode and if its on or off
void ShowModeItem(const int mode)
{
    if (mode == 1)
    {
        if (m1) { display("Mode 1 - ON"); }
        else { display("Mode 1 - OFF"); }
    }
    else if (mode == 2)
    {
        if (m2) { display("Mode 2 - ON"); }
        else { display("Mode 2 - OFF"); }
    }
    else if (mode == 3)
    {
        if (m3) { display("Mode 3 - ON"); }
        else { display("Mode 3 - OFF"); }
    }
    else { display("Error: Invalid Mode Given!"); }
}

// Display the given zone and if its on or off
void ShowZoneItem(const int zone)
{
    if (zone == 1)
    {
        if (z1) { display("Zone 1 - ON"); }
        else { display("Zone 1 - OFF"); }
    }
    else if (zone == 2)
    {
        if (z2) { display("Zone 2 - ON"); }
        else { display("Zone 2 - OFF"); }
    }
    else if (zone == 3)
    {
        if (z3) { display("Zone 3 - ON"); }
        else { display("Zone 3 - OFF"); }
    }
    else { display("Error: Invalid Zone Given!"); }
}

// Main program loop
void loop()
{
  // Have the light script take a step
  loop_li(z1,z2,z3,m1,m2,m3);
  // Process menu movement
  switch (loop_nc()) {
    case 0: // Center
      #if DEBUG_NUM_POS
      display("Pos: Center");
      #endif
      achange=1;
      break;
    case 1: // Up
      #if DEBUG_NUM_POS
      display("Pos: Up");
      #endif
      if (canMenuChange()) menu.up();
      break;
    case 2: // Right
      #if DEBUG_NUM_POS
      display("Pos: Right");
      #endif
      if (menu.isCurrentSubMenu()) {
        if (menu.getCurrentItem() == &menuModes) {
          if (canMenuChange()) subModes.up();
        }
        else if (menu.getCurrentItem() == &menuZones) {
          if (canMenuChange()) subZones.up();
        }
      }
      break;
    case 3: // Down
      #if DEBUG_NUM_POS
      display("Pos: Down");
      #endif
      if (canMenuChange()) menu.down();
      break;
    case 4: // Left
      #if DEBUG_NUM_POS
      display("Pos: Left");
      #endif
      if (menu.isCurrentSubMenu()) {
        if (menu.getCurrentItem() == &menuModes) {
          if (canMenuChange()) subModes.down();
        }
        else if (menu.getCurrentItem() == &menuZones) {
          if (canMenuChange()) subZones.down();
        }
      }
      break;
    case -1: // Error
      #if DEBUG_NUM_POS
      display("Pos: Error");
      #endif
      break;
  }
  
  // Process button presses
  // Note: I believe select goes down a menu, and
  //       use calls menuUsed() function.
  if (check_z()) { menu.select(1); }
  if (check_c()) { menu.use(); }  
  
  delay(1);
}

// Event: Called when the menu item has changed.
void menuChanged(ItemChangeEvent event)
{
  #if DEBUG_EVT_TRG
  display("ChangeEvent Triggered");
  #endif
  // Display the menu
  if (event == &menuModes) { display("Modes"); }
  else if (event == &SubModes1) { ShowModeItem(1); }
  else if (event == &SubModes2) { ShowModeItem(2); }
  else if (event == &SubModes3) { ShowModeItem(3); }
  else if (event == &menuZones) { display("Zones"); }
  else if (event == &SubZones1) { ShowZoneItem(1); }
  else if (event == &SubZones2) { ShowZoneItem(2); }
  else if (event == &SubZones3) { ShowZoneItem(3);; }
  else { display("Error: Unknown Menu Item"); }
}

// Event: Called when a menu item is used.
void menuUsed(ItemUseEvent event)
{
  #if DEBUG_EVT_TRG
  display("UseEvent Triggered");
  #endif
  // Turn things on or off
  if (event == &SubModes1) { 
    if (m1 == 0) { m1 = 1; }
    else { m1 = 0; }
    ShowModeItem(1);
  }
  else if (event == &SubModes2) {
    if (m2 == 0) { m2 = 1; }
    else { m2 = 0; }
    ShowModeItem(2);
  }
  else if (event == &SubModes3) {
    if (m3 == 0) { m3 = 1; }
    else { m3 = 0; }
    ShowModeItem(3);
  }
  else if (event == &SubZones1) {
    if (z1 == 0) { z1 = 1; }
    else { z1 = 0; }
    ShowZoneItem(1);
  }
  else if (event == &SubZones2) {
    if (z2 == 0) { z2 = 1; }
    else { z2 = 0; }
    ShowZoneItem(2);
  }
  else if (event == &SubZones3) {
    if (z3 == 0) { z3 = 1; }
    else { z3 = 0; }
    ShowZoneItem(3);
  }
  else { display("Error: Unknown or invalid selection"); }
}
