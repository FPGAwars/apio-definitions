// Flashes SOS in Morse code on the LED, over and over.

// N is the counter width. The pattern has 32 steps, and each step
// lasts 2^(N-5) clocks. With the default N = 26 and a 16MHz clock, a
// step lasts about 0.13 seconds. The testbench uses a small N to run
// quickly.
module main #(
    parameter integer N = 26
) (
    input  sys_clk,  // 16MHz clock
    output led,      // User/boot LED next to the power LED, active high.
    output usb_pu    // USB pull-up resistor, active high.
);

  // Keep the USB pull-up off, since this design doesn't use USB.
  assign usb_pu = 1'b0;

  // SOS in Morse code, one bit per step, read from bit 0 up. 1 is on.
  localparam [31:0] PATTERN = 32'b0000_0101_0100_0111_0111_0111_0001_0101;

  // The step counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // The counter's top 5 bits select the step in the pattern.
  assign led = PATTERN[counter[N-1:N-5]];

endmodule
