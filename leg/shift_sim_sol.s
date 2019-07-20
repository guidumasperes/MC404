@solucao para o programa do shift

@***************
@ shiftright_264
@***************
@ vamos usar uma fun ̧c~ao auxiliar, shiftright32, que faz o shift de at ́e 32 bits
shiftright264:
	mov  r11,r0        @ copia o endere ̧co do vetor para r11
	mov  r12,r1        @ copia o n ́umero de bits do shift para r12
shft_loop:
	cmp  r12,32        @ enquanto n ́umero de shifts for maior ou igual a 32
	jle  shft_last     @ desvia se n ́umero de shifts  ́e menor do que 32
	sub  r12,32        @ sen~ao fazemos shift de 32 bits
	push r11           @ prepara par^ametros para shiftright32
	@ primeiro par^ametro  ́e endere ̧co da palavra
	set  r0,32         @ segundo par^ametro  ́e n ́umero de bits a serem shiftados
	push r0
	call shiftright32
	add  sp,8         @ retira par^ametros da pilha
	jmp  shft_loop
	shft_last:
	@ aqui quando n ́umero de shifts restantes  ́e menor ou igual a 32
	push r11
	push r12
	call shiftright32
	add  sp,8         @ retira par^ametros da pilha
	ret
@*************
@ shiftright32
@*************
@ par^ametros passados pela pilha:
@   endere ̧co da palavra de 32 bits a ser shiftada (primeiro a ser empilhado na chamada)
@   valor do shift (segundo a ser empilhado na chamada)
shiftright32:
	ld   r1,[sp+8]    @ endere ̧co da palavra de 32 bits
	ld   r2,[sp+4]    @ valor do shift para a direita, entre 0 e 32
	set  r3,32
	sub  r3,r2        @ r3 cont ́em o valor de um shift para a esquerda para montar a palavra seguinte, veja abaixo
@ vamos montar uma m ́ascara em r4
	set  r4,0         @ com um loop
	mov  r5,r2        @ r5 vai ser o contador do loop
shft1:
	stc               @ liga o bit de carry
	rcl  r4,1         @ rotaciona de um, bit de carry entra no registrador r4 no bit menos significativo
	sub  r5,1         @ r2 bits menos significativos v~ao passar para a pr ́oxima palavra
	jnz  shft1        @ montamos em r4 uma m ́arcara para os r2 bits menos significativos de uma palavra
@ esses bits passar~ao para a palavra seguinte
	set  r5,8         @ oito palavras no total, vamos usar r5 como contador
	set  r6,0         @ r6 cont ́em sempre o valor shiftado da palavra anterior, inicializa com zero
shft2:
	ld   r0,[r1]      @ uma palavra a ser shiftada
	cmp  r2,32        @ vamos tratar de forma especial
	jz   shft_all
	mov  r7,r4        @ r7 vai ter bits que
	and  r7,r0        @ passar~ao para pr ́oxima palavra
	shr  r0,r2        @ r0 tem bits que ficar~ao nesta palavra ap ́os o shift
	or   r0,r6        @ junta com bits que vieram da palavra anterior no shift, que est~ao em r6
	st   [r1],r0      @ armazena de volta valor shiftado
	shl  r7,r3
	mov  r6,r7        @ bits que passar~ao para pr ́oxima palavra
	add  r1,4         @ avan ̧ca para pr ́oxima palavra
	sub  r5,1         @ tratamos uma palavra, verifica se terminou
	jnz  shft2
	ret
shft_all:
@ se shiftar 32 bits, valor da palavra corrente  ́e a palavra anterior
	st   [r1],r6      @ armazena de volta valor shiftado
	mov  r6,r0        @ se shiftar 32 bits, todos os bits passam para a pr ́oxima palavra
	add  r1,4         @ avan ̧ca para pr ́oxima palavra
	sub  r5,1         @ tratamos uma palavra, verifica se terminou
	jnz  shft2
	ret
@ para testar
inicio:
	set  sp,0x80000
	set  r0,vetor
	set  r1,1
	call shiftright264
	hlt
	.org 0x1000
vetor:
	.word 0x33333333
	.word 0x00000000
	.word 0x33333333
	.word 0x00000000
	.word 0x33333333
	.word 0x00000000
	.word 0x33333333
	.word 0x00000000
