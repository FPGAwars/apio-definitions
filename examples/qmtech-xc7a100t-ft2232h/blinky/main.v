//------------------------------------------------------------------
//-- Blinking LED
//------------------------------------------------------------------

// N is the counter width. leds_n[1] toggles every 2^(N-1) clocks.
// With the default N = 26 and a 50MHz clock, it toggles about
// every 0.7 seconds. The testbench uses a small N to run quickly.
module main #(
    parameter integer N = 26
) (
    input        sys_clk,  // 50MHz clock
    output [1:0] leds_n    // leds_n[1] blinks, the rest are off. Active low.
);

  // The blink counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // leds[1] follows the counter's top bit. The other LEDs are off.
  wire [1:0] leds = {counter[N-1], 1'b0};

  // The LEDs are active low, so invert them.
  assign leds_n = ~leds;

endmodule
