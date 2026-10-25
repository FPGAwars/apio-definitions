// Blinks the red part of the RGB LED. The clock comes from the FPGA's
// internal 48MHz oscillator, so the design needs no clock pin.

// N is the counter width. The LED toggles every 2^(N-1) clocks.
// With the default N = 26 and a 48MHz clock, it toggles about
// every 0.7 seconds. The testbench uses a small N to run quickly.
module main #(
    parameter integer N = 26
) (
    // The RGB LED pins, active low. [0]=red, [1]=green, [2]=blue.
    output [2:0] rgb_led
);

  // The 48MHz clock from the internal oscillator.
  wire sys_clk;
  hf_osc hf_osc (.clk(sys_clk));

  // The blink counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // Drive the RGB LED. Red follows the counter's top bit, green and blue
  // stay off.
  rgb_driver rgb_driver (
      .on  ({2'b00, counter[N-1]}),
      .pins(rgb_led)
  );

endmodule
