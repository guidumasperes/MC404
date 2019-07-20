@calcular o fatorial recursivamente
	.global	_start
	.org	0x0
@funcoes
_fatorial:
	push	{lr}
	ldr		r0,[sp,#4]
	cmp	r0,#1
	bhi		_fat1
	mov	r0,#1
	bx		lr
_fat1:
	sub	r0,#1
	push	{r0}
	bl		_fatorial
	add	sp,#8
	ldr		r1,[sp,#4]
	mov	r2,r0
	mul	r0,r1,r2
	ldr		lr,[sp]
	bx		lr

@programa principal
_start:
	mov	sp,#1000
	mov	r1,#4
	push	{r1}
	bl		_fatorial
	mov	r9,r0
	mov     r0, #0     @ status -> 0
    	mov     r7, #1     @ exit is syscall #1
    	swi     #0x55      @ invoke syscall
