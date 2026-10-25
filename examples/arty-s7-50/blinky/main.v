//------------------------------------------------------------------
//-- Blinking LED
//------------------------------------------------------------------

// N is the counter width. leds[3] toggles every 2^(N-1) clocks.
// With the default N = 24 and a 12MHz clock, it toggles about
// every 0.7 seconds. The testbench uses a small N to run quickly.
module main #(
    parameter integer N = 24
) (
    input        sys_clk,  // 12MHz clock
    output [3:0] leds      // leds[3] blinks, the rest are off. Active high.
);

  // The blink counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // leds[3] follows the counter's top bit. The other LEDs are off.
  assign leds = {counter[N-1], 3'b0};

endmodule
