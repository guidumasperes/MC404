@tarefa01

sequencia:	.skip	4*100 @nessa parte do codigo vamos definir as diretivas
compr:		.skip	4     @reservamos espaco para o compr e resultado
resultado:	.skip	4

inicio:
		ld	r3,compr	@carregamos o valor que esta em comprimento no r3
		set	r1,sequencia	@r1 sera nosso "apontador"
		ld	r2,[r1]		@r2 vai conter o valor para qual o apontador aponta	
inicio_for:
		set	r5,0		@preparamos o loop for
teste_for:
		cmp	r5,r3		
		jge	final_for
corpo_for:
		cmp	r2,0		@nessa parte verificamos se o valor a ser testado no intervalo
		js	if_neg		@e negativo ou positivo
		cmp	r2,100		@se for positivo, verificamos se e maior que 100, se nao for adicionamos 1 ao registrador r0
		ja	else_neg	@se for negativo vamos para o proximo teste
		add	r0,1		
		jmp	else_neg
		if_neg:
			cmp	r2,-100	  @se o valor for negativo, verificamos se e menor que -100
			jl	else_neg  @se nao for esta no intervalo e adicionamos 1 ao nosso r0
			add	r0,1	  	
		else_neg:
			jmp	incremento
incremento:
		add	r5,1		@nessa parte iteramos o for e atualizamos o apontador
		add	r1,4
		ld	r2,[r1]
		jmp	teste_for
final_for:
		st	resultado,r0
		set	r2,0
		set	r3,0
		hlt
