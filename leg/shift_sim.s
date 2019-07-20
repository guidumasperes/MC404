@programa que simula o shift right
@prepara pilha
FINAL_MEM	.equ	0x80000

@diretivas
vetor:
	.word 0x33333333
	.word 0x00000000
	.word 0x33333333
	.word 0x00000000
	.word 0x33333333
	.word 0x00000000
	.word 0x33333333
	.word 0x00000000
k:	.word	1

@programa principal
inicio:
	set	r5,vetor
	ld	r1,k
	set	r4,0
	set	sp,FINAL_MEM
loop:
	cmp	r1,r4
	jz	fim
	mov	r0,r5
	call	sim_desloc
	add	r4,1
	jmp	loop
fim:
	hlt

@funcao que simula desloca uma vez para direita
sim_desloc:
	set	r3,0
	set	r6,0
ini:
	add	r0,1
	cmp	r3,31
	jz	insere_zero
	ldb	r2,[r0]
	stb	[r0-1],r2
	add	r3,1
	jmp	ini
insere_zero:
	stb	[r0],r6
	ret

