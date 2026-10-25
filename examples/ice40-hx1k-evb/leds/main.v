// Each LED is on while its button is pressed.
module main (
    input  [1:0] btns_n,  // Push buttons, active low.
    output [1:0] leds     // Active high.
);

  // The buttons are active low, so invert them.
  wire [1:0] btns = ~btns_n;

  // Each LED follows its button.
  assign leds = btns;

endmodule
