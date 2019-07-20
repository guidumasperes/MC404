@sum_of_array.s
@Vamos assumir que podemos ter no maximo 10 elementos no vetor

vetA:	.skip	10*4
vetB:	.skip	10*4
vetC:   .skip	10*4
num_elem:   .skip   4

inicio:
	set	r1,vetA   @apontadores para vetores
	set	r2,vetB
	set	r3,vetC
	ld	r4,num_elem   @variaveis apontadoras e contadoras
	set	r5,0
inicio_loop:
	cmp	r4,r5
	jz	fim_loop
	ld	r6,[r1]
	ld	r7,[r2]
	add	r6,r7	@r6 tem o valor da soma que queremos em r3
	jo	zera_vetor
	st	[r3],r6
	add	r1,4
	add	r2,4
	add	r3,4
	add	r5,1
	jmp	inicio_loop
zera_vetor:
	set	r5,0
	set	r3,vetC
	set	r8,0
loop_zera_vetor:
	cmp	r4,r5
	jz	fim_loop
	st	[r3],r8
	add	r3,4
	add	r5,1
	jmp	loop_zera_vetor
fim_loop:
	hlt
fim:
	.end
	
