include console.inc

; MADD, MMUL, unsigned, m8/r8, m16/m16

.data
; messages
  miumiu db 'miumiu', 0
  E_empty db 'CALC_THREE: empty param.', 0
  E_overflow db 'CALC_THREE: param1 oveflow.', 0
  E_invalid_operation db 'CALC_THREE: invalid operation.', 0
  E_size db 'CALC_THREE: invalid size of param.', 0
  inp1 db 'param1: ', 0
  inp2 db 'param2: ', 0
  inp3 db 'param3: ', 0
  out1 db 'output: ', 0
; mem
  b1 db 1
  b2 db 2
  b3 db 3
  w1 dw 1
  w2 dw 2
  w3 dw 3
  d1 dd 1
  C = 5


.code
  CALC_THREE MACRO p0, p1, p2, p3
  LOCAL Overflow, Finish

  ; CHECKS
  ; blank check
  IFB <P0>
    OUTSTRLN offset E_empty
    exitm
  ELSEIFB <P1>
    OUTSTRLN offset E_empty
    exitm
   ELSEIFB <P2>
    OUTSTRLN offset E_empty
    exitm
   ELSEIFB <P3>
    OUTSTRLN offset E_empty
    exitm
  ENDIF 
  ; size check
  FOR i, <p1, p2, p3>
    IF (TYPE i EQ 4) OR (TYPE i EQ 0)
      OUTSTRLN offset E_size
      exitm
    ENDIF
  ENDM

  ; PUSH
  push eax
  push ebx
  push ecx

  ; MAIN
  ; madd: p1 := p1 + p2 + p3
  IFIDNI <p0>, <MADD>
    ; mov dw (with extention if needed)
    IF TYPE p1 EQ 2
      mov ax, p1
      IF TYPE p2 EQ 1
        movzx bx, p2
      ELSE
        mov bx, p2
      ENDIF
      IF TYPE p3 EQ 1
        movzx cx, p3
      ELSE
        mov cx, p3
      ENDIF
      ; sum
      add ax, bx
      jc Overflow
      add ax, cx
      jc Overflow
      ; save
      IFIDNI <p1>, <ax>
        mov [esp + 8], ax
      ELSEIFIDNI <p1>, <bx>
        mov [esp + 4], ax
      ELSEIFIDNI <p1>, <cx>
        mov [esp], ax
      ELSE
        mov p1, ax
      ENDIF
      jmp Finish
    ; mov db (with size check)
    ELSE
      mov al, p1
      IF (TYPE p2 EQ 2) OR (TYPE p3 EQ 2)
        OUTSTRLN offset E_size
        jmp Finish
      ENDIF
      mov bl, p2
      mov cl, p3
      ; sum
      add al, bl
      jc Overflow
      add al, cl
      jc Overflow
      ; save
      IFIDNI <p1>, <ax>
        mov [esp + 8], al
      ELSEIFIDNI <p1>, <bx>
        mov [esp + 4], al
      ELSEIFIDNI <p1>, <cx>
        mov [esp], al
      ELSEoperation
        mov p1, al
      ENDIF
      jmp Finish
    ENDIF

  ; mmul: p1:= p1 + p2 * p3
  ELSEIFIDNI <p0>, <MMUL>
    ; size check
    IF (TYPE p1 EQ 1) OR (TYPE p2 EQ 2) OR (TYPE p3 EQ 2)
      OUTSTRLN offset E_size
      jmp Finish
    ENDIF
    ; mov
    mov cx, p1
    mov al, p2
    mov bl, p3
    ; mult and sum
    mul bl
    jc Overflow
    add ax, cx
    jc Overflow
    ; save
    IFIDNI <p1>, <ax>
      mov [esp + 8], ax
    ELSEIFIDNI <p1>, <bx>
      mov [esp + 4], ax
    ELSEIFIDNI <p1>, <cx>
      mov [esp], ax
    ELSE
      mov p1, ax
    ENDIF
    jmp Finish

  ; invalid operation
  ELSE
    OUTSTRLN offset E_invalid_operation
    jmp Finish
  ENDIF

Overflow:
  OUTSTRLN offset E_overflow

Finish:
  ; POP
  pop ecx
  pop ebx
  pop eax
ENDM


Start:
  OUTSTR offset inp1
  ININTLN dx
  OUTSTR offset inp2
  ININTLN bl
  OUTSTR offset inp3
  ININTLN cl

  CALC_THREE MADD, dx, bl, cl
;  CALC_THREE MADD, w1, b2, b3

  OUTSTR offset out1
  OUTINTLN dx

  exit 0
end Start
