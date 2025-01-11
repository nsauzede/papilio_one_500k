module top #(
    parameter integer SHIFT = 23, // Counter shift to increment the address
    parameter integer BOARD_CK = 32000000,
    parameter INIT_FILE = "../darkriscv/src/darksocv_padded.mem"
) (
    input rx,
    output tx,
    inout [15:0] W1A,
    inout [15:0] W1B,
    inout [15:0] W2C,
    input clk
);
    wire [3:0] buttons;
    wire [3:0] leds;
    wire reset;
    assign reset = buttons[0];
    wingbutled_v butled1 (
        .io(W1B[7:0]),
        .buttons(buttons),
        .leds(leds)
    );
    dut #(.SHIFT(SHIFT), .BOARD_CK(BOARD_CK), .INIT_FILE(INIT_FILE)) dut1 (
        .rx(rx),
        .tx(tx),
        .leds(leds),
        .reset(reset),
        .clk(clk)
    );
endmodule
