//------------------------------------------------------------------
// Blinks the top bar (segment A) of the right-hand digit. The board has no
// user LEDs, so this is its blinky.
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
// PMOD map (Digilent 2x6, looking into the Lite header):
//
//   1 AA T6   2 AB T7   3 AC T8   4 AD T9   5 GND   6 3V3
//   7 AE P6   8 AF R8   9 AG P8  10 CAT P9 11 GND  12 3V3
//
//          AAA                 seven_seg[0] = AA (this example blinks it)
//         F   B                seven_seg[1] = AB
//         F   B                seven_seg[2] = AC
//          GGG                 seven_seg[3] = AD
//         E   C                seven_seg[4] = AE
//         E   C                seven_seg[5] = AF
//          DDD                 seven_seg[6] = AG
//                              seven_seg[7] = CAT
//
// Segments are active-low. CAT=1 selects the right-hand digit.
//------------------------------------------------------------------

// N is the counter width. The segment toggles every 2^(N-1) clocks.
// With the default N = 25 and a 27MHz clock, it toggles about
// every 0.6 seconds. The testbench uses a small N to run quickly.
module main #(
    parameter integer N = 25
) (
    input        sys_clk,   // 27MHz clock
    output [6:0] segs_n,    // Segments a to g, active low.
    output       digit_sel  // Digit select. 1 shows the right-hand digit.
);

  // The blink counter. It starts at 0 when the FPGA is configured.
  reg [N-1:0] counter = 0;

  // Count up on every clock.
  always @(posedge sys_clk) counter <= counter + 1;

  // Segment a follows the counter's top bit. The others are off.
  wire [6:0] segs = {6'b00_0000, counter[N-1]};

  // The segments are active low, so invert them.
  assign segs_n = ~segs;

  // Show the right-hand digit.
  assign digit_sel = 1'b1;

endmodule
