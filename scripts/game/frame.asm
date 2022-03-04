FRAME.Start:
	
	

FRAME.Loop:
	
	jmp INPUT.FrameUpdate



FRAME.InputDone:

	jmp CONTROL.FrameUpdate

FRAME.ControlDone:

	jmp TEXT.FrameUpdate

FRAME.TextDone:

	jmp SCORE.FrameUpdate

FRAME.ScoreDone:

	jmp LEVEL.FrameUpdate

FRAME.LevelDone:

	Inc_Ram RAM.Seed
	
	jmp FRAME.Loop


