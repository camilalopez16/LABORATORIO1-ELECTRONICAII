PROCESSOR 16F877A

#include <xc.inc>

; CONFIGURATION WORD PG 144 datasheet

CONFIG CP=OFF ; PFM and Data EEPROM code protection disabled
CONFIG DEBUG=OFF ; Background debugger disabled
CONFIG WRT=OFF
CONFIG CPD=OFF
CONFIG WDTE=OFF ; WDT Disabled; SWDTEN is ignored
CONFIG LVP=ON ; Low voltage programming enabled, MCLR pin, MCLRE ignored
CONFIG FOSC=XT
CONFIG PWRTE=ON
CONFIG BOREN=OFF
PSECT udata_bank0

max:
DS 1 ;reserve 1 byte for max

tmp:
DS 1 ;reserve 1 byte for tmp
PSECT resetVec,class=CODE,delta=2

resetVec:
    PAGESEL INISYS ;jump to the main routine
    goto INISYS

PSECT code

INISYS:
    ;Cambio a Banco N1
    BCF STATUS, 6
    BSF STATUS, 5 ; Bank1
    ; Modificar TRIS
    BSF TRISB, 1    ; PortB5 <- Definimos como una entrada S1
    BSF TRISB, 2    ; PortB1 <- Definimos como una entrada S2
    BSF TRISB, 3    ; PortB2 <- Definimos como una entrada S3
    BSF TRISB, 4    ; PortB3 <- Definimos como una entrada S4
    BSF TRISB, 5    ; PortB4 <- Definimos como una entrada S5
    ;------------------------------------------
    BCF TRISD, 0    ; PortD0 <- Definimos como una salida M1 
    BCF TRISD, 1    ; PortD1 <- Definimos como una salida M2
    BCF TRISD, 2    ; PortD2 <- Definimos como una salida M1R
    BCF TRISD, 3    ; PortD3 <- Definimos como una salida M2R
    BCF TRISD, 4    ; PortD4 <- Definimos como una salida LED.I
    BCF TRISD, 5    ; PortD5 <- Definimos como una salida LED.C
    BCF TRISD, 6    ; PortD6 <- Definimos como una salida LED.D
    ; Regresar a banco 
    BCF STATUS, 5 ; Bank0

Main:
    MOVF PORTB,0 ; Asignar un valor a W 
    MOVWF 0X25 ; Mover a w al registro 25
    ;ENTRADAS............
    ; C1 = S1 -> 26
    MOVF  0X25,0     ;"000000(S1)0"
    ANDLW 0b00000010
    MOVWF 0X26 
    RRF 0X26,1
    MOVF 0X26,0        ;OJO CON ESTA LINEA
    ANDLW 0b00000001
    MOVWF 0X26       ;
    
    ; C2 = S2 -> 27
    MOVF 0X25,0          ;"00000(S2)00"
    ANDLW 0b00000100  ; AND entre reg 25
    MOVWF 0X27          ; REGISTRO = W
    RRF 0X27,1          ; UN BIT A LA DERECHA  
    RRF 0X27,1
    MOVF 0X27,0         ; W = REGISTRO 27
    ANDLW 0b00000001  ; AND ENTRE W Y "00000001"
    MOVWF 0X27          ; REGISTRO = W
    
    ;--------------
    ; C3 = S3 -> 28
    MOVF 0X25,0          ;"0000(S3)000"
    ANDLW 0b00001000
    MOVWF 0X28
    RRF 0X28,1
    RRF 0X28,1
    RRF 0X28,1
    MOVF 0X28,0
    ANDLW 0b00000001
    MOVWF 0X28
   ;----------------
   ; C4 = S4 -> 29
    MOVF 0X25,0           ;"000(S4)0000"
    ANDLW 0b00010000
    MOVWF 0X29
    RRF 0X29,1
    RRF 0X29,1
    RRF 0X29,1
    RRF 0X29,1
    MOVF 0X29,0
    ANDLW 0b00000001
    MOVWF 0X29
    ;-----------------
   ; C5 = S5 -> 30
    MOVF 0X25,0           ;"00(S5)00000"
    ANDLW 0b00100000
    MOVWF 0X30
    RRF 0X30,1
    RRF 0X30,1
    RRF 0X30,1
    RRF 0X30,1
    RRF 0X30,1
    MOVF 0X30,0
    ANDLW 0b00000001
    MOVWF 0X30
   ;---------------
    ; !C1 = !S1 -> 31
    MOVF 0X25,0
    ANDLW 0b00000010
    MOVWF 0X31
    RRF 0X31,1
    COMF 0X31 
    MOVF 0X31,0
    ANDLW 0b00000001
    MOVWF 0X31
    ;-------------
    ; !C2 = !S2 -> 32
    MOVF 0X25,0
    ANDLW 0b00000100
    MOVWF 0X32
    RRF 0X32,1
    RRF 0X32,1
    COMF 0X32 
    MOVF 0X32,0
    ANDLW 0b00000001
    MOVWF 0X32
    ;--------------
    ; !C3 = !S3 -> 33
    MOVF 0X25,0
    ANDLW 0b00001000
    MOVWF 0X33
    RRF 0X33,1
    RRF 0X33,1
    RRF 0X33,1
    COMF 0X33
    MOVF 0X33,0
    ANDLW 0b00000001
    MOVWF 0X33
    ;-------------------
    ; !C4 = !S4 -> 34
    MOVF 0X25,0
    ANDLW 0b00010000
    MOVWF 0X34
    RRF 0X34,1
    RRF 0X34,1
    RRF 0X34,1
    RRF 0X34,1
    COMF 0X34 
    MOVF 0X34,0
    ANDLW 0b00000001
    MOVWF 0X34
    ;---------------------
    ; !C5 = !S5 -> 35
    MOVF 0X25,0
    ANDLW 0b00100000
    MOVWF 0X35
    RRF 0X35,1
    RRF 0X35,1
    RRF 0X35,1
    RRF 0X35,1
    RRF 0X35,1
    COMF 0X35 
    MOVF 0X35,0
    ANDLW 0b00000001
    MOVWF 0X35
    ; Funcion del Motor 1 M1 " S1'S5 +S1'S4 + S1'S2'S3 "
    CLRF PORTD
    ; Multiplicar 2 registros 
    MOVF 0X31,0
    ANDWF 0X30,0
    MOVWF 0X36 ; S1'S5
    ; --------------
    MOVF 0X31,0
    ANDWF 0X29,0
    MOVWF 0X37 ;--> (S1'S4)
    ; Suma de LOS 2 REGISTROS ANTERIORES 
    MOVF 0X36,0
    IORWF 0X37,0
    MOVWF 0X38 ;--> (S1'S5 +S1'S4)
    ; Multiplicar 3 registros
    MOVF 0X31,0
    ANDWF 0X32,0
    ANDWF 0X28,0
    MOVWF 0X39 ;--> (S1'S2'S3)
    ; Suma de LOS 2 REGISTROS ANTERIORES 	
     MOVF 0X38,0
    IORWF 0X39,0
    MOVWF 0X40 ; --> (S1'S5 +S1'S4 + S1'S2'S3) FUNCION
    ; VEROIFICAR MOTOR 1
    BTFSC 0X40,0	;PARA M1
    BSF PORTD,0		;PARA M1
    ;---------------
    ; Funcion del motor 2 M2 " S2S3' + S1S2' + S3S4'S5' "
    ; M2---------
    MOVF 0X27,0
    ANDWF 0X33,0
    MOVWF 0X41 ;--> (S2S3')
    ;------------
    MOVF 0X26,0
    ANDWF 0X32,0
    MOVWF 0X42 ;--> (S1S2')
    ;SUMA DE LOS 2 ANTERIORES REGISTROS 
    MOVF 0X41,0
    IORWF 0X42,0
    MOVWF 0X43 ;--> (S2S3' + S1S2')
    ; MULTIPLICAR 3 REGISTROS	
    MOVF 0X28,0
    ANDWF 0X34,0
    ANDWF 0X35,0
    MOVWF 0X44 ;--> (S3S4'S5')
    ; SUMA DE LOS 2 ANTERIORES REGISTROS 
    MOVF 0X43,0
    IORWF 0X44,0
    MOVWF 0X45 ;--> (S2S3' + S1S2' + S3S4'S5') FUNCION 
    ; VERIFICAR MOTOR 2
    BTFSC 0X45,0	
    BSF PORTD,1		
    ; FUNCION DEL MOTOR 1 M1R "REVERSA" --> " S1S4' + S2'S3'S4'S5' "
    ; M1R -------
    MOVF 0X26,0
    ANDWF 0X34,0
    MOVWF 0X46 ;--> (S1S4')
    ; ----------
    ; MULTIPLICAR 4 REGISTROS
    MOVF 0X32,0
    ANDWF 0X33,0
    ANDWF 0X34,0
    ANDWF 0X35,0
    MOVWF 0X47 ;--> (S2'S3'S4'S5')
    ; SUMA DE LOS ANTERIORES 2 REGISTROS 
    MOVF 0X46,0
    IORWF 0X47,0
    MOVWF 0X48 ;--> (S1S4' + S2'S3'S4'S5') FUNCION
    ; VERIFICAR MOTOR M1R
    BTFSC 0X48,0	 
    BSF PORTD,2		
    
    ; FUNCION DEL MOTOR 2 M2R "REVERSA --> " S1'S5 + S1'S2'S3'S4' "
    ; M2R -------
    ; MULTIPLICAR 4 REGISTROS
    MOVF 0X31,0
    ANDWF 0X32,0
    ANDWF 0X33 ,0
    ANDWF 0X34,0
    MOVWF 0X49 ;--> (S1'S2'S3'S4')
    ; SUMAR EL REGISTRO 36 --> "S1'S5" CON EL ULTIMO REGISTRO GUARDADO 
    MOVF 0X36,0
    IORWF 0X49,0
    MOVWF 0X50 ;--> (S1'S5 + S1'S2'S3'S4') FUNCION
    ; VERIFICAR MOTOR M2R
    BTFSC 0X50,0	
    BSF PORTD,3		
    ; FUNCIO DEL LED AMARILLO IZQUIERDO  --> " S2S4'S5' + S1S4'S5' "
    ; LED.I ---------
    MOVF 0X27,0
    ANDWF 0X34,0
    ANDWF 0X35,0
    MOVWF 0X51 ;--> (S2S4'S5')	
    ; ------------
    MOVF 0X26,0
    ANDWF 0X34,0
    ANDWF 0X35,0
    MOVWF 0X52 ;--> (S1S4'S5')
    ; SUMAR LOS 2 ULTIMOS REGISTROS 
    MOVF 0X51,0
    IORWF 0X52,0
    MOVWF 0X53 ;--> (S2S4'S5' + S1S4'S5') FUNCION 
    ; VERIFICAR LED.I
    BTFSC 0X53,0
    BSF PORTD,4	
     ;--------------
    ; FUNCION DEL LED ROJO ---> " S1S2S3S4S5 "
    ; LED.C
    MOVF 0X26,0
    ANDWF 0X27,0
    ANDWF 0X28,0
    ANDWF 0X29,0
    ANDWF 0X30,0
    MOVWF 0X54 ; ---> (S1S2S3S4S5) FUNCION 
    BTFSC 0X54,0	
    BSF PORTD,6		
    ;--------------
    ; FUNCION DEL LED AMARILLO DERECHO  ---> " S4S1'S2 + S4'S5S1'S2' "
    ; LED.D 
    MOVF 0X29,0
    ANDWF 0X31,0
    ANDWF 0X27,0
    MOVWF 0X55 ; --> (S4S1'S2)
    ; ------------
    MOVF 0X34,0
    ANDWF 0X30,0
    ANDWF 0X31,0
    ANDWF 0X32,0
    MOVWF 0X56 ; --> (S4'S5S1'S2')
    ;----------------
    ; SUMAR LOS ULTIMOS 2 REGISTROS 
    MOVF 0X55,0
    IORWF 0X56
    MOVWF 0X57 ; --> (S4S1'S2 + S4'S5S1'S2') FUNCION 
    BTFSC 0X57,0
    
    BSF PORTD,5		

    
    GOTO Main
    END resetVec


