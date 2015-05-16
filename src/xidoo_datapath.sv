// ******************************************************************
// * xidoo_datapath.sv -- joining all the components                *
// *                                                                *
// * Author: Daniel A. Razo                                         *
// *                                                                *
// * e-mail: da.razo@yahoo.com                                      *
// ******************************************************************

module xidoo_datapath 
    (
    input  logic        clock,      // master clock
    input  logic        reset,      // master reset
    input  logic [7:0]  Input,      // Input
    input  logic        IRload,     // Load inst reg
    input  logic        JMPmux,     // Mux sel
    input  logic        PCload,     // Load Prog counter 
    input  logic        Meminst,	      
    input  logic        MemWr,	      
    input  logic [1:0]  Asel, 	  
    input  logic        Aload,      // Load acc  
    input  logic        Sub,		      
    output logic        Aeq0,       // A =! 0	
    output logic        Apos,       // A > 0
    output logic [2:0]  IR,         // Instruction register
    output logic [7:0]  Output      // Output    
    );

    // glue signals

    // Mux8 4 to 1
    logic [7:0]	Instr, I3;

    // Register acc
    logic [7:0]	YA, A;

    // Add/Sub
    logic [7:0]	SS;

    // Instruction reg
    logic [7:0]	QIR;

    // Mux5 2 to 1
    logic [4:0]	IPC,DPC;

    // Program counter reg
    logic [4:0]	PC;
    
    // 2nd Mux5 2 to 1
    logic [4:0]	Addr;

    // modules

    MuxN_4_1
    #(
        .N(8)               // generic width
    ) U1 (
        .in_0(SS),          // input 0
        .in_1(Input),       // input 1
        .in_2(Instr),       // input 2
        .in_3(I3),          // input 3
        .sel(Asel),         // selector
        .out_y(YA)          // output
    );

    regN_en_D 
    #(
        .N(8)               // generic width
    ) U2 (
        .clock(clock),      // master clock
        .reset(reset),      // master reset
        .enable(Aload),     // enable
        .d_in(YA),          // data in
        .d_out(A)           // data out
    );

    comparator U3
    (
        .a(A),              // input word
        .aeq0(Aeq0)         // flag
    );

    add_sub_n 
    #(
        .N(8)               // generic width       
    ) U4 (
        .a_in(A),           // a operand
        .b_in(Instr),       // b operand
        .sel(Sub),          // selector
        .ss_o(SS)           // sum/sub
    );
    
    regN_en_D 
    #(
        .N(8)               // generic width
    ) U5 (
        .clock(clock),      // master clock
        .reset(reset),      // master reset
        .enable(IRload),    // enable
        .d_in(Instr),       // data in
        .d_out(QIR)         // data out
    );

    MuxN_2_1 
    #(
        .N(5)               // generic width
    ) U6 (
        .in_0(IPC),         // input 0
        .in_1(QIR[4:0]),    // input 1
        .sel(JMPmux),       // selector
        .out_y(DPC)         // output
    );

    regN_en_D 
    #(
        .N(5)               // generic width
    ) U7 (
        .clock(clock),      // master clock
        .reset(reset),      // master reset
        .enable(PCload),    // enable
        .d_in(DPC),         // data in
        .d_out(PC)          // data out
    );
    
    MuxN_2_1 
    #(
        .N(5)               // generic width
    ) U8 (
        .in_0(PC),          // input 0
        .in_1(QIR[4:0]),    // input 1
        .sel(Meminst),      // selector
        .out_y(Addr)        // output
    );

    incrementerN 
    #(
        .N(5)               // generic width
    ) U9 (
        .a_in(PC),          // input
        .b_out(IPC)         // input + 1
    );

    single_clk_ram
    #(
        .M(8),                  // width input word
        .N(5),                  // address bits
        .K(32)                  // memory locations K = 2^N
    ) U10 (
        .clk(clock),            // master clock
        .we(MemWr),             // write enable
        .write_address(Addr),   // write address
        .read_address(Addr),    // read address
        .d(A),                  // input word
        .q(Instr)               // output word
    );

    // wired
    assign Apos     = ~A[7]; 
    assign IR       = QIR[7:5];
    assign Output   = A;

endmodule
