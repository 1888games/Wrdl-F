WORD.GetNext:

	GetRandom

	ni %00111111

	ci NUM_BLOCKS
	bnc WORD.GetNext

	lr 0, a

	GetFromArray_A MaxSection
	Store_Ram RAM.MaxInSection

	lr a, 0
	GetFromArray_A Initial
	Store_Ram RAM.CurrentWord

	lr a, 0
	sl 1

	GetFromArray_A Addresses
	lr	Qu, A
	lm
	lr	Ql, A



WordInAddress:

	GetRandom
	ni %00011111

	dci RAM.MaxInSection
	cm 
	bnc WordInAddress

	sl 1
	sl 1
	Store_Ram RAM.WordStartIndex


	lr DC, Q
	adc 
	lm
	Store_Ram RAM.CurrentWord + 1

	Inc_Ram RAM.WordStartIndex
	lr DC, Q
	adc
	lm
	Store_Ram RAM.CurrentWord + 2

	Inc_Ram RAM.WordStartIndex
	lr DC, Q
	adc
	lm
	Store_Ram RAM.CurrentWord + 3

	Inc_Ram RAM.WordStartIndex
	lr DC, Q
	adc
	lm
	Store_Ram RAM.CurrentWord + 4

	li 0
	Store_Ram RAM.CurrentID
	Store_Ram RAM.BoxID

	Inc_Ram RAM.DrawLetter

	li 0
	Store_Ram RAM.BoxID
	Store_Ram RAM.DrawingDebug

	li 1
	Store_Ram RAM.DrawLetter

	li 0
	Store_Ram RAM.LetterID

//

Done:

	jmp DemoText



WORD.DrawTheWord:

	li 25
	Store_Ram RAM.BoxID

	li 0
	Store_Ram RAM.CurrentID

	Inc_Ram RAM.DrawingDebug


DebugLoop:

	
 	Load_Ram RAM.CurrentID
	GetFromArray_A RAM.CurrentWord
 	Store_Ram RAM.LetterID

 	jmp TEXT.DrawLetter

DoneLetter:

	Inc_Ram RAM.CurrentID
	ci 4
 	bnc SkipDebug

	Inc_Ram RAM.BoxID

	jmp DebugLoop

SkipDebug:

	jmp FRAME.Loop