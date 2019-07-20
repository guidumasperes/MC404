@fatorial iterativo
	.global	_start

@funcao
_fatorial:
	ldr		r0,[sp,#0]	@carrega o numero
	mov	r1,r0
	mov	r2,r0
_loop:
	sub	r1,#1
	cmp	r1,#1		@se chegarmos a 1 nosso resultado ja esta em r0 e saimos da funcao
	bxeq	lr
	mul	r0,r1,r2	@movemos o resultado para r2 para multiplica por r1-1 acima
	mov	r2,r0	
	b		_loop
	
_start:
	mov	r1,#4
	push	{r1}
	bl		_fatorial
	mov	r9,r0
	mov     	r0, #0     @ status -> 0
    	mov     	r7, #1     @ exit is syscall #1
    	swi     	#0x55      @ invoke syscall
