*-----------------------------------------------------------
* Title      :  Test Code
* Written by :  Audrey Nguyen
* Date       :  05/09/2020
* Description:  Version 1
*-----------------------------------------------------------
    ORG    $1000
START:                  
* NOP test
                NOP

* MOVE test
MOVETEST            
                * Direct Adressing
                MOVE.B      #$A, D0
                MOVE.W      #$AAAB, D1
                MOVE.L      #$AAAAAAAA, D2
                
                MOVE.B      #$A, $6000
                MOVE.W      #$AAAB, $6020
                MOVE.L      #$AAAAAAAA, $6040
                
                MOVE.W      #$AAAB, A1
                MOVE.L      #$AAAAAAAA, A2
                
                MOVE.B      #$A, (A1)
                MOVE.W      #$AAAB, (A2)
                MOVE.L      #$AAAAAAAA, (A3)
                
                MOVE.B      #$A, (A1)+
                MOVE.W      #$AAAB, (A2)+
                MOVE.L      #$AAAAAAAA, (A3)+
                
                MOVE.B      #$A, -(A1)
                MOVE.W      #$AAAB, -(A2)
                MOVE.L      #$AAAAAAAA, -(A3)
                
                * Data Register Direct
                MOVE.B      D0,D1
                MOVE.W      D1,D3
                MOVE.L      D2,D4
                
                MOVE.B      D0,$6000
                MOVE.W      D1,$6020
                MOVE.L      D2,$6040
                
                MOVE.W      D1,A2
                MOVE.L      D2,A3
                
                MOVE.B      D0,(A1)
                MOVE.W      D1,(A2)
                MOVE.L      D2,(A3)
                
                MOVE.B      D0,(A1)+
                MOVE.W      D1,(A2)+
                MOVE.L      D2,(A3)+
                
                MOVE.B      D0,-(A1)
                MOVE.W      D1,-(A2)
                MOVE.L      D2,-(A3)
                
                * Address Register Direct
                MOVE.W      A1,D3
                MOVE.L      A2,D4
                
                MOVE.W      A1,$6020
                MOVE.L      D2,$6040
                
                MOVE.W      A1,A2
                MOVE.L      A2,A3
                
                MOVE.W      A1,(A2)
                MOVE.L      A2,(A3)
                
                MOVE.W      A1,(A2)+
                MOVE.L      A2,(A3)+
                
                MOVE.W      A1,-(A2)
                MOVE.L      A2,-(A3)
                
                * Address Register Indirect
                MOVE.B      (A0),D1
                MOVE.W      (A1),D3
                MOVE.L      (A2),D4
                
                MOVE.B      (A0),$6000
                MOVE.W      (A1),$6020
                MOVE.L      (A2),$6040
                
                MOVE.W      (A1),A2
                MOVE.L      (A2),A3
                
                MOVE.B      (A0),(A1)
                MOVE.W      (A1),(A2)
                MOVE.L      (A2),(A3)
                
                MOVE.B      (A0),(A1)+
                MOVE.W      (A1),(A2)+
                MOVE.L      (A2),(A3)+
                
                MOVE.B      (A0),-(A1)
                MOVE.W      (A1),-(A2)
                MOVE.L      (A2),-(A3)
                
                * Address Register Indirect with Post incrementing
                MOVE.B      (A0)+,D1
                MOVE.W      (A1)+,D3
                MOVE.L      (A2)+,D4
                
                MOVE.B      (A0)+,$6000
                MOVE.W      (A1)+,$6020
                MOVE.L      (A2)+,$6040
                
                MOVE.W      (A1)+,A2
                MOVE.L      (A2)+,A3
                
                MOVE.B      (A0)+,(A1)
                MOVE.W      (A1)+,(A2)
                MOVE.L      (A2)+,(A3)
                
                MOVE.B      (A0)+,(A1)+
                MOVE.W      (A1)+,(A2)+
                MOVE.L      (A2)+,(A3)+
                
                MOVE.B      (A0)+,-(A1)
                MOVE.W      (A1)+,-(A2)
                MOVE.L      (A2)+,-(A3)
                
                * Address Register Indirect with Pre decrementing
                MOVE.B      -(A0),D1
                MOVE.W      -(A1),D3
                MOVE.L      -(A2),D4
                
                MOVE.B      -(A0),$6000
                MOVE.W      -(A1),$6020
                MOVE.L      -(A2),$6040
                
                MOVE.W      -(A1),A2
                MOVE.L      -(A2),A3
                
                MOVE.B      -(A0),(A1)
                MOVE.W      -(A1),(A2)
                MOVE.L      -(A2),(A3)
                
                MOVE.B      -(A0),(A1)+
                MOVE.W      -(A1),(A2)+
                MOVE.L      -(A2),(A3)+
                
                MOVE.B      -(A0),-(A1)
                MOVE.W      -(A1),-(A2)
                MOVE.L      -(A2),-(A3)
                
                * Absolute Long Address
                MOVE.B      $80000000, D0
                MOVE.W      $80200000, D1
                MOVE.L      $80300000, D2
                
                MOVE.B      $80000000, $6000
                MOVE.W      $80200000, $6020
                MOVE.L      $80300000, $6040
                
                MOVE.W      $80200000, A1
                MOVE.L      $80300000, A2
                
                MOVE.B      $80000000, (A1)
                MOVE.W      $80200000, (A2)
                MOVE.L      $80300000, (A3)
                
                MOVE.B      $80000000, (A1)+
                MOVE.W      $80200000, (A2)+
                MOVE.L      $80300000, (A3)+
                
                MOVE.B      $80000000, -(A1)
                MOVE.W      $80200000, -(A2)
                MOVE.L      $80300000, -(A3)
                
                * Absolute Word Address
                MOVE.B      $8000, D0
                MOVE.W      $8020, D1
                MOVE.L      $8030, D2
                
                MOVE.B      $8000, $6000
                MOVE.W      $8020, $6020
                MOVE.L      $8030, $6040
                
                MOVE.W      $8020, A1
                MOVE.L      $8030, A2
                
                MOVE.B      $8000, (A1)
                MOVE.W      $8020, (A2)
                MOVE.L      $8030, (A3)
                
                MOVE.B      $8000, (A1)+
                MOVE.W      $8020, (A2)+
                MOVE.L      $8030, (A3)+
                
                MOVE.B      $8000, -(A1)
                MOVE.W      $8020, -(A2)
                MOVE.L      $8030, -(A3)
                
    
* MOVEA test

MOVEATEST
                * Direct Adressing
                MOVEA.W     #$AAAB, A1
                MOVEA.L     #$AAAAAAAA, A2
                
                * Data Register Direct
                MOVEA.W     D1,A2
                MOVEA.L     D2,A3
                
                * Address Register Direct
                MOVEA.W     A1,A2
                MOVEA.L     A2,A3
                               
                * Address Register Indirect
                MOVEA.W     (A1)+,A2
                MOVEA.L     (A2)+,A3
                
                * Address Register Indirect with Post incrementing
                MOVEA.W     (A1)+,A2
                MOVEA.L     (A2)+,A3
                
                * Address Register Indirect with Pre decrementing
                MOVEA.W     -(A1),A2
                MOVEA.L     -(A2),A3
                
                * Absolute Long Address
                MOVEA.W     $80200000, A1
                MOVEA.L     $80300000, A2
                
                * Absolute Word Address
                MOVEA.W     $8020, A1
                MOVEA.L     $8030, A2
   
             
* MOVEQ test
MOVEQTEST
                MOVEQ.L     #2,D0
                MOVEQ       #3,D0
                
* MOVEM test
MOVEMTEST
                * Direct Adressing
                MOVEM       A0-A6/D0-D7,-(SP)
                MOVEM       (SP)+,A0-A6/D0-D7
  
* ADD test
ADDTEST
                * Direct Adressing
                ADD.B       #$A, D0
                ADD.W       #$AAAB, D1
                ADD.L       #$AAAAAAAA, D2
                
                ADD.B       #$A, $6000
                ADD.W       #$AAAB, $6020
                ADD.L       #$AAAAAAAA, $6040
                
                ADD.W       #$AAAB, A1
                ADD.L       #$AAAAAAAA, A2
                
                ADD.B       #$A, (A1)
                ADD.W       #$AAAB, (A2)
                ADD.L       #$AAAAAAAA, (A3)
                 
                ADD.B       #$A, (A1)+
                ADD.W       #$AAAB, (A2)+
                ADD.L       #$AAAAAAAA, (A3)+
                
                ADD.B       #$A, -(A1)
                ADD.W       #$AAAB, -(A2)
                ADD.L       #$AAAAAAAA, -(A3)
                
                * Data Register Direct
                ADD.B       D0,D1
                ADD.W       D1,D3
                ADD.L       D2,D4
                
                ADD.B       D0,$6000
                ADD.W       D1,$6020
                ADD.L       D2,$6040
                
                ADD.W       D1,A2
                ADD.L       D2,A3
                
                ADD.B       D0,(A1)
                ADD.W       D1,(A2)
                ADD.L       D2,(A3)
                
                ADD.B       D0,(A1)+
                ADD.W       D1,(A2)+
                ADD.L       D2,(A3)+
                
                ADD.B       D0,-(A1)
                ADD.W       D1,-(A2)
                ADD.L       D2,-(A3)
                
                * Address Register Direct
                ADD.W       A1,D3
                ADD.L       A2,D4
                
                ADD.L       D2,$6040
                
                ADD.W       A1,A2
                ADD.L       A2,A3
                
                * Address Register Indirect
                ADD.B      (A0),D1
                ADD.W      (A1),D3
                ADD.L      (A2),D4
                
                ADD.W      (A1),A2
                ADD.L      (A2),A3
                
                * Address Register Indirect with Post incrementing
                ADD.B      (A0)+,D1
                ADD.W      (A1)+,D3
                ADD.L      (A2)+,D4
                
                ADD.W      (A1)+,A2
                ADD.L      (A2)+,A3

                * Address Register Indirect with Pre decrementing
                ADD.B      -(A0),D1
                ADD.W      -(A1),D3
                ADD.L      -(A2),D4
                
                ADD.W      -(A1),A2
                ADD.L      -(A2),A3
                
                * Absolute Long Address
                ADD.B      $80000000, D0
                ADD.W      $80200000, D1
                ADD.L      $80300000, D2
                
                ADD.W      $80200000, A1
                ADD.L      $80300000, A2
                
                * Absolute Word Address
                ADD.B      $8000, D0
                ADD.W      $8020, D1
                ADD.L      $8030, D2
                
                ADD.W      $8020, A1
                ADD.L      $8030, A2
    
* ADDA test
ADDATEST
                * Direct Adressing
                ADDA.W      #$AAAB, A1
                ADDA.L      #$AAAAAAAA, A2
                
                * Data Register Direct
                ADDA.W      D1,A2
                ADDA.L      D2,A3
                
                * Address Register Direct
                ADDA.W      A1,A2
                ADDA.L      A2,A3
                
                * Address Register Indirect                
                ADDA.W     (A1),A2
                ADDA.L     (A2),A3
                
                * Address Register Indirect with Post incrementing            
                ADDA.W     (A1)+,A2
                ADDA.L     (A2)+,A3
                
                * Address Register Indirect with Pre decrementing
                ADDA.W     -(A1),A2
                ADDA.L     -(A2),A3
                
                * Absolute Long Address
                ADDA.W     $80200000, A1
                ADDA.L     $80300000, A2
                
                * Absolute Word Address
                ADDA.W     $8020, A1
                ADDA.L     $8030, A2
    
* ADDQ test
ADDQTEST
                ADDQ.L     #2,D0
                ADDQ       #3,D0
    
* SUB test
SUBTEST
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
    
* MULS test
MULSTEST
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
    
* DIVU test
DIVUTEST
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address  
  
* LEA test
LEATEST            
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
    
* AND test
ANDTEST
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
                
* OR test
ORTEST
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address

* NOT test
NOTTEST
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
                
* LSL test
LSLTEST
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
                
* LSR test
LSRTEST
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address

* ASL test
ASLTEST
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
    
* ASR test
ASRTEST
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
    
* Bcc test
BCCTEST
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address

* JSR test
JSRTEST             
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
    
* RTS test
RTSTEST
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
    
* BRA test 
BRATEST
                * Direct Adressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address

    SIMHALT             ; halt simulator

* Clears all registers
CLEAR           CLR.L   D0
                CLR.L   D1
                CLR.L   D2
                CLR.L   D3
                CLR.L   D4
                CLR.L   D5
                CLR.L   D6
                CLR.L   D7
                CLR.L   (A0)
                CLR.L   (A1)
                CLR.L   (A2)
                CLR.L   (A3)
                CLR.L   (A4)
                CLR.L   (A5)
                CLR.L   (A6)
                RTS


    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
