*-----------------------------------------------------------
* Title      :  Test Code
* Written by :  Audrey Nguyen
* Date       :  06/10/2020
* Description:  Version 4
*-----------------------------------------------------------
    ORG    $9000
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
                LSL.B       #1,D0
                LSL.W       #2,D2
                LSL.L       #3,D3
                
                LSL.B       D0,D1
                LSL.W       D2,D7
                LSL.L       D3,D4
                
                LSL.W       $0000A000
                LSL.W       $21(A4)
                LSL.W       (A6)
                LSL.W       (A1)+
                LSL.W       -(A2)
                
                
* LSR test
LSRTEST
                LSR.B       #1,D0
                LSR.W       #2,D2
                LSR.L       #3,D3
                
                LSR.B       D0,D1
                LSR.W       D2,D7
                LSR.L       D3,D4
                
                LSR.W       $0000A000
                LSR.W       $BBBB
                LSR.W       (A6)
                LSR.W       (A1)+
                LSR.W       -(A2)

* ASL test
ASLTEST 
                ASL.B       #1,D0
                ASL.W       #2,D2
                ASL.L       #3,D3
                
                ASL.B       D0,D1
                ASL.W       D2,D7
                ASL.L       D3,D4
                
                ASL.W       $0000A000
                ASL.W       $21(A4)
                ASL.W       (A6)
                ASL.W       (A1)+
                ASL.W       -(A2)
               
    
* ASR test
ASRTEST
                ASR.B       #1,D0
                ASR.W       #2,D2
                ASR.L       #3,D3
                
                ASR.B       D0,D1
                ASR.W       D2,D7
                ASR.L       D3,D4
                
                ASR.W       $0000A000
                ASR.W       $BBBB
                ASR.W       (A6)
                ASR.W       (A1)+
                ASR.W       -(A2)
* ROL test
ROLTEST 
                ROL.B       #1,D0
                ROL.W       #2,D2
                ROL.L       #3,D3
                
                ROL.B       D0,D1
                ROL.W       D2,D7
                ROL.L       D3,D4
                
                ROL.W       $0000A000
                ROL.W       $21(A4)
                ROL.W       (A6)
                ROL.W       (A1)+
                ROL.W       -(A2)
               
    
* ROR test
RORTEST
                ROR.B       #1,D0
                ROR.W       #2,D2
                ROR.L       #3,D3
                
                ROR.B       D0,D1
                ROR.W       D2,D7
                ROR.L       D3,D4
                
                ROR.W       $0000A000
                ROR.W       $BBBB
                ROR.W       (A6)
                ROR.W       (A1)+
                ROR.W       -(A2)

    
* JSR & RTS test
JSRTEST             
                JSR     SUBROUTINE
* Bcc & BRA test 
BCCTEST
                BCC         BRANCH
                BCS         BRANCH
                BEQ         BRANCH
                BNE         BRANCH
                BGE         BRANCH
                BGT         BRANCH
                BHI         BRANCH
                BLE         BRANCH
                BLS         BRANCH
                BLT         BRANCH
                BMI         BRANCH
                BPL         BRANCH
                BVC         BRANCH
                BVS         BRANCH

BRANCH 
BRATEST
                BRA         TESTBRANCH
                
TESTBRANCH                

    SIMHALT             ; halt simulator

SUBROUTINE      RTS

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
