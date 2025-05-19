include console.inc

;
; roll S 15 times right and change empty to ' '
;

.data
  N = 29
  R = 15
  Scale db '        1234567890123456789012345678901234567890123456789', 0
  Source db 'Source: ', 0
  Output db 'Output: ', 0
  S db 'aboba_aboba_ab01a_aboba_aboba', 0
  A db R dup (' ') , N - R dup (?), 0

.code
Start:
    CLD
    mov esi, offset S ; from
    mov edi, offset A + R ; to
    mov ecx, N - R
  REP MOVSB

  OUTSTRLN offset Scale

  OUTSTR offset Output
  OUTSTRLN offset A

  OUTSTR offset Source
  OUTSTRLN offset S

  exit 0
  end Start
