	.global _start	
	.org	0x1000

@**************
@funcao linha**
@**************

linha:
	ldrb	r1,[r0],#1 @carrega o byte da cadeia de caracteres em r1 e atualiza o endereco
	cmp	r1,#0x0a   @compara r1 com o caractere '\n' que eh 0x0a
	beq	testa_prox @e for igual verificamos se o proximo e 0
	b	linha	   @desvia para a funcao
testa_prox:
	add	r2,#1	   @adiciona no contador se for igual
	ldrb	r1,[r0]    @conferimos o zero
	cmp	r1,#0
	bne	linha	
final:
	mov	r0,r2	@copia o valor de r1(numero de linhas) para r0
	bx	lr	@volta para a funcao principal

@********************
@programa principal**
@********************

cadeia:	.skip	255 @pula 255 bytes
			.align	2   @alinha para multiplo de 4

_start:
	ldr	r0,=cadeia
	bl	linha
confere:
@syscall exit(int status)
	mov     r0, #0     @status -> 0
        mov     r7, #1     @exit is syscall #1
        swi	#0x55      @invoke syscall
