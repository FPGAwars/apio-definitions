// Turns on all the LEDs of the IceZUM Alhambra board.
module main (
    output [7:0] leds  // Active high.
);

  // Turn on all the LEDs.
  assign leds = {8{1'b1}};

endmodule
