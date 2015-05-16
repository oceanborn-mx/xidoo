// ******************************************************************
// * regN_en_D.sv -- generic input/output width, enabled register   *
// *                                                                *
// * Author: Daniel A. Razo                                         *
// *                                                                *
// * e-mail: da.razo@yahoo.com                                      *
// ******************************************************************

module regN_en_D 
    #(
    parameter N = 8                     // generic width
    )(
    input  logic            clock,      // master clock
    input  logic            reset,      // master reset
    input  logic            enable,     // enable
    input  logic [N-1:0]    d_in,       // data in
    output logic [N-1:0]    d_out       // data out
    );

    logic [N-1:0] Qp, Qn;   // inner states
    
    always_comb begin
        if (enable)
            Qn = d_in;  // load
        else    
            Qn = Qp;    // hold

        d_out = Qp;     // data out
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            Qp <= '0;
        else
            Qp <= Qn;
    end

endmodule
