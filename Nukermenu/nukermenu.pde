#include <Menu.h>
#include <MenuItem.h>
#include <SubMenu.h>
#include <SubMenuItem.h>
#include <LiquidCrystal.h>

// Debug
byte posdebug=0;

byte achange=0; // Allow the menu to change?
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

void setup()
{
    Serial.begin(19200);
    // Initialize NukerChuck
    setup_nc();
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
    // Initialize the LCD
    lcd.begin(16, 2);
    
    menu.select(0);
    subModes.select(0);
    subZones.select(0);
    
    Serial.println("Setup Complete");
    lcd.print("LCD Ready"); // Test LCD Display
}

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

void loop()
{
  // Process menu movement (TODO: Finish up/Test)
  switch (loop_nc()) {
    case 0: // Center
      if (posdebug == 1) Serial.println("Pos: Center");
      achange=1;
      break;
    case 1: // Up
      if (posdebug == 1) Serial.println("Pos: Up");
      if (canMenuChange()) menu.up();
      break;
    case 2: // Right
      if (posdebug == 1) Serial.println("Pos: Right");
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
      if (posdebug == 1) Serial.println("Pos: Down");
      if (canMenuChange()) menu.down();
      break;
    case 4: // Left
      if (posdebug == 1) Serial.println("Pos: Left");
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
      if (posdebug == 1) Serial.println("Pos: Error");
      break;
  }
  
  // Process button presses (TODO: Finish up/Test)
  // Note: I believe select goes down a menu, and
  //       use calls menuUsed() function.
  if (check_z()) { menu.select(1); }
  if (check_c()) { menu.use(); }  
  
  delay(1);
}

void menuChanged(ItemChangeEvent event)
{
  Serial.println("ChangeEvent Triggered");
  // Display the menu
  if (event == &menuModes) { Serial.println("Modes"); }
  else if (event == &SubModes1) { Serial.println("Mode 1"); }
  else if (event == &SubModes2) { Serial.println("Mode 2"); }
  else if (event == &SubModes3) { Serial.println("Mode 3"); }
  else if (event == &menuZones) { Serial.println("Zones"); }
  else if (event == &SubZones1) { Serial.println("Zone 1"); }
  else if (event == &SubZones2) { Serial.println("Zone 2"); }
  else if (event == &SubZones3) { Serial.println("Zone 3"); }
  else { Serial.println("Error: Unknown Menu Item"); }
}

void menuUsed(ItemUseEvent event)
{
  Serial.println("UseEvent Triggered");
  // Turn things on or off
  if (event == &SubModes1) { 
    if (m1 == 0) {
      m1 = 1;
      Serial.println("Mode 1 - ON");
    }
    else {
      m1 = 0;
      Serial.println("Mode 1 - OFF"); 
    }
  }
  else if (event == &SubModes2) {
    if (m2 == 0) {
      m2 = 1;
      Serial.println("Mode 2 - ON");
    }
    else {
      m2 = 0;
      Serial.println("Mode 2 - OFF"); 
    }
  }
  else if (event == &SubModes3) {
    if (m3 == 0) {
      m3 = 1;
      Serial.println("Mode 3 - ON");
    }
    else {
      m3 = 0;
      Serial.println("Mode 3 - OFF"); 
    }
  }
  else if (event == &SubZones1) {
    if (z1 == 0) {
      z1 = 1;
      Serial.println("Zone 1 - ON");
    }
    else {
      z1 = 0;
      Serial.println("Zone 1 - OFF"); 
    }
  }
  else if (event == &SubZones2) {
    if (z2 == 0) {
      z2 = 1;
      Serial.println("Zone 2 - ON");
    }
    else {
      z2 = 0;
      Serial.println("Zone 2 - OFF"); 
    }
  }
  else if (event == &SubZones3) {
    if (z3 == 0) {
      z3 = 1;
      Serial.println("Zone 3 - ON");
    }
    else {
      z3 = 0;
      Serial.println("Zone 3 - OFF"); 
    }
  }
  else { Serial.println("Error: Unknown or invalid selection"); }
}
