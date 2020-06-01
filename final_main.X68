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
                JSR     TEST_RANGE
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
                JSR     TEST_RANGE
                MOVEA.L D5,A3               ; store second input in A3
      
CHECK_ORDER     MOVE.L  A2,D3
                MOVE.L  A3,D4
                CMP.L   D3,D4               ; make sure first input is less than second input
                BLT     RESET_INPUT
                
DISASSEMBLE     MOVE.L  A2, D1              ; loads current address in D1
                JSR     PRINTNUM            ; prints out address                    
                JSR     OPCODE_DECODE       ; decode the opcode
                JSR     PRINTENTER          ; prints a new line
                CMP.L   A3, A2              ; checks if A2 has reached A3
                BLE     DISASSEMBLE         ; if not, loop

STOP            MOVE.B  #9,D0
                TRAP    #15

*--------------------SUBROUTINES------------------    

RESET_INPUT     MOVE.B  #1,D2
                BRA     INVALID            
                
CHECK_LENGTH    MOVEQ   #$0,D4              ; check if input is null   	
                CMP.B   D4,D1               ; D1 stores length
                BEQ     INVALID     	    ; input is null
                CMPI    #$8,D1          	; check if input is longer than a longword
                BGT     INVALID       	    ; input is longer than a longword
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
                CMP.B   #70,D3
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

TEST_RANGE      CLR.L      D4              	; D4 will store test results
                MOVE.L     #$1000,D1     	; D1 stores minimum address
                CMP.L      D1,D5           	; Compare minimum address with input
                BLT        INVALID   	    ; input is too low. 
                MOVE.L     #$00FFFFFE,D1  	; D1 now stores maximum address
                CMP.L      D1,D5          	; compare maximum address with input
                BGT        INVALID          ; input too large
                RTS                        	; input is within range 

* Checks every single possible opcode we could have. Jump table
* Inputs: (A2) which is a pointer to intruction word to be translated
* Outputs: Prints out dissasembled content to console and A2 will increment appropriatley

OPCODE_DECODE   MOVE.W  (A2)+,D0                ; load instruction word from memory
                
CASE_NOP        CMP.W   #$4E71,D0               ; compares to NOP opcode in hex
                BNE     CASE_MOVE               ; checks the next case if not equal
                LEA     MSG_NOP,A5              ; loads string pointer into A5
                JSR     PRINTNULL               ; prints NOP                
                RTS                             ; returns from the subroutine
                
                * if first two bits are 00, next two are not 00
CASE_MOVE       MOVE.W  D0,D1                   ; stores d0 in d1
                AND.W   #$C000, D1              ; applies a bitmask to get 4 bits, want 00XX
                BNE     CASE_MOVEQ              ; if not 0, not a  move instruction
                CMP.W   #$0FFF, D0              ; checks if it exceeds 0FFF
                BLE     CASE_MOVEQ              ; if less than or equal to, not a move 
                MOVE.W  D0,D1                   ; stores d0 in d1
                AND.W   #$01C0, D1              ; appplies a bitmask to get 3 bits, check if its 001
                CMP.W   #$0040, D1              ; confirms if it is a MOVEA
                BEQ     CASE_MOVEA              ; branches to MOVEA, otherwise it is a normal MOVE              
                
                ; get destination
                MOVE.W  #1,D1                   ; specifies that we are looking for dest addressing mode
                JSR     GET_EA                  ; gets effective address, output: D1 = EA
                MOVE.W  D1,D6                   ; saves EA to D6 so it doesn't get overwritten
                MOVE.W  #1,D1                   ; specifies that we are looking for dest Xn
                JSR     GET_XN                  ; Gets Xn, puts it into D1
                MOVE.W  D1,D7                   ; saves Xn to D7 so it doesn't get overwritten

CHECKDEST       LEA     VALIDEA_MOVE_DEST,A5    ; load valid move EA
                MOVE.W  D6,D1                   ; marks down that we are checking EA
                JSR     CHECKEAXN_IFVALID       ; checks if EA is valid
                CMP.W   #2,D1                   ; checks if it is Xn
                BEQ     CHECKMOVE_XN            ; branches to CHECKXn if it is
                CMP.W   #1,D1                   ; Checks if it is invalid
                BEQ     EAMOVE_INVALID          ; branches to CHECKXn if it is
                
                ; get source
EAMOVE_VALID    MOVE.W  #0,D1                   ; specifies that we are looking for source addressing mode
                JSR     GET_EA                  ; gets effective address, output: D1 = EA
                MOVE.W  D1,D4                   ; saves EA to D6 so it doesn't get overwritten
                MOVE.W  #0,D1                   ; specifies that we are looking for source Xn
                JSR     GET_XN                  ; Gets Xn, puts it into D1
                MOVE.W  D1,D5                   ; saves Xn to D7 so it doesn't get overwritten
                
                ; print source
                LEA     MSG_MOVE,A5             ; loads string pointer into A5
                JSR     PRINTNULL               ; prints out MOVE
                JSR     PRINTMOVESIZE           ; prints out the size  
                MOVE.W  D4,D2                   ; Moves D6 (dest effective address) to D2
                MOVE.W  D5,D3                   ; Moves D7 (dest Xn if applicable) to D3 
                JSR     EA_TO_STRING            ; outputs it into a string
                
                ; prints a comma to seperate
                LEA     MSG_COMMA,A5            ; loads string pointer into A5
                JSR     PRINTNULL               ; prints out MOVE
                
                ; print destination
                MOVE.W  D6,D2                   ; Moves D6 (dest effective address) to D2
                MOVE.W  D7,D3                   ; Moves D7 (dest Xn if applicable) to D3 
                JSR     EA_TO_STRING            ; outputs it into a string
                RTS                             ; exits subroutine
                     
                               
EAMOVE_INVALID  JSR     CASE_DATA               ; prints out the data                    

CHECKMOVE_Xn    LEA     VALIDXN_SHORTLONG,A5    ; Loads Xn into A5
                MOVE.W  D7,D1                   ; Loads D2 into D1 to check the Xn
                JSR     CHECKEAXN_IFVALID       ; checks if the Xn is valid, put result in D1
                TST.W   D1                      ; checks if it is valid
                BEQ     EAMOVE_VALID            ; go to EA_VALID to print
                BRA     EAMOVE_INVALID          ; branches to EA_INVALID if not              
                
                RTS                             ; returns from subroutine

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

CASE_RTS        CMP.W   #$4E75,D0           ; compares to NOP opcode in hex
                BNE     CASE_MOVE           ; checks the next case if not equal
                LEA     MSG_NOP,A5          ; loads string pointer into A5
                JSR     PRINTNULL           ; prints NOP                
                RTS                         ; returns from the subroutine
CASE_BRA 

CASE_DATA           
                    RTS               

CASE_EPICFAIL       RTS


* Finds the EA type
* Inputs: D0 = the instruction word, D1 = 0 (source EA), 1 (dest EA)
* Output: Addressing Mode (3 bits, 0 to 7) in D1
GET_EA              MOVEM.L   D2-D3, -(SP)          ; stores D2 and D3
                    TST.W     D1                    ; compares D1 to 0
                    BEQ       SOURCEEA              ; branch to SOURCEEA if it is 0
                    
DESTEA              MOVE.W    #$01C0,D2             ; stores bitmask to get the destination EA into D2
                    MOVE.W    #6,D3                 ; stores the shift amount to D3
                    BRA       FINDTYPEEA            

SOURCEEA            MOVE.W    #$0038,D2             ; stores bitmask to get the source EA into D2
                    MOVE.W    #3,D3                 ; stores the shift amount to D3


FINDTYPEEA          MOVE.W    D0,D1                 ; copies D0 in D1
                    AND.W     D2,D1                 ; applies bitmask to D1
                    LSR.W     D3,D1                 ; shifts D1, moves the result to the end
                    MOVEM.L   (SP)+,D2-D3           ; restores D2 and D3
                    RTS                             ; returns from subroutine    
                    
* Finds Xn type
* Inputs: D0 = the instruction word, D1 = 0 (source Xn), 1 (dest Xn)
* Output: Addressing Mode (3 bits, 0 to 7) in D1
GET_XN              MOVEM.L   D2-D3, -(SP)          ; stores D2 and D3
                    TST.W     D1                    ; compares D1 to 0
                    BEQ       SOURCEXN              ; branch to SOURCEEA if it is 0

DESTXN              MOVE.W    #$0E00,D2             ; stores bitmask to get the destination Xn into D2
                    MOVE.W    #9,D3                 ; stores the shift amount to D3
                    BRA       FINDTYPEXN            ; finds the type of Xn

SOURCEXN            MOVE.W    #$0007,D2             ; applies bitmask to D2
                    MOVE.W    #0,D3                 ; stores the shift amount to D3
                    
FINDTYPEXN          MOVE.W    D0,D1                 ; copies D0 in D1
                    AND.W     D2,D1                 ; applies bitmask to D1
                    LSR.W     D3,D1                 ; shifts D1, moves the result to the end
                    MOVEM.L   (SP)+,D2-D3           ; restores D2 and D3
                    RTS                             ; returns from subroutine                                           
 
                        
* Checks if EA is valid
* Inputs: A5 = Pointer to -1 terminated list of valid addressing modes, D1 = Addressing Mode (3 bit), 
* Outputs: D1 (0 = Valid, 1 = Invalid, 2 = Check Xn)                   
CHECKEAXN_IFVALID  MOVE.L     D2,-(SP)              ; saves D2

CHECKEAMLOOP       MOVE.B     (A5)+,D2              ; load possible EA
                   CMP.B      #-$1,D2               ; compares to -1 to see if loop is over
                   BEQ        INVALIDEA             ; branches to INVALIDEA if its over
                   CMP.B      D2,D1                 ; check addressing mode, check if current one is one of those
                   BEQ        VALIDEA               ; branches to valid EA
                   BRA        CHECKEAMLOOP          ; loops if it isn't valid
                   
INVALIDEA          MOVE.W     #$1,D1                ; marks that it is invalid
                   BRA        CHECKEAEXIT           ; exists the subroutine        
                  
VALIDEA            CMP.B      #Other,D2             ; check if its Xn
                   BEQ        OTHEREA               ; branches to OTHEREA if it is Xn
                   MOVE.W     #$0,D1                ; marks that it is valid
                   BRA        CHECKEAEXIT           ; exits the subroutine

OTHEREA            MOVE.W     #$2,D1                ; marks that it is invalid

CHECKEAEXIT        MOVE.L    (SP)+,D2               ; restores D2
                   RTS                              ; returns from subroutine

* Converts EA and Xn into a string                                
* Inputs: D2 = EA, D3 = Xn, A2 = NEXT INSTRUCTION WORD
* Outputs: Prints out EA and Xn into a string
EA_TO_STRING       MOVEM.L  D0-D1/A5,-(SP)          ; saves D1, D0, and A5
                   CMP.W    #An,D2                  ; checks if it is An
                   BEQ      CASE_AR                 ; branches to CASE_AR if address register
                   
                   CMP.W    #AnIndirect,D2          ; checks if it is (An)
                   BEQ      CASE_ARI                ; branches to CASE_ARI if address register indirect
                   
                   CMP.W    #AnPost,D2              ; checks if it is (An)+
                   BEQ      CASE_ARIPOST            ; branches to CASE_ARIPOST if address register indirect post increment
                   
                   CMP.W    #AnPre,D2               ; checks if it is -(An)
                   BEQ      CASE_ARIPRE             ; branches to CASE_ARIPRE if address register indirect pre increment
                   
                   CMP.W    #Other,D2               ; checks if it is other (has an Xn/D3)
                   BEQ      CASE_OTHER              ; branches to CASE_AR if address register
                   ; otherwise assumes D2 = #Dn which means its a data register                   

* data register, Dn
CASE_DR            LEA      MSG_DR,A5               ; Loads D into A5
                   JSR      PRINTNULL               ; Prints D
                   MOVE.W   D3, D1                  ; Loads D3 (the Xn) into D1 for printing 
                   JSR      PRINTNUM                ; Prints the Xn
                   BRA      EA_TO_STRING_EXIT       ; exits           


* address register
CASE_AR            LEA      MSG_AR,A5               ; Loads A into A5
                   JSR      PRINTNULL               ; Prints A
                   MOVE.W   D3, D1                  ; Loads D3 (the Xn) into D1 for printing 
                   JSR      PRINTNUM                ; Prints the Xn
                   BRA      EA_TO_STRING_EXIT       ; exits

* address register indirect
CASE_ARI           LEA      MSG_LB,A5               ; Loads ( into A5
                   JSR      PRINTNULL               ; Prints (
                   LEA      MSG_AR,A5               ; Loads A into A5
                   JSR      PRINTNULL               ; Prints A
                   MOVE.W   D3, D1                  ; Loads D3 (the Xn) into D1 for printing 
                   JSR      PRINTNUM                ; Prints the Xn
                   LEA      MSG_RB,A5               ; Loads ) into A5
                   JSR      PRINTNULL               ; Prints )
                   BRA      EA_TO_STRING_EXIT       ; exits

* address register indirect post increment
CASE_ARIPOST       LEA      MSG_LB,A5               ; Loads ( into A5
                   JSR      PRINTNULL               ; Prints (
                   LEA      MSG_AR,A5               ; Loads A into A5
                   JSR      PRINTNULL               ; Prints A
                   MOVE.W   D3, D1                  ; Loads D3 (the Xn) into D1 for printing 
                   JSR      PRINTNUM                ; Prints the Xn
                   LEA      MSG_RB,A5               ; Loads ) into A5
                   JSR      PRINTNULL               ; Prints )
                   LEA      MSG_PLUS,A5             ; Loads + into A5
                   JSR      PRINTNULL               ; Prints +
                   BRA      EA_TO_STRING_EXIT       ; exits


* address register indirect pre increment
CASE_ARIPRE        LEA      MSG_MINUS,A5            ; Loads - into A5
                   JSR      PRINTNULL               ; Prints -
                   LEA      MSG_LB,A5               ; Loads ( into A5
                   JSR      PRINTNULL               ; Prints (
                   LEA      MSG_AR,A5               ; Loads A into A5
                   JSR      PRINTNULL               ; Prints A
                   MOVE.W   D3, D1                  ; Loads D3 (the Xn) into D1 for printing 
                   JSR      PRINTNUM                ; Prints the Xn
                   LEA      MSG_RB,A5               ; Loads ) into A5
                   JSR      PRINTNULL               ; Prints )
                   BRA      EA_TO_STRING_EXIT       ; exits

* other (long, short, immediate) with Xn
CASE_OTHER         MOVE     (A2)+, D0               ; Moves next instruction word into D1 since A2 is auxilliary instruction word 
                   CMP.W    #ABSShort,D3            ; checks if it is a word
                   BEQ      CASE_WORD               ; branches to CASE_WORD if is a short
                   
                   CMP.W    #ABSLong,D3             ; checks if it is (An)
                   BEQ      CASE_LONG               ; branches to CASE_LONG if is a long

* NOTE DELETE LATER: update to print num as HEX and add NEGATIVE NUMBER CHECK
* immediate
CASE_IMMEDIATE     LEA      MSG_POUND,A5            ; Loads # into A5
                   JSR      PRINTNULL               ; Prints #  
                   * uncomment after converting to hex 
                   *LEA      MSG_HEX,A5              ; Loads $ into A5
                   *JSR      PRINTNULL               ; Prints $
                   MOVE.W   D0, D1                  ; moves instruction word into d1
                   JSR      PRINTNUM 
                   BRA      EA_TO_STRING_EXIT       ; exits subroutine                  
                   
; DELETE LATER: convert tp hex andwrite code to make them print out a total of 4 and 8 characters, add 0's                      

* word address
CASE_WORD          
                   *LEA      MSG_HEX,A5              ; Loads $ into A5
                   *JSR      PRINTNULL               ; Prints $
                   MOVE.W   D0, D1                  ; moves instruction word into d1
                   MOVE.W   #0, D4                  ; moves length size (word) into d4
                   JSR      PRINTSHORTLONGNUM       ; reformats the number to the proper length and prints out the number
                   BRA      EA_TO_STRING_EXIT       ; exits subroutine

* long address 
CASE_LONG          
                   *LEA      MSG_HEX,A5              ; Loads $ into A5
                   *JSR      PRINTNULL               ; Prints $
                   MOVE.W   D0, D1                  ; moves instruction word into d1
                   MOVE.W   #1, D4                  ; moves length size (long) into d4
                   JSR      PRINTSHORTLONGNUM       ; reformats the number to the proper length and prints out the number


* exits subroutine
EA_TO_STRING_EXIT   MOVEM.L  (SP)+,D0-D1/A5          ; restoers D1, D0, and A5
                    RTS                              ; returns from subroutine

* DELETE LATER: sorry the formatting is weird here we can fix it later or whenever you want  im just lazy for now

* Prints out the content of D1
* Input: number in D1 to be printed
* Output: contents of D1 printed
PRINTNUM         MOVEM.L     D0-D1, -(SP)        ; saves D0 and D1
                 MOVE.B      #3,D0               ; prints D1
                 TRAP        #15                 ; is trap task 3
            
                 MOVEM.L     (SP)+,D0-D1         ; returns D0 and D1
                 RTS                             ; returns from subroutine
                 
* DELETE LATER: THIS IS A  WIP AND DOESNT ACHIEVE PROPER FUNCTIONALITY YET
                 
* Prints out the content of D1 and formats it to have the length of WORD or a LONG
* Input: number in D1 to be printed, D4 = length (0 = WORD, 1 = LONG)
* Output: contents of D1 printed
PRINTSHORTLONGNUM         MOVEM.L     D1-D2, -(SP)        ; saves D0 and D1
                          MOVE.B      #3,D0               ; prints D1
                          TRAP        #15                 ; is trap task 3
                          MOVEM.L     (SP)+,D0-D1         ; returns D0 and D1
                RTS                                       ; returns from subroutine

* Converts decimal number to hex format
*DECTOHEX                  MOVE                
             
            
* Prints contents of things between a range
* input: A5, A6 (the range)
* output: prints memory contents from A5 to A6 as strings   
PRINTRANGE      MOVEM.L     D0-D1/A1, -(SP)  ; saves D0-D1 and A1
                MOVEA.L     A5, A1           ; loads A5 into A1
                SUB.L       A5, A6           ; subtracts A5 to A6, gets us n (number of characters)
                MOVE.W      A6, D1           ; move n into D1
                MOVE.B      #1, D0           ; display n characters of string at A1
                TRAP        #15              ; is trap task 1
                MOVEM.L     (SP)+, D0-D1/A1  ; restores D0-D1, A1
                RTS                          ; returns
    
* Prints null terminated string
* input: string pointed to by A5
* output: prints out the null terminated string
PRINTNULL       MOVEM.L     D0/A1, -(SP)    ; saves D0-D1 and A1
                MOVE.L      A5,A1           ; loads A5 into A1
                MOVE.B      #14,D0          ; prints null terminated string
                TRAP        #15             ; is trap task 10
                MOVEM.L     (SP)+,D0/A1     ; saves D0-D1 and A1
                RTS                         ; returns from subroutine
                
PRINTENTER      MOVE.L      A5, -(SP)       ; saves A5
                LEA         NEW_LINE,A5     ; Prints null
                JSR         PRINTNULL       ; prints the new line
                MOVE.L      (SP)+,A5        ; returns A5
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

CR                              EQU     $0D
LF                              EQU     $0A 
TAB                             EQU     $09  

* Addressing Modes
Dn                              EQU     0
An                              EQU     1
AnIndirect                      EQU     2
AnPost                          EQU     3
AnPre                           EQU     4
Other                           EQU     7           ; short, long, immediate

* Xn
ABSShort                        EQU     0
ABSLong                         EQU     1
XnImmediate                     EQU     4

* Valid Addressing Modes
VALIDEA_ALL                     DC.B    Dn,An,AnIndirect,AnPost,AnPre,Other,-1          
; MOVE (source),MOVEA, ADD, ADDA, ADDQ, and SUB
VALIDEA_MOVE_DEST               DC.B    Dn,AnIndirect,AnPost,AnPre,Other,-1
VALIDEA_MOVEQ                   DC.B    Dn,AnIndirect,AnPost,AnPre,Other,-1
VALIDEA_MOVEM                   DC.B    AnIndirect,AnPre,Other,-1
VALIDEA_MOVEM_MEMTOREG          DC.B    AnIndirect,AnPost,Other,-1
VALIDEA_ADDSUB_DESTOPERAND      DC.B    AnIndirect,AnPost,AnPre,Other,-1
VALIDEA_MULSDIVU                DC.B    Dn,AnIndirect,AnPost,AnPre,Other,-1
VALIDEA_LEA                     DC.B    An,Other,-1
VALIDEA_ANDORNOT                DC.B    Dn,AnIndirect,AnPost,AnPre,Other,-1
VALIDEA_ANDOR_DESTOPERAND       DC.B    AnIndirect,AnPost,AnPre,Other,-1
VALIDEA_SHIFT                   DC.B    AnIndirect,AnPost,AnPre,Other,-1                ; LSL, LSR, ASL, ASR
VALIDEA_JSR                     DC.B    AnIndirect, Other,-1

* Valid Xn
VALIDXN_ALL                     DC.B    ABSShort,ABSLong,XnImmediate,-1                 
; MOVE (source), MOVEA, ADD, ADDA, SUB, MULS, DIVU, AND, OR, 
VALIDXN_SHORTLONG               DC.B    ABSShort,ABSLong,-1                             
; MOVE (dest), MOVEM, ADD (destination operand), ADDQ, SUB (destination operand), LEA, AND (destination operand),
; OR (destination operand), NOT, LSL/R, ASL/R, JSR


* Starting messages
WELCOME                         DC.B    'Welcome to Team Big Blue Disassembler',CR,LF
                                DC.B    'Format: 8 digit address in hexadecimal format. Letters must be capital case.',CR,LF,0
STARTING                        DC.B    'Please enter a starting location in the above format',CR,LF,0
ENDING                          DC.B    'Please enter an ending location in the above format',CR,LF,0
BAD_INPUT                       DC.B    'Invalid input. Please try again',CR,LF,0
NEW_LINE                        DC.B    CR,LF,0

* Opcode Messages
MSG_NOP                         DC.B    TAB,'NOP',0
MSG_MOVE                        DC.B    TAB,'MOVE',0  
MSG_MOVEA                       DC.B    TAB,'MOVEA',0
MSG_MOVEQ                       DC.B    TAB,'MOVEQ',0
MSG_MOVEM                       DC.B    TAB,'MOVEM',0
MSG_ADD                         DC.B    TAB,'ADD',0
MSG_ADDA                        DC.B    TAB,'ADDA',0
MSG_ADDQ                        DC.B    TAB,'ADDQ',0
MSG_SUB                         DC.B    TAB,'SUB',0
MSG_MULS                        DC.B    TAB,'MULS',0
MSG_DIVU                        DC.B    TAB,'DIVU',0
MSG_LEA                         DC.B    TAB,'LEA',0
MSG_AND                         DC.B    TAB,'AND',0
MSG_OR                          DC.B    TAB,'OR',0
MSG_NOT                         DC.B    TAB,'NOT',0
MSG_LSL                         DC.B    TAB,'LSL',0
MSG_LSR                         DC.B    TAB,'LSR',0
MSG_ASL                         DC.B    TAB,'ASL',0
MSG_ASR                         DC.B    TAB,'ASR',0
MSG_BCC                         DC.B    TAB,'BCC',0
MSG_BCS                         DC.B    TAB,'BCS',0
MSG_BEQ                         DC.B    TAB,'BEQ',0
MSG_BNE                         DC.B    TAB,'BNE',0
MSG_BGE                         DC.B    TAB,'BGE',0
MSG_BGT                         DC.B    TAB,'BGT',0
MSG_BHI                         DC.B    TAB,'BHI',0
MSG_BLE                         DC.B    TAB,'BLE',0
MSG_BLS                         DC.B    TAB,'BLS',0
MSG_BLT                         DC.B    TAB,'BLT',0
MSG_BMI                         DC.B    TAB,'BMI',0
MSG_BPL                         DC.B    TAB,'BPL',0
MSG_BVC                         DC.B    TAB,'BVC',0
MSG_BVS                         DC.B    TAB,'BVS',0
MSG_JSR                         DC.B    TAB,'JSR',0
MSG_RTS                         DC.B    TAB,'RTS',0
MSG_BRA                         DC.B    TAB,'BRA',0

* Effective Addresses Messages
MSG_DR                          DC.B    'D',0
MSG_AR                          DC.B    'A',0
MSG_LB                          DC.B    '(',0       ; left bracket, NEVER PRINTED WITHOUT RB
MSG_RB                          DC.B    ')',0       ; right bracket, ALWAYS FOLLOWS AFTER LB
MSG_PLUS                        DC.B    '+',0
MSG_MINUS                       DC.B    '-',0
MSG_POUND                       DC.B    '#',0 
MSG_HEX                         DC.B    '$',0 
MSG_COMMA                       DC.B    ', ',0 

* Size Messages
MSG_B                           DC.B    '.B',TAB,TAB,TAB,0
MSG_W                           DC.B    '.W',TAB,TAB,TAB,0
MSG_L                           DC.B    '.L',TAB,TAB,TAB,0

            END     START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
