include console.inc

.data
	; messages
	Hello db 'Write your string: ', 0

	; var
	N = 100
	S db N dup (?), 0
	dot dd 0

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


; takes offset of last letter offset S
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


Start:
	; input
	OUTSTR offset Hello
	push N
	mov eax, offset S
	push eax
	call Main_read
	
	; output
	OUTSTRLN offset S

  ; check condition
  push eax
  mov ecx, offset S
  push ecx
	call Main_check

	OUTINTLN eax

Finish:
	exit 0
	end Start

