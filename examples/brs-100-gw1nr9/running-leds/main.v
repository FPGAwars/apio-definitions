// Running lights: one of the 6 LEDs is on at a time, and it moves to the
// next LED every DIV clocks.
module main #(
    // Clocks between steps. 4_500_000 makes 6 steps per second with the
    // 27MHz clock. The testbench uses a small value to run quickly.
    parameter integer DIV = 4_500_000
) (
    input        sys_clk,  // 27MHz clock
    output [5:0] leds_n    // Active low.
);

  // Power-on reset: sys_rst is high for the first 3 clocks.
  reg [1:0] rst_cnt = 0;
  wire sys_rst = ~&rst_cnt;
  always @(posedge sys_clk) if (sys_rst) rst_cnt <= rst_cnt + 1;

  // Counts clocks from 0 to DIV-1.
  reg [31:0] counter;

  // The LEDs, one-hot. leds[0] is on after reset.
  reg [ 5:0] leds;

  // Move the lit LED to the next one every DIV clocks.
  always @(posedge sys_clk)
    if (sys_rst) begin
      counter <= 32'd0;
      leds <= 6'b00_0001;
    end else if (counter == DIV - 1) begin
      counter <= 32'd0;
      leds <= {leds[4:0], leds[5]};
    end else begin
      counter <= counter + 1;
    end

  // The LEDs are active low, so invert them.
  assign leds_n = ~leds;

endmodule
