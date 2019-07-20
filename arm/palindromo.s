@Programa para checar se e palindromo
	.global	_start
	.org	0x1000

@mascaras para isolar os bits
	.set	MASC_1,0xf0000000
	.set	MASC_2,0x0000000f
	.set	MASC_3,0x0f000000
	.set	MASC_4,0x000000f0
	.set	MASC_5,0x00f00000
	.set	MASC_6,0x00000f00
	.set	MASC_7,0x000f0000
	.set	MASC_8,0x0000f000

@funcao para verificar se e palindromo
palindromo:
	ldr		r1,=MASC_1 	@carregamos as mascaras nos registradores
	ldr		r2,=MASC_2
	and	r1,r0			@isolamos o que queremos comparar
	and	r2,r0			
	mov	r5,#0			@inicializamos uma variavel contadora
loop_1:
	add	r5,#1			@em cada loop vamos fazer o shift esquerdo e pegarmos o bit que escapou e
	lsls		r1,#1			@guardar no registrador r3 se o bit foi 0
	mov	r3,#0			@ou se o bit foi 1
	movcs	r3,#1			@para isso fazemos a condicao 'cs'
	lsrs	r2,#1			@usamos a mesma logica para o shift direito
	mov	r4,#0		
	movcs	r4,#1
	cmp	r3,r4			@se os bits forem iguais vamos para o proximo bit, fazemos isso 4 vezes, pegando os 4 bits
	bne	final_1			@se nao forem iguais nao e palindromo
	cmp	r5,#4
	bne	loop_1
	ldr		r1,=MASC_3	@fazemos a mesma logica para todos os bytes extraidos
	ldr		r2,=MASC_4
	and	r1,r0
	and	r2,r0
	lsl		r1,#4			@sempre colocamos o byte na extrema direita ou extrema esquerda
	lsr		r2,#4			@para extrairmos o bit sem dificuldades
	mov	r5,#0			@a partir daqui o codigo e igual
loop_2:
	add	r5,#1		
	lsls		r1,#1
	mov	r3,#0
	movcs	r3,#1
	lsrs	r2,#1
	mov	r4,#0
	movcs	r4,#1
	cmp	r3,r4
	bne	final_1
	cmp	r5,#4
	bne	loop_2	
	ldr		r1,=MASC_5
	ldr		r2,=MASC_6
	and	r1,r0
	and	r2,r0
	lsl		r1,#8
	lsr		r2,#8		
	mov	r5,#0
loop_3:
	add	r5,#1		
	lsls		r1,#1
	mov	r3,#0
	movcs	r3,#1
	lsrs	r2,#1
	mov	r4,#0
	movcs	r4,#1
	cmp	r3,r4
	bne	final_1
	cmp	r5,#4
	bne	loop_3
	ldr		r1,=MASC_7
	ldr		r2,=MASC_8
	and	r1,r0
	and	r2,r0
	lsl		r1,#12
	lsr		r2,#12		
	mov	r5,#0
loop_4:
	add	r5,#1		
	lsls		r1,#1
	mov	r3,#0
	movcs	r3,#1
	lsrs	r2,#1
	mov	r4,#0
	movcs	r4,#1
	cmp	r3,r4
	bne	final_1
	cmp	r5,#4
	bne	loop_4
	mov	r0,#1			@movemos para r0 o valor correspondente
	b		final_2
final_1:
	mov	r0,#0			@saimos se nao e palindromo
final_2:
	bx		lr

@programa principal
_start:
	bl	       palindromo
	mov     r9,r0
	mov     r0, #0     @ status -> 0
    	mov     r7, #1     @ exit is syscall #1
    	swi     #0x55      @ invoke syscall
	