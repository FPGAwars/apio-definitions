// Blinks LED0. The clock comes from the FPGA's internal oscillator, because
// the board's 12MHz clock pin works only with jumper JP2 installed.

// N is the counter width. The LED toggles every 2^(N-1) clocks.
// With the default N = 22 and a 2.4MHz clock, it toggles about
// every 0.9 seconds. The testbench uses a small N to run quickly.
module main #(
    parameter integer N = 22
) (
    output led  // The blinking LED, active low.
);

  // The 2.4MHz clock from the internal oscillator.
  wire sys_clk;
  osc osc (.clk(sys_clk));

  // The blink counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // The LED follows the counter's top bit.
  assign led = counter[N-1];

endmodule
