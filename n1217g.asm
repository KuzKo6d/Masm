include console.inc

;
;
;

.data
  N = 18

  S db 'aboba_-_-aboba    ', 0
  T db N dup (?), 0

.code
Start:
  STD
	mov edi, offset S
	mov al, ' '
	mov ecx, N ; length of S
REPE SCASB

  STD
  inc ecx
  mov esi, edi ; from
  sub esi, 1
  mov edi, offset T ; to
REP MOVSB

  OUTSTRLN offset S
  OUTSTR offset T

  exit 0
  end Start

