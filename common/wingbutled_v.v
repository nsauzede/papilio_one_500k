module wingbutled_v (
    inout [7:0] io,
    output [3:0] buttons,
    input [3:0] leds
);
    // Assign LED values to specific io pins
    assign io[0] = leds[3];
    assign io[2] = leds[2];
    assign io[4] = leds[1];
    assign io[6] = leds[0];

    // Set specific io pins to high impedance (Z)
    assign io[1] = 1'bz;
    assign io[3] = 1'bz;
    assign io[5] = 1'bz;
    assign io[7] = 1'bz;

    // Assign io pin values to button outputs
    assign buttons[3] = io[1];
    assign buttons[2] = io[3];
    assign buttons[1] = io[5];
    assign buttons[0] = io[7];
endmodule

