`timescale 1ns / 1ps

module dut_tb;

    // Parameter
    parameter integer SHIFT = 0; // Counter shift to increment the address

    // Inputs
    reg rx = 0;
    reg clk = 0;

    // Bidirectional signals
    wire tx;
    wire [15:0] W1A;
    wire [15:0] W1B;
    wire [15:0] W2C;

    // Internal signals
    reg [3:0] buttons = 0;

    // Clock period
    localparam clk_period = 10;

    // Instantiate the Unit Under Test (UUT)
    dut #(
        .SHIFT(SHIFT) // Counter shift to increment the address
    ) dut1 (
        .rx(rx),
        .tx(tx),
        .W1A(W1A),
        .W1B(W1B),
        .W2C(W2C),
        .clk(clk)
    );

    assign W1B[1] = buttons[3];
    assign W1B[3] = buttons[2];
    assign W1B[5] = buttons[1];
    assign W1B[7] = buttons[0];

    // Clock generation
    initial begin
        forever begin
            clk = 1'b0;
            #(clk_period / 2);
            clk = 1'b1;
            #(clk_period / 2);
        end
    end

    // Stimulus process
    initial begin
        $dumpfile("dut.vcd");
        $dumpvars(0, dut1);
        // Hold reset state for 100 ns
        #100;

        // Insert stimulus
        buttons[0] = 1'b1;
        #(clk_period * 2);
        buttons[0] = 1'b0;

        // Additional stimulus or waiting
        #(clk_period * 10);

        // Wait indefinitely
        $finish;
    end
endmodule

