// Turns the RGB LED green.
module main (
    output [2:0] rgb_led_n  // RGB LED, active low. [0]=red, [1]=green, [2]=blue.
);

  // Turn on green only.
  wire [2:0] rgb_led = 3'b010;

  // The RGB LED is active low, so invert it.
  assign rgb_led_n = ~rgb_led;

endmodule
