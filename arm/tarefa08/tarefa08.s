@programa que simula um cofre
@vamos utilizar interrupcao para porta e timer

@*******************************************
@inicializacao dispositivos e interrupcoes**
@*******************************************

	.global	_start
@flag para habilitar interrupções externas
	.set	IRQ,0x80
	.set	FIQ,0x40

@enderecos das pilhas do programa e da interrupcao
	.set	STACK,0x80000
	.set	STACK_FIQ,0x72000
	.set	STACK_IRQ,0X70000

@modos de interrupcao
	.set	IRQ_MODE,0x12
	.set	FIQ_MODE,0x11
	.set	USER_MODE,0x10	

@enderecos dos dispositivos
	.set	LEDS,0x90000
	.set	PORTA,0xd0000
	.set	TIMER,0xc0000
	.set	DISPLAY1,0xa0000
	.set	DISPLAY2,0xa0001
	.set	DISPLAY3,0xa0002
	.set    DISPLAY4,0xa0003
	.set 	KBD_DATA,0xb0000
	.set 	KBD_STATUS,0xb0001

@contantes
	.set	BIT_READY,1
	.set	INTERVAL,1000
	.set	INTERVAL1,10000
	.set	KBD_READY,0x1

@vetor de interrupções
	.org	6*4
	b	tratador_porta
	b	tratador_timer

@********************
@programa principal**
@********************

	.org	0x200
_start:				@ATENCAO: essa parte e identica aos programas de E/S exemplos!!!
	mov	sp,#0x500
	mov	r0,#IRQ_MODE	
	msr	cpsr,r0	
	mov	sp,#STACK_IRQ	
	mov	r0,#FIQ_MODE	
	msr	cpsr,r0		
	mov	sp,#STACK_FIQ	
	mov	r0,#USER_MODE	
	bic     r0,r0,#(IRQ+FIQ)
	msr	cpsr,r0		
	mov	sp,#STACK	
	
	mov	r1,#0		@no inicio a porta esta aberta
loopIni:
	mov	r9,#0
	ldr	r1,=flag_porta  @verifica se a porta esta fechada
	ldr	r0,[r1]
	cmp	r0,#1
	bne 	loopIni		@se estiver ficamos no loop
	mov	r2,#0		@resetamos a flag_porta
	str	r2,[r1]
	mov	r2,#1		@mudamos o led para verde
	ldr	r3,=LEDS
	strb	r2,[r3]
	mov	r2,#0		@agora r2 vai ser nosso contador para ver se tem 4 digitos
	mov	r10,#1
le_teclado:
	ldr	r4,=KBD_STATUS
le_teclado1:
	ldr	r3,=flag_timer
	ldr	r6,[r3]
	cmp	r6,#1
	beq	apaga_display
	ldr	r1,=flag_porta
	ldr	r3,[r1]
	cmp	r3,#1
	beq	apaga_leds
	ldr	r5,[r4]		@carrega o status em r5 0 ou 1
	cmp	r5,#KBD_READY	@verificamos se esta pronto para ler
	bne	le_teclado1	@se nao ficamos no loop ate estar pronto
	ldr	r4,=KBD_DATA	
	ldr	r5,[r4]		@carrega o que foi lido no registrador r5
	cmp	r2,#0		@fazemos varias comparaçoes para ver em qual display vamos escrever o dado
	ldreq	r4,=DISPLAY1	@para isso usamos um contador que e o registrador r2
	cmp	r2,#1
	ldreq	r4,=DISPLAY2
	cmp	r2,#2
	ldreq	r4,=DISPLAY3
	cmp	r2,#3
	ldreq	r4,=DISPLAY4
	ldr	r3,=digitos	@agora vamos escrever o digito lido
	ldrb	r6,[r3,r5]	@incrementamos no vetor e carregamos o valor esperado no registrador
	strb	r6,[r4]		@escrevemos no display o numero lido
	ldr	r6,=senha	@temos que guardar o numero num vetor que vai ser nossa senha
	strb	r5,[r6,r2]	@guardamos o primero digito e vamos guardando succesivamente ate acabar o laco
	add	r2,#1		@incrementamos nosso contador
	cmp	r2,#4		@se terminamos de determinar nossa senha saimos do laco
	beq	fim_teclado
timer1:				@a partir do momento que escrevemos no display vamos contar 10 segundos
	ldr	r0,=TIMER	@setar o timer para 10 segundos se a interrupcao ocorrer saimos 
	ldr	r3,=INTERVAL1
	str	r3,[r0]	
	bl	le_teclado
fim_teclado:
	mov	r2,#2		@se terminamos de ler nossa senha simplesmente atualizamos para o estado fechado cujo led e vermelho e aceso
	ldr	r3,=LEDS
	strb	r2,[r3]
	mov	r10,#0
timer:				@agora estamos no estado FECHADO
	ldr	r0,=TIMER	@vamos preparar nosso timer
	ldr	r1,=INTERVAL	@definindo o intervalo e inicializando as variaveis necessarias
	str	r1,[r0]
loop_timer:
	ldr	r1,=flag_timer	@ficamos nesse loop ate a interrupcao de timer acontecer
	ldr	r0,[r1]		@se ela acontece uma flag e setada para 1
	cmp	r0,#1		@saimos do loop e agora vamos para a proxima parte do programa
	bne	loop_timer	
	mov	r0,#0		@o contador vai nos dizer em qual numero estamos 
	str	r0,[r1]		@reseta a flag
	ldr	r2,=contador
	ldr	r3,[r2]
	add	r3,r3,#1
	str	r3,[r2]	
	mov	r5,#0		@colocamos todos os valores para 0 ou seja desligamos todos os bits
	cmp	r3,#5		@num primeiro momento se chegarmos em 5 apos definirmos nossa senha temos que apagar o display
	bne	timer
	mov	r9,#0		@r9 vai nos auxiliar para ver quantas vezes o usuario errou a senha
apaga_display:
	ldr	r1,=flag_timer @resetamos a flag e desligamos o timer
	mov	r0,#0 	       @antes de apagarmos os displays	
	str	r0,[r1]
	ldr	r0,=TIMER
	mov	r1,#0
	str	r1,[r0] 	
	ldr	r4,=DISPLAY1
	strb	r1,[r4]	
	ldr	r4,=DISPLAY2
	strb	r1,[r4]	
	ldr	r4,=DISPLAY3
	strb	r1,[r4]	
	ldr	r4,=DISPLAY4
	strb	r1,[r4]
	cmp	r9,#11
	beq	loopIni
	cmp	r10,#1
	moveq	r2,#0
	beq	le_teclado
@segunda leitura do teclado
	mov	r2,#0
le_teclado0:
	ldr	r4,=KBD_STATUS	@essa parte do programa e praticamente igual ao de cima	
le_teclado2:
	ldr	r3,=flag_timer
	ldr	r6,[r3]
	cmp	r6,#1
	beq	apaga_display
	ldr	r5,[r4]	
	cmp	r5,#KBD_READY
	bne	le_teclado2
	ldr	r4,=KBD_DATA
	ldr	r5,[r4]		
	cmp	r2,#0		
	ldreq	r4,=DISPLAY1	
	cmp	r2,#1
	ldreq	r4,=DISPLAY2
	cmp	r2,#2
	ldreq	r4,=DISPLAY3
	cmp	r2,#3
	ldreq	r4,=DISPLAY4
	ldr	r3,=digitos
	ldrb	r6,[r3,r5]	
	strb	r6,[r4]
	ldr	r3,=senha	@nessa parte conferimos se a senha digitada esta correta
	ldrb	r6,[r3,r2]	
	cmp	r5,r6
	bne	erro		@se nao estiver da erro e e reiniciado para digitar novamente
	add	r2,#1		@se a senha for digitada corretamente as 4 vezes o programa abre o cofre
	cmp	r2,#4	
	beq	abre_cofre
timer0:				@a partir do momento que escrevemos no display vamos contar 10 segundos
	ldr	r0,=TIMER	@setar o timer para 10 segundos se a interrupcao ocorrer saimos 
	ldr	r3,=INTERVAL1
	str	r3,[r0]	
	bl	le_teclado0
abre_cofre:
	mov	r2,#1		@mudamos o led para verde
	ldr	r3,=LEDS
	strb	r2,[r3]
loop_abre_cofre:
	ldr	r1,=flag_porta
	ldr	r0,[r1]
	cmp	r0,#1
	bne 	loop_abre_cofre
apaga_leds:
	mov	r2,#0	        @resetamos a flag_porta
	str	r2,[r1]
	ldr	r3,=LEDS	@apaga os leds
	mov	r2,#0
	str	r2,[r3]
	mov	r9,#11
	bl	apaga_display
erro:
	add	r9,#1		@se o usuario errar a senha 3 vezes
	cmp	r9,#3		@o cofre e fechado e nao e possivel mais abri-lo
	beq	fecha_para_sempre
	bl	apaga_display	
fecha_para_sempre:
	bl	fecha_para_sempre	

@**************************
@aqui temos os tratadores**
@**************************

	.align 4
tratador_timer:
	ldr	r7,=flag_timer	@ apenas liga a flag
	mov	r8,#1
	str	r8,[r7]
	movs	pc,lr

tratador_porta:
	ldr	r7,=flag_porta	@ apenas liga a flag
	mov	r8,#1
	str	r8,[r7]
	movs	pc,lr

@**********************
@variaveis auxiliares**
@**********************

digitos:
	.byte	0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x4f,0x4f
senha:
	.word	0x0
contador:
	.word	0x0
flag_timer:
	.word	0x0
flag_porta:
     	.word 	0x0
