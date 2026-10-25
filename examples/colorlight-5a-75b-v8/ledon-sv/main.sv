// Turns on the LED.
module main (
    output logic led_n  // The LED, active low.
);

  // Turn on the LED.
  logic led = 1'b1;

  // The LED is active low, so invert it.
  assign led_n = ~led;

endmodule
