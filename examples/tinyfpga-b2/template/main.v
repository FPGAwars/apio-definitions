// Project template for the TinyFPGA B2 board. Start a new design by
// changing this one. It turns on one LED and keeps the USB lines quiet.
module main (
    input  sys_clk,  // 16MHz clock
    output usb_dp,   // USB D+, held low.
    output usb_dn,   // USB D-, held low.
    output led       // An LED wired to pin 13, active high.
);

  // Keep the USB lines quiet, since this design doesn't use USB.
  assign usb_dp = 1'b0;
  assign usb_dn = 1'b0;

  // Turn on the LED.
  assign led = 1'b1;

endmodule
