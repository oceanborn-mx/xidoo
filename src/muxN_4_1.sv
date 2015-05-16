// ******************************************************************
// * muxN_4_1.sv -- generic input/output width, 4 to 1 multiplexer  *
// *                                                                *
// * Author: Daniel A. Razo                                         *
// *                                                                *
// * e-mail: da.razo@yahoo.com                                      *
// ******************************************************************

module MuxN_4_1 
    #(
    parameter N = 8                 // generic width
    )(
    input  logic [N-1:0]    in_0,   // input 0
    input  logic [N-1:0]    in_1,   // input 1
    input  logic [N-1:0]    in_2,   // input 2
    input  logic [N-1:0]    in_3,   // input 3
    input  logic [1:0]      sel,    // selector
    output logic [N-1:0]    out_y   // output
    );

    always_comb begin
        case (sel)
            2'b00 : out_y = in_0;
            2'b01 : out_y = in_1;
            2'b10 : out_y = in_2;
            2'b11 : out_y = in_3;
        endcase
    end
    
endmodule
