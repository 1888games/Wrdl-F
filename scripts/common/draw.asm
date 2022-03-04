


DrawChar:
	;// registers reference:
	;// r1 = reserved (plot color)
	;// r2 = reserved (plot x)
	;// r3 = reserved (plot y)
	;// r4 = color 1
	;// r5 = color t5c§1	q§	§	§§	±	
	;// r6 = x
	;// r7 = y
	;// r8 = loop1 (row)
	;// r9 = loop2 (column)
	;// r10 = bitmask
	;// r11 = graphics byte

	;// save the return address
	;//lr	K, P
	;//pi	pushk

	;// get the tile address
	dci	numletters
	;// add the offset
	lr	A, 7
	sl 1
	adc
	lm
	lr	Qu, A
	lm
	lr	Ql, A
	lr	DC, Q

	;// Get the colour of the char

	;// load the width and height
	li	5
	lr	5, A
	lr	6, A

	;// draw the tile itself
	jmp	blit
	
DrawBox:
	
	;// get the tile address
	dci	chars
	lr	A, 7
	sl 1
	adc
	lm
	lr	Qu, A
	lm
	lr	Ql, A
	lr	DC, Q

	;// load the width and height
	li	9

NowDraw:

	lr	5, A
	lr	6, A

.drawSegmentBlit:
	;// draw the tile itself
	jmp	blit

