/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-08 16:56
 * Last modified : 2018-04-08 16:56
 * Filename      : top.v
 * Description   : 
 * *********************************************************************/
module  Greedy_snake(
        input                   CLOCK_50                ,
        //ir
        input                   IRDA_RXD                ,
        //ADC
        output  wire            VGA_CLK                 ,
        output  wire            VGA_SYNC_N              ,
        output  wire            VGA_BLANK_N             ,
        //VGA               
        output  wire            VGA_HS                  ,
        output  wire            VGA_VS                  ,
        output  wire  [ 7: 0]   VGA_R                   ,
        output  wire  [ 7: 0]   VGA_G                   ,
        output  wire  [ 7: 0]   VGA_B                   ,
        //smg
        output  wire  [ 6: 0]   HEX0                    ,
        output  wire  [ 6: 0]   HEX1                    
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
wire                            rst_n                           ; 
wire                            clk_25m                         ;
wire                            clk_65m                         ; 
wire                            clk_50m                         ; 
wire                            rom_rd_en                       ;
wire    [ 7: 0]                 rom_data                        ; 

wire                            hit_wall                        ;
wire                            hit_body                        ;
                                                                
wire    [ 7: 0]                 play_vga_r                      ;
wire    [ 7: 0]                 play_vga_g                      ;
wire    [ 7: 0]                 play_vga_b                      ;
wire                            play_hs                         ;
wire                            play_vs                         ;
              
wire    [ 1: 0]                 object                          ;
wire    [ 5: 0]                 apple_x                         ;
wire    [ 4: 0]                 apple_y                         ;
wire    [ 9: 0]                 pixel_x                         ;
wire    [ 9: 0]                 pixel_y                         ;

wire    [ 5: 0]                 head_x                          ;
wire    [ 4: 0]                 head_y                          ; 
wire    [ 2: 0]                 game_status                     ; 
wire                            body_add_sig                    ;

wire    [ 7: 0]                 ir_data                         ;
wire                            ir_dout_vld                     ;

wire    [ 7: 0]                 snake_length                    ; 

//======================================================================
// ***************      Main    Code    ****************
//======================================================================
assign  VGA_CLK     =       ~clk_25m;
assign  VGA_BLANK_N =       VGA_HS && VGA_VS;
assign  VGA_SYNC_N  =       1'b0;



pll_clk	pll_clk_inst (
        .inclk0                 (CLOCK_50               ),
        .c0                     (clk_50m                ),
        .c1                     (clk_25m                ),
        .c2                     (clk_65m                ),
        .locked                 (rst_n                  )
	);

game_ctrl   game_ctrl_inst(
        .clk                    (clk_25m                ),
        .rst_n                  (rst_n                  ),
        //IR
        .ir_data                (ir_data                ),
        .ir_dout_vld            (ir_dout_vld            ),
        //
        .hit_wall               (hit_wall               ),
        .hit_body               (hit_body               ),
        .game_status            (game_status            ),
        //play
        .play_vga_r             (play_vga_r             ),
        .play_vga_g             (play_vga_g             ),
        .play_vga_b             (play_vga_b             ),
        .play_hs                (play_hs                ),
        .play_vs                (play_vs                ),
        //vga
        .vga_r                  (VGA_R                  ),
        .vga_g                  (VGA_G                  ),
        .vga_b                  (VGA_B                  ),
        .vga_hs                 (VGA_HS                 ),
        .vga_vs                 (VGA_VS                 )
);

vga_play    vga_play_inst(
        .clk                    (clk_25m                ),
        .rst_n                  (rst_n                  ),
        //
        .object                 (object                 ),
        .apple_x                (apple_x                ),
        .apple_y                (apple_y                ),
        .pixel_x                (pixel_x                ),
        .pixel_y                (pixel_y                ),
        
        //vga
        .play_vga_r             (play_vga_r             ),
        .play_vga_g             (play_vga_g             ),
        .play_vga_b             (play_vga_b             ),
        .play_hs                (play_hs                ),
        .play_vs                (play_vs                )
);

ir_decode   ir_decode_inst(
        .clk                    (clk_25m                ),
        .rst_n                  (rst_n                  ),
        //ir
        .ir_din                 (IRDA_RXD               ),
        .ir_data                (ir_data                ),
        .ir_dout_vld            (ir_dout_vld            )
);



snake_ctrl  snake_ctrl_inst(
        .clk                    (clk_25m                ),
        .rst_n                  (rst_n                  ),
        //IR
        .ir_data                (ir_data                ),
        .ir_dout_vld            (ir_dout_vld            ),
        //pixel
        .pixel_x                (pixel_x                ),
        .pixel_y                (pixel_y                ),
        .game_status            (game_status            ),
        .body_add_sig           (body_add_sig           ),
        .snake_length           (snake_length           ),
        //head
        .head_x                 (head_x                 ),
        .head_y                 (head_y                 ),
        //hit
        .hit_body               (hit_body               ),
        .hit_wall               (hit_wall               ),
        .object                 (object                 )
);
apple_generate  apple_generate_inst(
        .clk                    (clk_25m                ),
        .rst_n                  (rst_n                  ),
        //head
        .head_x                 (head_x                 ),
        .head_y                 (head_y                 ),
        //apple
        .apple_x                (apple_x                ),
        .apple_y                (apple_y                ),
        
        .body_add_sig           (body_add_sig           )
);


smg smg_inst(
        .clk                    (clk_25m                ),
        .rst_n                  (rst_n                  ),
        //ir
        .snake_length           (snake_length           ),
        //smg
        .HEX0                   (HEX0                   ),
        .HEX1                   (HEX1                   )
);
endmodule
