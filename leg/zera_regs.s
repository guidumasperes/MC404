@ exemplo de chamada do procedimento zera_regs
inicio:
	set	r0,1
	set	r2,9
	set	r5,8
	set	sp,0x80000
	call  	zera_regs          @ ap ́os a chamada, r0=r1=r2=r3
	hlt

@ ********
@ zera_regs
@ ********
@ Zera os registradores r0, r1, r2 e r3
@   entrada: nenhuma
@   sa ́ıda: r0, r1, r2 e r3 zerados
@   destr ́oi: nada
zera_regs:
set r0,0
set r1,0
set r2,0
set r3,0
ret
