

ReduceThousands:		.byte -2, -2, -5, -5, -5, 0
ReduceHundreds:			.byte -5, -5, 0, 0, 0, 0


SCORE.Display:

	clr
	Store_Ram RAM.XReg

	li HUD_X_START
	ai 2
	Store_Ram RAM.X

ScoreLoop:

	;// Score Number
		
	Load_Ram RAM.XReg
	GetFromArray_A RAM.ScoreHundredThousands
	ai 26
	lr BLIT_ID, a

	li Transparent
	lr BLIT_BG, a	

	li Blue
	lr BLIT_COLOUR, a

	li TEXT_START_Y + TEXT_GAP + NUMBER_Y_OFFSET
	lr BLIT_Y, a

	Load_Ram RAM.X
	lr BLIT_X, a

	pi DrawChar


NoChar:

	Load_Ram RAM.X
	ai 4
	Store_Ram RAM.X

	Inc_Ram RAM.XReg
	ci 6
	bz ScoreDone

	jmp ScoreLoop

ScoreDone:

	jmp FRAME.ScoreDone





AddToScore: 

	;// loop back from digit 6 to digit 1
	li 6
	lr 1, a

;// 0 = temp
;// 1 = digit loop
;// 2 = carry loop

DigitLoop:
		
	;// Get the amount to add to this digit, store in 0
	lr a, 1
	GetFromArray_A RAM.ScoreToAdd
	ci 0
	bz NextDigit
	lr 0, a

	;// add the amount to the current digit value and save
	lr a, 1
	GetFromArray_A RAM.Score
	as 0
	lr 0, a
	lr a, 1
	SaveR0ToArray_A RAM.Score

	ai 246				;//subtract 10
	bm NextDigit		;// test if still positive - need to carry

	;// Save the digit with -10
	lr 0, a
	lr a, 1
	SaveR0ToArray_A RAM.Score
	lr a, 1
	ai 255
	lr 2, a


CarryLoop:
		
	;//Digit index for carry
	lr a, 2
	;//add one to digit and check if carry cascades
	Increment_Indexed_Ram RAM.Score
	ci 10
	bnz NextDigit

	;// set this digit to zero
	lr a, 2
	Reset_Indexed_RAM RAM.Score

	;// add one to next digit
	lr a, 2
	ai 255
	Increment_Indexed_Ram RAM.Score


	;// check if finished carrying
	lr a, 2
	ai 255
	ci 0
	bz NextDigit
	lr 2, a

	jmp CarryLoop

NextDigit:

	lr a, 1
	ai 255
	ci 0
	bz DoneAdding
	lr 1, a

	jmp DigitLoop


DoneAdding:

	dci RAM.ScoreToAdd
	clr
	st
	st
	st
	st
	st
	st
	st

	pop




ReduceFromScore: 

	
	;// loop back from digit 6 to digit 1
	li 6
	lr 1, a

;// 0 = temp
;// 1 = digit loop
;// 2 = carry loop

DigitLoop2:
		
	;// Get the amount to add to this digit, store in 0
	lr a, 1
	GetFromArray_A RAM.ScoreToAdd
	ci 0
	bz NextDigit2
	lr 0, a

	;// add the amount to the current digit value and save
	lr a, 1
	GetFromArray_A RAM.Score
	as 0
	lr 0, a
	lr a, 1
	SaveR0ToArray_A RAM.Score

	bp NextDigit2		;// test if still positive - need to carry

	;// Save the digit with +10
	ai 10
	lr 0, a
	lr a, 1
	SaveR0ToArray_A RAM.Score
	lr a, 1
	ai 255
	lr 2, a


CarryLoop2:
		
	;//Digit index for carry
	lr a, 2
	;//add one to digit and check if carry cascades
	Decrement_Indexed_Ram RAM.Score
	bp NextDigit2

	;// set this digit to zero
	li 9
	lr 0, a
	lr a, 2
	SaveR0ToArray_A RAM.Score

	;// add one to next digit
	lr a, 2
	ai 255
	;Decrement_Indexed_Ram RAM.Score


	;// check if finished carrying
	lr a, 2
	ai 255
	ci 0
	bz NextDigit2
	lr 2, a

	jmp CarryLoop2

NextDigit2:

	lr a, 1
	ai 255
	ci 0
	bnz CarryOn

	Load_Ram RAM.ScoreHundredThousands
	ci 9
	bnz NoWrapScore

	Load_Ram RAM.ScoreTenThousands
	ci 9
	bnz NoWrapScore

	li 0
	Store_Ram RAM.Score
	st
	st
	st
	st
	st
	st

NoWrapScore:

	jmp DoneAdding

CarryOn:
	lr 1, a
	jmp DigitLoop2




SCORE.FrameUpdate:


	Load_Ram RAM.AddToScore
	ci 0
	bz NoAdd

	li 0
	Store_Ram RAM.AddToScore
	
	pi AddToScore
	Inc_Ram RAM.UpdateScore

NoAdd:

	Load_Ram RAM.ReduceScore
	ci 0
	bz NoReduce

	li 0
	Store_Ram RAM.ReduceScore

	pi ReduceFromScore
	Inc_Ram RAM.UpdateScore

NoReduce:

	Load_Ram RAM.UpdateScore
	ci 0
	bz ExitScore

	li 0
	Store_Ram RAM.UpdateScore

	jmp SCORE.Display

ExitScore:

	Load_Ram RAM.ReduceTimer
	ci 0
	bz ReduceScore

	Dec_Ram RAM.ReduceTimer
	jmp FRAME.ScoreDone

ReduceScore:

	li REDUCE_FREQ
	Store_Ram RAM.ReduceTimer

	li 255
	Store_Ram RAM.ScoreAddDigits

	Inc_Ram RAM.ReduceScore


	jmp FRAME.ScoreDone
	
