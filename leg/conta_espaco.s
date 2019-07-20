@Conta_espaco

vetor:	.byte	'eu sou guilherme e ela e camilla0'

inicio:
	set	r1,vetor	@r1 aponta para vetor
	set	r0,0
inicio_loop:
	ldb	r2,[r1]
	cmp	r2,0x20
	jz	incrementa_reg
	cmp	r2,0x00
	jz	fim_loop
incrementa_apont:
	add	r1,1
	jmp	inicio_loop
incrementa_reg:
	add	r0,1
	jmp	incrementa_apont
fim_loop:
	hlt
fim:
	.end 
