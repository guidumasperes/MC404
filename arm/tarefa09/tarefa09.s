@Programa que simula um quadro de avisos de um onibus
	.global	_start
	
@determinando as portas de I/O, acima de 90000
	.set	CHEGADA1,0x90000
	.set	PARTIDA1,0x91000
	.set	CHEGADA2,0x92000
	.set	PARTIDA2,0x93000
	.set	CHEGADA3,0x94000
	.set	PARTIDA3,0x95000
	.set	PARADA,0x96000

@determinar constantes
	.set	BIT_READY,1

	.align	2
@comecar o programa
_start:
	mov	r6,#BIT_READY	@bit que verifica se o botao foi apertado
	mov	r10,#23		@vai ajudar a escrever no console
	b	loop_saida
loop_chegada:			@conferimos onde estamos chegando
	bl	confere_parada 	@mas antes conferimos se ocorreu solicitacao de parada
	mov	r4,#CHEGADA1
	ldr	r5,[r4]
	cmp	r5,r6
	bleq	chegada_ponto1
	bl	confere_parada
	mov	r4,#CHEGADA2
	ldr	r5,[r4]
	cmp	r5,r6
	bleq	chegada_ponto2
	bl	confere_parada
	mov	r4,#CHEGADA3
	ldr	r5,[r4]
	cmp	r5,r6
	bleq	chegada_ponto3
	b	loop_chegada
loop_saida:
	bl	confere_parada
	mov	r4,#PARTIDA1
	ldr	r5,[r4]
	cmp	r5,r6
	bleq	partida_ponto1
	bl	confere_parada
	mov	r4,#PARTIDA2
	ldr	r5,[r4]
	cmp	r5,r6
	bleq	partida_ponto2
	bl	confere_parada
	mov	r4,#PARTIDA3
	ldr	r5,[r4]
	cmp	r5,r6
	bleq	partida_ponto3
	b	loop_saida

@funcoes
confere_parada:
	mov	r11,lr				@copia o endereco da volta, pois o perdemos se foi solicitada a parada
	mov	r4,#PARADA
	ldr	r5,[r4]
	cmp	r5,r6
	bxne	lr
	mov	r13,#1
	ldr	r9,=msg
	mov	r10,#18
	bl	escreve_console
	mov	r10,#23
	mov	lr,r11
	bx	lr

chegada_ponto1:
	ldr	r9,=msg_cheg1
	bl	escreve_console
	b	loop_saida

chegada_ponto2:
	ldr	r9,=msg_cheg2
	bl	escreve_console
	b	loop_saida

chegada_ponto3:
	ldr	r9,=msg_cheg3
	bl	escreve_console
	b	loop_saida

partida_ponto1:
	ldr	r9,=msg_par1
	bl	escreve_console
	b	loop_chegada

partida_ponto2:
	ldr	r9,=msg_par2
	bl	escreve_console
	b	loop_chegada

partida_ponto3:
	ldr	r9,=msg_par3
	bl	escreve_console
	b	loop_chegada

escreve_console:
	mov 	r0, #1	@ fd -> stdout
	mov	r1, r9    	@ endereco da cadeia a ser escrita
	mov 	r2, r10 	@ tamanho da cadeia a ser escrita
	mov 	r7, #4   @ write é syscall #4
	svc     0x055   @ executa syscall 
	bx	lr

@constantes da memoria
msg_cheg1:	
	.ascii	"Esta e a parada Ponto1\n"
msg_cheg2:	
	.ascii	"Esta e a parada Ponto2\n"
msg_cheg3:	
	.ascii	"Esta e a parada Ponto3\n"
msg_par1:		
	.ascii	"Proxima parada: Ponto2\n"
msg_par2:		
	.ascii	"Proxima parada: Ponto3\n"
msg_par3:		
	.ascii	"Proxima parada: Ponto1\n"
msg:	
	.ascii	"Parada solicitada\n"
