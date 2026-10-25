// An AND gate: the LED is on when both buttons are high.
module main (
    input  logic [1:0] btns,  // Push buttons BTN1 and BTN2, polarity unknown.
    output logic       led    // LED0, active high.
);

  // The LED is the AND of the two buttons.
  assign led = &btns;

endmodule
