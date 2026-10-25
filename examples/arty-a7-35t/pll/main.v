// Blinks an LED using a 200MHz clock that the PLL generates from
// the board's 100MHz clock.

module main #(
    // Clocks between LED toggles. 33_333_333 toggles the LED 6 times
    // per second with the 200MHz clock. The testbench uses a small
    // value to run quickly.
    parameter integer DIV = 33_333_333
) (
    input      ext_clk,  // 100MHz clock
    output reg led       // The blinking LED, active high.
);

  // The 200MHz main clock, and a flag that is high once the PLL
  // output is stable.
  wire sys_clk;
  wire pll_locked;

  // PLL 100MHz -> 200MHz, in pll.v.
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

endmodule
