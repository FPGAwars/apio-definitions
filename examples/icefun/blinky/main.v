// Blinks two LEDs of the 4x8 LED matrix, taking turns.
module main #(
    parameter integer N = 3_000_000
) (
    input        sys_clk,  // 12MHz clock
    output [7:0] rows_n,   // LED rows, active low.
    output [3:0] cols_n    // LED columns, active low.
);

  reg [31:0] counter = 0;

  reg toggle = 0;

  // Rows and columns are active low.
  assign rows_n = {6'b11_1111, toggle, ~toggle};
  assign cols_n = 4'b1110;

  always @(posedge sys_clk) begin
    if (counter >= N - 1) begin
      counter <= 0;
      toggle  <= !toggle;
    end else begin
      counter <= counter + 1;
    end
  end

endmodule


