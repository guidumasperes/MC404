@acha o maior numero
	.global	_start
@definir as mascaras
	.set	MASC_1,0xf0000000
	.set	MASC_2,0x0f000000
	.set	MASC_3,0x00f00000
	.set	MASC_4,0x000f0000
	.set	MASC_5,0x0000f000
	.set	MASC_6,0x00000f00
	.set	MASC_7,0x000000f0
	.set	MASC_8,0x0000000f
	.set	MASC_9,0xfffffff0

@funcao
_menor_elem:
	ldr		r1,=MASC_1	@carrega as mascaras nos registradores
	ldr		r2,=MASC_2
	ldr		r3,=MASC_3
	ldr		r4,=MASC_4
	ldr		r5,=MASC_5
	ldr		r6,=MASC_6
	ldr		r7,=MASC_7
	ldr		r8,=MASC_8
	ldr		r9,=MASC_9
	and	r1,r0			@isola os elementos
	and	r2,r0
	and	r3,r0
	and	r4,r0
	and	r5,r0
	and	r6,r0
	and	r7,r0
	and	r8,r0
	lsr		r7,#4			@colaca todos na mesma posicao
	lsr		r6,#8
	lsr		r5,#12
	lsr		r4,#16
	lsr		r3,#20
	lsr		r2,#24
	lsr		r1,#28
	orr		r1,r9			@transforma todos em negativo
	orr		r2,r9
	orr		r3,r9
	orr		r4,r9
	orr		r5,r9
	orr		r6,r9
	orr		r7,r9
	orr		r8,r9
	cmp	r1,r2			@compara os elementos
	movle	r0,r1			@o que for menor move para r0
	movge	r0,r2
	cmp	r3,r0
	movle	r0,r3
	cmp	r4,r0
	movle	r0,r4
	cmp	r5,r0
	movle	r0,r5
	cmp	r6,r0
	movle	r0,r6
	cmp	r7,r0
	movle	r0,r7
	cmp	r8,r0
	movle	r0,r8
	bx		lr

@funcao principal
_start:
	bl		_menor_elem
	mov	r9,r0
	mov     r0, #0      @ status -> 0
    	mov     r7, #1      @ exit is syscall #1
    	swi       #0x55     @ invoke syscall
