@tarefa06.s

FINAL_MEMORIA	.equ	0x80000
TIMER_DATA	.equ	0x50
INT_TIMER	.equ	0x10

		.org	0x10000

inicio:
	set	r7,3
	set	r8,0
	set	r2,0	@r2 representa o estado atual, no caso comecamos no estado1
	set	r3,5	@r3 vai nos ajudar na correcao de um estado
	set	sp,FINAL_MEMORIA
	set	r0,INT_TIMER*4
	set	r1,int_tempo
	st	[r0],r1
	set	r0,0
	sti	
	set	r0,1000 @a cada 1 segundo ele muda o mostrador
	out	TIMER_DATA,r0
espera:
	wait	@vai trocar para estado amarelo faltando 5 segundos
	cmp	r8,0
	jz	muda_cont
	sub	r8,1
	cmp	r7,0
	jz	decide_estado
	jmp	chama_display
decide_estado:
	cmp	r8,1
	jz	reinicia_cont
	cmp	r8,5
	jnz	chama_display
	call	estado	
chama_display:
	call	display_seg
	jmp	espera
muda_cont:
	cmp	r7,3
	jz	sit_excep
	sub	r7,1
	set	r8,9
	call	display_seg
	jmp	espera
reinicia_cont:
	call	display_seg
	set	r7,3
	set	r8,0
	jmp	espera
sit_excep:
	call	estado
	call	display_seg
	sub	r7,1
	set	r8,10
	jmp	espera

@rotina de interrupcao
int_tempo:
	iret

@********
@estado**
@********

estado:
	add	r2,1
	cmp	r3,r2
	jnz	muda_estado
	set	r2,1
muda_estado:
	call	troca_estado
	ret

@**************
@troca_estado**
@**************

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

@*************
@display_seg**
@*************

@definicao da porta do mostrador
DISPLAY_DATA_UM	.equ	0x41
DISPLAY_DATA_DOIS .equ  0x40
@define uma tabela de digitos
tab:
	.byte	0x7e,0x30,0x6d,0x79,0x33,0x5b,0x5f,0x70,0x7f,0x7b,0x77,0x1f,0x4e,0x3d,0x4f,0x47

display_seg:
	set	r9,tab	@fazermos um apontador para tabela
	add	r9,r7	@adicionamos o numero no apontador para selecionarmos o numero no display
	ldb	r9,[r9]	@por fim mostramos no display e retornamos
	set	r10,tab
	add	r10,r8
	ldb	r10,[r10]
	outb	DISPLAY_DATA_UM,r9
	outb	DISPLAY_DATA_DOIS,r10
	
	ret
