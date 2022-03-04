chars:		.word Box, Fill ;// 0-7

numletters:	.word A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z
			.word tile_0, tile_1, tile_2, tile_3, tile_4, tile_5, tile_6, tile_7, tile_8, tile_9
			.word tile_slash, tile_space





Box:

	.byte %11111111
	.byte %11000000
	.byte %01100000
	.byte %00110000
	.byte %00011000
	.byte %00001100
	.byte %00000110
	.byte %00000011
	.byte %00000001
	.byte %11111111
	.byte %10000000


Fill:
	.byte %00000000
	.byte %00111111
	.byte %10011111
	.byte %11001111
	.byte %11100111
	.byte %11110011
	.byte %11111001
	.byte %11111100
	.byte %11111110
	.byte %00000000
	.byte %00000000


A:
	.byte %01110100
	.byte %01111111
	.byte %00011000
	.byte %10000000


B:
	.byte %11110100
	.byte %01111101
	.byte %00011111
	.byte %00000000

C:
	.byte %01111100
	.byte %00100001
	.byte %00000111
	.byte %10000000

D:
	.byte %11110100
	.byte %01100011
	.byte %00011111
	.byte %00000000

E:
	.byte %11111100
	.byte %00111101
	.byte %00001111
	.byte %10000000

F:	
	.byte %11111100
	.byte %00111101
	.byte %00001000
	.byte %00000000

G:	
	.byte %01111100
	.byte %00101111
	.byte %00010111
	.byte %10000000

H:	
	.byte %10001100
	.byte %01111111
	.byte %00011000
	.byte %10000000

I:	
	.byte %01110001
	.byte %00001000
	.byte %01000111
	.byte %00000000

J:	
	.byte %00001000
	.byte %01000011
	.byte %00010111
	.byte %00000000


K:	
	.byte %10001100
	.byte %10111001
	.byte %00101000
	.byte %10000000

L:	
	.byte %10000100
	.byte %00100001
	.byte %00001111
	.byte %10000000

M:	
	.byte %10001110
	.byte %11101011
	.byte %00011000
	.byte %10000000


N:	
	.byte %10001110
	.byte %01101011
	.byte %00111000
	.byte %10000000


O:	
	.byte %01110100
	.byte %01100011
	.byte %00010111
	.byte %00000000


P:	
	.byte %11110100
	.byte %01111101
	.byte %00001000
	.byte %00000000



Q:	
	.byte %01110100
	.byte %01100011
	.byte %00100110
	.byte %10000000


R:	
	.byte %11110100
	.byte %01111101
	.byte %00011000
	.byte %10000000


S:	
	.byte %01111100
	.byte %00011100
	.byte %00011111
	.byte %00000000

T:	
	.byte %11111001
	.byte %00001000
	.byte %01000010
	.byte %00000000


U:	
	.byte %10001100
	.byte %01100011
	.byte %00010111
	.byte %00000000

V:	
	.byte %10001100
	.byte %01100010
	.byte %10100010
	.byte %00000000


W:	
	.byte %10001100
	.byte %01101011
	.byte %10111000
	.byte %10000000


X:	
	.byte %10001010
	.byte %10001000
	.byte %10101000
	.byte %10000000


Y:	
	.byte %10001010
	.byte %10001000
	.byte %01000010
	.byte %00000000


Z:	
	.byte %11111000
	.byte %10001000
	.byte %10001111
	.byte %10000000

tile_0:
	.byte %01110010
	.byte %10010100
	.byte %10100111
	.byte %00000000



tile_1:
	.byte %00100011
	.byte %00001000
	.byte %01000111
	.byte %00000000


tile_2:
	.byte %01110000
	.byte %10011100
	.byte %10000111
	.byte %00000000



tile_3:
	.byte %01110000
	.byte %10011100
	.byte %00100111
	.byte %00000000



tile_4:
		.byte %01000010
	.byte %10011100
	.byte %00100001
	.byte %00000000


tile_5:
		.byte %01110010
		.byte %00011100
		.byte %00100111
		.byte %00000000



tile_6:
	.byte %01110010
	.byte %00011100
	.byte %10100111
	.byte %00000000



tile_7:
		.byte %01110000
		.byte %10000100
		.byte %00100001
		.byte %00000000


tile_8:
		.byte %01110010
		.byte %10011100
		.byte %10100111
		.byte %00000000

tile_9:
	.byte %01110010
	.byte %10011100
	.byte %00100001
	.byte %00000000



tile_slash:
	.byte %00001000
	.byte %10001000
	.byte %10001000
	.byte %00000000


tile_space:
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000


