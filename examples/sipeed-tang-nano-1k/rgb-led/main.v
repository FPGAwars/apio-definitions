// Rotates the RGB LED through red, blue and green. Button A restarts the
// rotation from red. Adapted from the official Sipeed example at
// https://github.com/sipeed/TangNano-1K-examples/tree/main/example_led

module main #(
    // Clocks per color. 13_500_000 changes the color every 0.5 seconds
    // with the 27MHz clock. The testbench uses a small value to run
    // quickly.
    parameter integer DIV = 13_500_000
) (
    input        sys_clk,   // 27MHz clock
    input        btn_n,     // Button A, active low.
    output [2:0] rgb_led_n  // RGB LED, active low. [0]=red, [1]=green, [2]=blue.
);

  // Pass the button through a two flip-flop synchronizer. They start at
  // 1, released.
  reg [1:0] btn_sync = 2'b11;
  always @(posedge sys_clk) btn_sync <= {btn_sync[0], btn_n};

  // The button is active low, so invert it.
  wire btn = ~btn_sync[1];

  // Power-on reset: sys_rst is high for the first 3 clocks, and again
  // while the button is pressed and for 3 clocks after it.
  reg [1:0] rst_cnt = 0;
  wire sys_rst = ~&rst_cnt;
  always @(posedge sys_clk)
    if (btn) rst_cnt <= 2'd0;
    else if (sys_rst) rst_cnt <= rst_cnt + 1;

  // Counts clocks from 0 to DIV-1.
  reg [31:0] counter;

  // The RGB LED colors, one-hot. Red after reset.
  reg [ 2:0] rgb_led;

  // Move to the next color, red -> blue -> green, every DIV clocks.
  always @(posedge sys_clk)
    if (sys_rst) begin
      counter <= 32'd0;
      rgb_led <= 3'b001;
    end else if (counter == DIV - 1) begin
      counter <= 32'd0;
      rgb_led <= {rgb_led[0], rgb_led[2:1]};
    end else begin
      counter <= counter + 1;
    end

  // The RGB LED is active low, so invert it.
  assign rgb_led_n = ~rgb_led;

endmodule
