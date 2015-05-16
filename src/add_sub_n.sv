// ******************************************************************
// * add_sub_n.sv -- generic input/output width, adder/substractor  *
// *                                                                *
// * Author: Daniel A. Razo                                         *
// *                                                                *
// * e-mail: da.razo@yahoo.com                                      *
// ******************************************************************

module add_sub_n 
    #(
    parameter N = 8                 // generic width       
    )(
    input  logic [N-1:0]    a_in,   // a operand
    input  logic [N-1:0]    b_in,   // b operand
    input  logic            sel,    // selector
    output logic [N-1:0]    ss_o    // sum/sub
    );

    always_comb begin
        if (sel)
            ss_o = unsigned'(a_in) - unsigned'(b_in);
        else
            ss_o = unsigned'(a_in) + unsigned'(b_in);
    end

endmodule
