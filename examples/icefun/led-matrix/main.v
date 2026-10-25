// Shows changing random patterns on the 4x8 LED matrix.
module main #(
    parameter integer N1        = 5_000,      // clks per col scan
    parameter integer N2        = 6_000_000,  // clks per rnd update
    parameter integer INTENSITY = 0           // Leds intensity, 0-15
) (
    input        sys_clk,  // 12MHz clock
    output [7:0] rows_n,   // LED rows, active low.
    output [3:0] cols_n    // LED columns, active low.
);

  // Running rand value.
  wire [31:0] rnd;

  // Sampled rand to display
  reg  [31:0] sampled_rnd = 0;

  // wire frame_tick;

  rand_gen rand_gen (
      .sys_clk(sys_clk),
      .rnd(rnd)
  );

  led_matrix #(
      .N(N1)
  ) led_matrix (
      .sys_clk(sys_clk),
      .data(sampled_rnd),
      .intensity(INTENSITY[3:0]),
      .frame_tick(),
      .rows_n(rows_n),
      .cols_n(cols_n)
  );

  // Counts clocks from 0 to N2-1.
  reg [31:0] timer = 0;

  // Sample a new random value every N2 clocks.
  always @(posedge sys_clk)
    if (timer == N2 - 1) begin
      timer <= 0;
      sampled_rnd <= rnd;
    end else begin
      timer <= timer + 1;
    end

endmodule


