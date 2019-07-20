@tarefa02.s

MASC_PRIMEIRO	.equ	0x0000ffff	@'arrancamos' o primeiro numero
MASC_SEGUNDO	.equ	0xffff0000	@'arrancamos' o segundo
divisor:	.skip	4
num_elem:	.skip	4
vetor:		.skip	4*64	@um vetor no qual em 32 bits tem 2 elementos de 16 bits cada

inicio:
	ld	r1,num_elem	@carrega o valor de num_elem no registrador r1
	ld	r2,divisor	@carrega o divisor no r2
	set	r3,vetor	@nosso r2 vai ser o "apontador" para o vetor
	set	r0,0		@a soma ficara no r0
	set	r6,MASC_PRIMEIRO
	set	r7,MASC_SEGUNDO

inicio_for:	
	set	r4,0
		
teste_for:
	cmp	r4,r1
	jge	final_for

corpo_for:		
	ld	r5,[r3]
	ld	r8,[r3]
	and	r5,r6	@aqui vamos usar as mascaras para separar os dois numeros
	and	r8,r7
	sar	r8,16	@rotacionamos devidamente para preservar o ultimo bit dos numeros
	rol	r5,16
	sar	r5,16		

if:			@verificar se vamos dividir por 2, 4 ou 8. Sempre mantemos o sinal
	cmp	r2,2	@divisao por 2
	jnz	else_if
	sar	r5,1
	sar	r8,1
	jmp	atualizar

else_if:
	cmp	r2,4
	jnz	else
	sar	r5,2	@divisao por 4
	sar	r8,2
	jmp	atualizar

else:
	sar	r5,3	@divisao por 8
	sar	r8,3

atualizar:
	add	r3,4	@nessa parte atualizamos o contador, o 'ponteiro' e adicionamos a soma em r0
	add	r4,2
	add	r8,r5
	add	r0,r8
	jmp	teste_for
	
final_for:
	hlt
