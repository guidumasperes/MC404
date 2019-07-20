@conta_impares.s

@definir pilha
FINAL_MEM	.equ	0x80000

@definir diretivas
vet:	.word	1,7,5,9,8,15,3,13
size:	.word	8

@comeco do programa
inicio:
	set	sp,FINAL_MEM
	set	r0,vet
	ld	r1,size
	call	impares
	hlt

@definicao de funcoes

@********
@impares*
@********

MASC_IMPAR	.equ	0x1

impares:
	set	r5,0
	set	r2,MASC_IMPAR
	set	r3,0
loop_impares:
	cmp	r1,r3
	jz	fim_impares
	ld	r4,[r0]
	and	r4,r2
	cmp	r4,0
	jnz	soma_impar
incrementa:
	add	r3,1
	add	r0,4
	jmp	loop_impares
soma_impar:
	add	r5,1
	jmp	incrementa
fim_impares:
	mov	r0,r5
	ret
