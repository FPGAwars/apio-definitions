// Turns on all the LEDs of the iCE40-HX8K Breakout board.
module main (
    output [7:0] leds  // Active high.
);

  // Turn on all the LEDs.
  assign leds = {8{1'b1}};

endmodule
