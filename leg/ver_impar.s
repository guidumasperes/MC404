@ex6.4.1

@definir constantes
MASC_IMPAR  .equ 0x1
MAX_VET .equ  8

@definir diretivas
vetor: .skip	MAX_VET @vetor de bytes, ou seja, e possivel
                        @armazenar numeros entre 0 e 255
                        @em cada posicao
num_elem: .skip 4

@comeco do programa
inicio:
  set r4,MASC_IMPAR @definimos as mascaras os contadores e apontadores
  set r1,vetor
  ld r2,num_elem
  set r5,0
loop: @no loop vamos avancando o contador em atualiza e verificando
      @com a mascara se o ultimo bit e 0 ou 1
  cmp r2,r5
  jna fim
  ldb r3,[r1]
  and r3,r4
  jz  atualiza
  add r0,1
atualiza:
  add r5,1
  add r1,1  @andamos 1 o inves de 4 pois e um vetor de bytes
  jmp loop
fim:
  hlt
