CHECK.Word:


	li 0
	Store_Ram RAM.ColumnID
	Store_Ram RAM.CurrentColumn
	Store_Ram RAM.Correct

	Inc_Ram RAM.DrawingAnswer

	Load_Ram RAM.StartBoxID
	Store_Ram RAM.BoxID

	li TEXT_TYPE_WRONG
	Store_Ram RAM.TextType


CheckLoop:

	Load_Ram RAM.ColumnID
	GetFromArray_A RAM.EnteredWord
	Store_Ram RAM.LetterID
	lr ENTERED_LETTER, a


MatchLoop:

	Load_Ram RAM.CurrentColumn
	dci RAM.CurrentWord
	adc

	lr a, ENTERED_LETTER
	cm
	bnz NoMatch

	Load_Ram RAM.ColumnID
	dci RAM.CurrentColumn
	cm
	bnz BlueMatch

GreenMatch:
	
	li TEXT_TYPE_CORRECT
	Store_Ram RAM.TextType
	Inc_Ram RAM.Correct

	jmp UpdateAnswer

BlueMatch:

	li TEXT_TYPE_POSITION
	Store_Ram RAM.TextType

	jmp UpdateAnswer

NoMatch:
	
	Inc_Ram RAM.CurrentColumn
	ci 5
	bnz MatchLoop
	
UpdateAnswer:
	

	jmp TEXT.DrawLetter

DoneAnswer:
	
	
	Inc_Ram RAM.BoxID
	Inc_Ram RAM.ColumnID
	ci 5
	bz DoneAll

	li 0
	Store_Ram RAM.CurrentColumn

	li TEXT_TYPE_WRONG
	Store_Ram RAM.TextType

	jmp CheckLoop


DoneAll:

	Load_Ram RAM.Correct
	ci 5
	bz Complete

	Load_Ram RAM.CurrentRow
	GetFromArray_A ReduceThousands
	Store_Ram RAM.ScoreAddThousands

	Load_Ram RAM.CurrentRow
	GetFromArray_A ReduceHundreds
	Store_Ram RAM.ScoreAddHundreds

	Inc_Ram RAM.ReduceScore
	
	PlaySound sfx.error

	jmp CheckRow

Complete:
	
	PlaySound sfx.win

	Inc_Ram RAM.LevelsSolved
	Dec_Ram RAM.GameRunning

	li 100
	Store_Ram RAM.Debounce

	jmp FRAME.Loop


CheckRow:

	Inc_Ram RAM.CurrentRow
	ci 6
	bnz NotFailed

	Load_Ram RAM.ScoreBefore
	Store_Ram RAM.ScoreHundredThousands

	Load_Ram RAM.ScoreBefore + 1
	Store_Ram RAM.ScoreTenThousands


	Load_Ram RAM.ScoreBefore + 2
	Store_Ram RAM.ScoreThousands
	
	Load_Ram RAM.ScoreBefore + 3
	Store_Ram RAM.ScoreHundreds
	
	Load_Ram RAM.ScoreBefore + 4
	Store_Ram RAM.ScoreTens

	Load_Ram RAM.ScoreBefore + 5
	Store_Ram RAM.ScoreDigits

	li 0
	Store_Ram RAM.GameRunning
	Store_Ram RAM.ReduceScore

	li 100
	Store_Ram RAM.Debounce

	li 250
	Store_Ram RAM.ReduceTimer

	jmp WORD.DrawTheWord

DoneSolution:

	

NotFailed:
	

	Load_Ram RAM.BoxID
	Store_Ram RAM.StartBoxID

	li 0
	Store_Ram RAM.CurrentColumn
	Store_Ram RAM.ColumnID
	Store_Ram RAM.EnteredWord
	Store_Ram RAM.EnteredWord + 1
	Store_Ram RAM.EnteredWord + 2
	Store_Ram RAM.EnteredWord + 3
	Store_Ram RAM.EnteredWord + 4
	Store_Ram RAM.LettersEntered
	Store_Ram RAM.DrawingAnswer
	Store_Ram RAM.LetterID

	li 1
	Store_Ram RAM.DrawLetter

	li TEXT_TYPE_ENTER
	Store_Ram RAM.TextType

	jmp FRAME.ControlDone