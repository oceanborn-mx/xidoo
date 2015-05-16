// ******************************************************************
// * xidoo.sv -- Top level module                                   *
// *                                                                *
// * Description: An example of a simple tiny Microprocessor        *
// *              fully synthetizable.                              *
// *              Inspired by:                                      *
// *              Digital logic and Microprocessor Design with VHDL *
// *              Enoch O. Hwang                                    *
// *                                                                *
// * Author: Daniel A. Razo                                         *
// *                                                                *
// * e-mail: da.razo@yahoo.com                                      *
// ******************************************************************

module xidoo 
    (
    input  logic        RST,    // Master reset
    input  logic        CLK,    // Master clock
    input  logic [7:0]  SWT,    // input 
    input  logic        Enter,  // enter
    output logic [7:0]  LEDs,   // output
    output logic        Halt    // halt
    );

    // glue signals

    logic       IRload,JMPmux;
    logic       PCload,Meminst;
    logic       MemWr;
    logic [1:0] Asel;
    logic       Aload,Sub;
    logic       Aeq0,Apos;
    logic [2:0] IR;

    xidoo_datapath U0 
    (
        .clock(CLK),            // master clock
        .reset(RST),            // master reset
        .Input(SWT),            // Input
        .IRload(IRload),        // Load inst reg
        .JMPmux(JMPmux),        // Mux sel
        .PCload(PCload),        // Load Prog counter 
        .Meminst(Meminst),	      
        .MemWr(MemWr),	      
        .Asel(Asel),	  
        .Aload(Aload),          // Load acc  
        .Sub(Sub),		      
        .Aeq0(Aeq0),            // A =! 0	
        .Apos(Apos),            // A > 0
        .IR(IR),                // Instruction register
        .Output(LEDs)           // Output    
    );

    fsm_control U1
    (
        .clock(CLK),            // master clock
        .reset(RST),            // master reset
        .Aeq0(Aeq0),            // A =! 0	
        .Apos(Apos),            // A > 0
        .ir(IR),                // Instruction register
        .Enter(Enter),          //
        .IRload(IRload),        // Load inst reg
        .JMPmux(JMPmux),        // Mux sel
        .PCload(PCload),        // Load Prog counter 
        .Meminst(Meminst),      // 
        .MemWr(MemWr),          // 
        .Asel(Asel),            // 
        .Aload(Aload),          // Load acc  
        .Sub(Sub),              // 	
        .Halt(Halt)             // Halt 
    );

endmodule
