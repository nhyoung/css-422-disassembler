*-----------------------------------------------------------
* Title      : Final Project
* Written by : Nick Young, Audrey Nguyen, Khiam Rehman
* Date       : 6/5/20
* Description: Final Project
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

                LEA     WELCOME,A1          ; output welcome startup message
                MOVE.B  #14,D0
                TRAP    #15
            
INPUT1          MOVE.L  #$0000000, A1       ;clear A1
                LEA     STARTING,A1         ; output starting address message
                MOVE.B  #14,D0
                TRAP    #15
            
                MOVE.L  #$0000000, A1       ;clear A1
                MOVE.B  #2,D0                   
                TRAP    #15                 ; take input from user
                MOVE.B  #1,D2               ; D2 stores if starting or ending address

                JSR     CHECK_LENGTH
                MOVE.B  #7,D6               ; D6 stores counter               
                JSR     CONVERT
                JSR     TEST_RANGE
                JSR     CHECK_ODD
                MOVE.L  D5,STARTING_ADDRESS
                MOVEA.L D5,A2               ; store first input in A2
  
INPUT2          MOVE.B  #2,D2
                MOVE.L  #$0000000, A1       ;clear A1
                LEA     ENDING,A1           ; output ending address message
                MOVE.B  #14,D0
                TRAP    #15         

                MOVE.L  #$0000000, A1       ;clear A1
                MOVE.B  #2,D0
                TRAP    #15
                
                JSR     CHECK_LENGTH
                MOVE.B  #7,D6               ; D6 stores counter
                CLR.L   D5
                JSR     CONVERT
                JSR     TEST_RANGE
                JSR     CHECK_ODD
                MOVE.L  D5,ENDING_ADDRESS
                MOVEA.L D5,A3               ; store second input in A3
      
CHECK_ORDER     MOVE.L  A2,D3
                MOVE.L  A3,D4
                CMP.L   D3,D4               ; make sure first input is less than second input
                BLT     RESET_INPUT
                               
DISASSEMBLE     MOVE.L  A2,D1               ; loads current address in D1
                MOVE.L  #1,D4               ; tells subroutine we want to make the address print as a long
                JSR     PRINTSHORTLONGNUM   ; prints out address                    
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
                
INVALID         MOVEA.L #$0000000, A1       ; clear A1
                LEA     BAD_INPUT,A1        ; output invalid message
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
           
CHECK_ODD       BTST       #0,D5            ; check if input is odd
                BNE        INVALID
                RTS


* Checks every single possible opcode we could have. Jump table
* Inputs: (A2) which is a pointer to intruction word to be translated
* Outputs: Prints out dissasembled content to console and A2 will increment appropriatley

OPCODE_DECODE   MOVE.W  (A2)+,D0                ; load instruction word from memory, store in D0
                
CASE_NOP        CMP.W   #$4E71,D0               ; compares to NOP opcode in hex
                BNE     CASE_MOVE               ; checks the next case if not equal
                LEA     MSG_NOP,A5              ; loads string pointer into A5
                JSR     PRINTNULL               ; prints NOP                
                RTS                             ; returns from the subroutine
                
                * if first two bits are 00, next two are not 00
CASE_MOVE       MOVE.W  D0,D1                   ; stores d0 in d1
                AND.W   #$C000, D1              ; applies a bitmask to get 4 bits, want 00XX
                BNE     CASE_MOVEM              ; if not 0, not a  move instruction
                CMP.W   #$0FFF, D0              ; checks if it exceeds 0FFF
                BLE     CASE_MOVEM              ; if less than or equal to, not a move             
                
                ; Check source
                LEA     VALIDEA_ALL,A5           ; Loads valid EA types in A5
                LEA     VALIDXN_ALL,A6           ; Loads valid Xn types in A6
                MOVE.W  #0,D7                    ; Marks D7 as "Source" for CHECKGETEAXN
                JSR     CHECKGET_EAXN            ; getting if its valid (D1), EA (D2), and Xn (D3)
                CMP.W   #1,D1                    ; checks if invalid
                BEQ     CASE_DATA                ; branches to CASE_DATA if invalid
                MOVE.W  D2,D4                    ; Moves D2 (source effective address) to D4
                MOVE.W  D3,D5                    ; Moves D3 (source Xn if applicable) to D5
                
                ; Check destination
                LEA     VALIDEA_ALL,A5           ; Loads valid EA types in A5
                LEA     VALIDXN_SHORTLONG,A6     ; Loads valid Xn types in A6
                MOVE.W  #1,D7                    ; Marks D7 as "Source" for CHECKGETEAXN
                JSR     CHECKGET_EAXN            ; getting if its valid (D1), EA (D2), and Xn (D3)
                CMP.W   #1,D1                    ; checks if invalid
                BEQ     CASE_DATA                ; branches to CASE_DATA if invalid
                MOVE.W  D2,D6                    ; Moves D2 (source effective address) to D6
                MOVE.W  D3,D7                    ; Moves D3 (source Xn if applicable) to D7
                
                ; Checking if it is MOVEA
                MOVE.W  D0,D1                    ; stores d0 in d1
                AND.W   #$01C0, D1               ; appplies a bitmask to get 3 bits, check if its 001
                CMP.W   #$0040, D1               ; confirms if it is a MOVEA
                BEQ     INSERTA                  ; branches to MOVEA, otherwise it is a normal MOVE
 
                LEA     MSG_MOVE,A5              ; loads string pointer for MOVE into A5
                BRA     PRINTMOVE                ; Branches to print move
                
INSERTA         LEA     MSG_MOVEA,A5             ; loads string pointer for MOVEA into A5
 
PRINTMOVE       JSR     PRINTNULL                ; prints out MOVE/MOVEA
                JSR     PRINTMOVESIZE            ; prints out the size  
                MOVE.W  D4,D2                    ; Moves D4 (source effective address) to D2
                MOVE.W  D5,D3                    ; Moves D5 (source Xn) to D3 
                JSR     EA_TO_STRING             ; outputs it into a string
                
                ; prints a comma to seperate
                LEA     MSG_COMMA,A5             ; loads string pointer into A5
                JSR     PRINTNULL                ; prints out MOVE
                
                ; print destination
                MOVE.W  D6,D2                    ; Moves D6 (dest effective address) to D2
                MOVE.W  D7,D3                    ; Moves D7 (dest Xn if applicable) to D3 
                JSR     EA_TO_STRING             ; outputs it into a string
                RTS                              ; exits subroutine                 
              
                
CASE_MOVEM      MOVE.W  D0,D1                           ; copies instruction word to D1
                AND.W   #$FB80,D1                       ; check bitmask for MOVEM (1111 1011 1000 0000)
                CMP.W   #$4880,D1                       ; sees if it matches MOVEM (0100 1000 1000 0000)
                BNE     CASE_MOVEQ                      ; checks MOVEQ if its not MOVEM
                
                ; loads EA and XN
                MOVE.W  #0,D1                           ; copies instruction word to D1
                JSR     GET_EA                          ; gets EA and puts in D1
                MOVE.W  D1,D2                           ; copies EA to D1 so it won't be overwritten
                MOVE.W  #0,D1                           ; copies instruction word to D1
                JSR     GET_XN                          ; gets XN and puts in D1
                MOVE.W  D1,D3                           ; copies EA to D1 so it won't be overwritten
                
                ; Check D
                MOVE.W  D0,D1                           ; copies instruction word to D1
                AND.W   #$0400,D1                       ; check bitmask for D in MOVEM (0000 0100 0000 0000)
                MOVE.W  D1,D7                           ; stores D1 in D7 so it doesn't get overwritten
                CMP.W   #$0400,D1                       ; checks if value is 1
                BEQ     MOVEM_MEM2REG                   ; if value is 1, then it is Memory to Register   

MOVEM_REG2MEM   LEA     VALIDEA_MOVEM_REGTOMEM,A5       ; loads valid addresses
                MOVE.W  D2,D1                           ; Loads D2 into D1 to check the number representing EA
                JSR     CHECKEAXN_IFVALID               ; checks if the EA is valid
                CMP.W   #1,D1                           ; checks if D1 invalid
                BEQ     CASE_DATA                       ; if invalid go to CASE_DATA
                CMP.W   #2,D1                           ; checks if we need to check Xn
                
REG2MEMXNCHECK  LEA     VALIDEA_MOVEM_REGTOMEM,A5       ; loads valid addresses
                MOVE.W  D3,D1                           ; Loads D2 into D1 to check the number representing EA
                JSR     CHECKEAXN_IFVALID               ; checks if the EA is valid
                CMP.W   #1,D1                           ; checks if D1 invalid
                BEQ     CASE_DATA                       ; if invalid go to CASE_DATA

                

MOVEM_MEM2REG    
                        


CASE_MOVEQ      MOVE.W  D0,D1
                AND.W   #$F100,D1
                CMP.W   #$7000,D1
                BNE     CASE_ADD
                
                ;loads Register
                MOVE.W  #1,D1                           ; copies instruction word to D1
                JSR     GET_XN                          ; gets XN and puts in D1
                MOVE.W  D1,D2                           ; copies Xn to D2 so it won't be overwritten
                
                ;loads DATA
                MOVE.W  D0,D1
                AND.W   #$00FF,D1                       ;bit mask to get DATA
                MOVE.W  D1,D3                          ;copy data into D3
                                                        ;must convert bits to hex
                
                
PRINT_MOVEQ     LEA     MSG_MOVEQ,A5                    ;PRINT MOVEQ
                JSR     PRINTNULL  
                
                LEA     MSG_L,A5                        ;PRINT SIZE L
                JSR     PRINTNULL
    
                LEA     THREE_TAB,A5                    ;PRINT THREE TABS
                JSR     PRINTNULL
                
                LEA     MSG_POUND, A5                     ;PRINT HASHTAG
                JSR     PRINTNULL
                RTS
                
* get bits 0-5, 9-11, and 12-15 first (similarities between ADD and ADDA)
CASE_ADD        MOVE.W  D0,D1
                AND.W   #$F000,D1
                CMP.W   #$D000,D1
                BNE     CASE_ADDQ
                
                ; Check bits 0-5 
                LEA     VALIDEA_ALL,A5           ; Loads valid EA types in A5
                LEA     VALIDXN_ALL,A6           ; Loads valid Xn types in A6
                MOVE.W  #0,D7                    ; Marks D7 as "Source" for CHECKGETEAXN
                JSR     CHECKGET_EAXN            ; getting if its valid (D1), EA (D2), and Xn (D3)
                CMP.W   #1,D1                    ; checks if invalid
                BEQ     CASE_DATA                ; branches to CASE_DATA if invalid
                MOVE.W  D2,D4                    ; Moves D2 (source effective address) to D4
                MOVE.W  D3,D5                    ; Moves D3 (source Xn if applicable) to D5
                
                ; get bits 9-11
                MOVE.W  D0,D1
                LSL.W   #4,D1                   ; get rid of left 4 bits
                LSR.W   #4,D1
                LSR.W   #8,D1                   ; get rid of right 6 bits
                LSR.W   #1,D1                   ; get rid of right 6 bits
                MOVE.W  D1,D6
                
                ; bits 7-8 determine if it is ADDA or ADD
                MOVE.W  D0,D1
                LSL.W   #8,D1                   ; get rid of left 8 bits
                LSR.W   #8,D1
                LSR.W   #6,D1                   ; get rid of right 6 bits
                CMP.W   #3,D1                   ; if bits 7-8 are 3 (11) then it is ADDA
                BEQ     CASE_ADDA
                
                LEA     MSG_ADD,A5              ; loads string pointer for MOVE into A5
                BRA     PRINTADD                ; Branches to print move
                
PRINTADD        JSR     PRINTNULL
                MOVE.W  D0,D1                   ; bits 7-8 contain size
                LSL.W   #8,D1
                LSR.W   #8,D1
                LSR.W   #6,D1                   ; gets bits 7-8
                
                CMP.W   #1,D1                   ; if 1, it is a word
                BEQ     ADD_WORD
                CMP.W   #2,D1                   ; if 2, it is a long
                BEQ     ADD_LONG
                
ADD_BYTE        LEA     MSG_B,A5
                JSR     PRINTNULL
                BRA     FINISH_ADD  

ADD_WORD        LEA     MSG_W,A5
                JSR     PRINTNULL
                BRA     FINISH_ADD  
                

ADD_LONG        LEA     MSG_L,A5
                JSR     PRINTNULL
                BRA     FINISH_ADD  

FINISH_ADD      LSL.W   #7,D1
                LSR.W   #7,D1
                LSR.W   #8,D1

                CMP.W   #1,D1
                BRA     Dn_PLUS_EA          
                
                ; print Data Register
                LEA     MSG_DR,A5
                JSR     PRINTNULL
                MOVE.W  D6,D1
                JSR     PRINTNUM                
                
                ; prints a comma to seperate
                LEA     MSG_COMMA,A5             ; loads string pointer into A5
                JSR     PRINTNULL                ; prints out MOVE
                
                ; below is EA+Dn->Dn  
                MOVE.W  D4,D2                    ; Moves D4 (source effective address) to D2
                MOVE.W  D5,D3                    ; Moves D5 (source Xn) to D3 
                JSR     EA_TO_STRING             ; outputs it into a string
                RTS                              ; exits subroutine 

Dn_PLUS_EA      ; below is Dn+EA->EA  
                MOVE.W  D4,D2                    ; Moves D4 (source effective address) to D2
                MOVE.W  D5,D3                    ; Moves D5 (source Xn) to D3 
                JSR     EA_TO_STRING             ; outputs it into a string   
                
                ; prints a comma to seperate
                LEA     MSG_COMMA,A5             ; loads string pointer into A5
                JSR     PRINTNULL                ; prints out MOVE
                
                ; below is Dn+EA->EA
                LEA     MSG_DR,A5                  ; print data register
                JSR     PRINTNULL
                MOVE.W  D6,D1
                JSR     PRINTNUM             
                RTS                              ; exits subroutine                
                 

CASE_ADDA       MOVE.W  D0,D1
                LSL.W   #7,D1
                LSR.W   #7,D1
                LSR     #8,D1                               ; gets bit 8 (size bit)
                
                LEA     MSG_ADDA,A5
                JSR     PRINTNULL
                
                CMP.W   #1,D1
                BEQ     ADDA_LONG
                
                LEA     MSG_W,A5
                JSR     PRINTNULL
                BRA     FINISH_ADDA   
                
ADDA_LONG       LEA     MSG_L,A5
                JSR     PRINTNULL
                BRA     FINISH_ADDA
                
FINISH_ADDA     MOVE.W  D4,D2                    ; Moves D4 (source effective address) to D2
                MOVE.W  D5,D3                    ; Moves D5 (source Xn) to D3 
                JSR     EA_TO_STRING             ; outputs it into a string
                
                ; prints a comma to seperate
                LEA     MSG_COMMA,A5             ; loads string pointer into A5
                JSR     PRINTNULL                ; prints out MOVE
        
                LEA     MSG_AR,A5                ; print address register
                JSR     PRINTNULL
                MOVE.W  D6,D1
                JSR     PRINTNUM             
                RTS                              ; exits subroutine
                

CASE_ADDQ       MOVE.W  D0,D1
                AND.W   #$F000,D1       
                CMP.W   #$5000,D1
                BNE     CASE_SUB
                
                ; Check bits 0-5 
                LEA     VALIDEA_ALL,A5           ; Loads valid EA types in A5
                LEA     VALIDXN_ALL,A6           ; Loads valid Xn types in A6
                MOVE.W  #0,D7                    ; Marks D7 as "Source" for CHECKGETEAXN
                JSR     CHECKGET_EAXN            ; getting if its valid (D1), EA (D2), and Xn (D3)
                CMP.W   #1,D1                    ; checks if invalid
                BEQ     CASE_DATA                ; branches to CASE_DATA if invalid
                MOVE.W  D2,D4                    ; Moves D2 (source effective address) to D4
                MOVE.W  D3,D5                    ; Moves D3 (source Xn if applicable) to D5
                
                ; get bits 6-7 (size bits)
                MOVE.W  D0,D1
                LSL.W   #8,D1
                LSR.W   #8,D1
                LSR.W   #6,D1
                MOVE.W  D1,D2

                ; gets bits 9-11 (data bits)
                LSL.W   #4,D1
                LSR.W   #4,D1                               ; get rid of left 4 bits
                LSR.W   #8,D1
                LSR.W   #1,D1                               ; get rid of right 9 bits
                
                LEA     MSG_ADDQ,A5
                JSR     PRINTNULL
                
                CMP.W   #1,D2
                BEQ     ADDQ_WORD
                CMP.W   #2,D2
                BEQ     ADDQ_LONG
                
ADDQ_BYTE       LEA     MSG_B,A5
                JSR     PRINTNULL
                BRA     FINISH_ADDQ  

ADDQ_WORD       LEA     MSG_W,A5
                JSR     PRINTNULL
                BRA     FINISH_ADDQ                 

ADDQ_LONG       LEA     MSG_L,A5
                JSR     PRINTNULL
                BRA     FINISH_ADDQ                  
                
FINISH_ADDQ     JSR     PRINT_ADDQ_DATA

                ; prints a comma to seperate
                LEA     MSG_COMMA,A5             ; loads string pointer into A5
                JSR     PRINTNULL                ; prints out MOVE
                
                ; prints destination
                MOVE.W  D4,D2                    ; Moves D4 (source effective address) to D2
                MOVE.W  D5,D3                    ; Moves D5 (source Xn) to D3 
                JSR     EA_TO_STRING             ; outputs it into a string
                
                RTS


PRINT_ADDQ_DATA LEA     MSG_POUND,A5
                JSR     PRINTNULL
                CMP.W   #0,D1
                BEQ     PRINT_8
                JSR     PRINTNUM
                RTS 

PRINT_8         MOVE.B  #8,D1
                JSR     PRINTNUM
                RTS           
                

CASE_SUB

CASE_LEA        MOVE.W  D0,D1                                ; Copies instruction word to D1
                AND.W   #$F000,D1                            ; Applies a bitmask to get first 4 bits                
                CMP.W   #$4000,D1                            ; Checks if it fits the first four bits of LEA opcode
                BNE.W   CASE_AND                             ; If its not, check AND
                MOVE.W  D0,D1                                ; Copies instruction word to D1
                AND.W   #$01C0,D1                            ; Applies a bitmask to get 3 bits from places 6 to 8             
                CMP.W   #$01C0,D1                            ; Checks if it matches 111/#3
                BNE.W   CASE_AND                             ; If its not, check AND
                
                ; Check source
                LEA     VALIDEA_LEA,A5                       ; Loads valid EA types in A5
                LEA     VALIDXN_SHORTLONG,A6                 ; Loads valid Xn types in A6
                MOVE.W  #0,D7                                ; Marks D7 as "Source" for CHECKGETEAXN
                JSR     CHECKGET_EAXN                        ; checks the EA and XN
                MOVE.W  D2,D4                                ; Saves D2 in D4
                MOVE.W  D3,D5                                ; Saves D2 in D4
                
                ; Check destination
                LEA     VALIDEA_LEA,A5                       ; Loads valid EA types in A5
                LEA     VALIDXN_SHORTLONG,A6                 ; Loads valid Xn types in A6
                MOVE.W  #1,D7                                ; Marks D7 as "destination" for CHECKGETEAXN
                JSR     CHECKGET_EAXN                        ; checks the EA and XN
                MOVE.W  D2,D6                                ; Saves D2 in D4
                MOVE.W  D3,D7                                ; Saves D2 in D4

                LEA     MSG_LEA,A5                           ; loads string pointer for LEA into A5
                JSR     PRINTNULL                            ; prints LEA
                
                ; print source
                MOVE.W  D4,D2
                MOVE.W  D5,D3
                JSR     EA_TO_STRING                         ; Prints out the EA
                
                ; comma
                LEA     MSG_COMMA,A5                         ; prints out a comma for formatting
                JSR     PRINTNULL                       
                 
                ; register
                LEA     MSG_AR,A5                            ; loads A into A5 (we already checked for it)
                JSR     PRINTNULL 
                MOVE.W  D1,D2                                ; saves Xn to D3 so it doesn't get overwritten
                MOVE.W  #1,D1                                ; specifies that we are looking for destination Xn
                JSR     GET_XN                               ; Gets Xn, puts it into D1
                JSR     PRINTNUM                             ; Prints the number in D1
                RTS

**---------------AND opcode----------------------
CASE_AND
*CASE_AND        LEA         MSG_AND,A1
*                MOVE.B      #14,D0
*                TRAP        #15 
*                JSR         GET_VARS
*                JSR         AND_SIZE                        ; .B, .W, or .L  
*                MOVE.W      CURRENT_INSTR, D5                         
*                LSL.W       #7, D5                        
*                LSR.W       #8, D5                   
*                LSR.W       #7, D5                     
*                CMP.B       #00, D5                         ; check if destination is a Dn?
*                BEQ         DEST_DN                         ; Yes it is, go to DEST_DN
*                CMP.B       #$01,D5                         ; Is the destination not a Dn?
*                BEQ         DEST_EA                         ; branch to DEST_EA            
*                RTS
   
*AND_SIZE        CMP.B       #%00,OPMODE_VAR       
*                BEQ         PRINT_BYTE
*                CMP.B       #$01, OPMODE_VAR
*                BEQ         PRINT_WORD
*                CMP.B       #$02, OPMODE_VAR
*                BEQ         PRINT_LONG    
*    
*DEST_DN         MOVE.W      CURRENT_INSTR, D5               
*                LSL.W       #6,D5
*                LSL.W       #4,D5
*                LSR.W       #6,D5
*                LSR.W       #4,D5
*                LSR.W       #3,D5                           ; d5 stores EA mode                
*                  
*                MOVE.W      CURRENT_INSTR, D6               
*                LSL.W       #6,D5
*                LSL.W       #4,D5
*                LSL.W       #3,D6
*                LSR.W       #6,D6
*                LSR.W       #4,D6
*                LSR.W       #3,D6                           ; d6 stores EA register
*                JSR         FIND_EA
*
*                
*                MOVE.W      CURRENT_INSTR, D5               
*                LSL.W       #4, D5                         
*                LSR.W       #8, D5                          ; shift bits to get register
*                LSR.W       #5, D5                          ; D5 contains register
*                LEA         MSG_COMMA, A1                   
*                MOVE.B      #14,D0
*                TRAP        #15                             ; print comma
*                LEA         MSG_DR, A1                      ; print D
*                MOVE.B      #14,D0
*                TRAP        #15
*                MOVEA.L     D5,A1
*                MOVE.B      #14,D0
*                TRAP        #15                              
*                RTS        
*
*FIND_EA        CMP.W       #%010,D5
*                BEQ         CASE_ARI
*                CMP.W       #%011,D5
*                BEQ         CASE_ARIPOST
*                CMP.W       #%100,D5
*                BEQ         CASE_ARIPRE
*                CMP.W       #%111,D5
*                BEQ         CASE_OTHER
*                BRA         ERROR    
*                                     
*DEST_EA         MOVE.W      CURRENT_INSTR, D5               
*                LSL.W       #4, D5                         
*                LSR.W       #8, D5                          ; shift bits to get register
*                LSR.W       #5, D5                          ; D5 contains register
*
*                LEA         MSG_DR, A1                   
*                MOVE.B      #14,D0
*                TRAP        #15                             ; print D
*                MOVEA.L     D5,A1  
*                MOVE.B      #14,D0                          ; print register
*                TRAP        #15
*                
*                LEA         MSG_COMMA, A1                   
*                MOVE.B      #14,D0
*                TRAP        #15                             ; print comma
*                
*                MOVE.W      CURRENT_INSTR, D5               
*                LSL.W       #6,D5
*                LSL.W       #4,D5
*                LSR.W       #6,D5
*                LSR.W       #4,D5
*                LSR.W       #3,D5                           ; d5 stores EA mode                
*                  
*                MOVE.W      CURRENT_INSTR, D6               
*                LSL.W       #6,D6
*                LSL.W       #4,D6
*                LSL.W       #3,D6
*                LSR.W       #6,D6
*                LSR.W       #4,D6
*                LSR.W       #3,D6                           ; d6 stores EA register
*                JSR         FIND_EA                          
*                RTS                                     Return full instruction   
            
CASE_OR

CASE_NOT

CASE_LSDASD     MOVE.W      D0,D1                            ; copies D0 to D1
                AND.W       #$F000, D1                       ; gets first 4 bits
                CMP.W       #$E000,D1                        ; checks if next 4 bits is E (confirm if ASd/LSd)
                BNE         CASE_BRA                         ; if not equal ASd/LSd check BRA
                MOVE.W      D0,D2                            ; copies D0 to D2
                JSR         GETROTATIONSIZE                  ; gets the rotation size
                CMP.W       #$3, D2                          ; checks if it is memory or register option
                BNE         CASE_SHIFTREG                    ; if rotation size not equal to 3, go to shift reg         
                
CASE_SHIFTMEM   MOVE.W      D0,D2                            ; copies D0 to D2
                JSR         GETROTATION                      ; gets rotation value of D2
                CMP.W       #ASd_MEM,D2                      ; checks if rotation value is ASdMem
                BEQ         CASE_ASdMEM                      ; branches to ASd_MEM if value matches
                CMP.W       #ROd_MEM,D2                      ; checks if rotation value is ASdMem
                BEQ         CASE_ROdMEM                      ; branches to ASd_MEM if value matches
                
CASE_LSdMEM     LEA         MSG_LSd,A5                       ; loads LS into A5
                BRA         PRINTSHIFTMEM                    ; branches to PRINTSHIFTMEM

CASE_ASdMEM     LEA         MSG_ASd,A5                       ; loads AS into A5  
                BRA         PRINTSHIFTMEM                    ; branches to PRINTSHIFTMEM

CASE_ROdMEM     LEA         MSG_ROd,A5                       ; loads AS into A5          
                
PRINTSHIFTMEM   JSR         PRINTNULL                        ; Prints LS or AS   
                MOVE.W      D0,D2                            ; copies D0 to D2
                JSR         GETDIRECTION                     ; gets direction
                CMP.W       #0,D2                            ; checking if its right
                BEQ         CASE_RIGHTMEM                    ; shifts to the right 

CASE_LEFTMEM    LEA         MSG_LEFT,A5                      ; loads L into A5 
                BRA         PRINT_MEMDIR                     ; branches for printing
        
CASE_RIGHTMEM   LEA         MSG_RIGHT,A5                     ; loads R into A5  

PRINT_MEMDIR    JSR         PRINTNULL                        ; Prints L or R
                LEA         MSG_W,A5                         ; loads .W into A5
                JSR         PRINTNULL                        ; Prints .W
                BRA         GETMEMSOURCE                     ; checks the source 
                
; get source addressing mode       
GETMEMSOURCE                                                 
                MOVE.W      #0,D1                            ; specifies that we are looking for source addressing mode
                JSR         GET_EA                           ; gets effective address, output: D1 = EA
                MOVE.W      D1,D4                            ; saves EA to D4 so it doesn't get overwritten
                MOVE.W      #0,D1                            ; specifies that we are looking for source Xn
                JSR         GET_XN                           ; Gets Xn, puts it into D1
                MOVE.W      D1,D5                            ; saves Xn to D5 so it doesn't get overwritten

CHECKMEMSOURE   LEA         VALIDEA_SHIFT,A5                 ; load valid move EA
                MOVE.W      D4,D1                            ; marks down that we are checking EA
                JSR         CHECKEAXN_IFVALID                ; checks if EA is valid
                CMP.W       #2,D1                            ; checks if it is Xn
                BEQ         CHECKSHIFT_XN                    ; branches to CHECKXn if it is
                CMP.W       #1,D1                            ; Checks if it is invalid
                BEQ         CASE_DATA                        ; branches to CASE_DATA if it is

EASHIFT_VALID   MOVE.W      D4,D2                            ; moves EA to D2
                MOVE.W      D5,D3                            ; moves EA to D3
                JSR         EA_TO_STRING                     ; prints out the EA
                RTS                
                
                
CHECKSHIFT_Xn   LEA         VALIDXN_SHORTLONG,A5             ; Loads Xn into A5
                MOVE.W      D5,D1                            ; Loads D5 into D1 to check the Xn
                JSR         CHECKEAXN_IFVALID                ; checks if the Xn is valid, put result in D1
                TST.W       D1                               ; checks if it is valid
                BEQ         EASHIFT_VALID                    ; go to EA_SHIFT to print
                BRA         CASE_DATA                        ; branches to CASE_DATA if not                


CASE_SHIFTREG   MOVE.W      D2,D3                            ; copies D2 to D3
                MOVE.W      D0,D1                            ; copies D0 to D1
                AND.W       #$0018,D1                        ; gets bits representing type (bitmask: 0000 0000 0001 1000)
                LSR.W       #3,D1                            ; shifts 3 bits to the right so we only have 2 bits left   
                CMP.W       #ASd_REG,D1                      ; Compares D1 to 0, if it is 0, it is ASd
                BEQ         CASE_ASdReg                      ; goes to ASd case if so    
                CMP.W       #ROd_REG,D1                      ; Compares D1 to 0, if it is 0, it is ASd
                BEQ         CASE_ROdReg                      ; goes to ASd case if so                 
                
CASE_LSdREG     LEA         MSG_LSd,A5                       ; loads LS into A5
                BRA         PRINTSHIFTREG                    ; branches to PRINTSHIFTREG

CASE_ASdREG     LEA         MSG_ASd,A5                       ; loads AS into A5
                BRA         PRINTSHIFTREG                    ; branches to PRINTSHIFTREG

CASE_ROdREG     LEA         MSG_ROd,A5                       ; loads AS into A5          
                
PRINTSHIFTREG   JSR         PRINTNULL                        ; Prints LS or AS   
                MOVE.W      D0,D2                            ; copies D0 to D2
                JSR         GETDIRECTION                     ; gets direction
                CMP.W       #0,D2                            ; checking if its right
                BEQ         CASE_RIGHTREG                    ; shifts to the right 

CASE_LEFTREG    LEA         MSG_LEFT,A5                      ; loads L into A5 
                BRA         PRINT_REGDIR                     ; branches for printing
        
CASE_RIGHTREG   LEA         MSG_RIGHT,A5                     ; loads R into A5 
                BRA         PRINT_REGDIR                     ; branches for printing
                
PRINT_REGDIR    JSR         PRINTNULL                        ; Prints L or R

PRINTREGSIZE    MOVE.W      D0,D2                            ; loads D0 into D2 to get unmodified instruction word
                JSR         GETROTATIONSIZE                  ; gets the rotation size
                CMP.W       #1,D2                            ; Checks if it is word size
                BEQ         REG_WORD                         ; Prints .W
                CMP.W       #2,D2                            ; Checks if it is long size
                BEQ         REG_LONG                         ; Prints .L

REG_BYTE        LEA         MSG_B,A5                         ; loads .B into A5
                BRA         PRINTREGEA      

REG_WORD        LEA         MSG_W,A5                         ; loads .W into A5
                BRA         PRINTREGEA      
                           
REG_LONG        LEA         MSG_L,A5                         ; loads .L into A5

PRINTREGEA      JSR         PRINTNULL                        ; Prints size
                MOVE.W      D0,D2                            ; copies D0 to D1
                JSR         GETROTATIONLOCATION              ; finds out if its immediate or register 
                CMP.W       #$1,D1                           ; Compares D1 to 0, if it is 0, it is a data register
                BEQ         REG_REGISTER                     ; goes to ASd case if so
                                
REG_IMMEDIATE   MOVE.W      D0,D2                            ; copies D0 to D2
                JSR         GETROTATIONSIZE                  ; gets the rotation size
                MOVE.W      D2, D1                           ; moves rotation size to D1
                LEA         MSG_POUND, A5                    ; loads # into A5
                JSR         PRINTNULL                        ; prints #
                JSR         PRINTNUM                         ; prints shift count
                LEA         MSG_COMMA, A5                    ; loads , into A5
                JSR         PRINTNULL                        ; prints the comma out to divide the source and destination  
                LEA         MSG_DR, A5                       ; loads D into A5
                JSR         PRINTNULL                        ; prints out D 
                MOVE.W      #0,D1                            ; marks that we are looking for Xn (data register number) in the source location  
                JSR         GET_XN                           ; gets the data register number, stores in D1
                JSR         PRINTNUM                         ; prints data register number in D1          
                RTS                                          ; ends subroutine to go onto the next instruction opcode
                
REG_REGISTER    MOVE.W      D0,D2                            ; copies D0 to D2
                JSR         GETROTATIONSIZE                  ; gets the rotation size
                MOVE.W      D2, D1                           ; moves rotation size to D1
                LEA         MSG_DR, A5                       ; loads D into A5
                JSR         PRINTNULL                        ; prints D
                JSR         PRINTNUM                         ; prints register number
                LEA         MSG_COMMA, A5                    ; loads , into A5
                JSR         PRINTNULL                        ; prints the comma out to divide the source and destination  
                LEA         MSG_DR, A5                       ; loads D into A5
                JSR         PRINTNULL                        ; prints out D 
                MOVE.W      #0,D1                            ; marks that we are looking for Xn (data register number) in the source location  
                JSR         GET_XN                           ; gets the data register number, stores in D1
                JSR         PRINTNUM                         ; prints data register number in D1          
                RTS                                          ; ends subroutine to go onto the next instruction opcode
             
CASE_BRA        MOVE.W  D0,D1                                ; Copies instruction word to D1
                AND.W   #$FF00,D1                            ; Applies a bitmask to get first 8 bits                
                CMP.W   #$6000,D1                            ; Checks if it fits the BRA opcode
                BNE.W   CASE_BCC                             ; If its not, check BCC
                
                LEA     MSG_BRA,A5                           ; loads string pointer for BRA into A5
                JSR     PRINTNULL                            ; prints BRA

                MOVE.W  D0,D2                                ; Copies instruction word to D1
                JSR     GETDISPLACEMENT                      ; finds the displacement
                RTS
                
; DO NOT MOVE THIS FORM UNDER CASE_BRA. IS DEPENDENT ON RESULTS OF BRA
; DELETE THIS NOTE: NEED TO FIX LSL/LSR SHIFT TO ENSURE THE BCC CODES GET PRINTED 
CASE_BCC        MOVE.W  D0,D1                                ; copies instruction word from D0 to D1
                AND.W   #$F000,D1                            ; get top 4 bits
                CMP.W   #$6000,D1                            ; make sure top 4 bits are 6
                BNE.W   CASE_JSR                             ; checks next case if not Bcc
                MOVE.W  D0,D1                                ; copies instruction word from D0 to D1
                AND.W   #$0F00,D1                            ; get next 4 bits, condition code
                LSR.W   #8,D1                                ; shifts 8 bits to the right
                
                CMP.W   #$E,D1                               ; checks if D1 is BGT (1 1 1 0)
                BEQ     CASE_BGT                             ; branches to BGT if it is
                
                CMP.W   #$F,D1                               ; checks if D1 is BLE (1 1 1 1)
                BEQ     CASE_BLE                             ; branches to BLE if it is
                    
                CMP.W   #$7,D1                               ; checks if D1 is BEQ (0 1 1 1)
                BEQ     CASE_BEQ                             ; branches to BEQ if it is
                BRA     CASE_DATA                            ; BCC condition code not in the system
   
CASE_BEQ        LEA     MSG_BEQ,A5                           ; loads string pointer for BEQ into A5
                BRA     PRINTBCC

CASE_BLE        LEA     MSG_BLE,A5                           ; loads string pointer for BLE into A5
                BRA     PRINTBCC
                
CASE_BGT        LEA     MSG_BGT,A5                           ; loads string pointer for BGT into A5
                BRA     PRINTBCC

PRINTBCC        JSR     PRINTNULL                            ; prints BEQ/BLE/BGT
                MOVE.W  D0,D2                                ; Copies instruction word to D1
                JSR     GETDISPLACEMENT                      ; finds the displacement
                RTS              
                

CASE_JSR       

CASE_RTS        CMP.W   #$4E75,D0           ; compares to RTS opcode in hex
                BNE     CASE_MOVE           ; checks the next case if not equal
                LEA     MSG_RTS,A5          ; loads string pointer into A5
                JSR     PRINTNULL           ; prints RTS                
                RTS                         ; returns from the subroutine

                

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
                    
* Checks and gets the EA and Xn
* Input: A5 = EA LIST, A6 = Xn LIST, D0 = INSTRUCTION WORD,  D7 = 0 (source EA/Xn), 1 (dest EA/Xn) 
* Output: D1(0 = VALID, 1 = INVALID), D2 = EA, D3 = Xn
CHECKGET_EAXN   MOVE.W  D7,D1                   ; loads value representing position of EA     
                JSR     GET_EA                  ; Gets EA
                MOVE.W  D1,D2                   ; Stores EA in D2
                MOVE.W  D7,D1                   ; loads value representing position of EA   
                JSR     GET_XN                  ; Gets Xn
                MOVE.W  D1,D3                   ; Stores Xn in D3
                MOVE.W  D2,D1                   ; Stores EA in D1 for comparisons
                
                JSR     CHECKEAXN_IFVALID       ; checks if EA is valid
                CMP.W   #2,D1                   ; checks if it is Xn
                BEQ     CHECK_XN                ; branches to CHECKXn if it is
                CMP.W   #1,D1                   ; Checks if it is invalid
                BEQ     EAXN_INVALID            ; branches to CHECKXn if it is
                
                
EAXN_VALID      MOVE.W  #0,D1                   ; loads 0 (VALID) into D1
                BRA     END_CHECKGET
      
; need XN
CHECK_Xn        MOVEA.L A6,A5                   ; Loads Xn into A5  
                MOVE.W  D3,D1                   ; MOves Xn to D1 to be checked
                JSR     CHECKEAXN_IFVALID       ; checks if Xn is valid
                TST.W   D1                      ; checks if it is valid
                BEQ     EAXN_VALID              ; go to EA_VALID to print
                BRA     EAXN_INVALID            ; branches to EA_INVALID if not  
 
EAXN_INVALID    MOVE.W  #1,D1                   ; loads 1 (INVALID) into D

END_CHECKGET    RTS          
                                          
                                          
* Gets the displacement and pritns it 
* Inputs: D2 = instruction word, A2 = address of next word
* Outputs: prints out displacement
GETDISPLACEMENT     MOVEM.L    D1/A5, -(SP)         ; saves D1
                    MOVE.W    A2,A5                 ; copies A2 to A5
                    AND.W     #$00FF,D2             ; applies a bitmask to get rid of the first 8 bits
                    BNE       PRINTADDRESS          ; prints address if not 0
                    MOVE.W    (A2)+,D2               ; gets 16 bit displacement                    
                    
PRINTADDRESS        ADD.W     A5,D2                 ; Adds address to D2 to get displacement
                    MOVE.W    D2,D1                 ; moves address to D1 for printing
                    MOVE.B    #0,D4                 ; marks address as word  length
                    LEA       MSG_HEX,A5            ; loads hex sign to A5
                    JSR       PRINTNULL             ; prints null
                    JSR       PRINTSHORTLONGNUM     ; prints address
                    
                    MOVEM.L    (SP)+,D1/A5              ; restores D1
                    ; DELETE LATER. NOTE: WE DONT HAVE HEX YET, PRINT HEX SIGN BEFORE NUM, BUT WILL NEED TO ADD THIS LATER

* Gets the rotation value for ASd and LSd
* Input: D2 = instruction word copy (of D0)                                    
* Output: rotation  value in D2             
GETROTATION         AND.W      #$0E00,D2             ; gets the rotation bits
                    LSR.W      #8,D2                ; shifts 8 bits to the right to only have the rotation bits
                    LSR.W      #1,D2                ; shifts 1 bits to the right to only have the rotation bits
                    RTS                             ; return from subroutine

* Gets the direction value for ASd and LSd
* Input: D2 = instruction word copy (of D0)                                    
* Output: direction value in D2             
GETDIRECTION        AND.W      #$0100,D2             ; gets the rotation bits
                    LSR.W      #8,D2                ; shifts 8 bits to the right to only have the rotation bits
                    RTS                             ; return from subroutine

* Gets the rotation size value for ASd and LSd
* Input: D2 = instruction word copy (of D0)                                    
* Output: rotation size value in D2             
GETROTATIONSIZE     AND.W      #$00C0,D2            ; gets the rotation bits
                    LSR.W      #6,D2                ; shifts 6 bits to the right to only have the rotation bits
                    RTS                             ; return from subroutine

* Gets the rotation location  value for ASd and LSd
* Input: D2 = instruction word copy (of D0)                                    
* Output: rotation location value in D2             
GETROTATIONLOCATION AND.W      #$0020,D2            ; gets the rotation location bits
                    LSR.W      #5,D2                ; shifts 6 bits to the right to only have the rotation bits
                    RTS                             ; return from subroutine

                        
* Checks if EA or Xn is valid
* Inputs: A5 = Pointer to -1 terminated list of valid addressing modes, D1 = Addressing Mode (3 bit)
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

* other (long, short, immediate) with Xn yes
CASE_OTHER         MOVE     (A2)+, D0               ; Moves next instruction word into D1 since A2 is auxilliary instruction word 
                   CMP.W    #ABSShort,D3            ; checks if it is a word
                   BEQ      CASE_WORD               ; branches to CASE_WORD if is a short
                   
                   CMP.W    #ABSLong,D3             ; checks if it is (An)
                   BEQ      CASE_LONG               ; branches to CASE_LONG if is a long

* NOTE DELETE LATER: update to print num as HEX and add NEGATIVE NUMBER CHECK
* immediate
CASE_IMMEDIATE     LEA      MSG_POUND,A5            ; Loads # into A5
                   JSR      PRINTNULL               ; Prints #  
                   LEA      MSG_HEX,A5              ; Loads $ into A5
                   JSR      PRINTNULL               ; Prints $
                   MOVE.W   D0, D1                  ; moves instruction word into d1
                   JSR      PRINTHEXNUM 
                   BRA      EA_TO_STRING_EXIT       ; exits subroutine                  
                   
; DELETE LATER: convert to hex andwrite code to make them print out a total of 4 and 8 characters, add 0's                      

* word address
CASE_WORD          
                   LEA      MSG_HEX,A5              ; Loads $ into A5
                   JSR      PRINTNULL               ; Prints $
                   MOVE.W   D0, D1                  ; moves instruction word into d1
                   MOVE.W   #0, D4                  ; moves length size (word) into d4
                   JSR      PRINTSHORTLONGNUM       ; reformats the number to the proper length and prints out the number
                   BRA      EA_TO_STRING_EXIT       ; exits subroutine

* long address 
CASE_LONG          
                   LEA      MSG_HEX,A5              ; Loads $ into A5
                   JSR      PRINTNULL               ; Prints $
                   MOVE.W   D0, D1                  ; moves instruction word into d1
                   MOVE.W   #1, D4                  ; moves length size (long) into d4
                   JSR      PRINTSHORTLONGNUM       ; reformats the number to the proper length and prints out the number
                   MOVE     (A2)+, D1               ; Moves next instruction word into D1 since A2 is auxilliary instruction word
                   JSR      PRINTNUM                ; reformats the number to the proper length and prints out the number


* exits subroutine
EA_TO_STRING_EXIT   MOVEM.L  (SP)+,D0-D1/A5          ; restoers D1, D0, and A5
                    RTS                              ; returns from subroutine

* DELETE LATER: sorry the formatting is weird here we can fix it later or whenever you want  im just lazy for now

* Prints out the content of D1 as a decimal number
* Input: number in D1 to be printed
* Output: contents of D1 printed
PRINTNUM         MOVEM.L     D0-D1, -(SP)        ; saves D0 and D1
                 MOVE.B      #3,D0               ; prints D1
                 TRAP        #15                 ; is trap task 3
            
                 MOVEM.L     (SP)+,D0-D1         ; returns D0 and D1
                 RTS                             ; returns from subroutine
                 
* Prints out the content of D1 as a hex number
* Input: number in D1 to be printed
* Output: contents of D1 printed
PRINTHEXNUM      MOVEM.L     D0-D1, -(SP)        ; saves D0 and D1
                 MOVE.B      #16,D2              ; for trap task 15 to print it out as hex
                 MOVE.B      #15,D0              ; converts D1 to Hex and prints it out
                 TRAP        #15                 ; is trap task 15
                 MOVEM.L     (SP)+,D0-D1         ; returns D0 and D1
                 RTS                             ; returns from subroutine
                 
* Prints out the content of D1 as a hex number and formats it to have the length of WORD or a LONG
* Input: number in D1 to be printed, D4 = length (0 = WORD, 1 = LONG)
* Output: contents of D1 printed
PRINTSHORTLONGNUM         MOVEM.L     D0-D2, -(SP)        ; saves D0 to D2
                          CMP.B       #1,D4               ; checks size of number
                          BEQ         PRINTLONGZERO       ; if it is a long then branch to PRINTLONGZERO

PRINTSHORTZERO            MOVE.W      D1,D2               ; copies number to D2
                          AND.W       #$F000,D2           ; gets the first digit
                          CMP.W       #0, D2              ; checks if it is 0
                          BNE         PRINTASHEX          ; if the digit is not equal to zero then print the full number
                          JSR         PRINTZERO           ; prints a zero
                          
                          MOVE.W      D1,D2               ; copies number to D2
                          AND.W       #$0F00,D2           ; gets the second digit
                          CMP.W       #0, D2              ; checks if it is 0
                          BNE         PRINTASHEX          ; if the digit is not equal to zero then print the full number
                          JSR         PRINTZERO           ; prints a zero
                          
                          MOVE.W      D1,D2               ; copies number to D2
                          AND.W       #$00F0,D2           ; gets the third digit
                          CMP.W       #0, D2              ; checks if it is 0
                          BNE         PRINTASHEX          ; if the digit is not equal to zero then print the full number
                          JSR         PRINTZERO           ; prints a zero
                          BRA         PRINTASHEX          ; prints last digit
                          
PRINTLONGZERO             MOVE.L      D1,D2               ; copies number to D2
                          AND.L       #$F0000000,D2       ; gets the first digit
                          CMP.L       #0, D2              ; checks if it is 0
                          BNE         PRINTASHEX          ; if the digit is not equal to zero then print the full number
                          JSR         PRINTZERO           ; prints a zero
                          
                          MOVE.L      D1,D2               ; copies number to D2
                          AND.L       #$0F000000,D2       ; gets the second digit
                          CMP.L       #0, D2              ; checks if it is 0
                          BNE         PRINTASHEX          ; if the digit is not equal to zero then print the full number
                          JSR         PRINTZERO           ; prints a zero
                          
                          MOVE.L      D1,D2               ; copies number to D2
                          AND.L       #$00F00000,D2       ; gets the third digit
                          CMP.L       #0, D2              ; checks if it is 0
                          BNE         PRINTASHEX          ; if the digit is not equal to zero then print the full number
                          JSR         PRINTZERO           ; prints a zero
                          
                          MOVE.L      D1,D2               ; copies number to D2
                          AND.L       #$000F0000,D2       ; gets the fourth digit
                          CMP.L       #0, D2              ; checks if it is 0
                          BNE         PRINTASHEX          ; if the digit is not equal to zero then print the full number
                          JSR         PRINTZERO           ; prints a zero
                          
                          MOVE.L      D1,D2               ; copies number to D2
                          AND.L       #$0000F000,D2       ; gets the fith digit
                          CMP.L       #0, D2              ; checks if it is 0
                          BNE         PRINTASHEX          ; if the digit is not equal to zero then print the full number
                          JSR         PRINTZERO           ; prints a zero
                          
                          MOVE.L      D1,D2               ; copies number to D2
                          AND.L       #$00000F00,D2       ; gets the sixth digit
                          CMP.L       #0, D2              ; checks if it is 0
                          BNE         PRINTASHEX          ; if the digit is not equal to zero then print the full number
                          JSR         PRINTZERO           ; prints a zero
                          
                          MOVE.L      D1,D2               ; copies number to D2
                          AND.L       #$000000F0,D2       ; gets the seventh digit
                          CMP.L       #0, D2              ; checks if it is 0
                          BNE         PRINTASHEX          ; if the digit is not equal to zero then print the full number
                          JSR         PRINTZERO           ; prints a zero

PRINTASHEX                MOVE.B      #16,D2              ; for trap task 15 to print it out as hex
                          MOVE.B      #15,D0              ; converts D1 to Hex and prints it out
                          TRAP        #15                 ; is trap task 15
                          MOVEM.L     (SP)+,D0-D2         ; returns D0 and D1
                          RTS                             ; returns from subroutine    
* Prints a zero
* Input: nothing
* Output: 0 printed out to the console
PRINTZERO                 MOVE.L      D1,-(SP)            ; saves D1
                          MOVE.L      #0,D1               ; moves 0 to D1
                          JSR         PRINTNUM            ; prints the number
                          MOVE.L      (SP)+,D1            ; restores D1
                          RTS                             ; returns from subroutine
            
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

ERROR           LEA     ERROR_MSG,A1
                MOVE.B  #14,D0
                TRAP    #15 
       
* DELETE THIS: Test                
DELETEME        MOVEA.L  -(A1),A3
                BEQ      DELETEMEAGAIN  
                BLE      DELETEMEAGAIN
                BGT      DELETEMEAGAIN

                LSR.B      #2,D2
                LSR.W      -(A2)
                LSR.W      (A2)+
                LSR.L      D2,D2 
                LSL.B      #2,D2
                LSL.W      -(A2)
                LSL.W      (A2)+
                LSL.L      D2,D2
                ROL.B      #2,D2
                ROL.W      -(A2)
                ROL.W      (A2)+
                ROL.L      D2,D2
                ROR.B      #2,D2
                ROR.W      -(A2)
                ROR.W      (A2)+
                ROR.L      D2,D2
                
                ADDQ.W      #8,A5
                       
                
DELETEMEAGAIN                 
          
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
VALIDEA_MOVEQ                   DC.B    Dn,AnIndirect,AnPost,AnPre,Other,-1
VALIDEA_MOVEM_REGTOMEM          DC.B    AnIndirect,AnPre,Other,-1
VALIDEA_MOVEM_MEMTOREG          DC.B    AnIndirect,AnPost,Other,-1
VALIDEA_ADDSUB_DESTOPERAND      DC.B    AnIndirect,AnPost,AnPre,Other,-1
VALIDEA_MULSDIVU                DC.B    Dn,AnIndirect,AnPost,AnPre,Other,-1
VALIDEA_LEA                     DC.B    An,Other,-1
VALIDEA_ANDORNOT                DC.B    Dn,AnIndirect,AnPost,AnPre,Other,-1
VALIDEA_ANDOR_DESTOPERAND       DC.B    AnIndirect,AnPost,AnPre,Other,-1
VALIDEA_SHIFT                   DC.B    AnIndirect,AnPost,AnPre,Other,-1                ; LSL, LSR, ASL, ASR, ROR, ROL
VALIDEA_JSR                     DC.B    AnIndirect, Other,-1

* Valid Xn
VALIDXN_ALL                     DC.B    ABSShort,ABSLong,XnImmediate,-1                 
; MOVE (source), MOVEA, ADD, ADDA, SUB, MULS, DIVU, AND, OR, 
VALIDXN_SHORTLONG               DC.B    ABSShort,ABSLong,-1                             
; MOVE (dest), MOVEM, ADD (destination operand), ADDQ, SUB (destination operand), LEA, AND (destination operand),
; OR (destination operand), NOT, LSL/R, ASL/R, JSR

* posible memory ASd/LSd rotation values
ASd_MEM                         EQU     0   
LSd_MEM                         EQU     1 
ROd_MEM                         EQU     3
 
ASd_REG                         EQU     0   
LSd_REG                         EQU     1 
ROd_REG                         EQU     3

* Starting messages
WELCOME                         DC.B    'Welcome to Team Big Blue Disassembler',CR,LF
                                DC.B    'Format: 8 digit address in hexadecimal format. Letters must be capital case.',CR,LF,0
STARTING                        DC.B    'Please enter a starting location in the above format',CR,LF,0
ENDING                          DC.B    'Please enter an ending location in the above format',CR,LF,0
BAD_INPUT                       DC.B    'Invalid input. Please try again',CR,LF,0
ERROR_MSG                       DC.B    'Error while disassembling',CR,LF,0
NEW_LINE                        DC.B    CR,LF,0
THREE_TAB                       DC.B    TAB,TAB,TAB,0

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
MSG_LEA                         DC.B    TAB,'LEA',TAB,TAB,TAB,0
MSG_AND                         DC.B    TAB,'AND',0
MSG_OR                          DC.B    TAB,'OR',0
MSG_NOT                         DC.B    TAB,'NOT',0
MSG_LSd                         DC.B    TAB,'LS',0
MSG_ASd                         DC.B    TAB,'AS',0
MSG_ROd                         DC.B    TAB,'RO',0
MSG_BCC                         DC.B    TAB,'BCC',TAB,TAB,TAB,0
MSG_BCS                         DC.B    TAB,'BCS',TAB,TAB,TAB,0
MSG_BEQ                         DC.B    TAB,'BEQ',TAB,TAB,TAB,0
MSG_BNE                         DC.B    TAB,'BNE',TAB,TAB,TAB,0
MSG_BGE                         DC.B    TAB,'BGE',TAB,TAB,TAB,0
MSG_BGT                         DC.B    TAB,'BGT',TAB,TAB,TAB,0
MSG_BHI                         DC.B    TAB,'BHI',TAB,TAB,TAB,0
MSG_BLE                         DC.B    TAB,'BLE',TAB,TAB,TAB,0
MSG_BLS                         DC.B    TAB,'BLS',TAB,TAB,TAB,0
MSG_BLT                         DC.B    TAB,'BLT',TAB,TAB,TAB,0
MSG_BMI                         DC.B    TAB,'BMI',TAB,TAB,TAB,0
MSG_BPL                         DC.B    TAB,'BPL',TAB,TAB,TAB,0
MSG_BVC                         DC.B    TAB,'BVC',TAB,TAB,TAB,0
MSG_BVS                         DC.B    TAB,'BVS',TAB,TAB,TAB,0
MSG_JSR                         DC.B    TAB,'JSR',TAB,TAB,TAB,0
MSG_RTS                         DC.B    TAB,'RTS',0
MSG_BRA                         DC.B    TAB,'BRA',TAB,TAB,TAB,0

* Direction for LSd and ASd
MSG_RIGHT                       DC.B    'R',0
MSG_LEFT                        DC.B    'L',0

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
MSG_SPACE                       DC.B    ' ',0
MSG_TAB                         DC.B    TAB,0

* Size Messages
MSG_B                           DC.B    '.B',TAB,TAB,TAB,0
MSG_W                           DC.B    '.W',TAB,TAB,TAB,0
MSG_L                           DC.B    '.L',TAB,TAB,TAB,0

* Variables
STARTING_ADDRESS                EQU     $100
ENDING_ADDRESS                  EQU     $150
CURRENT_INSTR                   EQU     $200
REG_VAR                         EQU     $250 * Hold bits 11-9
OPMODE_VAR                      EQU     $300 * Hold bits 8-6
EA_MODE                         EQU     $350 * Hold bits 5-3
EA_REG                          EQU     $400 * Hold bits 2-0

            END     START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
