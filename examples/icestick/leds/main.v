// Turns on all the LEDs of the iCEstick board.
module main (
    output [4:0] leds  // Active high.
);

  // Turn on all the LEDs.
  assign leds = {5{1'b1}};

endmodule
