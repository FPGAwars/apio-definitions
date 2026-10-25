// A two digit decimal (BCD) counter that counts once per second
// and shows the count on the 8 LEDs. leds[3:0] are the units digit
// and leds[7:4] are the tens digit.

module main #(
    // Clocks per count. 12_000_000 gives one count per second with the
    // 12MHz clock. The testbench uses a small value to run quickly.
    parameter int DIV = 12_000_000
) (
    input  logic       sys_clk,  // 12MHz clock
    output logic [7:0] leds      // The two BCD digits, active high.
);

  // Power-on reset: sys_rst is high for the first 3 clocks.
  logic [1:0] rst_cnt = 0;
  logic sys_rst;
  assign sys_rst = ~&rst_cnt;
  always_ff @(posedge sys_clk) if (sys_rst) rst_cnt <= rst_cnt + 1;

  // Count ticks. Each one is high for one clock and tells the next
  // stage to count.
  logic tick1;  // From the ticker to the units digit.
  logic tick2;  // From the units digit to the tens digit.
  logic tick3;  // From the tens digit. Not used.

  // Ticker. tick1 is high for one clock every DIV clocks.
  ticker #(
      .DIV(DIV)
  ) ticker (
      .sys_clk(sys_clk),
      .sys_rst(sys_rst),
      .tick(tick1)
  );

  // The units digit.
  bcd_digit digit1 (
      .sys_clk(sys_clk),
      .sys_rst(sys_rst),
      .tick_in(tick1),
      .tick_out(tick2),
      .count(leds[3:0])
  );

  // The tens digit.
  bcd_digit digit2 (
      .sys_clk(sys_clk),
      .sys_rst(sys_rst),
      .tick_in(tick2),
      .tick_out(tick3),
      .count(leds[7:4])
  );

endmodule
