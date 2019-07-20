@programas do ex5
	.global	_start

@funcoes
_strcmp:
	ldr	r0,[sp,#0]
	ldr	r1,[sp,#4]
_loop:
	ldrb	r2,[r0]
	ldrb	r3,[r1]
	cmp	r2,r3
	beq	_iguais
	bhi		_primeiro_maior
	mov	r0,#-1
	bx		lr
_primeiro_maior:
	mov	r0,#1
	bx		lr
_iguais:
	cmp	r2,#'\n'
	moveq	r0,#0
	bxeq	lr
	add	r0,#1
	add	r1,#1
	b		_loop

_strncmp:
	ldr	r0,[sp,#0]		@tamanho maximo
	ldr	r1,[sp,#4]		@endereco da stringb
	ldr	r2,[sp,#8]		@endereco da stringa
_loop1:
	cmp	r0,#0
	moveq	r0,#0
	bxeq	lr
	ldrb	r3,[r1]		@carrega os bytes nos registradores
	ldrb	r4,[r2]
	cmp	r3,r4
	beq	_iguais1
	bhi		_primeira_maior1
	mov	r0,#-1		@stringb	é maior que a
	bx		lr
_iguais1:				@as duas sao iguais
	cmp	r2,#'\n'
	moveq	r0,#0
	bxeq	lr
	add	r1,#1		@atualizamos os apontadores	
	add	r2,#1
	sub	r0,#1		@decrementa o tamanho ate chegar a 0
	b		_loop1
_primeira_maior1:	@striga maior que stringb
	mov	r0,#1
	bx		lr

_strpbrk:
	ldr	r0,[sp,#0]		@cadeia s
	ldr	r1,[sp,#4]		@cadeia charset
_loop_ext:
	ldrb	r2,[r0]		@carrega o caractrere que vamos procurar em r1	
	cmp	r2,#'\n'	@se chegou no \n significa que nao achou
	moveq	r0,#0
	bxeq	lr
	mov	r4,r1
_loop_int:
	ldrb	r3,[r4]		@carrega o byte em r3
	cmp	r3,r2		@compara com r2 se for igual so voltamos
	bxeq	lr
	cmp	r3,#'\n'	@se r3 for \n vamos para o proximo byte de r0 e procura-lo em r1
	addeq	r0,#1
	beq	_loop_ext
	add	r4,#1
	b		_loop_int			

@constantes
stringa:
	.ascii	"abcde\n"
stringb:
	.ascii	"fgbdh\n"

@funcao principal
_start:
	mov	sp,#1000
	ldr		r1,=stringa
	ldr		r2,=stringb
	push	{r1}
	push	{r2}
	bl		_strpbrk
	mov	r9,r0
	mov     	r0, #0     @ status -> 0
    	mov     	r7, #1     @ exit is syscall #1
    	swi     	#0x55      @ invoke syscall
