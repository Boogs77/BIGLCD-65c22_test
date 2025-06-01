// It is only for testing interface with 65c22 and specific setting an clearing function



#define PORT_MANIPULATION

#define VIA_ADD   0xd1
#define VIA_PORTA 0x91
#define VIA_ADDRA 0x93

#define RESET 19
#define IRQ 20
#define RW 21

#define RD 0x01 // B00000001 PA0 ~RD
#define WR 0x02 // B00000010 PA1 ~WR
#define CE 0x04 // B00000100 PA2 ~CE
#define CD 0x08 // B00001000 PA3 C~D
#define RS 0x20 // B00100000 PA5 RST

void writedatalines(unsigned int data){

  PORTG = ((data & 0x08) << 2);                   
  PORTH = ((data & 0x01) << 4) + ((data & 0x02) << 2);
  PORTE = ((data & 0x04) << 1) + ((data & 0x10) << 1) + ((data & 0x20) >> 1) + ((data & 0x40 ) >> 5) + ((data & 0x80) >> 7);
}

void reset() {
  SET_RS();                            //Reset LCD HIGH 
  //digitalWrite(RESET, HIGH);           //Reset 65C22 HIGH
  delayMicroseconds(100);
  CLR_RS();                            //Reset LCD LOW
  //digitalWrite(RESET, LOW);            //Reset 65C22 LOW
  delayMicroseconds(10); 
  SET_RS();                            //Reset LCD HIGH 
  //digitalWrite(RESET, HIGH);           //Reset 65C22 HIGH
  //Serial.println("Reset Display");  
}

unsigned int LCD_BITS = 0;

void writedata2reg(unsigned int data, unsigned int VIA_ADDdd, unsigned int LOWregadd){
  writedatalines(data);
  PORTK = VIA_ADDdd;
  PORTF = LOWregadd;  //PORTA
  digitalWrite(RW, LOW);
  delay(10);
  digitalWrite(RW, HIGH);
}

void CLR_CS(){
  LCD_BITS &= ~(CE);
  writedata2reg(LCD_BITS,VIA_ADD,VIA_PORTA);
  //delayMicroseconds(100);
}

void SET_CS(){
  LCD_BITS |= (CE);
  writedata2reg(LCD_BITS,VIA_ADD,VIA_PORTA);
  //delayMicroseconds(100);
}

void CLR_DC(){
  LCD_BITS &= ~(CD);
  writedata2reg(LCD_BITS,VIA_ADD,VIA_PORTA);
}

void SET_DC(){
  LCD_BITS |= (CD);
  writedata2reg(LCD_BITS,VIA_ADD,VIA_PORTA);
}

void CLR_WR(){
  LCD_BITS &= ~(WR);
  writedata2reg(LCD_BITS,VIA_ADD,VIA_PORTA);
}

void SET_WR(){
  LCD_BITS |= (WR);
  writedata2reg(LCD_BITS,VIA_ADD,VIA_PORTA);
}

void CLR_RD(){
  LCD_BITS &= ~(RD);
  writedata2reg(LCD_BITS,VIA_ADD,VIA_PORTA);
}

void SET_RD(){
  LCD_BITS |= (RD);
  writedata2reg(LCD_BITS,VIA_ADD,VIA_PORTA);
}

void CLR_RS(){
  LCD_BITS &= ~(RS);
  writedata2reg(LCD_BITS,VIA_ADD,VIA_PORTA);
}

void SET_RS(){
  LCD_BITS |= (RS);
  writedata2reg(LCD_BITS,VIA_ADD,VIA_PORTA);
}
void setup() {
  DDRK = 0xFF;
  DDRF = 0xFF;
  DDRH = B00011000;
  DDRE = B00111011;
  DDRG = B00100000;
  
  Serial.begin(9600);
  pinMode (RW, OUTPUT);
  pinMode (IRQ, INPUT);
  pinMode (RESET, OUTPUT);
  digitalWrite(RW, HIGH);
  delayMicroseconds(10);
  digitalWrite(RESET, HIGH); 
  reset();
  delayMicroseconds(10);
  writedata2reg(0xFF,VIA_ADD,VIA_ADDRA);
  Serial.println("ALL PINS OUTPUT"); 
}

void loop() {


  CLR_DC();
  SET_RD();
  delay(500);
  CLR_RD();
  SET_WR();
  delay(500);
  CLR_WR();
  SET_CS();
  delay(500);
  CLR_CS();
  SET_DC();
  delay(500);




}
