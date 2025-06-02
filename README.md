# BIGLCD_test
Test for display DS-G160128STBWW (RA6963) interfaced with 65C22 inspired by https://github.com/crystalfontz/RA6963

Arduino control lines

```
LCD & USD control lines
  ARD MEGA  | Port  | Display pcb |  Function - 8080 Parallel   |
-----------+-------+-------------+-----------------------------+
 5V        |       |     vcc     |  POWER                      |
 GND	      |       |     gnd     |  GROUND                     |
-----------+-------+-------------+-----------------------------+
 D8        | PD0   |     ~R/W    |  Data Read Write (/WR)(/RD) |
 D9        | PD1   |     ~IRQ    |  Interrupt Request          |
 D10       | PD2   |     ~RESET  |  Reset (\RST)               |
-----------+-------+-------------+-----------------------------+
Data Lines
-----------+-------+-------------+-----------------------------+
 D7        | PH4   |     D0      |  LCD_D10 (DB0)              |
 D6        | PH3   |     D1      |  LCD_D11 (DB1)              |
 D5        | PE3   |     D2      |  LCD_D12 (DB2)              |
 D4        | PG5   |     D3      |  LCD_D13 (DB3)              |
 D3        | PE5   |     D4      |  LCD_D14 (DB4)              |
 D2        | PE4   |     D5      |  LCD_D15 (DB5)              |
 D1        | PE1   |     D6      |  LCD_D16 (DB6)              |
 D0        | PE0   |     D7      |  LCD_D17 (DB7)              |
-----------+-------+-------------+-----------------------------+
Address Lines
-----------+-------+-------------+-----------------------------+
 A0        | PF0   |     A0      |  LCD_D10 (DB0)              |
 A1        | PF1   |     A1      |  LCD_D11 (DB1)              |
 A2        | PF2   |     A2      |  LCD_D12 (DB2)              |
 A3        | PF3   |     A3      |  LCD_D13 (DB3)              |
 A4        | PF4   |     A4      |  LCD_D14 (DB4)              |
 A5        | PF5   |     A5      |  LCD_D15 (DB5)              |
 A6        | PF6   |     A6      |  LCD_D16 (DB6)              |
 A7        | PF7   |     A7      |  LCD_D17 (DB7)              |
 A8        | PK0   |     A8      |  LCD_D10 (DB0)              |
 A9        | PK1   |     A9      |  LCD_D11 (DB1)              |
 A10       | PK2   |     A10     |  LCD_D12 (DB2)              |
 A11       | PK3   |     A11     |  LCD_D13 (DB3)              |
 A12       | PK4   |     A12     |  LCD_D14 (DB4)              |
 A13       | PK5   |     A13     |  LCD_D15 (DB5)              |
 A14       | PK6   |     A14     |  LCD_D16 (DB6)              |
 A15       | PK7   |     A15     |  LCD_D17 (DB7)              |
-----------+-------+-------------+-----------------------------+
```

there are three differt codes: "Logo", "Hello, World!" and "screensaver"