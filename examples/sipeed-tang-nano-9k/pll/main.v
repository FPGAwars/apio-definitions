// Blinks an LED using a 75MHz clock that the PLL generates from
// the board's 27MHz clock.

module main #(
    // Clocks between LED toggles. 12_500_000 toggles the LED 6 times
    // per second with the 75MHz clock. The testbench uses a small
    // value to run quickly.
    parameter integer DIV = 12_500_000
) (
    input  ext_clk,  // 27MHz clock
    output led_n     // The blinking LED, active low.
);

  // The 75MHz main clock, and a flag that is high once the PLL
  // output is stable.
  wire sys_clk;
  wire pll_locked;

  // PLL 27MHz -> 75MHz, in pll.v.
  pll pll (
      .clock_in(ext_clk),
      .clock_out(sys_clk),
      .locked(pll_locked)
  );

  // Power-on reset: sys_rst is high until the PLL is locked and
  // for 3 more clocks.
  reg [1:0] rst_cnt = 0;
  wire sys_rst = ~&rst_cnt;
  always @(posedge sys_clk)
    if (!pll_locked) rst_cnt <= 2'd0;
    else if (sys_rst) rst_cnt <= rst_cnt + 1;

  // The LED, before inverting it for the active-low pin.
  reg led;

  // Counts clocks from 0 to DIV-1.
  reg [31:0] counter;

  // Toggle the LED every DIV clocks. The LED is on after reset.
  always @(posedge sys_clk)
    if (sys_rst) begin
      counter <= 32'd0;
      led <= 1'b1;
    end else if (counter == DIV - 1) begin
      counter <= 32'd0;
      led <= ~led;
    end else begin
      counter <= counter + 1;
    end

  // The LED is active low, so invert it.
  assign led_n = ~led;

endmodule
