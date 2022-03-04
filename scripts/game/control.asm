
CONTROL.FireDown:

	Load_Ram RAM.GameRunning
	ci 1
	bz GamePlaying

	jmp LevelEnd

GamePlaying:
	
	Load_Ram RAM.LettersEntered
	ci 3
	bc NotYet
	jmp CHECK.Word

NotYet:
	
	;jmp CONTROL.Right
	jmp FRAME.ControlDone

	
CONTROL.FrameUpdate: 
	
	Load_Ram RAM.Debounce
	ci 0
	bz CONTROL.CheckFire

	Dec_Ram RAM.Debounce
	jmp FRAME.ControlDone


CONTROL.CheckFire:

	
	Load_Ram RAM.JoyFireNow
	ci 0
	bz CONTROL.FireNotDown

	jmp CONTROL.FireDown


CONTROL.FireNotDown:

	Load_Ram RAM.GameRunning
	ci 1
	bz GamePlaying2

	jmp FRAME.Loop

GamePlaying2:

CONTROL.CheckPull:

	Load_Ram RAM.JoyPullUp
	ci 0
	bz CONTROL.NotPullUp

	
	jmp CONTROL.Exit

CONTROL.NotPullUp:

CONTROL.CheckUp:

	Load_Ram RAM.JoyUpNow
	ci 0
	bz CONTROL.NotUp


CONTROL.Up:
	
	Load_Ram RAM.LetterID
	ci 0
	bz WrapZ

	ci 255
	bz WrapZ

	Dec_Ram RAM.LetterID
	jmp WillDrawUp

WrapZ:

	li 25
	Store_Ram RAM.LetterID

WillDrawUp:

	Inc_Ram RAM.DrawLetter
	jmp CONTROL.Debounce

CONTROL.NotUp:

	Load_Ram RAM.JoyDownNow
	ci 0
	bz CONTROL.NotDown

CONTROL.Down:

	Load_Ram RAM.LetterID
	ci 25
	bz WrapA

	Inc_Ram RAM.LetterID
	jmp WillDrawDown

WrapA:

	li 0
	Store_Ram RAM.LetterID

WillDrawDown:

	Inc_Ram RAM.DrawLetter
	jmp CONTROL.Debounce

CONTROL.NotDown:


	Load_Ram RAM.JoyRightNow
	ci 0
	bnz CONTROL.Right

	jmp CONTROL.NotRight


CONTROL.Right:
	
	Inc_Ram RAM.MoveNext
	Inc_Ram RAM.DrawLetter

	li TEXT_TYPE_ENTERED
	Store_Ram RAM.TextType

	jmp CONTROL.Debounce
	

CONTROL.NotRight:

	Load_Ram RAM.JoyLeftNow
	ci 0
	bnz CONTROL.Left

	jmp CONTROL.NotLeft


CONTROL.Left:

	Inc_Ram RAM.MovePrevious
	Inc_Ram RAM.DrawLetter


	li TEXT_TYPE_ENTERED
	Store_Ram RAM.TextType

	jmp CONTROL.Debounce
	

CONTROL.NotLeft:



CONTROL.Exit:

	jmp FRAME.ControlDone


CONTROL.Debounce:

	li DEBOUNCE_TIME
	Store_Ram RAM.Debounce
	jmp FRAME.ControlDone





LevelEnd:	

	Load_Ram RAM.JoyFireNow
	ci 0
	bnz NextLevelNow

	jmp FRAME.Loop

NextLevelNow:

	Inc_Ram RAM.GameRunning
	Inc_Ram RAM.CurrentLevel
	
	li 250
	Store_Ram RAM.ReduceTimer
	
	pi NewLevelVariables

	jmp SCREEN.Draw