include console.inc
.data
.code
	OUTD proc
	push ebp
	mov ebp, esp
	mov edx, 0
	cmp eax, 0
	je Fin
	movzx ebx, bl
	div ebx
	push edx
	call OUTD
	pop edx

Fin:
	OUTWORD edx
	pop ebp
	ret
	OUTD endp

Start:
	mov bl, 2
	mov eax, 64
	call OUTD
	exit
	end Start
