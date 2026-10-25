// Turns on LED 0 and turns off the others.
module main (
    output [7:0] leds  // Active high.
);

  // Turn on leds[0] only.
  assign leds = 8'b0000_0001;

endmodule
