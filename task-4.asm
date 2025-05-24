include console.inc

; MADD, MMUL, unsigned, m8/r8, m16/m16

.data
; messages
  E1 db 'Error: blank argument.', 0
  E2 db 'Error: incorrect operation.', 0
  E3 db 'Eroor: incorrect argument (dword).', 0
  E4 db 'Error: incorrect argument (constant).', 0
  E5 db 'Error: param1 oveflow.', 0
E1 db '', 0
E1 db '', 0

.code
CALC_THREE macro operation, param1, param2, param3
; MADD: param1:= param1 + param2 + param3
; MMUL: param1:= param1 + param2 * param3

; blank check
IFB operation
  .ERR <Blank operation.>
ELSEIFB param1
  .ERR <Blank param1.>
ELSEIFB param2
  .ERR <Blank param2.>
ELSEIFB param3
  .ERR <Blank param3.>

; constant check
IF TYPE param1 EQ 0
.ERR <Incorrect param1 size.>
ELSEIF TYPE param2 EQ 0
.ERR <Incorrect param2 size.>
ELSEIF TYPE param3 EQ 0
.ERR <Incorrect param3 size.>

; size check
IF SIZEOF param1 GT 2
  .ERR <Incorrect param1 size.>
ELSEIF SIZEOF param2 GT 2
  .ERR <Incorrect param2 size.>
ELSEIF SIZEOF param3 GT 2
  .ERR <Incorrect param3 size.>



; operation level
IFIDNI operation, 'MADD'


; operation level
ELSEIFIDNI operation, 'MMUL'


; operation level
ELSE
  .ERR <Incorrect operation.>
ENDIF


endm


Start:


  end Start
