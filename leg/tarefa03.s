@tarefa03.s

@alocar o tamanho da pilha
	.org	0x1000
FINAL_MEMORIA	.equ	0x80000

@comeco do programa principal
inicio:
	set	r3,0
	set	sp,FINAL_MEMORIA
	set	r0,0
	call	display

loop:
	call    read
	set	r8,0x0a		@verificamos se o caractere e '*'
	cmp	r8,r1		@se sim, o programa terminou
	jnz	verifica_adc
	jmp	final_pro
verifica_adc:
	set	r8,0x0b		@verificamos se o caractere e '#'
	cmp	r8,r1		@se sim, nao vamos adicionar e esperamos o prox numero
	jnz	faz_adicao
	jmp	loop
faz_adicao:	
	add	r0,r7		@caso os outros testes falharem, entao adicionamos o numero e mostramos
	call	display
	mov	r7,r0
	jmp	loop

final_pro:
	hlt
	
@fim do programa principal

@*****
@read
@*****

CARACJOGOVELHA	.equ	0x0b
CARACESTRELA	.equ	0x0a
@endereco das portas
KEYBD_DATA	.equ	0x80
KEYBD_STAT	.equ	0x81
@bit de estado
KEYBD_READY	.equ	1

read:
	set	r2,KEYBD_READY
read1:
	inb	r3,KEYBD_STAT
	cmp	r2,r3
	jnz	read1	@se o dado nao estiver pronto saimos da funcao
	inb	r5,KEYBD_DATA
	set	r4,CARACJOGOVELHA
	cmp	r4,r5	@verificar se vamos guardar caractere ou numero
	jnz	ver_car
	mov	r1,r5
	jmp	final
ver_car:
	set	r4,CARACESTRELA
	cmp	r4,r5	
	jnz	guarda_num
	mov	r1,r5
	jmp	final
guarda_num:
	mov	r0,r5
	set	r1,0
final:
	ret

@*****
@display
@*****

@definicao da porta do mostrador
DISPLAY_DATA	.equ	0x40
@define uma tabela de digitos
tab:
	.byte	0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x77,0x1f,0x4e,0x3d,0x4f,0x47

display:
	set	r6,tab	@fazermos um apontador para tabela
	add	r6,r0	@adicionamos o numero no apontador para selecionarmos o numero no display
	ldb	r6,[r6]	@por fim mostramos no display e retornamos
	outb	DISPLAY_DATA,r6
	ret	



