module aaatop #( parameter integer SHIFT = 23) // Counter shift to increment the address
(   input rx,
    inout tx,
    inout [15:0] W1A,
    inout [15:0] W1B,
    inout [15:0] W2C,
    input clk
);
    localparam integer ADDR_WIDTH = 32;
    wire [3:0] buttons;
    wire [3:0] leds;
    reg [31:0] count = 32'b0;
    wire reset;

    reg we = 1'b0;
    reg [ADDR_WIDTH-1:0] addr = {ADDR_WIDTH{1'b0}};
    reg [31:0] din = 32'b0;
    wire [31:0] IDATA;
	 wire IDACK;
    wire [31:0] XATAO;
	 wire XDACK;
	 localparam INIT_FILE = "../darkriscv/src/darksocv_padded.mem";

    darkram #(.INIT_FILE(INIT_FILE)) u_bram (
        .CLK    (clk),            
        .RES    (reset),            
        .HLT    (1'b0),            
                                  
        .IDREQ  (1'b0),          
        .IADDR  (0),          
        .IDATA  (IDATA),          
        .IDACK  (IDACK),          
                                  
        .XDREQ  (1'b0),    
        .XRD    (1'b0),            
        .XWR    (1'b0),            
        .XBE    (4'hf),            
        .XADDR  (0),          
        .XATAI  (0),          
        .XATAO  (XATAO),    
        .XDACK  (XDACK)     
    );
    always @(*) begin addr[1:0] = count[1+SHIFT:SHIFT]; addr[ADDR_WIDTH-1:2] = {ADDR_WIDTH-2{1'b0}}; end
    assign leds[2:0] = XATAO[6:4];
    wingbutled_v butled1 ( .io(W1B[7:0]), .buttons(buttons), .leds(leds));
    assign reset = buttons[0];
    assign tx = rx;
    assign leds[3] = (count < 32'd16000000) ? 1'b1 : 1'b0;
    always @(posedge clk or posedge reset) begin
        if (reset) begin count <= 32'b0;
        end else begin
            if (count >= 32'd32000000) begin count <= 32'b0;
            end else begin count <= count + 1; end
        end
    end
endmodule
