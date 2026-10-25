// Drives the RGB LED through the FPGA's RGB LED driver (SB_RGBA_DRV).
// SB_RGBA_DRV can't be simulated, so simulations use a simple model
// instead.

module rgb_driver (
    input  [2:0] on,   // 1 turns a color on. [0]=red, [1]=green, [2]=blue.
    output [2:0] pins  // The LED pins, active low, in the same order.
);

`ifdef SYNTHESIS

  // The real driver, set to its lowest current. Its outputs RGB0, RGB1
  // and RGB2 are wired to the green, blue and red LEDs.
  SB_RGBA_DRV #(
      .CURRENT_MODE("0b1"),
      .RGB0_CURRENT("0b000001"),
      .RGB1_CURRENT("0b000001"),
      .RGB2_CURRENT("0b000001")
  ) driver (
      .CURREN  (1'b1),
      .RGBLEDEN(1'b1),
      .RGB0PWM (on[1]),
      .RGB1PWM (on[2]),
      .RGB2PWM (on[0]),
      .RGB0    (pins[1]),
      .RGB1    (pins[2]),
      .RGB2    (pins[0])
  );

`else

  // Simulation model: a pin goes low when its color is on.
  assign pins = ~on;

`endif

endmodule
