
Rows:		.byte START_ROW + 0, START_ROW + 0, START_ROW + 0, START_ROW + 0, START_ROW + 0
			.byte START_ROW + 8, START_ROW + 8, START_ROW + 8, START_ROW + 8, START_ROW + 8
			.byte START_ROW + 16, START_ROW + 16, START_ROW + 16, START_ROW + 16, START_ROW + 16
			.byte START_ROW + 24, START_ROW + 24, START_ROW + 24, START_ROW + 24, START_ROW + 24
			.byte START_ROW + 32, START_ROW + 32, START_ROW + 32, START_ROW + 32, START_ROW + 32
			.byte START_ROW + 40, START_ROW + 40, START_ROW + 40, START_ROW + 40, START_ROW + 40


Columns:	.byte START_COL + 0, START_COL + 8, START_COL + 16, START_COL + 24, START_COL + 32
			.byte START_COL + 0, START_COL + 8, START_COL + 16, START_COL + 24, START_COL + 32
			.byte START_COL + 0, START_COL + 8, START_COL + 16, START_COL + 24, START_COL + 32
			.byte START_COL + 0, START_COL + 8, START_COL + 16, START_COL + 24, START_COL + 32
			.byte START_COL + 0, START_COL + 8, START_COL + 16, START_COL + 24, START_COL + 32
			.byte START_COL + 0, START_COL + 8, START_COL + 16, START_COL + 24, START_COL + 32


LevelText:	.byte l,e,v,e,l
ScoreText:	.byte s,c,o,r,e
WrongText:	.byte s,o,l,v,e





SCREEN.Draw: 
	
	li 0
	Store_Ram RAM.CurrentID


Loop:

	Load_Ram RAM.CurrentID

	lr 9, a
	GetFromArray_A Rows	
	lr BLIT_Y, a

	lr a, 9
	GetFromArray_A Columns
	lr BLIT_X, a

	li Blue
	lr BLIT_COLOUR, a

	li Transparent
	lr BLIT_BG, a	

	li 0
	lr BLIT_ID, a

	pi DrawBox

	Inc_Ram RAM.CurrentID
	ci BOXES
	bnz Loop

SCREEN.Text:

	li HUD_X_START
	Store_Ram RAM.X

	li 0
	Store_Ram RAM.CurrentID

TextLoop:


LevelDraw:

	Load_Ram RAM.CurrentID
	GetFromArray_A LevelText
	lr BLIT_ID, a

	Load_Ram RAM.X
	lr BLIT_X, a

	li TEXT_START_Y
	lr BLIT_Y, a

	li Green
	lr BLIT_COLOUR, a 

	li Transparent
	lr BLIT_BG, a	

	pi DrawChar


ScoreDraw:

	Load_Ram RAM.CurrentID
	GetFromArray_A ScoreText
	lr BLIT_ID, a

	Load_Ram RAM.X
	lr BLIT_X, a

	li TEXT_START_Y + TEXT_GAP
	lr BLIT_Y, a

	li Blue
	lr BLIT_COLOUR, a 

	li Transparent
	lr BLIT_BG, a	

	pi DrawChar

WrongDraw:

	Load_Ram RAM.CurrentID
	GetFromArray_A WrongText
	lr BLIT_ID, a

	Load_Ram RAM.X
	lr BLIT_X, a

	li TEXT_START_Y + (TEXT_GAP * 2)
	lr BLIT_Y, a

	li Red
	lr BLIT_COLOUR, a 

	li Transparent
	lr BLIT_BG, a	

	pi DrawChar

	Load_Ram RAM.X
	ai 6
	Store_Ram RAM.X

	Inc_Ram RAM.CurrentID
	ci 5
	bnz TextLoop



	jmp ScreenDrawn


