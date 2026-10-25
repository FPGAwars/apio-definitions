// Blinks two LEDs alternately. This is the example of the Apio
// getting started docs.

module main #(
    // Clocks between LED toggles. The default comes from the macro N
    // that apio.ini defines. The testbench uses a small value to run
    // quickly.
    parameter integer N = `N
) (
    input        sys_clk,  // 12MHz clock
    output [1:0] leds      // The two LEDs, always one on and one off. Active high.
);

  // Counts clocks from 0 to N-1. It starts at 0 when the FPGA is
  // configured.
  reg [31:0] counter = 0;

  // The LED state. Toggles every N clocks.
  reg led = 0;

  // Count, and toggle the LED state when the count reaches N-1.
  always @(posedge sys_clk) begin
    if (counter == N - 1) begin
      counter <= 32'd0;
      led <= ~led;
    end else begin
      counter <= counter + 1;
    end
  end

  // leds[0] shows the LED state and leds[1] its opposite.
  assign leds = {~led, led};

endmodule
