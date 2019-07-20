MASC_IMPAR	.equ	0x1

par_impar:
	set	r1,2
	set	r0,MASC_IMPAR
	and	r0,r1
	hlt
