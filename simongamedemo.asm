
/*
	// Ekvivalentan C kod:
	short* p_food_and_snake = &a_food_and_snake;
	short frames_cnt = 0;
	short frames_per_heartbeat = 75; // 75 for synth, 1 for sim.
	short* p_rgb_matrix = 0x100;
	short* p_frame_sync = 0x140;
	short* p_pb_dec = 0x200;
	typedef struct {
		short x;
		short y
	} chunk_t;
	chunk_t a_food_and_snake[67] = {
		{6, 2}, // Food.
		{2, 4}, // Head.
		{2, 3},
		{2, 2},
		{2, 1},
		{1, 1}, // Tail.
		{-1, -1},
	};

*/
.data
6
0
75 ;; Milos kaze da je 75 jedna sekunda. Stavljeno 5 kako bi se olaksalo testiranje u simulaciji
0x100
0x140
0x200
10     ;; Adresa za crvenu
44    ;; Adresa za plavu
78     ;; Adresa za zelenu
112     ;; Adresa za zutu
0, 0     ;; 0x10 CRVENA
1, 0
1, 1
2, 0
2, 1
2, 2
3, 0
3, 1
3, 2
3, 3
4, 0
4, 1
4, 2
5, 0
5, 1
6, 0
-1, -1
0, 1  ;; 0x44 PLAVA
0, 2
0, 3
0, 4
0, 5
0, 6
0, 7
1, 2
1, 3
1, 4
1, 5
1, 6
2, 3
2, 4
2, 5
3, 4
-1, -1
7, 0 ;; 0x78 ZELENA
7, 1
7, 2
7, 3
7, 4
7, 5
7, 6
6, 1
6, 2
6, 3
6, 4
6, 5
5, 2
5, 3
5, 4
4, 3
-1, -1
1, 7 ;; 0x112 ZUTA
2, 6
2, 7
3, 5
3, 6
3, 7
4, 4
4, 5
4, 6
4, 7
5, 5
5, 6
5, 7
6, 6
6, 7
7, 7
-1, -1 ;; y je na 0x145 adresi

;; znaci do 0x150 je sve zauzeto

/*
	Ekvivalentan C kod (viši nivo):
*/
.text
/*
	Spisak registara:
	R0 - tmp register
	R1 - tmp chunk x
	R2 - tmp chunk y
	R3 - color
	R4 - p_color_positions
	R5 - p_pb_dec
	R6 - p_frame_sync
	R7 - p_rgb_matrix
*/

begin:
	;; Setup pointers and color.
	inc R0, R0                  ;; addr = 1
	inc R0, R0                  ;; addr = 2
	inc R0, R0                  ;; addr = 3
	ld R7, R0                   ;; R7 <- p_rgb_matrix
	inc R0, R0                  ;; addr = 4
	ld R6, R0                   ;; R6 <- p_frame_sync
	inc R0, R0                  ;; addr = 5
	ld R5, R0                   ;; R5 <- p_pb_dec
	inc R3,R3		    ;; Pocetna boja - RED

frame_sync_rising_edge:
frame_sync_wait_0:
	ld R0, R6                   ;; R0 <- p_frame_sync
	jmpnz frame_sync_wait_0
frame_sync_wait_1:
	ld R0, R6                   ;; R0 <- p_frame_sync
	jmpz frame_sync_wait_1

pera:
	sub R0,R0,R0
	st R0,R5
	inc R5,R5
	st R0,R5
	dec R5,R5

pb_x:
	ld R0,R5 ;; p_pb_dec -> x
	jmpz pb_y
	dec R0,R0
	jmpz select_green
	jmp select_blue

pb_y:
	inc R5,R5
	ld R0,R5 ;; p_pb_dec -> y
	dec R5,R5
	dec R0,R0
	jmpz select_yellow
	jmpnz select_red
	jmp pera

select_red:
	sub R3,R3,R3
	inc R3,R3
	sub R0,R0,R0
	inc R0,R0
	shl R0,R0
	shl R0,R0
	inc R0,R0
	inc R0,R0
	ld R4,R0
	jmp draw_color_loop
		
select_green:
	sub R3,R3,R3
	inc R3,R3
	shl R3,R3
	sub R0,R0,R0
	inc R0,R0
	shl R0,R0
	shl R0,R0
	shl R0,R0
	ld R4,R0
	jmp draw_color_loop

select_blue:
	sub R3,R3,R3
	inc R3,R3
	shl R3,R3
	shl R3,R3
	sub R0,R0,R0
	inc R0,R0
	shl R0,R0
	shl R0,R0
	shl R0,R0
	dec R0,R0
	ld R4,R0
	jmp draw_color_loop

select_yellow:
	sub R3,R3,R3
	inc R3,R3
	shl R3,R3
	inc R3,R3
	sub R0,R0,R0
	inc R0,R0
	shl R0,R0
	shl R0,R0
	shl R0,R0
	inc R0,R0
	ld R4,R0
	jmp draw_color_loop
select_black:
	sub R3,R3,R3
	sub R0,R0,R0
	inc R0,R0
	shl R0,R0
	shl R0,R0
	shl R0,R0
	shl R0,R0
	shl R0,R0
	sub R4,R4,R0
	
draw_color_loop:
	ld R1, R4                   ;; R1 <- p_food_and_snake->x
	jmps draw_color_end ;; Jump to end if passed tail of snake.
	inc R4, R4
	ld R2, R4                   ;; R2 <- p_food_and_snake->y
	inc R4, R4                  ;; Move p_food_and_snake
	;; p_rgb_matrix + (y << 3) + x        [y][x]   0+x   8+x 16+x   
	shl R2, R2
	shl R2, R2
	shl R2, R2
	add R2, R1, R2              ;; (y << 3) + x
	add R2, R7, R2              ;; p_rgb_matrix + 
	st R3, R2                   ;; R3 -> p_rgb_matrix[y][x]
	jmp draw_color_loop
draw_color_end:

count_frames_begin:		    ;; Ovo je counter. Na adresu 2 staviti broj frejmova. 75 za 1s
	sub R0, R0, R0              ;; addr = 0
	inc R0, R0
	ld R1, R0                   ;; R1 <- frame_cnt
	inc R0, R0
	ld R2, R0                   ;; R2 <- frames_per_heartbeat
	dec R0, R0
	inc R1, R1                  ;; frame_cnt++;
	sub R2, R2, R1              ;; frame_cnt == frames_per_heartbeat
	jmpz count_frames_heatbeat  ;; Jump if equal.
	st R1, R0
	sub R0,R0,R0
	st R0,R5
	inc R5,R5
	st R0,R5
	dec R5,R5                 ;; R1 -> frame_cnt
	jmp frame_sync_rising_edge
count_frames_heatbeat:
	sub R1, R1, R1
	st R1, R0                   ;; R1 i.e. 0 -> frame_cnt
	inc R3,R3		    ;; VAŽNO!!! Nakon sto odbroji 75 frejma tj. nacrta jednu boju X puta, prelazi se na sledecu boju
	sub R0,R0,R0
	st R0,R5
	inc R5,R5
	st R0,R5
	dec R5,R5
	jmp frame_sync_rising_edge



