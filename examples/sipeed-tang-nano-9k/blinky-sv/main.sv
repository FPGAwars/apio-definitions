//------------------------------------------------------------------
//-- Blinking LED, in SystemVerilog
//------------------------------------------------------------------

// N is the counter width. led toggles every 2^(N-1) clocks.
// With the default N = 25 and a 27MHz clock, it toggles about
// every 0.6 seconds. The testbench uses a small N to run quickly.
module main #(
    parameter integer N = 25
) (
    input sys_clk,  // 27MHz clock
    output logic led  // The blinking LED, active low.
);

  // The blink counter. It starts at 0 when the FPGA is configured.
  logic [N-1:0] counter = 0;

  // Count up on every clock.
  always_ff @(posedge sys_clk) counter <= counter + 1;

  // The LED follows the counter's top bit.
  assign led = counter[N-1];

endmodule
