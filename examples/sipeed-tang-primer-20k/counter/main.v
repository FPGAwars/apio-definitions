//------------------------------------------------------------------
// Two-digit decimal counter 00..99 on both 7-seg digits.
//
// Board : Sipeed Tang Primer 20K Lite (GW2A-LV18PG256C8/I7)
// PMOD  : icebreaker 7-seg display v1.1a, top-right connector
// Clock : 27 MHz on H11
//
// Copyright (c) 2026 Carlos Venegas <carlos@magnitude.es>
// X: @cavearr  github: @cavearr
//
// SPDX-License-Identifier: GPL-3.0-or-later
//
// Mapping and polarity follow the iCEBreaker workshop stopwatch.
//
// PMOD map (Digilent 2x6, looking into the Lite header):
//
//   1 AA T6   2 AB T7   3 AC T8   4 AD T9   5 GND   6 3V3
//   7 AE P6   8 AF R8   9 AG P8  10 CAT P9 11 GND  12 3V3
//
//     tens (CAT=0)      units (CAT=1)
//          AAA               AAA          seven_seg[0] = AA
//         F   B             F   B         seven_seg[1] = AB
//         F   B             F   B         seven_seg[2] = AC
//          GGG               GGG          seven_seg[3] = AD
//         E   C             E   C         seven_seg[4] = AE
//         E   C             E   C         seven_seg[5] = AF
//          DDD               DDD          seven_seg[6] = AG
//                                         seven_seg[7] = CAT
//
// Segments are active-low. CAT multiplexes the two digits.
//------------------------------------------------------------------

module main #(
    parameter integer CLK_HZ = 27_000_000
) (
    input        sys_clk,   // 27MHz clock
    output [6:0] segs_n,    // Segments a to g, active low.
    output       digit_sel  // Digit select. 1 shows the units digit, 0 the tens.
);

  // The display bus, {CAT, AG, AF, AE, AD, AC, AB, AA}.
  wire [7:0] seven_seg;
  assign {digit_sel, segs_n} = seven_seg;

  reg [7:0] value = 0;  // BCD: tens in [7:4], units in [3:0]
  reg [31:0] tick_div = 0;
  reg tick = 0;

  always @(posedge sys_clk) begin
    if (tick_div == (CLK_HZ - 1)) begin
      tick_div <= 0;
      tick <= 1;
    end else begin
      tick_div <= tick_div + 1;
      tick <= 0;
    end

    if (tick) begin
      if (value == 8'h99) value <= 0;
      else if (value[3:0] == 4'h9) value <= {value[7:4] + 4'd1, 4'h0};
      else value <= {value[7:4], value[3:0] + 4'd1};
    end
  end

  seven_seg_ctrl display (
      .sys_clk(sys_clk),
      .din(value),
      .dout(seven_seg)
  );

endmodule
