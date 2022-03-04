TitleText:	.byte w,r,d,l,SPACE_CHAR,SLASH_CHAR,SPACE_CHAR ,f

TITLE.Show:

	li 26
	Store_Ram RAM.X

	li 0
	Store_Ram RAM.CurrentID

TextLoop2:

	Load_Ram RAM.CurrentID
	GetFromArray_A TitleText
	lr BLIT_ID, a

	Load_Ram RAM.X
	lr BLIT_X, a

	li 25
	lr BLIT_Y, a

	li Green
	lr BLIT_COLOUR, a 

	li Transparent
	lr BLIT_BG, a	

	pi DrawChar

	Load_Ram RAM.X
	ai 6
	Store_Ram RAM.X

	Inc_Ram RAM.CurrentID
	ci 8
	bnz TextLoop2


TITLE.Loop:
	

	pi WaitForInput
	lr 2, a

TITLE.CheckFire:

	lr a, 2
	ni %10000000
	bz TITLE.Loop

	jmp ReadyToPlay

