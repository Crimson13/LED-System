/*
 * LED-System: Custom Logo
 *
 * Setups and displays a custom logo when the program is first loaded.
 */

#include <LiquidCrystal.h>

// Custom logo to display (I wonder why a dimensional array didn't work... I blame crim)
byte logo0[8] = { B00011, B00100, B01011, B10010, B10011, B01010, B00100, B00011 };
byte logo1[8] = { B11111, B00000, B10111, B00101, B00101, B00111, B00000, B11111 };
byte logo2[8] = { B11111, B00000, B01110, B01010, B01100, B01010, B00000, B11111 };
byte logo3[8] = { B11100, B00010, B11001, B10100, B10100, B11001, B00010, B11100 };
byte logo4[8] = { B00000, B00000, B00000, B10000, B10000, B00000, B00000, B00000 };

// Setups and initializes the custom logo 
void setup_cl() {
  lcd.createChar(0, logo0);
  lcd.createChar(1, logo1);
  lcd.createChar(2, logo2);
  lcd.createChar(3, logo3);
  lcd.createChar(4, logo4);
  
  display("CustomLogo Ready");
}

// Display the custom logo with text
void displaylogo() { displaylogo("", ""); } // No text
void displaylogo(const char line[]) { displaylogo("", line); } // Text on bottom line
void displaylogo(const char line1[], const char line2[])
{
    lcd.clear();
    for (int i=0; i<=4; i++) {
      lcd.setCursor(i,0);
      lcd.write(i);
    }
    lcd.setCursor(5,0);
    lcd.print(line1);
    lcd.setCursor(0,1);
    lcd.print(line2);
}
