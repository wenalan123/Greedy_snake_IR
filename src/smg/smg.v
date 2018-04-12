module  smg(
        input                   clk                     ,
        input                   rst_n                   ,
        //ir
        input         [ 7: 0]   snake_length            ,
        //smg
        output  wire  [ 6: 0]   HEX0                    ,
        output  wire  [ 6: 0]   HEX1                    
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
reg     [ 3: 0]                 hex_in0                         ;
reg     [ 3: 0]                 hex_in1                         ;


//======================================================================
// ***************      Main    Code    ****************
//======================================================================
//ir_data_tmp
always  @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0)
            {hex_in1,hex_in0}   <=      'd0;
        else 
            {hex_in1,hex_in0}   <=     snake_length;
end




smg_decoder smg_decoder_inst0(
        .hex_in                 (hex_in0                ),
        .hex_out                (HEX0                   )
);
smg_decoder smg_decoder_inst1(
        .hex_in                 (hex_in1                ),
        .hex_out                (HEX1                   )
);



endmodule
