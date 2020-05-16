*-----------------------------------------------------------
* Title      :  Test Code
* Written by :  Audrey Nguyen
* Date       :  05/15/2020
* Description:  Version 2
*-----------------------------------------------------------
    ORG    $1000
START:                  
* NOP test
                NOP

* MOVE test
MOVETEST            
                * Direct Addressing
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
                MOVE.L      A2,$6040
                
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
                * Direct Addressing
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
                * Direct Addressing
                MOVEM       A0-A6/D0-D7,-(SP)
                MOVEM       (SP)+,A0-A6/D0-D7
  
* ADD test
ADDTEST
                * Direct Addressing
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
                * Direct Addressing
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
                ADDA.W      $80200000, A1
                ADDA.L      $80300000, A2
                
                * Absolute Word Address
                ADDA.W      $8020, A1
                ADDA.L      $8030, A2
    
* ADDQ test
ADDQTEST
                ADDQ.L      #2,D0
                ADDQ        #3,D0
    
* SUB test
SUBTEST
                * Direct Addressing
                SUB.B       #$A, D0
                
                SUB.W       #$AAAB, D1
                SUB.L       #$AAAAAAAA, D2
                
                SUB.B       #$A, $6000
                SUB.W       #$AAAB, $6020
                SUB.L       #$AAAAAAAA, $6040
                
                SUB.W       #$AAAB, A1
                SUB.L       #$AAAAAAAA, A2
                
                SUB.B       #$A, (A1)
                SUB.W       #$AAAB, (A2)
                SUB.L       #$AAAAAAAA, (A3)
                
                SUB.B       #$A, (A1)+
                SUB.W       #$AAAB, (A2)+
                SUB.L       #$AAAAAAAA, (A3)+
                
                SUB.B       #$A, -(A1)
                SUB.W       #$AAAB, -(A2)
                SUB.L       #$AAAAAAAA, -(A3)
                
                * Data Register Direct
                SUB.B       D0,D1
                SUB.W       D1,D3
                SUB.L       D2,D4
                
                SUB.B       D0,$6000
                SUB.W       D1,$6020
                SUB.L       D2,$6040
                
                SUB.W       D1,A2
                SUB.L       D2,A3
                
                SUB.B       D0,(A1)
                SUB.W       D1,(A2)
                SUB.L       D2,(A3)
                
                SUB.B       D0,(A1)+
                SUB.W       D1,(A2)+
                SUB.L       D2,(A3)+
                
                SUB.B       D0,-(A1)
                SUB.W       D1,-(A2)
                SUB.L       D2,-(A3)
                
                * Address Register Direct
                SUB.W       A1,D3
                SUB.L       A2,D4
                
                SUB.W       A1,A2
                SUB.L       A2,A3
                
                * Address Register Indirect
                SUB.B       (A0),D1
                SUB.W       (A1),D3
                SUB.L       (A2),D4
                
                SUB.W       (A1),A2
                SUB.L       (A2),A3
                
                * Address Register Indirect with Post incrementing
                SUB.B       (A0)+,D1
                SUB.W       (A1)+,D3
                SUB.L       (A2)+,D4
                
                SUB.W       (A1)+,A2
                SUB.L       (A2)+,A3
                
                * Address Register Indirect with Pre decrementing
                SUB.B       -(A0),D1
                SUB.W       -(A1),D3
                SUB.L       -(A2),D4
                
                SUB.W       -(A1),A2
                SUB.L       -(A2),A3
                
                * Absolute Long Address
                SUB.B       $80000000, D0
                SUB.W       $80200000, D1
                SUB.L       $80300000, D2
                
                SUB.W       $80200000, A1
                SUB.L       $80300000, A2
                
                * Absolute Word Address
                SUB.B       $8000, D0
                SUB.W       $8020, D1
                SUB.L       $8030, D2
                
                SUB.W       $8020, A1
                SUB.L       $8030, A2
    
* MULS test
MULSTEST
                * Direct Addressing
                MULS.W      #$AAAB, D1
                
                * Data Register Direct
                MULS.W      D1,D3
                               
                * Address Register Indirect
                MULS.W      (A1),D3
                
                * Address Register Indirect with Post incrementing
                MULS.W      (A1)+,D3
                
                * Address Register Indirect with Pre decrementing
                MULS.W      -(A1),D3
                                
                * Absolute Long Address
                MULS.W      $80200000, D1
                
                * Absolute Word Address
                MULS.W      $8020, D1
    
* DIVU test
DIVUTEST
                * Direct Addressing
                DIVU.W      #$AAAB, D1
                
                * Data Register Direct
                DIVU.W      D1,D3
                               
                * Address Register Indirect
                DIVU.W      (A1),D3
                
                * Address Register Indirect with Post incrementing
                DIVU.W      (A1)+,D3
                
                * Address Register Indirect with Pre decrementing
                DIVU.W      -(A1),D3
                                
                * Absolute Long Address
                DIVU.W      $80200000, D1
                
                * Absolute Word Address
                DIVU.W      $8020, D1
  
* LEA test
LEATEST            
                LEA         (A1),A0
                LEA         $6000,A1
                LEA         $80000000,A2
                  
* AND test
ANDTEST
                * Direct Addressing
                AND.B       #$A, D0
                AND.W       #$AAAB, D1
                AND.L       #$AAAAAAAA, D2
                
                AND.B       #$A, $6000
                AND.W       #$AAAB, $6020
                AND.L       #$AAAAAAAA, $6040
                
                AND.B       #$A, (A1)
                AND.W       #$AAAB, (A2)
                AND.L       #$AAAAAAAA, (A3)
                
                AND.B       #$A, (A1)+
                AND.W       #$AAAB, (A2)+
                AND.L       #$AAAAAAAA, (A3)+
                
                AND.B       #$A, -(A1)
                AND.W       #$AAAB, -(A2)
                AND.L       #$AAAAAAAA, -(A3)

                * Data Register Direct
                AND.B       D0,D1
                AND.W       D1,D3
                AND.L       D2,D4
                
                AND.B       D0,$6000
                AND.W       D1,$6020
                AND.L       D2,$6040
                
                AND.B       D0,(A1)
                AND.W       D1,(A2)
                AND.L       D2,(A3)
                
                AND.B       D0,(A1)+
                AND.W       D1,(A2)+
                AND.L       D2,(A3)+
                
                AND.B       D0,-(A1)
                AND.W       D1,-(A2)
                AND.L       D2,-(A3)
                
                * Address Register Indirect
                AND.B       (A0),D1
                AND.W       (A1),D3
                AND.L       (A2),D4
                
                * Address Register Indirect with Post incrementing
                AND.B       (A0)+,D1
                AND.W       (A1)+,D3
                AND.L       (A2)+,D4
                
                * Address Register Indirect with Pre decrementing
                AND.B       -(A0),D1
                AND.W       -(A1),D3
                AND.L       -(A2),D4

                * Absolute Long Address
                AND.B       $80000000, D0
                AND.W       $80200000, D1
                AND.L       $80300000, D2
                
                * Absolute Word Address
                AND.B       $8000, D0
                AND.W       $8020, D1
                AND.L       $8030, D2

* OR test
                * Direct Addressing
                OR.B        #$A, D0
                OR.W        #$AAAB, D1
                OR.L        #$AAAAAAAA, D2
                
                OR.B        #$A, $6000
                OR.W        #$AAAB, $6020
                OR.L        #$AAAAAAAA, $6040
                
                OR.B        #$A, (A1)
                OR.W        #$AAAB, (A2)
                OR.L        #$AAAAAAAA, (A3)
                
                OR.B        #$A, (A1)+
                OR.W        #$AAAB, (A2)+
                OR.L        #$AAAAAAAA, (A3)+
                 
                OR.B        #$A, -(A1)
                OR.W        #$AAAB, -(A2)
                OR.L        #$AAAAAAAA, -(A3)

                * Data Register Direct
                OR.B        D0,D1
                OR.W        D1,D3
                OR.L        D2,D4
                
                OR.B        D0,$6000
                OR.W        D1,$6020
                OR.L        D2,$6040
                
                OR.B        D0,(A1)
                OR.W        D1,(A2)
                OR.L        D2,(A3)
                
                OR.B        D0,(A1)+
                OR.W        D1,(A2)+
                OR.L        D2,(A3)+
                
                OR.B        D0,-(A1)
                OR.W        D1,-(A2)
                OR.L        D2,-(A3)
 
                * Address Register Indirect
                OR.B        (A0),D1
                OR.W        (A1),D3
                OR.L        (A2),D4

                * Address Register Indirect with Post incrementing
                OR.B        -(A0),D1
                OR.W        -(A1),D3
                OR.L        -(A2),D4

                * Address Register Indirect with Pre decrementing
                OR.B        (A0)+,D1
                OR.W        (A1)+,D3
                OR.L        (A2)+,D4

                * Absolute Long Address
                OR.B        $80000000, D0
                OR.W        $80200000, D1
                OR.L        $80300000, D2

                * Absolute Word Address
                OR.B        $8000, D0
                OR.W        $8020, D1
                OR.L        $8030, D2

* NOT test
NOTTEST
                * Direct Addressing
                
                * Data Register Direct
                NOT.B       D0
                NOT.W       D1
                NOT.L       D2
                                
                * Address Register Indirect
                NOT.B       (A0)
                NOT.W       (A1)
                NOT.L       (A2)

                * Address Register Indirect with Post incrementing
                NOT.B       (A0)+
                NOT.W       (A1)+
                NOT.L       (A2)+

                * Address Register Indirect with Pre decrementing
                NOT.B       -(A0)
                NOT.W       -(A1)
                NOT.L       -(A2)
                
                * Absolute Long Address
                NOT.B       $00AFF0000 
                NOT.W       $00BFF0000  
                NOT.L       $00CFF0000
                
                * Absolute Word Address
                NOT.B       $00AFF
                NOT.W       $00BFF 
                NOT.L       $00CFF     
                
* LSL test
LSLTEST
                * Direct Addressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
                
* LSR test
LSRTEST
                * Direct Addressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address

* ASL test
ASLTEST
                * Direct Addressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
    
* ASR test
ASRTEST
                * Direct Addressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
    
* Bcc test
BCCTEST
                * Direct Addressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address

* JSR test
JSRTEST             
                * Direct Addressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
    
* RTS test
RTSTEST
                * Direct Addressing
                
                * Data Register Direct
                
                * Address Register Direct
                
                * Address Register Indirect
                
                * Address Register Indirect with Post incrementing
                
                * Address Register Indirect with Pre decrementing
                
                * Absolute Long Address
                
                * Absolute Word Address
    
* BRA test 
BRATEST
                * Direct Addressing
                
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
