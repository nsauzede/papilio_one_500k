`ifdef SIMULATION
module darkram #(parameter INIT_FILE = "memory_init.mem")
(
    input           CLK,    
    input           RES,    
    input           HLT,    

    input           IDREQ,  
    input  [31:0]   IADDR,  
    output [31:0]   IDATA,  
    output          IDACK,  

    input           XDREQ,  
    input           XRD,    
    input           XWR,    
    input  [3:0]    XBE,    
    input  [31:0]   XADDR,  
    input  [31:0]   XATAI,  
    output [31:0]   XATAO,  
    output          XDACK,  

    output [3:0]    DEBUG   
);

    reg [31:0] ram [0:8191];  // 4KB RAM
    reg [31:0] ram_q_a = 0, ram_q_b = 0;

    initial begin
        $readmemh(INIT_FILE, ram); // Load memory contents
    end

    always @(posedge CLK) begin
//        if (RES) begin
//            ram_q_a <= 0;
//        end else begin
        if (XDREQ && XWR) begin
            if (XBE[0]) ram[XADDR[13:2]][7:0]   <= XATAI[7:0];
            if (XBE[1]) ram[XADDR[13:2]][15:8]  <= XATAI[15:8];
            if (XBE[2]) ram[XADDR[13:2]][23:16] <= XATAI[23:16];
            if (XBE[3]) ram[XADDR[13:2]][31:24] <= XATAI[31:24];
        end

//        if (IDREQ)
            ram_q_a <= ram[IADDR[12:2]];
            
        if (XDREQ && XRD)
            ram_q_b <= ram[XADDR[12:2]];
//        end
    end

    assign IDATA = ram_q_a;
    assign IDACK = IDREQ;

    assign XATAO = ram_q_b;
    assign XDACK = DTACK==1 ||(XDREQ&&XWR);
    reg [3:0] DTACK  = 0;
    always@(posedge CLK) // stage #1.0
    begin
        DTACK <= RES ? 0 : DTACK ? DTACK-1 : XDREQ && XRD ? 1 : 0;
    end

    // Debug outputs (for observability)
    assign DEBUG = { XDREQ,XRD,XWR,XDACK };
endmodule
`else
module darkram #(parameter INIT_FILE = "memory_init.mem")
(
    input           CLK,    // Clock
    input           RES,    // Reset
    input           HLT,    // Halt

    input           IDREQ,  // Instruction fetch request
    input  [31:0]   IADDR,  // Instruction address
    output [31:0]   IDATA,  // Instruction data output
    output          IDACK,  // Instruction acknowledge

    input           XDREQ,  // Data request
    input           XRD,    // Read enable
    input           XWR,    // Write enable
    input  [3:0]    XBE,    // Byte enable
    input  [31:0]   XADDR,  // Data address
    input  [31:0]   XATAI,  // Data input
    output [31:0]   XATAO,  // Data output
    output          XDACK,  // Data acknowledge

    output [3:0]    DEBUG   // Debug signals
);

    // Internal signals
    wire [31:0] ram_q_a, ram_q_b;
    wire        write_enable;

    reg [3:0] DTACK  = 0;
/*
    RAMB16_S36_S36 #(
        .INIT_FILE("memory_init.mif")  // Initialization File
    ) ram_inst (
        // Port A - Instruction Fetch (Read-Only)
        .ADDRA({1'b0, IADDR}),  // Address for Port A
        .DIA(32'b0),  // No writes on Port A (Read-Only)
        .DOA(ram_q_a),  // Data output for Port A
        .WEA(4'b0000),  // No write enable (Read-Only)
        .ENA(1'b1),  // Enable Port A
        .CLKA(CLK),  // Clock for Port A
        .SSRA(1'b0),  // No reset

        // Port B - Data Access (Read/Write)
        .ADDRB({1'b0, XADDR}),  // Address for Port B
        .DIB(XATAI),  // Data input for Port B
        .DOB(ram_q_b),  // Data output for Port B
        .WEB(write_enable ? XBE : 4'b0000),  // Byte enable control
        .ENB(1'b1),  // Enable Port B
        .CLKB(CLK),  // Clock for Port B
        .SSRB(1'b0)  // No reset
    );
*/
    // Four independent BRAM instances, one per byte
    RAMB16_S9_S9 #(
    .INIT_00(256'hCAFEBABEDEADBEEF123456789ABCDEF0123456789ABCDEF0CAFEBABEDEADBEEF),
    .INIT_01(256'h00112233445566778899AABBCCDDEEFF00112233445566778899AABBCCDDEEFF),
    // Continue for INIT_02 to INIT_3F (total 64 entries for full BRAM init)
    .INIT_3F(256'hDEADBEEFCAFEBABE112233445566778899AABBCCDDEEFF001122334455667788)
        )
    ram_byte0 (
        .ADDRA({1'b0, IADDR}), .DOA(ram_q_a[7:0]), .DIA(8'b0), 
        .WEA(1'b0), .ENA(1'b1), .CLKA(CLK), .SSRA(1'b0), 

        .ADDRB({1'b0, XADDR}), .DOB(ram_q_b[7:0]), .DIB(XATAI[7:0]), 
        .WEB(write_enable & XBE[0]), .ENB(1'b1), .CLKB(CLK), .SSRB(1'b0)
    );

    RAMB16_S9_S9 ram_byte1 (
        .ADDRA({1'b0, IADDR}), .DOA(ram_q_a[15:8]), .DIA(8'b0), 
        .WEA(1'b0), .ENA(1'b1), .CLKA(CLK), .SSRA(1'b0), 

        .ADDRB({1'b0, XADDR}), .DOB(ram_q_b[15:8]), .DIB(XATAI[15:8]), 
        .WEB(write_enable & XBE[1]), .ENB(1'b1), .CLKB(CLK), .SSRB(1'b0)
    );

    RAMB16_S9_S9 ram_byte2 (
        .ADDRA({1'b0, IADDR}), .DOA(ram_q_a[23:16]), .DIA(8'b0), 
        .WEA(1'b0), .ENA(1'b1), .CLKA(CLK), .SSRA(1'b0), 

        .ADDRB({1'b0, XADDR}), .DOB(ram_q_b[23:16]), .DIB(XATAI[23:16]), 
        .WEB(write_enable & XBE[2]), .ENB(1'b1), .CLKB(CLK), .SSRB(1'b0)
    );

    RAMB16_S9_S9 ram_byte3 (
        .ADDRA({1'b0, IADDR}), .DOA(ram_q_a[31:24]), .DIA(8'b0), 
        .WEA(1'b0), .ENA(1'b1), .CLKA(CLK), .SSRA(1'b0), 

        .ADDRB({1'b0, XADDR}), .DOB(ram_q_b[31:24]), .DIB(XATAI[31:24]), 
        .WEB(write_enable & XBE[3]), .ENB(1'b1), .CLKB(CLK), .SSRB(1'b0)
    );

/*
    // Instantiate altsyncram
    altsyncram #(
        .operation_mode("BIDIR_DUAL_PORT"),
        .width_a(32),
        .widthad_a(13),  // Address width for 4KB RAM
        .numwords_a(2048),
        .width_b(32),
        .widthad_b(13),
        .numwords_b(2048),
        .lpm_type("altsyncram"),
        .ram_block_type("AUTO"),
//        .init_file(INIT_FILE),
//        .init_file("../darkriscv/src/four.hex"),
        .init_file("../memory_init.mif"),
        .outdata_reg_a("UNREGISTERED"),
        .outdata_reg_b("UNREGISTERED"),
        .indata_reg_b("CLOCK0"),
        .address_reg_b("CLOCK0"),
        .wrcontrol_wraddress_reg_b("CLOCK0"),
        .byte_size(8),
        .width_byteena_a(4),
        .width_byteena_b(4),
        .byteena_reg_b("CLOCK0")
    ) ram_inst (
        .clock0(CLK),
        .address_a(IADDR[12:2]),
        .q_a(ram_q_a),
        .address_b(XADDR[12:2]),
        .wren_b(write_enable),
        .byteena_b(XBE),
        .data_b(XATAI),
        .q_b(ram_q_b)
    );
*/
    assign write_enable = XWR & XDREQ;

    // Assign instruction fetch outputs
    assign IDATA = ram_q_a;
    assign IDACK = IDREQ;  // Immediate ACK for simplicity

    // Assign data read/write outputs
    assign XATAO = ram_q_b;
    assign XDACK = DTACK==1 ||(XDREQ&&XWR);
    always@(posedge CLK) // stage #1.0
    begin
        DTACK <= RES ? 0 : DTACK ? DTACK-1 : XDREQ && XRD ? 1 : 0;
    end

    // Debug outputs (for observability)
    assign DEBUG = { XDREQ,XRD,XWR,XDACK };

endmodule
`endif
