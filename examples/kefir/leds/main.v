// Turns on all the LEDs of the Kéfir I board.
module main (
    output [3:0] leds  // Active high.
);

  // Turn on all the LEDs.
  assign leds = {4{1'b1}};

endmodule
