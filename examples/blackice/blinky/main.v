//------------------------------------------------------------------
//-- Blinking LED
//------------------------------------------------------------------

// N is the counter width. led toggles every 2^(N-1) clocks.
// With the default N = 27 and a 100MHz clock, it toggles about
// every 0.7 seconds. The testbench uses a small N to run quickly.
module main #(
    parameter integer N = 27
) (
    input  sys_clk,  // 100MHz clock
    output led       // The blinking LED, polarity unknown.
);

  // The blink counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // The LED follows the counter's top bit.
  assign led = counter[N-1];

endmodule
