// Blinks the blue user LED LED2. The clock comes from the FPGA's internal
// 48MHz oscillator, because the board has no clock for the FPGA.

// N is the counter width. The LED toggles every 2^(N-1) clocks.
// With the default N = 26 and a 48MHz clock, it toggles about
// every 0.7 seconds. The testbench uses a small N to run quickly.
module main #(
    parameter integer N = 26
) (
    output led  // The blinking LED, active high.
);

  // The 48MHz clock from the internal oscillator.
  wire sys_clk;
  hf_osc hf_osc (.clk(sys_clk));

  // The blink counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // The LED follows the counter's top bit.
  assign led = counter[N-1];

endmodule
