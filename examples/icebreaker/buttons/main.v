// The on-board button switches the on-board LED from green to red, and
// each button on the snap-off PMOD turns on one of its LEDs.
module main (
    input        btn_n,     // On-board button, active low.
    input  [2:0] btns,      // Buttons on the snap-off PMOD, active high.
    output [1:0] leds_n,    // On-board LEDs, active low. [0]=red, [1]=green.
    output [2:0] pmod_leds  // LEDs on the snap-off PMOD, active high.
);

  // The on-board button is active low, so invert it.
  wire btn = ~btn_n;

  // Red while the button is pressed, green while it isn't.
  wire [1:0] leds = {~btn, btn};

  // The on-board LEDs are active low, so invert them.
  assign leds_n = ~leds;

  // Each PMOD LED follows its button.
  assign pmod_leds = btns;

endmodule
