// ******************************************************************
// * fsm_control.sv -- finite state machine                         *
// *                                                                *
// * Author: Daniel A. Razo                                         *
// *                                                                *
// * e-mail: da.razo@yahoo.com                                      *
// ******************************************************************

`define __ALTERA__      1
//`define __SYNOPSYS__    1

module fsm_control 
    (
    input  logic        clock,      // master clock
    input  logic        reset,      // master reset
    input  logic        Aeq0,       // A =! 0	
    input  logic        Apos,       // A > 0
    input  logic [2:0]  ir,         // Instruction register
    input  logic        Enter,      //
    output logic        IRload,     // Load inst reg
    output logic        JMPmux,     // Mux sel
    output logic        PCload,     // Load Prog counter 
    output logic        Meminst,    // 
    output logic        MemWr,      // 
    output logic [1:0]  Asel,       // 
    output logic        Aload,      // Load acc  
    output logic        Sub,        // 	
    output logic        Halt        // Halt 
    );

    enum int {
        START_BIT   = 0,    // index of START state in Qp register
        FETCH_BIT   = 1,    // index of FETCH state in Qp register  
        DECODE_BIT  = 2,    // index of DECODE state in Qp register
        LOAD_BIT    = 3,    // index of LOAD state in Qp register
        STORE_BIT   = 4,    // index of STORE state in Qp register
        ADD_BIT     = 5,    // index of ADD state in Qp register
        SUB_BIT     = 6,    // index of SUB state in Qp register
        INPUT_BIT   = 7,    // index of INPUT state in Qp register 
        JZ_BIT      = 8,    // index of JZ state in Qp register    
        JPOS_BIT    = 9,    // index of JPOS state in Qp register
        HALT_BIT    = 10    // index of HALT state in Qp register  
    } state_bit;    // register index

    // one-hot encoding states
    enum logic [10:0] {
        START   = 11'b00000000001 << START_BIT,
        FETCH   = 11'b00000000001 << FETCH_BIT,
        DECODE  = 11'b00000000001 << DECODE_BIT,
        LOAD    = 11'b00000000001 << LOAD_BIT,
        STORE   = 11'b00000000001 << STORE_BIT,
        ADD     = 11'b00000000001 << ADD_BIT,
        SUB     = 11'b00000000001 << SUB_BIT,
        INPUT   = 11'b00000000001 << INPUT_BIT,
        JZ      = 11'b00000000001 << JZ_BIT,
        JPOS    = 11'b00000000001 << JPOS_BIT,
        HALT    = 11'b00000000001 << HALT_BIT
    } Qp, Qn;   // inner states

`ifdef __ALTERA__
    always_comb begin : set_next_state
         Qn = Qp;    // the default for each branch below
        case (Qp)
            START : begin : start_state     // start
                Qn = FETCH;
            end : start_state
            FETCH : begin : fetch_state     // fetch 
                Qn = DECODE;
            end : fetch_state
            DECODE : begin : decode_state   // decode
                case (ir)
                    3'b000 : Qn = LOAD;     // load
                    3'b001 : Qn = STORE;    // store
                    3'b010 : Qn = ADD;      // add
                    3'b011 : Qn = SUB;      // sub	
                    3'b100 : Qn = INPUT;    // input  
                    3'b101 : Qn = JZ;       // jz
                    3'b110 : Qn = JPOS;     // jpos
                    3'b111 : Qn = HALT;     // halt
                endcase
            end : decode_state
            LOAD : begin : load_state       // load
                Qn = START;
                end : load_state
            STORE : begin : store_state     // store
                Qn = START;
            end : store_state
            ADD : begin : add_state         // add
                Qn = START;
            end : add_state
            SUB : begin : sub_state         // sub
                Qn = START;
            end : sub_state
            INPUT : begin : input_state     // input	
                if (Enter)
                	Qn = START;
                else
                	Qn = Qp;
            end : input_state
            JZ : begin : jz_state           // jz
                Qn = START;
            end : jz_state
            JPOS : begin : jpos_state       // jpos
                Qn = START;
            end : jpos_state
            HALT : begin : halt_state       // halt
                Qn = START;
            end : halt_state
        endcase
    end : set_next_state

    always_comb begin : set_outputs
        // defaults
        IRload	= 1'b0;
        JMPmux	= 1'b0;
        PCload	= 1'b0;
        Meminst = 1'b0;
        MemWr	= 1'b0;
        Asel	= 2'b00;
        Aload	= 1'b0;
        Sub     = 1'b0;
        Halt	= 1'b0;
        case (Qp)
            START : begin : start_state     // start
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b0;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : start_state
            FETCH : begin : fetch_state     // fetch 
                IRload	= 1'b1;
                JMPmux	= 1'b0;
                PCload	= 1'b1;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b0;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : fetch_state
            DECODE : begin : decode_state   // decode
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b1;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b0;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : decode_state
            LOAD : begin : load_state       // load
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b10;
                Aload	= 1'b1;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : load_state
            STORE : begin : store_state     // store
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b1;
                MemWr	= 1'b1;
                Asel	= 2'b00;
                Aload	= 1'b0;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : store_state
            ADD : begin : add_state         // add
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b1;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : add_state
            SUB : begin : sub_state         // sub
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b1;
                Sub     = 1'b1;
                Halt	= 1'b0;
            end : sub_state
            INPUT : begin : input_state     // input	
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b01;
                Aload	= 1'b1;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : input_state
            JZ : begin : jz_state           // jz
                IRload	= 1'b0;
                JMPmux	= 1'b1;
                PCload	= Aeq0;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b0;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : jz_state
            JPOS : begin : jpos_state       // jpos
                IRload	= 1'b0;
                JMPmux	= 1'b1;
                PCload	= Apos;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b0;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : jpos_state
            HALT : begin : halt_state       // halt
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b0;
                Sub     = 1'b0;
                Halt	= 1'b1;
            end : halt_state
        endcase
    end : set_outputs
`endif  // end __ALTERA__

`ifdef __SYNOPSYS__
    always_comb begin : set_next_state
        Qn = Qp;    // the default for each branch below
        unique case (1'b1)  // reverse case statement
            Qp[START_BIT] : begin : start_state     // start
                Qn = FETCH;
            end : start_state
            Qp[FETCH_BIT] : begin : fetch_state     // fetch 
                Qn = DECODE;
            end : fetch_state
            Qp[DECODE_BIT] : begin : decode_state   // decode
                unique case (ir)
                    3'b000 : Qn = LOAD;     // load
                    3'b001 : Qn = STORE;    // store
                    3'b010 : Qn = ADD;      // add
                    3'b011 : Qn = SUB;      // sub	
                    3'b100 : Qn = INPUT;    // input  
                    3'b101 : Qn = JZ;       // jz
                    3'b110 : Qn = JPOS;     // jpos
                    3'b111 : Qn = HALT;     // halt
                endcase
            end : decode_state
            Qp[LOAD_BIT] : begin : load_state       // load
                Qn = START;
                end : load_state
            Qp[STORE_BIT] : begin : store_state     // store
                Qn = START;
            end : store_state
            Qp[ADD_BIT] : begin : add_state         // add
                Qn = START;
            end : add_state
            Qp[SUB_BIT] : begin : sub_state         // sub
                Qn = START;
            end : sub_state
            Qp[INPUT_BIT] : begin : input_state     // input	
                if (Enter)
                	Qn = START;
                else
                	Qn = Qp;
            end : input_state
            Qp[JZ_BIT] : begin : jz_state           // jz
                Qn = START;
            end : jz_state
            Qp[JPOS_BIT] : begin : jpos_state       // jpos
                Qn = START;
            end : jpos_state
            Qp[HALT_BIT] : begin : halt_state       // halt
                Qn = START;
            end : halt_state
        endcase
    end : set_next_state

    always_comb begin : set_outputs
        // defaults
        IRload	= 1'b0;
        JMPmux	= 1'b0;
        PCload	= 1'b0;
        Meminst = 1'b0;
        MemWr	= 1'b0;
        Asel	= 2'b00;
        Aload	= 1'b0;
        Sub     = 1'b0;
        Halt	= 1'b0;
        unique case (1'b1)  // reverse case statement
            Qp[START_BIT] : begin : start_state     // start
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b0;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : start_state
            Qp[FETCH_BIT] : begin : fetch_state     // fetch 
                IRload	= 1'b1;
                JMPmux	= 1'b0;
                PCload	= 1'b1;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b0;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : fetch_state
            Qp[DECODE_BIT] : begin : decode_state   // decode
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b1;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b0;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : decode_state
            Qp[LOAD_BIT] : begin : load_state       // load
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b10;
                Aload	= 1'b1;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : load_state
            Qp[STORE_BIT] : begin : store_state     // store
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b1;
                MemWr	= 1'b1;
                Asel	= 2'b00;
                Aload	= 1'b0;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : store_state
            Qp[ADD_BIT] : begin : add_state         // add
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b1;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : add_state
            Qp[SUB_BIT] : begin : sub_state         // sub
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b1;
                Sub     = 1'b1;
                Halt	= 1'b0;
            end : sub_state
            Qp[INPUT_BIT] : begin : input_state     // input	
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b01;
                Aload	= 1'b1;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : input_state
            Qp[JZ_BIT] : begin : jz_state           // jz
                IRload	= 1'b0;
                JMPmux	= 1'b1;
                PCload	= Aeq0;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b0;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : jz_state
            Qp[JPOS_BIT] : begin : jpos_state       // jpos
                IRload	= 1'b0;
                JMPmux	= 1'b1;
                PCload	= Apos;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b0;
                Sub     = 1'b0;
                Halt	= 1'b0;
            end : jpos_state
            Qp[HALT_BIT] : begin : halt_state       // halt
                IRload	= 1'b0;
                JMPmux	= 1'b0;
                PCload	= 1'b0;
                Meminst = 1'b0;
                MemWr	= 1'b0;
                Asel	= 2'b00;
                Aload	= 1'b0;
                Sub     = 1'b0;
                Halt	= 1'b1;
            end : halt_state
        endcase
    end : set_outputs
`endif  // end __SYNOPSYS__

    always_ff @ (posedge clock, posedge reset) begin : sequential
        if (reset)
            Qp <= START;
        else
            Qp <= Qn;
    end : sequential

endmodule
