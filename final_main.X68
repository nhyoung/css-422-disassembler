*-----------------------------------------------------------
* Title      : Final Project
* Written by : Nick Young, Audrey Nguyen, Khiam Rehman
* Date       : 5/1/20
* Description: Final Project
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

                LEA     STARTUP,A1          ; output startup message
                MOVE.B  #14,D0
                TRAP    #15
            
INPUT1          LEA     STARTING,A1         ; output starting address message
                MOVE.B  #14,D0
                TRAP    #15
            
                MOVE.B  #2,D0                   
                TRAP    #15
                MOVEA.W A1,A2               ; move to A2
                MOVE.B  #7,D2               ; D2 stores counter

                            
CONVERT1        CLR.L   D3
                CLR.L   D4
                MOVE.B  (A2)+,D3            ; D3 stores current char
                CMP.B   #57,D3
                BGT     NOTNUMBER1
                
                CMP.B   #47,D3
                BGT     ISNUMBER1
                
ISNUMBER1       ADD.B   #-48,D3             ; current char is number
                BRA     CONCAT1
            
NOTNUMBER1      CMP.B   #65,D3
                BLT     INVALID1
                CMP.B   #90,D3
                BGT     INVALID1  
                ADD.B   #-55,D3             ; is letter             
                BRA     CONCAT1
                
INVALID1        LEA     INVALID,A1          ; output invalid message
                MOVE.B  #14,D0
                TRAP    #15
                BRA     INPUT1 
            
CONCAT1         CMP.B   #0,D2               ; D2 stores counter
                BLT     INPUT2
                MOVE.B  D2,D4               ; D4 stores modified counter 
                LSL.B   #2,D4               ; multiply counter by 4 to scale hex to binary, 8 -> 32, 7 -> 28, etc.
                LSL.L   D4,D3               ; moves current char to correct position  
                ADD.L   D3,D5               ; D5 stores converted input so far
                ADD.B   #-1,D2  
                BRA     CONVERT1            ; continue loop for remaining chars

INPUT2          LEA     ENDING,A1           ; output ending address message
                MOVE.B  #14,D0
                TRAP    #15         

                MOVE.B  #2,D0
                TRAP    #15
                MOVEA.W A1,A3               ; move to A3
                MOVE.B  #7,D7               ; D2 stores counter

CONVERT2        CLR.L   D3
                CLR.L   D4
                MOVE.B  (A3)+,D3            ; D3 stores current char
                CMP.B   #57,D3
                BGT     NOTNUMBER2
                
                CMP.B   #47,D3
                BGT     ISNUMBER2
                
ISNUMBER2       ADD.B   #-48,D3             ; current char is number
                BRA     CONCAT2
            
NOTNUMBER2      CMP.B   #65,D3
                BLT     INVALID2
                CMP.B   #90,D3
                BGT     INVALID2  
                ADD.B   #-55,D3             ; is letter             
                BRA     CONCAT2
                
INVALID2        LEA     INVALID,A1          ; output invalid message
                MOVE.B  #14,D0
                TRAP    #15
                BRA     INPUT2 
            
CONCAT2         CMP.B   #0,D7               ; D7 stores counter
                BLT     STOP
                MOVE.B  D7,D4               ; D4 stores modified counter 
                LSL.B   #2,D4               ; multiply counter by 4 to scale hex to binary, 8 -> 32, 7 -> 28, etc.
                LSL.L   D4,D3               ; moves current char to correct position  
                ADD.L   D3,D6               ; D6 stores converted input so far
                ADD.B   #-1,D7  
                BRA     CONVERT2            ; continue loop for remaining chars                

STOP            MOVE.B  #9,D0
                TRAP    #15

    SIMHALT             ; halt simulator

* Put variables and constants here

CR          EQU     $0D
LF          EQU     $0A   
STARTUP     DC.B    'Welcome to Team Big Blue Disassembler',CR,LF
            DC.B    'Format: 8 digit address in hexadecimal format',CR,LF,0
STARTING    DC.B    'Please enter a starting location in the above format',CR,LF,0
ENDING      DC.B    'Please enter an ending location in the above format',CR,LF,0
INVALID     DC.B    'Invalid input. Please try again',CR,LF,0

            END     START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
