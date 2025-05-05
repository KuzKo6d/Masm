include console.inc

.data
	; messages
	Hello db 'Write your string: ', 0
  Readed db 'Readed:', 0
  First db 'First condition applied:', 0
  Second db 'Second condition applied:', 0

	; var
	N = 100
	S db N dup (?), 0
  X db 2*N dup (?), 0

.code
; takes N and offset S
Main_read proc ; writes S untill '.'. -> eax := offset of last letter
	push ebp
	mov ebp, esp

	push ebx

	mov eax, [ebp + 8] ; offset S
	mov ebx, [ebp + 12] ; N
	
	mov ecx, 0
L_read:
	cmp ecx, ebx
	je After_loop_read
	INCHAR dl
	cmp dl, '.'
	je After_loop_read 
	mov [eax + ecx], dl
	
	inc ecx
	jmp L_read

After_loop_read:
	mov byte ptr [eax + ecx], 0 ; end of string
  ; -> eax := offset of last letter
  add eax, ecx
  dec eax

	pop ebx
	pop ebp
	ret 8
Main_read endp


; takes offset of last letter, offset S
Main_check proc ; check last letter. if it's capital and nowhere else -> true (-1) in eax
	push ebp
	mov ebp, esp

	push ebx

	mov eax, [ebp + 8] ; offset S
  mov ecx, [ebp + 12] ; last letter offset
  
  mov dl, [ecx] ; last letter
  cmp dl, 'A' ; check range below
  jb Check_finish
  cmp dl, 'Z' ; check range above
  ja Check_finish
  dec ecx ; for cycle

L_check:
  cmp eax, ecx ; handle end of string
  jae Check_true

  mov bl, [ecx] ; fetch letter
  cmp bl, dl ; compare with last
  je Check_finish

  dec ecx
  jmp L_check

Check_true:
  mov eax, -1

Check_finish:
	pop ebx
	pop ebp
	ret 8
Main_check endp


; takes offset S
Main_resize_letters proc ; invert size of a-z, A-Z letters
  push ebp
  mov ebp, esp

  mov eax, [ebp + 8] ; offset S
  
  mov ecx, 0
L_resize:
  mov dl, [eax + ecx] ; fetch current letter
  cmp dl, 0 ; handle end of string
  je Resize_finish

  ; check lowercase
  cmp dl, 'a'
  jb Resize_not_lower
  cmp dl, 'z'
  ja Resize_not_lower
  sub dl, 'a'-'A'
  mov [eax + ecx], dl
  inc ecx
  jmp L_resize
Resize_not_lower:

  ; check uppercase
  cmp dl, 'A'
  jb Resize_not_upper
  cmp dl, 'Z'
  ja Resize_not_upper
  add dl, 'a'-'A'
  mov [eax + ecx], dl
  inc ecx
  jmp L_resize
Resize_not_upper:

  inc ecx
  jmp L_resize

Resize_finish:
  pop ebp
  ret 4
Main_resize_letters endp


; takes offset X, offset S
Main_duplicate_letters proc ; duplicates letters from S and writes them to X
  push ebp
  mov ebp, esp

  push ebx

  mov eax, [ebp + 8] ; offset S
  mov ebx, [ebp + 12] ; offset X

  mov ecx, 0
L_duplicate:
  mov dl, [eax + ecx]
  cmp dl, 0 ; handle end of string
  je Duplicate_finish
  ; fill the X
  mov [ebx + 2 * ecx], dl
  mov [ebx + 2 * ecx + 1], dl

  inc ecx
  jmp L_duplicate

Duplicate_finish:
  mov dl, 0
  mov [ebx + 2 * ecx], dl ; mark end of X string
  pop ebx
  pop ebp
  ret 8
Main_duplicate_letters endp

Start:
	; input
	OUTSTR offset Hello
	push N
	mov eax, offset S
	push eax
	call Main_read
	
	; output
  NEWLINE
  OUTSTRLN offset Readed
	OUTSTRLN offset S
  NEWLINE

  ; check condition procedure
  push eax
  mov ecx, offset S
  push ecx
	call Main_check

; first condition
  cmp eax, -1
  jne Sec_condition
  mov eax, offset S
  push eax
  call Main_resize_letters
  OUTSTRLN offset First
  OUTSTRLN offset S
  jmp Finish

; second condition
Sec_condition:
  mov eax, offset X
  push eax
  mov eax, offset S
  push eax
  call Main_duplicate_letters
  OUTSTRLN offset Second
  OUTSTRLN offset X

Finish:
	exit 0
	end Start

