// Blinks leds[7]. The blink rate comes from the env that apio.ini
// selects, slow or fast.

module main #(
    // Clocks per blink cycle (on and off). The default comes from the
    // macro CLK_DIV that apio.ini defines for each env. The testbench
    // uses a small value to run quickly.
    parameter integer CLK_DIV = `CLK_DIV
) (
    input        sys_clk,  // 12MHz clock
    output [7:0] leds      // leds[7] blinks, the rest are off. Active high.
);

  // The counter counts this many clocks between LED toggles,
  // half a blink cycle.
  localparam integer LIMIT = (CLK_DIV / 2) - 1;

  // The LED state. It starts off.
  reg led = 0;

  // Counts clocks from 0 to LIMIT. It starts at 0 when the FPGA is
  // configured.
  reg [31:0] counter = 0;

  // Count, and toggle the LED state when the count passes LIMIT.
  always @(posedge sys_clk) begin
    if (counter < LIMIT) begin
      counter <= counter + 1;
    end else begin
      counter <= 32'd0;
      led <= ~led;
    end
  end

  // leds[7] shows the LED state. The other LEDs are off.
  assign leds = {led, 7'b0};

endmodule
