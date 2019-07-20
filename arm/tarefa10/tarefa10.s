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
	.set 	ADISPLAY_CMD,0x97000
	.set    ADISPLAY_DAT,0x98000

@determinar constantes
@constante para o botao
	.set	BIT_READY,1
@constante para o lcd
        .set    LCD_BUSYFLAG,0x80
        .set    LCD_DISPLAYCONTROL,0x08
        .set    LCD_DISPLAYON,0x04
        .set    LCD_BLINKOFF,0x00
        .set    LCD_CLEARDISPLAY,0x01
        .set    LCD_SETDDRAMADDR,0x80
        .set    LCD_FUNCTIONSET,0x20
        .set    LCD_8BITMODE,0x10
        .set    LCD_2LINE,0x08
        .set    LCD_5x8DOTS,0x00

	.align	2
@comecar o programa
_start:
	mov	sp,#1000
	mov	r6,#BIT_READY	@bit que verifica se o botao foi apertado
	mov	r0,#LCD_FUNCTIONSET+LCD_8BITMODE+LCD_2LINE+LCD_5x8DOTS
	bl      wr_cmd
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
	mov	r10,lr				@copia o endereco da volta, pois o perdemos se foi solicitada a parada
	mov	r4,#PARADA
	ldr	r5,[r4]
	cmp	r5,r6
	bxne	lr
	ldr	r1,=msg
	bl	escreve_lcd_linha2
	mov	lr,r10
	bx	lr

chegada_ponto1:
	bl	apaga_lcd
	ldr	r1,=msg_cheg1
	bl	escreve_lcd
	b	loop_saida

chegada_ponto2:
	bl	apaga_lcd
	ldr	r1,=msg_cheg2
	bl	escreve_lcd
	b	loop_saida

chegada_ponto3:
	bl	apaga_lcd
	ldr	r1,=msg_cheg3
	bl	escreve_lcd
	b	loop_saida

partida_ponto1:
	bl	apaga_lcd
	ldr	r1,=msg_par1
	bl	escreve_lcd
	b	loop_chegada

partida_ponto2:
	bl	apaga_lcd
	ldr	r1,=msg_par2
	bl	escreve_lcd
	b	loop_chegada

partida_ponto3:
	bl	apaga_lcd
	ldr	r1,=msg_par3
	bl	escreve_lcd
	b	loop_chegada

escreve_lcd:
	mov	r11,lr
	mov	r0,#LCD_DISPLAYCONTROL+LCD_DISPLAYON+LCD_BLINKOFF
	bl      wr_cmd
	bl      write_msg
	mov	lr,r11
	bx	lr

escreve_lcd_linha2:
	mov	r11,lr
	mov	r0,#(LCD_SETDDRAMADDR+64)
	bl      wr_cmd
	bl      write_msg
	mov	lr,r11
	bx	lr

apaga_lcd:
	mov	r11,lr
	mov	r0,#LCD_CLEARDISPLAY
	bl      wr_cmd
	mov	lr,r11
	bx	lr

wr_cmd:
	ldr	r2,=ADISPLAY_CMD
	ldrb	r3,[r2]
	tst     r3,#LCD_BUSYFLAG
	beq	wr_cmd
	strb	r0,[r2]
	mov	pc,lr

wr_dat:
	ldr	r2,=ADISPLAY_CMD
	ldrb	r3,[r2]   
	tst     r3,#LCD_BUSYFLAG
	beq	wr_dat         
	ldr	r2,=ADISPLAY_DAT
	strb	r0,[r2]
	mov	pc,lr

write_msg:
	push    {lr}	
	mov	r7, #0
write_msg1:
	ldrb    r0,[r1,r7]
	teq	r0,#0
	popeq   {pc}      
	bl      wr_dat     
	add     r1,#1      
	b       write_msg1



@constantes da memoria
msg_cheg1:	
	.asciz	"Esta e a parada P1  "
msg_cheg2:	
	.asciz	"Esta e a parada P2  "
msg_cheg3:	
	.asciz	"Esta e a parada P3  "
msg_par1:		
	.asciz	"Proxima parada: P2  "
msg_par2:		
	.asciz	"Proxima parada: P3  "
msg_par3:		
	.asciz	"Proxima parada: P1  "
msg:	
	.asciz	"Parada solicitada   "
