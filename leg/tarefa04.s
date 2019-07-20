@tarefa04.s

FINAL_MEMORIA	.equ	0x80000

inicio:
	set	r2,1	@r2 representa o estado atual, no caso comecamos no estado1
	set	r3,5	@r3 vai nos ajudar na correcao de um estado
	set	sp,FINAL_MEMORIA
	call	troca_estado @inicialmente fazemos rua1 verde e rua2 vermelho
loop_infinito:
	call	ler_botao
	cmp	r3,r2
	jnz	muda_estado
	set	r2,1	@fazemos uma correcao quando o estado passa de 4
muda_estado:
	call	troca_estado
	jmp	loop_infinito

@*********
@ler_botao
@*********

@bit de estado para verificar se esta pressionado e se esta pronto
KEYBD_STAT	.equ	0x40
KEYBD_READY	.equ	1

ler_botao:
	set	r0,KEYBD_READY
ler_botao1:
	inb	r1,KEYBD_STAT
	cmp	r0,r1
	jz	fim_func
	jmp	ler_botao1
fim_func:	
	add	r2,1	@adiciona 1 no r2 para mudar para estado apropriado
	ret		

@************
@troca_estado
@************

RUAUM	.equ	0x90
RUADOIS	.equ	0x91

troca_estado:
	set	r4,1
	cmp	r2,r4	@se o estado1 for o desejado vamos para a parte do programa que o implementa
	jz	estado1		
	set	r4,2
	cmp	r2,r4
	jz	estado2 @se nao vamos para o estado2
	set	r4,4
	cmp	r4,r2
	jz	estado2
	set	r5,4	@por fim se nao e nem estado1 e nem estado2 fazemos o estado3 e saimos 
	set	r6,1
	outb	RUAUM,r5
	outb	RUADOIS,r6
	jmp	fim
estado1:
	set	r5,1
	set	r6,4
	outb	RUAUM,r5
	outb	RUADOIS,r6
	jmp	fim
estado2:
	set	r5,2
	set	r6,2
	outb	RUAUM,r5
	outb	RUADOIS,r6
fim:
	ret
