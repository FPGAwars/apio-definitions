// Turns on the green on-board LED. The other LEDs are off.
module main (
    output [1:0] leds_n,    // On-board LEDs, active low. [0]=red, [1]=green.
    output [4:0] pmod_leds  // LEDs on the snap-off PMOD, active high.
);

  // Turn on the green LED and turn off the red one.
  wire [1:0] leds = 2'b10;

  // The on-board LEDs are active low, so invert them.
  assign leds_n = ~leds;

  // Turn off the PMOD LEDs.
  assign pmod_leds = 5'b0;

endmodule
