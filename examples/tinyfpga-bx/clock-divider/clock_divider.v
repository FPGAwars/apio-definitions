// Divides a clock by 4, with two outputs a quarter period apart (0 and
// 90 degrees).
module clock_divider (
    input clock_in,
    output reg clock_div4_0 = 0,
    output reg clock_div4_90 = 0
);

  reg clock_div2 = 0;

  always @(posedge clock_in) begin
    clock_div2 <= ~clock_div2;
  end

  always @(posedge clock_div2) begin
    clock_div4_0 <= ~clock_div4_0;
  end

  always @(negedge clock_div2) begin
    clock_div4_90 <= ~clock_div4_90;
  end

endmodule
