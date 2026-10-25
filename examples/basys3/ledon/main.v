// Turns on LED 15 and turns off the others.
module main (
    output [15:0] leds  // Active high.
);

  // Turn on leds[15] only.
  assign leds = 16'h8000;

endmodule
