// Project template for the Kéfir I board. Start a new design by
// changing this one. It turns on one LED.
module main (
    output led  // Active high.
);

  // Turn on the LED.
  assign led = 1'b1;

endmodule
