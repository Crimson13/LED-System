// Project 1 - Police Lights by Dave1324

int ledDelay = 75; // delay by 75ms
int redPin = 2;
int bluePin = 3;


void setup() {
pinMode(redPin, OUTPUT);
pinMode(bluePin, OUTPUT);

}

void loop() {

digitalWrite(redPin, HIGH); // turn the red light on
delay(ledDelay); // wait 75 ms

digitalWrite(redPin, LOW); // turn the red light off
delay(ledDelay); // wait 75 ms

digitalWrite(redPin, HIGH); // turn the red light on
delay(ledDelay); // wait 75 ms

digitalWrite(redPin, LOW); // turn the red light off
delay(ledDelay); // wait 75 ms

digitalWrite(redPin, HIGH); // turn the red light on
delay(ledDelay); // wait 75 ms

digitalWrite(redPin, LOW); // turn the red light off
delay(ledDelay); // wait 75 ms

delay(150); // delay midpoint by 150ms

digitalWrite(bluePin, HIGH); // turn the blue light on
delay(ledDelay); // wait 75 ms

digitalWrite(bluePin, LOW); // turn the blue light off
delay(ledDelay); // wait 75 ms

digitalWrite(bluePin, HIGH); // turn the blue light on
delay(ledDelay); // wait 75 ms

digitalWrite(bluePin, LOW); // turn the blue light off
delay(ledDelay); // wait 75 ms

digitalWrite(bluePin, HIGH); // turn the blue light on
delay(ledDelay); // wait 75 ms

digitalWrite(bluePin, LOW); // turn the blue light off
delay(ledDelay); // wait 75 ms

delay(150);

}
