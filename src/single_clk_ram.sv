// ******************************************************************
// * single_clk_ram.sv -- single clock RAM                          *
// *                                                                *
// * Author: Daniel A. Razo                                         *
// *                                                                *
// * e-mail: da.razo@yahoo.com                                      *
// ******************************************************************

module single_clk_ram
    #(
    parameter int M = 8,    // width input word
    parameter int N = 4,    // address bits
    parameter int K = 16    // memory locations K = 2^N
    )(
    input  logic            clk,            // master clock
    input  logic            we,             // write enable
    input  logic [N-1:0]    write_address,  // write address
    input  logic [N-1:0]    read_address,   // read address
    input  logic [M-1:0]    d,              // input word
    output logic [M-1:0]    q               // output word
    );

    logic [M-1:0] mem [K-1:0];  // memory locations

    // initialize RAM
    // TODO: do this in a separate file
    // int i;
    
    initial begin : initialization
        //for (i = 0; i < 32; i = i + 1)
        //    mem[i] = i[7:0];
        
        // COUNT
        // Program to countdown from input N to 0
        //mem[0] 	= 8'b10000000;	//	input
        //mem[1] 	= 8'b01111111;	//	sub A,11111
        //mem[2] 	= 8'b10100100;	//	jz 00100
        //mem[3] 	= 8'b11000001;	//	jp 00001
        //mem[4]	= 8'b11111111;	//	halt
        //mem[31]	= 8'b00000001;	//	constant 1	
        //	///////////////////////////////////////////////////

        // SUM
        // Program to sum N downto 1
        //mem[0] 	= 8'b00011101;	//	load A,one		-- zero sum by doing 1-1
        //mem[1] 	= 8'b01111101;	//	sub A,one
        //mem[2] 	= 8'b00111110;	//	store A,sum
        //
        //mem[3] 	= 8'b10000000;	//	input A
        //mem[4]	= 8'b00111111;	//	store A,n  
        //
        //mem[5] 	= 8'b00011111;	//	loop: load A,n  -- n + sum
        //mem[6]	= 8'b01011110;	//	add A,sum 
        //mem[7] 	= 8'b00111110;	//	store A,sum
        //mem[8]	= 8'b00011111;	//	load A,n		-- decrement A	
        //mem[9]	= 8'b01111101;	//	sub A,one
        //mem[10]	= 8'b00111111;	//	store A,n 
        //
        //mem[11] = 8'b10101101;	//	jz out
        //mem[12]	= 8'b11000101;	//	jp loop	
        //mem[13]	= 8'b00011110;	//	out: load A,sum
        //mem[14]	= 8'b11111111;	//	halt
        //
        //mem[29] = 8'b00000001;	//	one
        //mem[30]	= 8'b00000000;	//	sum	
        //mem[31]	= 8'b00000000;	//	n 
        
        // GCD
        // Program to calculate the GCD of two numbers
        mem[0] 	= 8'b10000000;  // input A
        mem[1] 	= 8'b00111110;  // store A,x
        mem[2] 	= 8'b10000000;  // input A
        mem[3] 	= 8'b00111111;  // store A,y
        
        mem[4]	= 8'b00011110;  // loop: load A,x   -- x = y 
        mem[5] 	= 8'b01111111;  // sub A,y
        mem[6]	= 8'b10110000;  // jz out           -- x == y
        mem[7] 	= 8'b11001100;  // jp xgty          -- x > y	 
        
        mem[8]	= 8'b00011111;  // load A,y         -- y > x		
        mem[9]	= 8'b01111110;  // sub A,x          -- y - x
        mem[10]	= 8'b00111111;  // store A,y 
        mem[11] = 8'b11000100;  // jz loop	  
        
        mem[12]	= 8'b00011110;  // xgty: load A,x   -- x > y	
        mem[13]	= 8'b01111111;  // sub A,y          -- x - y
        mem[14]	= 8'b00111110;  // store A,x 
        mem[15]	= 8'b11000100;  // jp loop  
        
        mem[16]	= 8'b00011110;  // load A,x
        mem[17]	= 8'b11111111;  // halt
        
        mem[30]	= 8'b00000000;  // x	
        mem[31]	= 8'b00000000;  // y
    end : initialization

    always_ff @ (posedge clk) begin
        if (we)
            mem[write_address] <= d;

        q <= mem[read_address]; // q doesn't get d in this clock cycle
    end
    
endmodule
