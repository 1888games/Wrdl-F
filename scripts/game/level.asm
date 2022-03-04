
LEVEL.Draw:
	

DrawLevel:

	Load_Ram RAM.CurrentLevel
	ai 27
	lr BLIT_ID, a


	li Transparent
	lr BLIT_BG, a	

	li Green
	lr BLIT_COLOUR, a

	li TEXT_START_Y + NUMBER_Y_OFFSET
	lr BLIT_Y, a

	li HUD_X_START + 12
	lr BLIT_X, a

	pi DrawChar

DrawSuccess:

	Load_Ram RAM.CurrentLevel
	ai 26
	lr BLIT_ID, a
	
	li Transparent
	lr BLIT_BG, a	

	li Red
	lr BLIT_COLOUR, a

	li TEXT_START_Y + NUMBER_Y_OFFSET + (TEXT_GAP * 2)
	lr BLIT_Y, a

	li HUD_X_START + 18
	lr BLIT_X, a

	pi DrawChar



	Load_Ram RAM.LevelsSolved
	ai 26
	lr BLIT_ID, a
	
	li Transparent
	lr BLIT_BG, a	

	li Red
	lr BLIT_COLOUR, a

	li TEXT_START_Y + NUMBER_Y_OFFSET + (TEXT_GAP * 2)
	lr BLIT_Y, a

	li HUD_X_START + 6
	lr BLIT_X, a

	pi DrawChar


	li SLASH_CHAR
	lr BLIT_ID, a
	
	li Transparent
	lr BLIT_BG, a	

	li Red
	lr BLIT_COLOUR, a

	li TEXT_START_Y + NUMBER_Y_OFFSET + (TEXT_GAP * 2)
	lr BLIT_Y, a

	li HUD_X_START + 12
	lr BLIT_X, a

	pi DrawChar

	jmp FRAME.LevelDone


LEVEL.FrameUpdate:

	Load_Ram RAM.UpdateLevel
	ci 0
	bz LevelExit

	li 0
	Store_Ram RAM.UpdateLevel

	Load_Ram RAM.ScoreHundredThousands
	Store_Ram RAM.ScoreBefore

	Load_Ram RAM.ScoreTenThousands
	Store_Ram RAM.ScoreBefore + 1

	Load_Ram RAM.ScoreThousands
	Store_Ram RAM.ScoreBefore + 2

	Load_Ram RAM.ScoreHundreds
	Store_Ram RAM.ScoreBefore + 3

	Load_Ram RAM.ScoreTens
	Store_Ram RAM.ScoreBefore + 4

	Load_Ram RAM.ScoreDigits
	Store_Ram RAM.ScoreBefore + 5

	li 2
	Store_Ram RAM.ScoreAddTenThousands

	li 5
	Store_Ram RAM.ScoreAddThousands

	Inc_Ram RAM.AddToScore


	jmp LEVEL.Draw




LevelExit:

	jmp FRAME.LevelDone



