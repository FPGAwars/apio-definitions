// Blinks an LED. apio.ini builds it for two boards with different
// clocks, each at a slow and a fast blink rate.

module main #(
    // Clocks per blink cycle (on and off). The default comes from the
    // macro CLKS_PER_CYCLE that apio.ini defines for each env. The
    // testbench uses a small value to run quickly.
    parameter integer CLKS_PER_CYCLE = `CLKS_PER_CYCLE
) (
    input  sys_clk,  // 12MHz (Alhambra II) or 27MHz (Tang Nano 9K) clock
    output led       // The blinking LED. Active high on Alhambra II, low on Tang Nano 9K.
);

  // The counter counts this many clocks between LED toggles,
  // half a blink cycle.
  localparam integer LIMIT = (CLKS_PER_CYCLE / 2) - 1;

  // Counts clocks from 0 to LIMIT. It starts at 0 when the FPGA is
  // configured.
  reg [31:0] counter = 0;

  // The LED state. It starts off.
  reg led_state = 0;

  // Count, and toggle the LED state when the count passes LIMIT.
  always @(posedge sys_clk) begin
    if (counter < LIMIT) begin
      counter <= counter + 1;
    end else begin
      counter   <= 32'd0;
      led_state <= ~led_state;
    end
  end

  // Drive the LED.
  assign led = led_state;

endmodule
