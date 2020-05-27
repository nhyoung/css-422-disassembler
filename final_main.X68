*-----------------------------------------------------------
* Title      : Final Project
* Written by : Nick Young, Audrey Nguyen, Khiam Rehman
* Date       : 5/1/20
* Description: Final Project
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

                LEA     WELCOME,A1          ; output welcome startup message
                MOVE.B  #14,D0
                TRAP    #15
            
INPUT1          LEA     STARTING,A1         ; output starting address message
                MOVE.B  #14,D0
                TRAP    #15
            
                MOVE.B  #2,D0                   
                TRAP    #15                 ; take input from user
                MOVE.B  #1,D2               ; D2 stores if starting or ending address

                JSR     CHECK_LENGTH
                MOVE.B  #7,D6               ; D6 stores counter               
                JSR     CONVERT
                MOVEA.L D5,A2               ; store first input in A2
  
INPUT2          MOVE.B  #2,D2
                LEA     ENDING,A1           ; output ending address message
                MOVE.B  #14,D0
                TRAP    #15         

                MOVE.B  #2,D0
                TRAP    #15
                JSR     CHECK_LENGTH
                MOVE.B  #7,D6               ; D6 stores counter
                CLR.L   D5
                JSR     CONVERT
                MOVEA.L D5,A3               ; store second input in A3
                
STOP            MOVE.B  #9,D0
                TRAP    #15

*--------------------SUBROUTINES------------------                
                
CHECK_LENGTH    MOVEQ      #$0,D4           ; check if input is null   	
                CMP.B      D4,D1           	; D1 stores length
                BEQ        INVALID     	    ; input is null
                CMPI       #$8,D1          	; check if input is longer than a longword
                BGT        INVALID       	; input is longer than a longword
                RTS
                            
CONVERT         CLR.L   D3
                CLR.L   D4
                MOVE.B  (A1)+,D3            ; D3 stores current char
                CMP.B   #57,D3
                BGT     NOTNUMBER
                
                CMP.B   #47,D3
                BGT     ISNUMBER
                
ISNUMBER        ADD.B   #-48,D3             ; current char is number
                BRA     CONCAT
            
NOTNUMBER       CMP.B   #65,D3
                BLT     INVALID
                CMP.B   #90,D3
                BGT     INVALID  
                ADD.B   #-55,D3             ; is letter             
                BRA     CONCAT
            
CONCAT          CMP.B   #0,D6               ; D6 stores counter
                BLT     RETURN
                MOVE.B  D6,D4               ; D4 stores modified counter 
                LSL.B   #2,D4               ; multiply counter by 4 to scale hex to binary, 8 -> 32, 7 -> 28, etc.
                LSL.L   D4,D3               ; moves current char to correct position  
                ADD.L   D3,D5               ; D5 stores converted input so far
                ADD.B   #-1,D6  
                BRA     CONVERT            ; continue loop for remaining chars
                
RETURN          RTS
                
INVALID         LEA     BAD_INPUT,A1          ; output invalid message
                MOVE.B  #14,D0
                TRAP    #15
                CMP     #1,D2
                BEQ     INPUT1
                BRA     INPUT2                 

    SIMHALT             ; halt simulator

* Put variables and constants here

CR          EQU     $0D
LF          EQU     $0A   
WELCOME     DC.B    'Welcome to Team Big Blue Disassembler',CR,LF
            DC.B    'Format: 8 digit address in hexadecimal format. Letters must be capital case.',CR,LF,0
STARTING    DC.B    'Please enter a starting location in the above format',CR,LF,0
ENDING      DC.B    'Please enter an ending location in the above format',CR,LF,0
BAD_INPUT   DC.B    'Invalid input. Please try again',CR,LF,0

            END     START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
