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
            
            LEA     STARTING,A1         ; output starting address message
            MOVE.B  #14,D0
            TRAP    #15
            
            MOVE.B  #2,D0               
            TRAP    #15
            MOVEA.W A1,A2               ; move to A2
            
            LEA     ENDING,A1           ; output ending address message
            MOVE.B  #14,D0
            TRAP    #15         

            MOVE.B  #2,D0
            TRAP    #15
            MOVEA.W A1,A3               ; move to A3


    SIMHALT             ; halt simulator

* Put variables and constants here

CR          EQU     $0D
LF          EQU     $0A   
STARTUP     DC.B    'Welcome to Team Big Blue Disassembler',CR,LF
            DC.B    'Format: 4 digit address in hexadecimal format',CR,LF,0
STARTING    DC.B    'Please enter a starting location in the above format',CR,LF,0
ENDING      DC.B    'Please enter an ending location in the above format',CR,LF,0

            END     START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
