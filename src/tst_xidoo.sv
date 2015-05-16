// ******************************************************************
// * tst_xidoo.sv -- Test bench                                     *
// *                                                                *
// * Author: Daniel A. Razo                                         *
// *                                                                *
// * e-mail: da.razo@yahoo.com                                      *
// ******************************************************************

`timescale 1ns/100ps

module tst_xidoo;
    logic           rst;    // Master reset
    logic           clk;    // Master clock
    logic [7:0]     swt;    // input 
    logic           enter;  // enter
    logic [7:0]     leds;   // output
    logic           halt;   // halt
    
    // device under test
    xidoo dut (
        .RST(rst),      // Master reset
        .CLK(clk),      // Master clock
        .SWT(swt),      // input 
        .Enter(enter),  // enter
        .LEDs(leds),    // output
        .Halt(halt)     // halt
    );

    // stimuli
    initial	begin : Reset_Reloj	
			 //swt = 8'b00001000;
			 clk <= 1'b0;
		     rst <= 1'b1;
		#100 rst <= 1'b0;
    end	: Reset_Reloj
	
	always #10 clk = ~clk; 


    // input
	initial begin : entrada
		swt <= 8'b00000110;
		//wait for 220 ns;
        #320 swt <= 8'b00001111;
        //wait;
    end : entrada

    // push buttom
	initial begin : pushB
//		enter <= '0';
//		wait for 140 ns;
//		enter <= '1';
//		wait for 20 ns;
//		enter <= '0';
//		wait;	   

//		enter <= '0';
//		wait for 320 ns;
//		enter <= '1';
//		wait for 20 ns;
//		enter <= '0';
//		wait;		   

		enter <= 1'b0;
		//wait for 120 ns;
        #150 enter <= 1'b1;
		//wait for 20 ns;
        #40 enter <= 1'b0;
		//wait for 180 ns;
        #180 enter <= 1'b1;
		//wait for 20 ns;
        #40	enter <= 1'b0;
        enter <= 1'b0;

		//wait;
    end : pushB

		
//		STF <= '1';
//		wait for 20 ns;
//		STF <= '0';
//		wait for 999980 ns;
		
//	always begin : Muestreador  
//		#980   STF = 1'b1;
//		#20 STF = 1'b0;
//	end
		
endmodule
