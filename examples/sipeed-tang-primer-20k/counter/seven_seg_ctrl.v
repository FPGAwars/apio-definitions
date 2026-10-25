// Multiplex the two digits. Patterns are active-high internally, then
// inverted for the PMOD (active-low segments). CAT=1 shows units.
module seven_seg_ctrl (
    input            sys_clk,
    input      [7:0] din,
    output reg [7:0] dout
);
  wire [6:0] tens_digit;
  wire [6:0] units_digit;

  seven_seg_hex tens_nibble (
      .din (din[7:4]),
      .dout(tens_digit)
  );
  seven_seg_hex ones_nibble (
      .din (din[3:0]),
      .dout(units_digit)
  );

  reg [9:0] mux_div = 0;
  reg mux_tick = 0;
  reg show_tens = 0;

  always @(posedge sys_clk) begin
    mux_div   <= mux_div + 1;
    mux_tick  <= &mux_div;
    show_tens <= show_tens ^ mux_tick;

    if (mux_tick) begin
      if (show_tens) begin
        dout[6:0] <= ~tens_digit;
        dout[7]   <= 1'b0;
      end else begin
        dout[6:0] <= ~units_digit;
        dout[7]   <= 1'b1;
      end
    end
  end
endmodule
