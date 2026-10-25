//------------------------------------------------------------------
//-- Blinking LED
//------------------------------------------------------------------

// N is the counter width. leds[7] toggles every 2^(N-1) clocks.
// With the default N = 25 and a 25MHz clock, it toggles about
// every 0.7 seconds. The testbench uses a small N to run quickly.
module main #(
    parameter integer N = 25
) (
    input        sys_clk,    // 25MHz clock
    output [7:0] leds,       // Active high. leds[7] blinks, the rest are off.
    output       wifi_gpio0  // Held high, see below.
);

  // Keep the ESP32's GPIO0 high, so it doesn't reset the board.
  assign wifi_gpio0 = 1'b1;

  // The blink counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // leds[7] follows the counter's top bit. The other LEDs are off.
  assign leds = {counter[N-1], 7'b0};

endmodule
