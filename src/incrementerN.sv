// ******************************************************************
// * incrementerN.sv -- generic input/output width, incrementer     *
// *                                                                *
// * Author: Daniel A. Razo                                         *
// *                                                                *
// * e-mail: da.razo@yahoo.com                                      *
// ******************************************************************

module incrementerN 
    #(
    parameter N = 5                     // generic width
    )(
    input  logic [N-1:0]    a_in,       // input
    output logic [N-1:0]    b_out       // input + 1
    );

    logic [N-1:0] b;    // inner signal

    always_comb begin
        b[0] = 1'b1;
        for (int i = 1; i < N; i++) begin
            b[i] = b[i-1] & a_in[i-1];
        end
    end

    assign b_out = a_in ^ b;     // a_in + 1

endmodule
