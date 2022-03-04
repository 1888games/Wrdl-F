
-----------;
; Play Song ;
;-----------;

; plays a song from memory
; song address stored in DC0
; uses r3, r4, r5, r7

playSong:                       				; taken from Pro Football
	lis	3						; A = 3
	lr	4, A						; A -> r4, r4 = 3

.playSongDelay1:      
	inc							; increase A
	bnz	.playSongDelay1					; [Branch if not zero] back to .psdly1
	am							; Memory adressed by DC0 is added to A, flags set  - get duration data
	lr	7, A						; A -> r7
	bz	.playSongEnd					; Go to end if zero
	lm							; Load memory into A (adressed by DC0) - get frequency data
	lr	5, A						; A -> r5

	; check to see if we should pause
	inc
	bnc  .playSongLoop					; it didn't roll over, play a note instead

.playSongPause:
	li	$ff
	lr	6, A
.playSongPauseLoop:
	ds	6						; pause counter
	bnz	.playSongPauseLoop
	ds	7						; duration of the pause
	bnz	.playSongPause

	; play the next note
	br	playSong

.playSongLoop:
	li	$80						; A= $80 
	outs	5						; Send  A -> port 5
	lr	A, 5						; r5 -> A

.playSongDelay2:
	inc							; increase A
	bnz	.playSongDelay2						; [Branch if not zero] back to .psdly2
	outs	5						; A -> port 5
	lr	A, 5						; r5 -> A

.playSongDelay3:
	inc							; increase A
	bnz	.playSongDelay3					; [Branch if not zero] back to .psdly3
	ds	4						; decrease r4
	bnz	.playSongLoop					; [Branch if not zero] back to .psloop
	lis	3						; A = 3
	lr	4, A						; A -> r4
	ds	7						; decrease r7
	bnz	.playSongLoop						; [Branch if not zero] back to .psloop
	br	playSong					; start over - branch to beginning

.playSongEnd:
	pop		



sfx.error:

	.byte 10, 100, 10, 50
	.byte 0


sfx.moveSegmentRight:

	.byte 5, 130, 0

sfx.moveSegmentLeft:

	.byte 5, 110, 0



sfx.win:

	.byte 20, 150, 20, 120, 20, 90, 20, 120, 15, 150, 15, 120, 50, 150
	.byte 0

