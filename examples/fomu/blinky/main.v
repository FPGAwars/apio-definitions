// Blinks the red part of the RGB LED.

// N is the counter width. The LED toggles every 2^(N-1) clocks.
// With the default N = 26 and a 48MHz clock, it toggles about
// every 0.7 seconds. The testbench uses a small N to run quickly.
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
