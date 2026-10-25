//------------------------------------------------------------------
//-- Blinking LED
//------------------------------------------------------------------

// N is the counter width. led toggles every 2^(N-1) clocks.
// With the default N = 24 and a 16MHz clock, it toggles about
// every 0.5 seconds. The testbench uses a small N to run quickly.
module main #(
    parameter integer N = 24
) (
    input  sys_clk,  // 16MHz clock
    output led,      // The blinking LED, active high.
    output usb_pu    // USB pull-up resistor, active high.
);

  // The blink counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // The LED follows the counter's top bit.
  assign led = counter[N-1];

  // Keep the USB pull-up off, since this design doesn't use USB.
  assign usb_pu = 1'b0;

endmodule
