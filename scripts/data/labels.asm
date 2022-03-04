;------------------------
; BIOS Calls
;------------------------
clrscrn         =       $00d0                                   ;uses r31
delay           =       $008f
pushk           =       $0107                                   ;used to allow more subroutine stack space
popk            =       $011e
drawchar        =       $0679
IncP1Score      =       $02AC

;------------------------
; Colors
;------------------------
Red             =       $40
Blue            =       $80
Green           =       $00
Transparent     =       $C0
Back_green 		=      	$C0
Back_grey		= 		$C6
Clear = 				$FF



X_Reg = 45
Y_Reg = 44

SCORE_TIME = 120



NUMBER_SEGMENTS = 88

GAME_OVER_DELAY = 250

BLIT_ID = 7
BLIT_BG = 1
BLIT_COLOUR  = 2
BLIT_X = 3
BLIT_Y = 4


ENTERED_LETTER = 0
REAL_LETTER = 1

HUD_X_START = 60


DESTINATION_ID = 6
SOURCE_ID = 7

PLOT_Y = 3
PLOT_X = 2
PLOT_COLOUR = 1




BLANK_ID = 10
STORE_X = 11
STORE_Y = 12



COLUMNS = 5
ROWS = 6
BOXES = COLUMNS * ROWS


TEXT_TYPE_ENTER = 0
TEXT_TYPE_CORRECT = 1
TEXT_TYPE_WRONG = 2
TEXT_TYPE_POSITION = 3
TEXT_TYPE_ENTERED = 4


GAME_MODE_ENTRY = 0
DEBOUNCE_TIME = 100

a = 0
b = 1
c = 2
d = 3
e = 4
f = 5
g = 6
h = 7
i = 8
j = 9
k = 10
l = 11
m = 12
n = 13
o = 14
p = 15
q = 16
r = 17
s = 18
t = 19
u = 20
v = 21
w = 22
x = 23
y = 24
z = 25


TEXT_GAP = 18
TEXT_START_Y = 4
START_ROW = 4
START_COL = 10
NUMBER_Y_OFFSET = 7

SLASH_CHAR = 36
SPACE_CHAR = 37

REDUCE_FREQ = 150
NUM_BLOCKS = 49