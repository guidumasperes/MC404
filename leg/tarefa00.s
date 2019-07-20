@tarefa00
@Primeiro vamos definir as diretivas

	.org	0x100
varA:	.skip	4
varB:	.skip	4
varC:	.skip	4

	.org	0x200
	set	r3,0x1000
	ld	r0,varA
	ld	r1,varB
	ld	r2,varC
	add	r2,r3
	add	r1,r2
	add	r0,r1
	hlt	
