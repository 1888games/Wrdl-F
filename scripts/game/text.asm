
TypeColour:		.byte Blue, Transparent, Transparent,Transparent, Green
BackColour:		.byte Transparent, Green, Red, Blue, Transparent


TEXT.DrawLetter:


DrawBG:

	Load_Ram RAM.BoxID
	lr 12, a

	GetFromArray_A Rows
	lr BLIT_Y, a

	lr a, 12
	GetFromArray_A Columns
	lr BLIT_X, a

	li 1
	lr BLIT_ID, a

	Load_Ram RAM.TextType
	GetFromArray_A BackColour
	lr BLIT_COLOUR, a

	li Clear
	lr BLIT_BG, a

	pi DrawBox


TheLetter:

	
	Load_Ram RAM.BoxID
	lr 12, a

	GetFromArray_A Rows
	ai 2
	lr BLIT_Y, a

	lr a, 12
	GetFromArray_A Columns
	ai 2
	lr BLIT_X, a


	Load_Ram RAM.TextType
	GetFromArray_A TypeColour
	lr BLIT_COLOUR, a

	li Clear
	lr BLIT_BG, a

	Load_Ram RAM.LetterID
	lr BLIT_ID, a

	pi DrawChar

	Load_Ram RAM.DrawingDebug
	ci 0
	bz NotDebug

	jmp DoneLetter

NotDebug:

	Load_Ram RAM.DrawingAnswer
	ci 0
	bz NotAnswer

	jmp DoneAnswer

NotAnswer:


	li 0
	Store_Ram RAM.DrawLetter

	Load_Ram RAM.LetterID
	lr 0, a

	Load_Ram RAM.ColumnID
	SaveR0ToArray_A RAM.EnteredWord



CheckMovedRight:

	Load_Ram RAM.MoveNext
	ci 0
	bz NotMovingRight

	li 0
	Store_Ram RAM.MoveNext

	Load_Ram RAM.ColumnID
	ci 4
	bnz CanMoveRight


	li TEXT_TYPE_ENTER
	Store_Ram RAM.TextType
	jmp ExitRight


CanMoveRight:	

	PlaySound sfx.moveSegmentRight

	pi StoreEnteredLetter

	Inc_Ram RAM.BoxID
	Inc_Ram RAM.ColumnID

	Inc_Ram RAM.LettersEntered

	li TEXT_TYPE_ENTER
	Store_Ram RAM.TextType

	pi GetEnteredLetter

ExitRight:

	Inc_Ram RAM.DrawLetter




NotMovingRight:

	Load_Ram RAM.MovePrevious
	ci 0
	bz NotMovingLeft

	li 0
	Store_Ram RAM.MovePrevious

	Load_Ram RAM.ColumnID
	ci 0
	bnz CanMoveLeft

	li TEXT_TYPE_ENTER
	Store_Ram RAM.TextType



	jmp ExitLeft


CanMoveLeft:
	
	PlaySound sfx.moveSegmentLeft

	pi StoreEnteredLetter

	Dec_Ram RAM.BoxID
	Dec_Ram RAM.ColumnID

	li TEXT_TYPE_ENTER
	Store_Ram RAM.TextType

	pi GetEnteredLetter

ExitLeft:

	Inc_Ram RAM.DrawLetter


NotMovingLeft:

	li TEXT_TYPE_ENTER
	Store_Ram RAM.TextType

	jmp FRAME.TextDone




TEXT.FrameUpdate: 

	Load_Ram RAM.DrawLetter
	ci 0
	bz TEXT.Exit

	jmp TEXT.DrawLetter










TEXT.Exit:

	jmp FRAME.TextDone




StoreEnteredLetter:

	Load_Ram RAM.LetterID
	lr 0, a

	Load_Ram RAM.ColumnID
	SaveR0ToArray_A RAM.EnteredWord

	pop


GetEnteredLetter:

	Load_Ram RAM.ColumnID
	GetFromArray_A RAM.EnteredWord
	Store_Ram RAM.LetterID

	pop