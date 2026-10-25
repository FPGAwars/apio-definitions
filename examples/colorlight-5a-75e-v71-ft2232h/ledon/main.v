// Turns on the LED.
module main (
    output led_n  // The LED, active low.
);

  // Turn on the LED.
  wire led = 1'b1;

  // The LED is active low, so invert it.
  assign led_n = ~led;

endmodule
