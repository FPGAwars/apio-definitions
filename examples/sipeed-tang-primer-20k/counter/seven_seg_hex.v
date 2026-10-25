// Active-high 7-seg patterns, bit0=A .. bit6=G.
module seven_seg_hex (
    input      [3:0] din,
    output reg [6:0] dout
);
  always @* begin
    case (din)
      4'h0: dout = 7'b011_1111;
      4'h1: dout = 7'b000_0110;
      4'h2: dout = 7'b101_1011;
      4'h3: dout = 7'b100_1111;
      4'h4: dout = 7'b110_0110;
      4'h5: dout = 7'b110_1101;
      4'h6: dout = 7'b111_1101;
      4'h7: dout = 7'b000_0111;
      4'h8: dout = 7'b111_1111;
      4'h9: dout = 7'b110_1111;
      default: dout = 7'b100_0000;
    endcase
  end
endmodule
