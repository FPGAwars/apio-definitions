// Project template for the TinyFPGA BX board. Start a new design by
// changing this one. It turns on one LED and keeps the USB lines quiet.
module main (
    input  sys_clk,  // 16MHz clock
    output usb_pu,   // USB pull-up resistor, active high, held off.
    output led       // Active high.
);

  // Keep the USB lines quiet, since this design doesn't use USB.
  assign usb_pu = 1'b0;

  // Turn on the LED.
  assign led = 1'b1;

endmodule
