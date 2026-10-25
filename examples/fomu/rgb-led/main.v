// Cycles the RGB LED through all the combinations of its three colors.

// N is the counter width. The colors change every 2^(N-3) clocks.
// With the default N = 26 and a 48MHz clock, they change about
// every 0.17 seconds. The testbench uses a small N to run quickly.
module main #(
    parameter integer N = 26
) (
    input        sys_clk,  // 48MHz clock
    // The RGB LED pins, active low. [0]=red, [1]=green, [2]=blue.
    output [2:0] rgb_led,
    output       usb_dp,   // USB D+, held low.
    output       usb_dn,   // USB D-, held low.
    output       usb_pu    // USB D+ pull-up, active high, held off.
);

  // Keep the USB lines low, so the host doesn't try to talk to the board.
  assign usb_dp = 1'b0;
  assign usb_dn = 1'b0;
  assign usb_pu = 1'b0;

  // The counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // The counter's top 3 bits turn the colors on: blue, red and green.
  rgb_driver rgb_driver (
      .on  ({counter[N-1], counter[N-3], counter[N-2]}),
      .pins(rgb_led)
  );

endmodule
