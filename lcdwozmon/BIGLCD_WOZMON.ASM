 .org $1000

; Definizione delle porte del 65C22
PORTB = $d190        ; Indirizzo per i dati (8 bit)
PORTA = $d191        ; Indirizzo per le linee di controllo (4 bit: CS, RW, RS, RESET)
DDRB  = $d192
DDRA  = $d193

RD    = $01          ; %00000001 PA0 ~RD
WR    = $02          ; %00000010 PA1 ~WR
CE    = $04          ; %00000100 PA2 ~CE
CD    = $08          ; %00001000 PA3 C~D
HT    = $10          ; %00010000 PA4 ~HALT
RS    = $20          ; %00100000 PA5 ~RST


START:
    ; Init 65c22
    LDA #%11111111 ; Set all pins on port B to output dati (8 bit)
    STA DDRB
    LDA #%11111111 ; Set all pins on port A to output (5 bit: ~RD, ~WR, ~CE, C~D, ~RST)
    STA DDRA
    
    LDA #%00111011 ; SET |X|X|RST|HALT|CD|CS|WR|RD|  
    STA PORTA
    
    JSR InitDisplay
    ;JSR CLEARTEXT
    ;JSR CLEARDISPLAY
    
    JSR SET_ADD_POINTER

    LDA #$21                  ; LETTER A
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_DATA

    LDA #$c0
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_CMD


    JMP $fe00                  ; Jump to Wozmon

InitDisplay:
; Reset display
    JSR RESET_DISPLAY

; Command 0x40: set text home address  00 00

    LDA #$00          ; LOW address Text Home Address
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_DATA    
    LDA #$00          ; HIGH address Text Home Address
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_DATA    

    LDA #$40          ; load command 0x40 (Text Home Address Set)
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_CMD    

; Command 0x41: set text area  14 00

    LDA #$14          ; LOW address Text Area
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_DATA    
    LDA #$00         ; HIGH address Text Area
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_DATA 

    LDA #$41          ; load command 0x41 (Text Area Set)
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_CMD     

; Command 0x42: set graphic home address 00 08

    LDA #$00          ; LOW address graphic home
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_DATA    
    LDA #$08          ; HIGH address graphic home
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_DATA 
    
    LDA #$42          ;load command 0x42 (graphic home address Set)
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_CMD        
    
; Command 0x43: set graphic area 14 00

    LDA #$14          ; LOW address graphic area 160/8 
    ; JSR WAIT_BUSY_CLEAR
    JSR WRITE_DATA    
    LDA #$00          ; HIGH address graphic area
    ; JSR WAIT_BUSY_CLEAR
    JSR WRITE_DATA    

    LDA #$43          ;load command 0x43 (graphic area Set)
    ; JSR WAIT_BUSY_CLEAR
    JSR WRITE_CMD    

; Commands   
    LDA #$A7; // 8 line cursor
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_CMD
    LDA #$81; // mode set - exor mode 81
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_CMD
    LDA #$97; // 9c display mode - graphic on, text on 94
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_CMD

; Command 0x21: set cursor position

    JSR SET_CURSOR_POS     
    RTS


WRITE_CMD:
    PHA                     
    LDA #%00111011         ; PA5 = 1 (/RST Inactive), PA3 = 1 (command), 
                           ; PA2 = 0 (/CE Active), PA1 = 1 (/WR Inactive), 
                           ; PA0 = 1 (/RD alto) 
    STA PORTA
    PLA                    ; Load command from stack
    STA PORTB              ; command to PORTB
    
    LDA #%00111001         ; PA1 = 0 (/WR Active)
    STA PORTA
    NOP ;JSR DELAY_19u
    LDA #%00111011         ; PA1 = 1 (/WR Inactive)
    STA PORTA
    ;LDA #%00111111         ; PA2 = 1 (/CS Inactive)
    ;STA PORTA
    RTS

WRITE_DATA:
    PHA                    
    LDA #%00110011         ; PA5 = 1 (/RST Inactive), PA3 = 0 (data), 
                           ; PA2 = 0 (/CE Active), PA1 = 1 (/WR Inactive), 
                           ; PA0 = 1 (/RD alto) 
    STA PORTA
    PLA                    ; Load command from stack
    STA PORTB              ; data to PORTB

    LDA #%00111001         ; PA1 = 0 (/WR Active)
    STA PORTA
    NOP ;JSR DELAY_19u
    LDA #%00111011         ; PA1 = 1 (/WR Inactive)
    STA PORTA   
    ;LDA #%00111111         ; PA2 = 1 (/CS Inactive)
    ;STA PORTA
    RTS  

CLEARTEXT:
    PHA
    
    PLA
    RTS

CLEARDISPLAY:
    PHA

    PLA
    RTS

RESET_DISPLAY:
    PHA

    LDA #%00111011   ;SET RD WR CS RST
    STA PORTA

    LDA #%00101011   ;HALT PA4 LDA #%00010000
    STA PORTA
    JSR DELAY_19u    
    LDA #%00001011   ;RST  PA5  #%00000000
    STA PORTA    
    
    JSR DELAY_100u      

    LDA #%00111011   ;SET RD WR CS RST
    STA PORTA    
    JSR DELAY_500u   

    PLA
    RTS

DELAY_100u:
  PHX
  LDX #18 ;  
DELAY_1:
  DEX
  BNE DELAY_1
  PLX
  RTS

DELAY_19u:
  PHX
  LDX #1 ;  
DELAY_2:
  DEX
  BNE DELAY_2
  PLX
  RTS   

DELAY_500u:
  PHX
  LDX #98 ;  
DELAY_3:
  DEX
  BNE DELAY_3
  PLX
  RTS   

DELAY_1289u:
  PHX
  LDX #255 ;  
DELAY_4:
  DEX
  BNE DELAY_4
  PLX
  RTS     

WAIT_BUSY_CLEAR:
    PHA

    LDA #%00000000    ; PB INPUT FOR READING
    STA DDRB
WaitBusyLoop:
    LDA #%00111011    ; PA5=1 (/RST) PA4=1 (/HALT) PA3=1 (C/D) PA2=0 (/CE) PA1=1 (/WR) PA0=1 (/RD)
    STA PORTA
    JSR DELAY_100u
    LDA #%00111010    ; PA5=1 (/RST) PA4=1 (/HALT) PA3=1 (C/D) PA2=0 (/CE) PA1=1 (/WR) PA0=0 (/RD)
    STA PORTA

    NOP

    LDA PORTB
    AND #%00000011    ; STA1 = COMMAND EXEC CAPABILITY STA0 = DATA R/W CAPABILITY
    CMP #%00000011    ; 
    BNE WaitBusyLoop  ; NOT EQUAL JUMP BACK

    LDA #%00111011    ; PA5=1 (/RST) PA4=1 (/HALT) PA3=1 (C/D) PA2=0 (/CE) PA1=1 (/WR) PA0=1 (/RD)
    STA PORTA

    LDA #%11111111    ; PB OUTPUT
    STA DDRB

    PLA
    RTS

SET_CURSOR_POS:    ; Command 0x21: set cursor position
    PHA
    LDA #$01          ; LOW address graphic area 160/8 
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_DATA    
    LDA #$00          ; HIGH address graphic area
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_DATA 

    LDA #$21          ;load command 0x21 (cursor position set)
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_CMD    
    PLA
    RTS

SET_ADD_POINTER:   ; Command 0x24: set address position
    PHA
    LDA #$00
    JSR WAIT_BUSY_CLEAR         
    JSR WRITE_DATA    
    LDA #$00
    JSR WAIT_BUSY_CLEAR          
    JSR WRITE_DATA 
    LDA #$24          ; SET ADDRESS POINTER (posizione 0,0)
    JSR WAIT_BUSY_CLEAR
    JSR WRITE_CMD 
    PLA
    RTS