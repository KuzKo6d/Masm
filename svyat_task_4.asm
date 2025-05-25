include console.inc

.DATA
      trash dd ?
      b1 db 4
      b2 db 2
      b3 db 1
.CODE
CALL_THREE macro op0, op1, op2, op3
      local overflow_1, overflow_2, overflow_3, overflow, fin, param, big, dal
      OUTSTRLN "CALL_THREE &op0& &op1& &op2& &op3&"
      IFB <op0>
            OUTSTRLN "ERROR 2: WHERE IS 1 PARAM?"
            exitm
      ELSEIFB <op1>
            OUTSTRLN "ERROR 2: WHERE IS 2 PARAM?"
            exitm
      ELSEIFB <op2>
            OUTSTRLN "ERROR 2: WHERE IS 3 PARAM?"
            exitm
      ELSEIFB <op3>
            OUTSTRLN "ERROR 2: WHERE IS 4 PARAM?"
            exitm
      ENDIF

      IFDIFI <op0>, <MSUB>
            IFDIFI <op0>, <MDIV>
                  OUTSTRLN "ERROR 1: WRONG OPERATION"
                  jmp fin
            ENDIF
      ENDIF

      IF type op1 EQ 0 and type op2 EQ 0 and type op3 EQ 0
            OUTSTRLN "ERROR 5: THREE CONST"
            exitm
      ELSEIF type op1 EQ 4 or type op2 EQ 4 or type op3 EQ 4
            OUTSTRLN "ERROR 3: DWORD AS OPERAND"
            exitm
      ENDIF

      push EAX
      push EBX
      push ECX
      push EDX
      IFIDNI <op0>, <MSUB>
            IFDIFI <op1>, <AX>
                  IF type op1 NE 0
                        if type op1 EQ 1
                              movzx AX, op1
                        ELSE
                              mov AX, op1
                        ENDIF
                  ELSE
                        mov AX, op1
                  ENDIF
            ENDIF
            IFIDNI <op2>, <AX>
                  MOV BX, WORD PTR [ESP+12]
            ELSEIFIDNI <op2>, <AH>
                  MOVZX BX, BYTE PTR [ESP+13]
            ELSEIFIDNI <op2>, <AL>
                  MOVZX BX, BYTE PTR [ESP+12]
            ELSEIF type op2 EQ 0
                  MOV BX, op2
            ELSE
                  IF type op2 EQ 2
                        mov BX, op2
                  ELSE
                        MOVZX BX, op2
                  ENDIF
            ENDIF
            SUB AX, BX
            IFIDNI <op3>, <AX>
                  MOV CX, WORD PTR [ESP+12]
            ELSEIFIDNI <op3>, <AH>
                  MOVZX CX, BYTE PTR [ESP+13]
            ELSEIFIDNI <op3>, <AL>
                  MOVZX CX, BYTE PTR [ESP+12]
            ELSEIFIDNI <op3>, <BX>
                  MOV CX, WORD PTR [ESP+8]
            ELSEIFIDNI <op3>, <BH>
                  MOVZX CX, BYTE PTR [ESP+9]
            ELSEIFIDNI <op3>, <BL>
                  MOVZX CX, BYTE PTR [ESP+8]
            ELSEIF type op3 EQ 0
                  MOV CX, op3
            ELSEif type op3 EQ 1
                  MOVZX CX, op3
            ELSE
                  MOV CX, op3
            ENDIF
            SUB AX, CX
            IF type op1 EQ 0
                  IF type op2 EQ 0
                        IF type op3 EQ 1
                              cmp AH, 0
                              je overflow_3
                              cmp AH, -1
                              JE overflow_3
                              jmp overflow
                        overflow_3:
                              mov op3, AL
                              OUTSTR "Result: "
                              outintln op3
                              IFIDNI <op3>, <AL>
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP trash
                                    JMP fin
                              ELSEIFIDNI <op3>, <AH>
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP trash
                                    JMP fin
                              ELSEIFIDNI <op3>, <BL>
                                    POP EDX
                                    POP ECX
                                    POP trash
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op3>, <BH>
                                    POP EDX
                                    POP ECX
                                    POP trash
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op3>, <CL>
                                    POP EDX
                                    POP trash
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op3>, <CH>
                                    POP EDX
                                    POP trash
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op3>, <DL>
                                    POP trash
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op3>, <DH>
                                    POP trash
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSE
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    jmp fin
                              ENDIF
                        ELSE
                              mov op3, AX
                              OUTSTR "Result: "
                              outintln op3
                              IFIDNI <op3>, <AX>
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP trash
                                    JMP fin
                              ELSEIFIDNI <op3>, <BX>
                                    POP EDX
                                    POP ECX
                                    POP trash
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op3>, <CX>
                                    POP EDX
                                    POP trash
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op3>, <DX>
                                    POP trash
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSE
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    jmp fin
                              ENDIF
                        ENDIF
                  ELSEIF type op2 EQ 1
                  cmp AH, 0
                        je overflow_2
                        cmp AH, -1
                        JE overflow_2
                        jmp overflow
                  overflow_2:
                        mov op2, AL
                        OUTSTR "Result: "
                        outintln op2
                        IFIDNI <op2>, <AL>
                              POP EDX
                              POP ECX
                              POP EBX
                              POP trash
                              JMP fin
                        ELSEIFIDNI <op2>, <AH>
                              POP EDX
                              POP ECX
                              POP EBX
                              POP trash
                              JMP fin
                        ELSEIFIDNI <op2>, <BL>
                              POP EDX
                              POP ECX
                              POP trash
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op2>, <BH>
                              POP EDX
                              POP ECX
                              POP trash
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op2>, <CL>
                              POP EDX
                              POP trash
                              POP EBX
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op2>, <CH>
                              POP EDX
                              POP trash
                              POP EBX
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op2>, <DL>
                              POP trash
                              POP ECX
                              POP EBX
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op2>, <DH>
                              POP trash
                              POP ECX
                              POP EBX
                              POP EAX
                              JMP fin
                        ELSE
                              POP EDX
                              POP ECX
                              POP EBX
                              POP EAX
                              jmp fin
                        ENDIF
                  ELSE
                        mov op2, AX
                        OUTSTR "Result: "
                        outintln op2
                        IFIDNI <op2>, <AX>
                              POP EDX
                              POP ECX
                              POP EBX
                              POP trash
                              JMP fin
                        ELSEIFIDNI <op2>, <BX>
                              POP EDX
                              POP ECX
                              POP trash
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op2>, <CX>
                              POP EDX
                              POP trash
                              POP EBX
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op2>, <DX>
                              POP trash
                              POP ECX
                              POP EBX
                              POP EAX
                              JMP fin
                        ELSE
                              POP EDX
                              POP ECX
                              POP EBX
                              POP EAX
                              jmp fin
                        ENDIF
                  ENDIF
            ELSEIF type op1 EQ 1
                  cmp AH, 0
                  je overflow_1
                  cmp AH, -1
                  je overflow_1
                  jmp overflow
            overflow_1:
                  mov op1, AL
                  OUTSTR "Result: "
                  outintln op1
                  IFIDNI <op1>, <AL>
                        POP EDX
                        POP ECX
                        POP EBX
                        POP trash
                        JMP fin
                  ELSEIFIDNI <op1>, <AH>
                        POP EDX
                        POP ECX
                        POP EBX
                        POP trash
                        JMP fin
                  ELSEIFIDNI <op1>, <BL>
                        POP EDX
                        POP ECX
                        POP trash
                        POP EAX
                        JMP fin
                  ELSEIFIDNI <op1>, <BH>
                        POP EDX
                        POP ECX
                        POP trash
                        POP EAX
                        JMP fin
                  ELSEIFIDNI <op1>, <CL>
                        POP EDX
                        POP trash
                        POP EBX
                        POP EAX
                        JMP fin
                  ELSEIFIDNI <op1>, <CH>
                        POP EDX
                        POP trash
                        POP EBX
                        POP EAX
                        JMP fin
                  ELSEIFIDNI <op1>, <DL>
                        POP trash
                        POP ECX
                        POP EBX
                        POP EAX
                        JMP fin
                  ELSEIFIDNI <op1>, <DH>
                        POP trash
                        POP ECX
                        POP EBX
                        POP EAX
                        JMP fin
                  ELSE
                        POP EDX
                        POP ECX
                        POP EBX
                        POP EAX
                        jmp fin
                  ENDIF
            ELSE
                  mov op1, AX
                  OUTSTR "Result: "
                  outintln op1
                  IFIDNI <op1>, <AX>
                        POP EDX
                        POP ECX
                        POP EBX
                        POP trash
                        JMP fin
                  ELSEIFIDNI <op1>, <BX>
                        POP EDX
                        POP ECX
                        POP trash
                        POP EAX
                        JMP fin
                  ELSEIFIDNI <op1>, <CX>
                        POP EDX
                        POP trash
                        POP EBX
                        POP EAX
                        JMP fin
                  ELSEIFIDNI <op1>, <DX>
                        POP trash
                        POP ECX
                        POP EBX
                        POP EAX
                        JMP fin
                  ELSE
                        POP EDX
                        POP ECX
                        POP EBX
                        POP EAX
                        jmp fin
                  ENDIF
            ENDIF

      ELSEIFIDNI <op0>, <MDIV>
            IF type op3 EQ 2
                  if type op2 EQ 2
                        MOVZX EAX, WORD PTR op2
                  ELSEIF type op2 EQ 1
                        MOVZX EAX, byte PTR op2
                  ELSE
                        mov eax, op2
                  ENDIF
                  IFIDNI <op3>, <AX>
                        mov BX, WORD PTR [ESP+12]
                  ELSE
                        MOV BX, op3
                  ENDIF
            ELSEIF type op2 EQ 2
                  mov ax, op2
                  ifidni <op3>, <AL>
                        MOV BL, BYTE PTR [ESP+12]
                        mov BH, 0
                  ELSEIFIDNI <op3>, <AH>
                        MOV BL, BYTE PTR [ESP+13]
                        mov BH, 0
                  ELSE
                        mov BL, op3
                        mov BH, 0
                  ENDIF
            ELSE
                  if type op2 EQ 0
                        mov ax, op2
                  ELSE
                        MOVZX AX, op2
                  ENDIF
                  ifidni <op3>, <AL>
                        MOV BL, BYTE PTR [ESP+12]
                        mov BH, 0
                  ELSEIFIDNI <op3>, <AH>
                        MOV BL, BYTE PTR [ESP+13]
                        mov BH, 0
                  ELSE
                        mov BL, op3
                        mov BH, 0
                  ENDIF
            ENDIF
            cmp BX, 0
            JE div_0
            IF type op3 EQ 2
                  MOV EDX, 0
                  div BX
                  IF type op1 EQ 0
                        MOV CX, op1
                        ADD AX, CX
                        jc overflow
                        IF type op2 EQ 0
                              if type op3 EQ 1
                                    jmp overflow
                              ELSE
                                    mov op3, AX
                                    OUTSTR "RESULT: "
                                    outint op3
                                    IFIDNI <op3>, <AX>
                                          POP EDX
                                          POP ECX
                                          POP EBX
                                          POP trash
                                          JMP fin
                                    ELSEIFIDNI <op3>, <BX>
                                          POP EDX
                                          POP ECX
                                          POP trash
                                          POP EAX
                                          JMP fin
                                    ELSEIFIDNI <op3>, <CX>
                                          POP EDX
                                          POP trash
                                          POP EBX
                                          POP EAX
                                          JMP fin
                                    ELSEIFIDNI <op3>, <DX>
                                          POP trash
                                          POP ECX
                                          POP EBX
                                          POP EAX
                                          JMP fin
                                    ELSE
                                          POP EDX
                                          POP ECX
                                          POP EBX
                                          POP EAX
                                          jmp fin
                                    ENDIF
                              ENDIF
                        ELSEIF type op2 EQ 1
                              jmp overflow
                        ELSE
                              mov op2, AX
                              OUTSTR "RESULT: "
                              outint op2
                              IFIDNI <op2>, <AX>
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP trash
                                    JMP fin
                              ELSEIFIDNI <op2>, <BX>
                                    POP EDX
                                    POP ECX
                                    POP trash
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op2>, <CX>
                                    POP EDX
                                    POP trash
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op2>, <DX>
                                    POP trash
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSE
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    jmp fin
                              ENDIF
                        ENDIF
                  ELSEIF type op1 EQ 1
                        jmp overflow
                  ELSE
                        IFIDNI <op1>, <AX>
                              MOV CX, WORD ptr [ESP+12]
                        ELSEIFIDNI <op1>, <BX>
                              MOV CX, WORD ptr [ESP+8]
                        ELSEIFIDNI <op1>, <DX>
                              MOV CX, WORD ptr [ESP]
                        ELSE
                              MOV CX, op1
                        ENDIF
                        ADD AX, CX
                        MOV op1, AX
                        OUTSTR "RESULT: "
                        outint op1
                        IFIDNI <op1>, <AX>
                              POP EDX
                              POP ECX
                              POP EBX
                              POP trash
                              JMP fin
                        ELSEIFIDNI <op1>, <BX>
                              POP EDX
                              POP ECX
                              POP trash
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op1>, <CX>
                              POP EDX
                              POP trash
                              POP EBX
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op1>, <DX>
                              POP trash
                              POP ECX
                              POP EBX
                              POP EAX
                              JMP fin
                        ELSE
                              POP EDX
                              POP ECX
                              POP EBX
                              POP EAX
                              jmp fin
                        ENDIF
                  ENDIF
            ELSE
                  DIV BL
                  IF type op1 EQ 0
                        MOV CL, op1
                        ADD AL, CL
                        jc overflow
                        IF type op2 EQ 0
                              mov op3, Al
                              OUTSTR "RESULT: "
                              outint op3
                              IFIDNI <op3>, <AL>
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP trash
                                    JMP fin
                              ELSEIFIDNI <op3>, <AH>
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP trash
                                    JMP fin
                              ELSEIFIDNI <op3>, <BL>
                                    POP EDX
                                    POP ECX
                                    POP trash
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op3>, <BH>
                                    POP EDX
                                    POP ECX
                                    POP trash
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op3>, <CL>
                                    POP EDX
                                    POP trash
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op3>, <CH>
                                    POP EDX
                                    POP trash
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op3>, <DL>
                                    POP trash
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op3>, <DH>
                                    POP trash
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSE
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    jmp fin
                              ENDIF
                        ELSEIF type op2 EQ 2
                              MOVZX op2, AL
                              OUTSTR "RESULT: "
                              outint op2
                              IFIDNI <op2>, <AX>
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP trash
                                    JMP fin
                              ELSEIFIDNI <op2>, <BX>
                                    POP EDX
                                    POP ECX
                                    POP trash
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op2>, <CX>
                                    POP EDX
                                    POP trash
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op2>, <DX>
                                    POP trash
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSE
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    jmp fin
                              ENDIF
                        ELSE
                              mov op2, Al
                              OUTSTR "RESULT: "
                              outint op2
                              IFIDNI <op2>, <AL>
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP trash
                                    JMP fin
                              ELSEIFIDNI <op2>, <AH>
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP trash
                                    JMP fin
                              ELSEIFIDNI <op2>, <BL>
                                    POP EDX
                                    POP ECX
                                    POP trash
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op2>, <BH>
                                    POP EDX
                                    POP ECX
                                    POP trash
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op2>, <CL>
                                    POP EDX
                                    POP trash
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op2>, <CH>
                                    POP EDX
                                    POP trash
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op2>, <DL>
                                    POP trash
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSEIFIDNI <op2>, <DH>
                                    POP trash
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    JMP fin
                              ELSE
                                    POP EDX
                                    POP ECX
                                    POP EBX
                                    POP EAX
                                    jmp fin
                              ENDIF
                        ENDIF
                  ELSEIF type op1 EQ 2
                        IFIDNI <op1>, <AX>
                              MOV CX, WORD ptr [ESP+12]
                        ELSEIFIDNI <op1>, <BX>
                              MOV CX, WORD ptr [ESP+8]
                        ELSEIFIDNI <op1>, <DX>
                              MOV CX, WORD ptr [ESP]
                        ELSE
                              MOV CX, op1
                        ENDIF
                        movzx ax, AL
                        add cx, AX
                        mov op1, cx
                        OUTSTR "RESULT: "
                        outint op1
                        IFIDNI <op1>, <AX>
                              POP EDX
                              POP ECX
                              POP EBX
                              POP trash
                              JMP fin
                        ELSEIFIDNI <op2>, <BX>
                              POP EDX
                              POP ECX
                              POP trash
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op2>, <CX>
                              POP EDX
                              POP trash
                              POP EBX
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op2>, <DX>
                              POP trash
                              POP ECX
                              POP EBX
                              POP EAX
                              JMP fin
                        ELSE
                              POP EDX
                              POP ECX
                              POP EBX
                              POP EAX
                              jmp fin
                        ENDIF
                  ELSE
                        IFIDNI <op1>, <AL>
                              MOV CL, BYTE ptr [ESP+12]
                        ELSEIFIDNI <op1>, <AH>
                              MOV CL, BYTE ptr [ESP+13]
                        ELSEIFIDNI <op1>, <BL>
                              MOV CL, BYTE ptr [ESP+8]
                        ELSEIFIDNI <op1>, <BH>
                              MOV CL, BYTE ptr [ESP+9]
                        ELSEIFIDNI <op1>, <DL>
                              MOV CL, BYTE ptr [ESP]
                        ELSEIFIDNI <op1>, <DH>
                              MOV CL, BYTE ptr [ESP+1]
                        ELSE
                              MOV CL, op1
                        ENDIF
                        ADD Al, Cl
                        MOV op1, AL
                        OUTSTR "RESULT: "
                        outint op1
                        IFIDNI <op1>, <AL>
                              POP EDX
                              POP ECX
                              POP EBX
                              POP trash
                              JMP fin
                        ELSEIFIDNI <op1>, <AH>
                              POP EDX
                              POP ECX
                              POP EBX
                              POP trash
                              JMP fin
                        ELSEIFIDNI <op1>, <BL>
                              POP EDX
                              POP ECX
                              POP trash
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op1>, <BH>
                              POP EDX
                              POP ECX
                              POP trash
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op1>, <CL>
                              POP EDX
                              POP trash
                              POP EBX
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op1>, <CH>
                              POP EDX
                              POP trash
                              POP EBX
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op1>, <DL>
                              POP trash
                              POP ECX
                              POP EBX
                              POP EAX
                              JMP fin
                        ELSEIFIDNI <op1>, <DH>
                              POP trash
                              POP ECX
                              POP EBX
                              POP EAX
                              JMP fin
                        ELSE
                              POP EDX
                              POP ECX
                              POP EBX
                              POP EAX
                              jmp fin
                        ENDIF
                  ENDIF
            ENDIF
            JMP param
      ENDIF
      

overflow:
      OUTSTR "ERROR 4: OVERFLOW"
      jmp param
div_0:
      OUTSTR "ERROR 8: DIV BY 0"
param:
      POP EDX
      POP ECX
      POP EBX
      POP EAX
fin:
endm

start:
      mov EAX, 346
      mov EBX, 4
      MOV ECX, 1
      CALL_THREE MDIV, AL, BL, CL
      EXIT 0
END start