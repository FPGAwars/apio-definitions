// Hello world example for the Alhambra II board. Turns on
// leds[0] and turns off the other LEDs.

module main (
    output [7:0] leds  // leds[0] is on, the rest are off. Active high.
);

  // leds[0] on, the other LEDs off.
  assign leds = 8'b0000_0001;

endmodule
