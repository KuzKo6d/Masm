include console.inc

; MADD, MMUL, unsigned, m8/r8, m16/m16

.data
; messages
  E_overflow db 'CALC_THREE: param1 oveflow.', 0
  inp1 db 'param1: ', 0
  inp2 db 'param2: ', 0
  inp3 db 'param3: ', 0
  out1 db 'output: ', 0

.code
  CALC_THREE MACRO operation:REQ, p1, p2, p3
  LOCAL Overflow, Success
; MADD: param1:= param1 + param2 + param3
; MMUL: param1:= param1 + param2 * param3

; PUSH
  push eax
  push ecx
  push edx

; CHECKS
; blank check
FOR i, <operation, p1, p2, p3>
  IFB i
    .ERR <Blank param.>
  ENDIF
ENDM

; size check (dd/constant not supported)
FOR i, <p1, p2, p3>
  IF (TYPE i EQ 4) OR (TYPE i EQ 0)
    .ERR <Param is too big.>
  ENDIF
ENDM

; BODY
; operation defining MADD
IFIDNI <operation>, <MADD>
  mov ax, p1
  add ax, p2
  jo Overflow
  add ax, p3
  jo Overflow
  mov p1, ax
  jmp Success

; operation defining MMUL
ELSEIFIDNI <operation>, <MMUL>
  ; multiplication arguments size check
  IF (SIZEOF p2 EQ 1) AND (SIZEOF p3 EQ 1)
    mov al, p2
    mov cl, p3
    mul cl
    jo Overflow

    ; check size of param1
    IF SIZEOF p1 EQ 1
      mov dl, p1
      add dl, al
      jo Overflow
      mov p1, dl
    ELSE
      mov dx, p1
      mov ah, 0 ; extend to word
      add dx, ax
      jo Overflow
      mov p1, dx
    ENDIF
    jmp Success

  ELSE
    .ERR <Param2 or param3 is too big. Can multiply only byte size.>
  ENDIF

; operation defining Error
ELSE
  .ERR <Incorrect operation.>
ENDIF

Overflow:
  pop edx
  pop ecx
  pop eax
  OUTSTRLN offset E_overflow
  EXITM

Success:
  pop edx
  pop ecx
  pop eax
ENDM


Start:
  OUTSTR offset inp1
  ININT ax
  NEWLINE
  OUTSTR offset inp2
  ININT bx
  NEWLINE
  OUTSTR offset inp3
  ININT cx
  NEWLINE

  CALC_THREE MADD, ax, bx, cx

  OUTSTR offset out1
  OUTINTLN ax

  exit 0
  end Start

