WaitForInput:
	; see if one of the hand controllers has moved

	Inc_Ram RAM.Seed
	
	clr						; clear accumulator 
	outs	0					; enable input from both hand controllers
	outs	1					; clear latch of port of right hand controller
	outs	4					; clear latch of port of left hand controller
	ins	1					; fetch inverted data from right hand controller
	com						; invert controller data (a %1 now means active)
	bnz	SomeInput1		; if no movement then input is 0 -> no branch

	Store_Ram RAM.ControlDebounce1

	; check the other controller
	ins	4					; fetch inverted data from left hand controller
	com						; invert controller data (if bit is 1 it means active)
	bnz SomeInput2

	Store_Ram RAM.ControlDebounce2


	jmp WaitForInput

SomeInput1:

	dci RAM.ControlDebounce1
	cm
	bz WaitForInput

	Store_Ram RAM.ControlDebounce1
	pop

SomeInput2:

	dci RAM.ControlDebounce2
	cm
	bz WaitForInput

	Store_Ram RAM.ControlDebounce2
	pop






INPUT.FrameUpdate: 

	Reset_Ram RAM.JoyFireNow
	st
	st
	st
	st

	clr						; clear accumulator 
	outs	0					; enable input from both hand controllers
	outs	1					; clear latch of port of right hand controller
	outs	4					; clear latch of port of left hand controller
	ins	1					; fetch inverted data from right hand controller
	com						; invert controller data (a %1 now means active)
	bnz	SomeInput		; if no movement then input is 0 -> no branch

	; check the other controller
	ins	4					; fetch inverted data from left hand controller
	com						; invert controller data (if bit is 1 it means active)
	bnz SomeInput

	jmp FRAME.InputDone

SomeInput:

	lr 2, a
	ni %10000000
	bz CheckFireUp

	Inc_Ram RAM.JoyFireNow

	jmp CheckLeft


CheckFireUp:

	Load_Ram RAM.JoyFireLast
	Store_Ram RAM.FireUpThisFrame

CheckLeft:

	lr a, 2
	ni %00000010
	bz CheckUp

	Inc_Ram RAM.JoyLeftNow


CheckUp:

	lr a, 2
	ni %00001000
	bz CheckDown

	Inc_Ram RAM.JoyUpNow

	jmp CheckRight

CheckDown:

	lr a, 2
	ni %00000100
	bz CheckRight

	Inc_Ram RAM.JoyDownNow

CheckRight:

	lr a, 2
	ni %00000001
	bz CheckRotateRight

	Inc_Ram RAM.JoyRightNow

CheckRotateRight:


Finish:

	jmp FRAME.InputDone