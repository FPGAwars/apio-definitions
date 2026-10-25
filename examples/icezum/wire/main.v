// Connects a header pin to an LED, so the LED shows the pin's level.
module main (
    input  gpio,  // Header pin D13.
    output led    // LED0, active high.
);

  // The LED follows the pin.
  assign led = gpio;

endmodule
