	processor f8


	org	$800

	db	$55	;	// cartridge id
	db	$2b	;	// unknown


	include "scripts/common/macros.asm"

Entry:
	
	li	$21	;// 3-colour, green background
	lr	3, A		;// store A to R3z
	pi 	clrscrn 	;// call BIOS clear screen 

	jmp TITLE.Show


ReadyToPlay:	
	

	;// Seed our 'random' list

InitialiseVariables:

	pi DefaultVariables

Title:

	li	$93	;// 3-colour, green background
	lr	3, A		;// store A to R3z
	pi 	clrscrn 	;// call BIOS clear screen 

	pi NewLevelVariables

	jmp SCREEN.Draw

		
ScreenDrawn:
	
	jmp WORD.GetNext

DemoText:

	jmp FRAME.Start

	include "scripts/common/draw.asm"
	include "scripts/data/labels.asm"
	include "scripts/data/chars.asm"
	include "scripts/common/drawing.inc"
	include "scripts/data/ram.asm"
	include "scripts/common/input.asm"
	include "scripts/common/sound.asm"
	
	include "scripts/game/frame.asm"
	include "scripts/game/title.asm"
	include "scripts/game/screen.asm"
	include "scripts/game/text.asm"
	include "scripts/game/word.asm"
	include "scripts/game/control.asm"
	include "scripts/game/check.asm"
	include "scripts/game/score.asm"
	include "scripts/game/level.asm"

RandomLookup:
	

	;.byte 29,61,10,138,52,207,52,178,0
  	;.byte 168,192,236,42,44,36,42,224,37
  	;.byte 39,68,183,60,168,188,246,67,24,18
  	;.byte 159,56,24,238,172,103,212,17,24,170,202,50,117
  	;.byte 95,33,219,36,169,99,26,242,79,85,138,61,113,50
  	;.byte 210,128,110,61,53,44,70,183,212, 101,45,114,124
  	;.byte 5,34,212,173,193,83,57,153,200,102,68,40,157,118
  	;.byte 59,231,7,237,98,205,14,247,121,19,133,40,20,97,121,
  	;.byte 33,76,210,247,136,112,54,252,122,253,25,58,148,46,39,
  	;.byte 8,182,125,174,250,229,251,93,85,39,74,89,104,215
   	;.byte 180,173,126,245,197,53,139,110,160,38,242,78,116
   	;.byte 189,233,27,37,109,163,11,125,33,114,128,179,129,51,11,
   	;.byte 67,54,145,7,119,225,181,140,19,169,134,139,227,211
   	;.byte 74,254,76,7,206,218,17,224,186,186,137,198,85,103
   ;	.byte 192,169,142,75,68,194,181,16,66,234,105,193,106,137
   ; .byte 86,93,70,244,152,75,22,119,108,154,79,250,239,9,283,191
    ;.byte 35,16,249,72,193,122,236,64,244,160,3,235,60,143
    ;.byte 8,58,208,155,53,97,206,193,232,183,28,179,121,21
   ; .byte 33,59,173,224,249,8,141,215,250,87,204,240,137
   ; .byte 143,182



NewLevelVariables:

	li 0
	Store_Ram RAM.BoxID
	Store_Ram RAM.LetterID
	Store_Ram RAM.TextType
	Store_Ram RAM.ColumnID
	Store_Ram RAM.EnteredWord
	Store_Ram RAM.MoveNext
	Store_Ram RAM.LettersEntered
	Store_Ram RAM.StartBoxID
	Store_Ram RAM.DrawingDebug
	Store_Ram RAM.Correct
	Store_Ram RAM.DrawingAnswer
	Store_Ram RAM.CurrentRow
	Store_Ram RAM.ReduceScore
	Store_Ram RAM.AddToScore
	Store_Ram RAM.EnteredWord
	Store_Ram RAM.EnteredWord + 1
	Store_Ram RAM.EnteredWord + 2
	Store_Ram RAM.EnteredWord + 3
	Store_Ram RAM.EnteredWord + 4
	Store_Ram RAM.ScoreToAdd
	st
	st
	st
	st
	st

	li 1
	Store_Ram RAM.UpdateScore
	Store_Ram RAM.UpdateLevel
	Store_Ram RAM.GameRunning

	li REDUCE_FREQ
	Store_Ram RAM.ReduceTimer

	pop


DefaultVariables:
	
	li 0
	Store_Ram RAM.GameMode
	Store_Ram RAM.GameType
	Store_Ram RAM.LevelsSolved
	Store_Ram RAM.LevelsSolved2
	Store_Ram RAM.Score
	st
	st
	st
	st
	st
	st
	Store_Ram RAM.CurrentLevel2

	li 1
	Store_Ram RAM.CurrentLevel
	pop


	include "scripts/data/words.asm"

