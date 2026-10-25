// Cycles the RGB LED through all the combinations of its three colors.

// N is the counter width. The colors change every 2^(N-3) clocks.
// With the default N = 25 and a 12MHz clock, they change about
// every 0.35 seconds. The testbench uses a small N to run quickly.
module main #(
    parameter integer N = 25
) (
    input        sys_clk,   // 12MHz clock
    output [2:0] rgb_led_n  // RGB LED, active low. [0]=red, [1]=green, [2]=blue.
);

  // The counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // The counter's top 3 bits turn the colors on and off.
  wire [2:0] rgb_led = {counter[N-2], counter[N-1], counter[N-3]};

  // The RGB LED is active low, so invert it.
  assign rgb_led_n = ~rgb_led;

endmodule
