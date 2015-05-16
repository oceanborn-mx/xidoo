// ******************************************************************
// * comparator.sv -- equal to zero comparator                      *
// *                                                                *
// * Author: Daniel A. Razo                                         *
// *                                                                *
// * e-mail: da.razo@yahoo.com                                      *
// ******************************************************************

module comparator 
    (
    input  logic [7:0]  a,      // input word
    output logic        aeq0    // flag
    );

    assign aeq0 = (a == 8'b00000000) ? 1'b1 : 1'b0;

endmodule
