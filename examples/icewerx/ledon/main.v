// Turns on the red LED.
module main (
    output led_n  // The red LED, active low.
);

  // Turn on the LED.
  wire led = 1'b1;

  // The LED is active low, so invert it.
  assign led_n = ~led;

endmodule
