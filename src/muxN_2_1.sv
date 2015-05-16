// ******************************************************************
// * muxN_2_1.sv -- generic input/output width, 2 to 1 multiplexer  *
// *                                                                *
// * Author: Daniel A. Razo                                         *
// *                                                                *
// * e-mail: da.razo@yahoo.com                                      *
// ******************************************************************

module MuxN_2_1 
    #(
    parameter int N = 8             // generic width
    )(
    input  logic [N-1:0]    in_0,   // input 0
    input  logic [N-1:0]    in_1,   // input 1
    input  logic            sel,    // selector
    output logic [N-1:0]    out_y   // output
    );

    always_comb begin
        if (sel)
            out_y = in_1;
        else
            out_y = in_0;
    end
    
endmodule
