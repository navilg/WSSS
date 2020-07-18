/* Final year project. 
 *  
 *  WIRELESS SURVEILLANCE AND SAFETY SYSTEM FOR MINE WORKERS USING ZIGBEE
 *  
 *  EC12015 NAMRATA BHAGAT
 *  EC12016 NAVRATAN LAL GUPTA
 *  EC12040 SHALAKA POKLEY
 *  EC12051 PRAGYA KUMARI
 */

#include "DHT.h"
#define DHTPIN 3     // what digital pin we're connected to
#define DHTTYPE DHT11
const int AOUTpin=A0;//the AOUT pin of the methane sensor goes into analog pin A0 of the arduino
const int ledPing=13;//the anode of the LED connects to digital pin D13 of the arduino for ALL OK sign
const int ledPinm=5;//the anode of the LED connects to digital pin D13 of the arduino for warning sign
const int ledPint=7;//the anode of the LED connects to digital pin D13 of the arduino for warning sign
const int ledPinh=9;//the anode of the LED connects to digital pin D13 of the arduino for warning sign
const int emergency=11; //To send emergency Alarm
int value;
int check=0; //check bits
DHT dht(DHTPIN, DHTTYPE);
void setup() {
  delay(3000);
  Serial.begin(115200);
  dht.begin();
  pinMode(ledPing, OUTPUT);//sets the pin 13 as an output of the arduino
  pinMode(ledPinm, OUTPUT);//sets the pin 5 as an output of the arduino
  pinMode(ledPinh, OUTPUT);//sets the pin 9 as an output of the arduino
  pinMode(ledPint, OUTPUT);//sets the pin 7 as an output of the arduino
  pinMode(emergency,INPUT); //set the pin 11 as an input of the arduino

}

void loop() {
  if(digitalRead(emergency)==HIGH)
  {
    check=110;
  }
  else
  {
    check=0;
  }
 
  // put your main code here, to run repeatedly:
int h = dht.readHumidity();  //Read humidity
  int t = dht.readTemperature(); // Read temperature as Celsius (the default)
  value= analogRead(AOUTpin); // Read methane value
  if (isnan(h) || isnan(t)  || isnan(value) ) {
    int n=0;
    Serial.println(n);
    return;
  }
  if (h>60)
  {
    digitalWrite(ledPinh, HIGH); //humidity high indicator
  }
  else
  {
  digitalWrite(ledPinh,LOW);
}
  if (t>48)
  {
    digitalWrite(ledPint, HIGH); //temperature high indicator
  }
  else
  {
    digitalWrite(ledPint,LOW);
  }
  if (value>440)
  {
    digitalWrite(ledPinm, HIGH); //methane high indicator
  }
  else
  {
    digitalWrite(ledPinm,LOW);
  }
  if(h<=60 && t<=48 && value<=440)
  {
    digitalWrite(ledPing, HIGH); //ALL OK
  }
  else
  {
    digitalWrite(ledPing,LOW);
  }
  Serial.println(check,DEC); //transmit check bits
 Serial.println(h,DEC); //Serially transmit the humidity value
 Serial.println(t,DEC); //Serially transmit the temperature value
 Serial.println(value,DEC); //Serially transmit the methane value
 //delay(300000); //sleeping for 5 minutes
 delay(5000); //sleeping for 3 seconds for demo purpose
}
