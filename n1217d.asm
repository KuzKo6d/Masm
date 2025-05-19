include console.inc

;
;
;

.data
  N = 18

  S db '    aboba_-_-aboba', 0
  T db N dup (?), 0

.code
Start:
  CLD
	mov edi, offset S
	mov al, ' '
	mov ecx, N ; length of S
REPE SCASB

  CLD
  inc ecx
  mov esi, edi ; from
  sub esi, 1
  mov edi, offset T ; to
REP MOVSB

  OUTSTRLN offset S
  OUTSTRLN offset T

  exit 0
  end Start

