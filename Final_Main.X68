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
                
*DISASSEMBLE     MOVE.L  A2, D1              ; loads current address in D1
*                JSR     PRINTNUM            ; prints out address                    
*                JSR     OPCODE_DECODE       ; decode the opcode
*                JSR     PRINTENTER          ; prints a new line
*                CMP.L   A2, A3              ; checks if A2 has reached A3
*                BLE     DISASSEMBLE         ; if not, loop

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
                BRA     CONVERT             ; continue loop for remaining chars
                
RETURN          RTS
                
INVALID         LEA     BAD_INPUT,A1        ; output invalid message
                MOVE.B  #14,D0
                TRAP    #15
                CMP     #1,D2
                BEQ     INPUT1
                BRA     INPUT2 

* Checks every single possible opcode we could have. Jump table
* Inputs: (A2) which is a pointer to intruction word to be translated
* Outputs: Prints out dissasembled content to console and A2 will increment appropriatley

OPCODE_DECODE   MOVE.W  (A2)+,D0            ; load instruction word from memory
                
CASE_NOP        CMP.W   #$4E71,D0           ; compares to NOP opcode in hex
                BNE     CASE_MOVE           ; checks the next case if not equal
                LEA     MSG_NOP,A5          ; loads string pointer into A5
                JSR     PRINTNULL           ; prints NOP                
                RTS                         ; returns from the subroutine
                
                * if first two bits are 00, next two are not 00
CASE_MOVE       MOVE.W  D0,D1               ; stores d0 in d1
                AND.W   #$C000, D1          ; applies a bitmask to get 4 bits, want 00XX
                BNE     CASE_MOVEQ          ; if not 0, not a  move instruction
                CMP.W   #$0FFF, D0          ; checks if it exceeds 0FFF
                BLE     CASE_MOVEQ          ; if less than or equal to, not a move 
                MOVE.W  D0,D1               ; stores d0 in d1
                AND.W   #$01C0, D1          ; appplies a bitmask to get 3 bits, check if its 001
                CMP.W   #$0040, D1          ; confirms if it is a MOVEA
                BEQ     CASE_MOVEA          ; branches to MOVEA, otherwise it is a normal MOVE
                LEA     MSG_MOVE,A5         ; loads string pointer into A5
                JSR     PRINTNULL           ; prints out MOVE
                JSR     PRINTMOVESIZE       ; prints out the size                
                * OTHER STUFF PROBABLY
                RTS

CASE_MOVEA      

CASE_MOVEM

CASE_MOVEQ

CASE_ADD

CASE_ADDA

CASE_ADDQ

CASE_SUB

CASE_MULS

CASE_DIVU

CASE_LEA

CASE_AND

CASE_OR

CASE_NOT

CASE_LSL

CASE_LSR

CASE_ASL

CASE_ASR

CASE_BCC

CASE_JSR

CASE_RTS

CASE_BRA                


* 
* 
GET_EA

* data register
CASE_DR

* address register
CASE_AR

* address register indirect
CASE_ARI

* immediate data
CASE_ID

* address register indirect post increment
CASE_ARIPOST

* address register indirect pre increment
CASE_ARIPRE

* long address
CASE_LONG

* word address
CASE_WORD


EA_TO_STRING                


* DELETE LATER: sorry the formatting is weird here we can fix it later or whenever you want  im just lazy for now

* Prints out the content of D1
* Input: number in D1 to be printed
* Output: contents of D1 printed
PRINTNUM         MOVEM.L     D0-D1, -(SP)        ; saves D0 and D1
                 MOVE.B      #3,D0               ; prints D1
                 TRAP        #15                 ; is trap task 3
            
                 MOVEM.L     (SP)+,D0-D1        ; returns D0 and D1
                RTS                             ; returns from subroutune
            
* Prints contents of things between a range
* input: A5, A6 (the range)
* output: prints memory contents from A5 to A6 as strings   
PRINTRANGE      MOVEM.L     D0-D1/A1, -(SP)  ; saves D0-D1 and A1
                MOVEA.L     A5, A1           ; loads A5 into A1
                SUB.L       A5, A6           ; subtracts A5 to A6, gets us n (number of characters)
                MOVE.W      A6, D1           ; move n into D1
                MOVE.B      #1, D0           ; display n characyers of string at A1
                TRAP        #15              ; is trap task 1
                MOVEM.L     (SP)+, D0-D1/A1  ; restores D0-D1, A1
                RTS                          ; returns
    
* Prints null terminated string
* input: string pointed to by A5
* output: prints out the null terminated string
PRINTNULL       MOVEM.L     D0/A1, -(SP)    ; saves D0-D1 and A1
                MOVE.L      A5,A1           ; loads A5 into A1
                MOVE.B      #10,D0          ; prints null terminated string
                TRAP        #15            ; is trap task 10
                MOVEM.L     (SP)+,D0/A1    ; saves D0-D1 and A1
                RTS                        ; returns
                
PRINTENTER      MOVE.L      A5, -(SP)      ; saves A5
                LEA         NEW_LINE,A5    ; Prints null
                JSR         PRINTNULL      ; prints the new line
                MOVE.L      (SP)+,A5       ; returns A5
                RTS

* Prints the size of the MOVE or MOVEA operation  
* input: D0
* output: prints out the size of a MOVE or MOVEA operation        
PRINTMOVESIZE   MOVEM.L D0/A5,-(SP)         ; saves D0 and A5
                MOVE.W  D0,D1               ; stores d0 in d1
                AND.W   #$3000,D0           ; gets the size
                CMP.W   #$2000,D0           ; checks if is long
                BEQ     MOVE_LONG
                CMP.W   #$3000,D0           ; checks if is word
                BEQ     MOVE_WORD
                
MOVE_BYTE       LEA     MSG_B,A5            ; loads string pointer into a1
                BRA     FINISHMOVE          ; branches to FINISHMOVE

MOVE_WORD       LEA     MSG_W,A5            ; loads string pointer into a1
                BRA     FINISHMOVE          ; branches to FINISHMOVE

MOVE_LONG       LEA     MSG_L,A5            ; loads string pointer into a1         
                
FINISHMOVE      JSR     PRINTNULL           ; prints out the size
                MOVEM.L (SP)+,D0/A5         ; restores D0 and A5
                RTS
                
    SIMHALT             ; halt simulator

* Put variables and constants here

CR          EQU     $0D
LF          EQU     $0A   
WELCOME     DC.B    'Welcome to Team Big Blue Disassembler',CR,LF
            DC.B    'Format: 8 digit address in hexadecimal format. Letters must be capital case.',CR,LF,0
STARTING    DC.B    'Please enter a starting location in the above format',CR,LF,0
ENDING      DC.B    'Please enter an ending location in the above format',CR,LF,0
BAD_INPUT   DC.B    'Invalid input. Please try again',CR,LF,0
NEW_LINE    DC.B    CR,LF,0

* Opcode Messages
MSG_NOP     DC.B    'NOP',0
MSG_MOVE    DC.B    'MOVE',0  
MSG_MOVEA   DC.B    'MOVEA',0
MSG_MOVEQ   DC.B    'MOVEQ',0
MSG_MOVEM   DC.B    'MOVEM',0
MSG_ADD     DC.B    'ADD',0
MSG_ADDA    DC.B    'ADDA',0
MSG_ADDQ    DC.B    'ADDQ',0
MSG_SUB     DC.B    'SUB',0
MSG_MULS    DC.B    'MULS',0
MSG_DIVU    DC.B    'DIVU',0
MSG_LEA     DC.B    'LEA',0
MSG_AND     DC.B    'AND',0
MSG_OR      DC.B    'OR',0
MSG_NOT     DC.B    'NOT',0
MSG_LSL     DC.B    'LSL',0
MSG_LSR     DC.B    'LSR',0
MSG_ASL     DC.B    'ASL',0
MSG_ASR     DC.B    'ASR',0
MSG_BCC     DC.B    'BCC',0
MSG_BCS     DC.B    'BCS',0
MSG_BEQ     DC.B    'BEQ',0
MSG_BNE     DC.B    'BNE',0
MSG_BGE     DC.B    'BGE',0
MSG_BGT     DC.B    'BGT',0
MSG_BHI     DC.B    'BHI',0
MSG_BLE     DC.B    'BLE',0
MSG_BLS     DC.B    'BLS',0
MSG_BLT     DC.B    'BLT',0
MSG_BMI     DC.B    'BMI',0
MSG_BPL     DC.B    'BPL',0
MSG_BVC     DC.B    'BVC',0
MSG_BVS     DC.B    'BVS',0
MSG_JSR     DC.B    'JSR',0
MSG_RTS     DC.B    'RTS',0
MSG_BRA     DC.B    'BRA',0

* Effective Addresses Messages
MSG_DR      DC.B    'D',0
MSG_AR      DC.B    'A',0
MSG_RB      DC.B    '(',0       ; right bracket
MSG_LB      DC.B    ')',0       ; left bracket
MSG_PLUS    DC.B    '+',0
MSG_MINUS   DC.B    '-',0

* Size Messages
MSG_B       DC.B    '.B',0
MSG_W       DC.B    '.W',0
MSG_L       DC.B    '.L',0

* Effective address messages

            END     START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
