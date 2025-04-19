#include<Wire.h>

volatile bool flag = false;
volatile byte myArray[2];
volatile byte register_address;
volatile byte simulated_registers[0x10];
volatile byte cntRequest=0;

void setup()
{  
  simulated_registers[0]='U';
  simulated_registers[1]='U';
  simulated_registers[2]=0xAA;
  simulated_registers[3]=0xAA;

  Serial.begin(115200);
  delay(100);
  Serial.println("i2c device with address 0x20");
  Wire.begin(0x20); 
  Wire.onReceive(receiveEvent);
  Wire.onRequest(requestEvent);
}

void loop()
{
  if (flag == true)
  {
    int x = (myArray[0]<<8)|myArray[1];
    Serial.println(x, HEX);  //shows: 1234
    if(x)   
      flag = false;
  }
}

void requestEvent() 
{
  Wire.write( (byte *) &simulated_registers[cntRequest], 1);
  cntRequest++;
}


void receiveEvent(int howMany)
{
  myArray[0] = 0xFE;
  myArray[1] = 0xFE;
  for(int i=0; i<howMany; i++)
  {
    myArray[i] = Wire.read();  
  }
  if( (myArray[0]==6) && (myArray[1]==0) )
  {
    cntRequest=0;
  }
  flag = true;
}



