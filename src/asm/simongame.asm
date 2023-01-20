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
0
0
75 ;; Milos kaze da je 75 jedna sekunda. Stavljeno 5 kako bi se olaksalo testiranje u simulaciji
0x100
0x140
0x200
14     ;; Adresa za crvenu
48    ;; Adresa za plavu
82    ;; Adresa za zelenu
116     ;; Adresa za zutu
150     ;; Adresa simon boja
6 ;; promenljiva adresa za simon boje
6 ;; pocetna vrednost promenljive adrese za simon boje koja se loaduje na pocetku simon begin
2	;; STATE, player 0, simon_loop 1, 2 - simon_begin , 3 - player loop // 
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
-1 ;; end simon uslov
2 ;; green  
1 ;; red
3 ;; yellow
1 ;; red
2 ;; green
4 ;; blue
-1 ;; end



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
	sub R3,R3,R3 				;; Pocetna boja - RED

frame_sync_rising_edge:
frame_sync_wait_0:
	ld R0, R6                   ;; R0 <- p_frame_sync
	jmpnz frame_sync_wait_0
frame_sync_wait_1:
	ld R0, R6                   ;; R0 <- p_frame_sync
	jmpz frame_sync_wait_1
	

check_state:
	sub R0,R0,R0
	inc R0,R0
	shl R0,R0
	shl R0,R0
	shl R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	ld R1,R0
	jmpz player
	dec R1,R1
	jmpz choose_color
	dec R1,R1
	jmpz simon_begin
	dec R1,R1
	jmpz choose_color
	jmp choose_color
	

choose_color:
	dec R3,R3
	jmpz select_red
	dec R3,R3
	jmpz select_green
	dec R3,R3
	jmpz select_yellow
	dec R3,R3
	jmpz select_blue
	jmp select_black
	

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

	
count_frames_begin:
	sub R0, R0, R0              ;; addr = 0
	inc R0, R0
	ld R1, R0                   ;; R1 <- frame_cnt
	inc R0, R0
	ld R2, R0                   ;; R2 <- frames_per_heartbeat
	dec R0, R0
	inc R1, R1                  ;; frame_cnt++;
	sub R2, R2, R1              ;; frame_cnt == frames_per_heartbeat
	jmpz count_frames_heatbeat  ;; Jump if equal.
	st R1, R0                   ;; R1 -> frame_cnt
	jmp frame_sync_rising_edge
count_frames_heatbeat:
	sub R1, R1, R1
	st R1, R0                   ;; R1 i.e. 0 -> frame_cnt	


check_state:
	sub R0,R0,R0
	inc R0,R0
	shl R0,R0
	shl R0,R0
	shl R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	ld R1,R0
	jmpz player
	dec R1,R1
	jmpz simon_loop
	dec R1,R1
	jmpz simon_begin
	dec R1,R1
	jmpz player_loop
	jmp choose_color



simon_begin:
	sub R1,R1,R1
	inc R1,R1
	st R1,R0
	dec R0,R0
	ld R1,R0
	dec R0,R0
	st R1,R0
	dec R0,R0
	jmp simon_loop

simon_loop:
	sub R0,R0,R0
	inc R0,R0
	shl R0,R0
	shl R0,R0
	shl R0,R0
	inc R0,R0
	inc R0,R0
	ld R1,R0
	inc R0,R0
	ld R3,R0
	add R1,R3,R1 ;; sabrali smo pocetnu memoriju sajmona sa trenutnom
	dec R3,R3
	st R3,R0
	ld R3,R1
	jmps simon_loop_end
	jmp frame_sync_rising_edge

	
simon_loop_end:
	sub R0,R0,R0
	inc R0,R0
	shl R0,R0
	shl R0,R0
	shl R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	
	sub R1,R1,R1
	st R1,R0

	dec R0,R0
	ld R1,R0  ;; loadujes broj sajmon boja u memorijsko mesto za i promenljivu
	dec R0,R0 
	st R1,R0	


	jmp frame_sync_rising_edge
	
player:
	sub R0,R0,R0
	inc R0,R0
	shl R0,R0
	shl R0,R0
	shl R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	sub R1,R1,R1
	inc R1,R1
	inc R1,R1
	inc R1,R1
	st R1, R0
	
	
player_loop:
	sub R0,R0,R0
	inc R0,R0
	shl R0,R0
	shl R0,R0
	shl R0,R0
	inc R0,R0
	inc R0,R0
	ld R1,R0
	inc R0,R0
	ld R2,R0
	add R1,R2,R1 ;; sabrali smo pocetnu memoriju sajmona sa trenutnom
	ld R2,R1
	jmps pobeda
	
pb_x:
	ld R0,R5 ;; p_pb_dec -> x
	jmpz pb_y
	dec R0,R0
	jmpz compare_green
	jmp compare_blue

pb_y:
	inc R5,R5
	ld R0,R5 ;; p_pb_dec -> y
	dec R5,R5
	dec R0,R0
	jmpz compare_yellow
	inc R0,R0
	inc R0,R0
	jmpz compare_red
	jmp player_loop

compare_green:
	sub R3,R3,R3
	inc R3,R3
	inc R3,R3
	jmp compare

compare_red:
	sub R3,R3,R3
	inc R3,R3
	jmp compare

compare_blue:
	sub R3,R3,R3
	inc R3,R3
	shl R3,R3
	shl R3,R3
	jmp compare

compare_yellow:
	sub R3,R3,R3
	inc R3,R3
	inc R3,R3
	inc R3,R3
	jmp compare
	


compare:
	sub R0,R0,R0
	inc R0,R0
	shl R0,R0
	shl R0,R0
	shl R0,R0
	inc R0,R0
	inc R0,R0
	ld R1,R0
	inc R0,R0
	ld R2,R0
	add R1,R2,R1 ;; sabrali smo pocetnu memoriju sajmona sa trenutnom
	dec R2,R2
	st R2,R0
	ld R2,R1
	jmps pobeda
	
	ld R2,R1
	sub R2,R3,R2
	jmpz choose_color
	jmp gubitak


pobeda:
	sub R3,R3,R3
	inc R3,R3
	shl R3,R3
	shl R3,R3
	jmp kraj
	
gubitak:
	sub R3,R3,R3
	inc R3,R3
	jmp kraj
	jmp choose_color
	jmp kraj
	
kraj:
	sub R0,R0,R0
	inc R0,R0
	shl R0,R0
	shl R0,R0
	shl R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	inc R0,R0
	sub R1,R1,R1
	inc R1,R1
	shl R1,R1
	shl R1,R1
	st R1,R0
	jmp choose_color
	

