// Testbench for main.v.
// Run it in batch mode with 'apio test', or view the signals
// in GTKWave with 'apio sim'.

// Checks that 'actual_val' equals 'expected_val'. On a mismatch, prints
// the values and location, sets assertion_err, and stops the simulation.
// Under 'apio sim' the simulation continues so the signals can be viewed.
`define EXPECT_EQ(actual_val, expected_val) \
  if ((actual_val) !== (expected_val)) begin \
    $display("*** ASSERTION FAILED at %s:%0d: expected 'h%h, actual 'h%h", \
             `__FILE__, `__LINE__, (expected_val), (actual_val)); \
    assertion_err = 1; \
    if (!`APIO_SIM) $fatal; \
  end

`timescale 1ns / 1ps

module main_tb;

  // Set to 1 when an assertion fails.
  reg assertion_err = 0;

  // Clock.
  reg sys_clk = 0;
  always #5 sys_clk = ~sys_clk;

  // Number of sys_clk rising edges so far.
  integer clk_num = 0;
  always @(posedge sys_clk) clk_num <= clk_num + 1;

  // The display pins driven by the design.
  wire [6:0] segs_n;
  wire digit_sel;

  // A count every 2 clocks, to run quickly.
  localparam integer CLK_HZ = 2;

  main #(
      .CLK_HZ(CLK_HZ)
  ) dut (
      .sys_clk(sys_clk),
      .segs_n(segs_n),
      .digit_sel(digit_sel)
  );

  // The segments a to g for a decimal digit, as in seven_seg_hex.v.
  function [6:0] segs_of(input [3:0] digit);
    case (digit)
      4'h0: segs_of = 7'b011_1111;
      4'h1: segs_of = 7'b000_0110;
      4'h2: segs_of = 7'b101_1011;
      4'h3: segs_of = 7'b100_1111;
      4'h4: segs_of = 7'b110_0110;
      4'h5: segs_of = 7'b110_1101;
      4'h6: segs_of = 7'b111_1101;
      4'h7: segs_of = 7'b000_0111;
      4'h8: segs_of = 7'b111_1111;
      default: segs_of = 7'b110_1111;
    endcase
  endfunction

  // The count as two BCD digits.
  function [7:0] bcd(input integer n);
    integer tens, ones;
    begin
      tens = n / 10;
      ones = n % 10;
      bcd  = {tens[3:0], ones[3:0]};
    end
  endfunction

  // What the display should show. The display controller loads a new
  // digit when its mux_tick is high, from the values before that clock.
  reg [7:0] expected_display;
  reg displayed = 0;
  always @(posedge sys_clk)
    if (dut.display.mux_tick) begin
      expected_display <= dut.display.show_tens ? {1'b0, ~segs_of(
          dut.value[7:4]
      )} : {1'b1, ~segs_of(
          dut.value[3:0]
      )};
      displayed <= 1;
    end

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // The count goes up every CLK_HZ clocks, the first time at clock
    // CLK_HZ + 1, and wraps from 99 to 00. Once the display has loaded
    // its first digit, it always shows the expected one.
    for (i = 0; i <= 5000; i = i + 1) begin
      if (i > 0) @(posedge sys_clk);
      #1;
      `EXPECT_EQ(dut.value, bcd(i > 0 ? ((i - 1) /CLK_HZ) % 100 : 0))
      if (displayed) `EXPECT_EQ({digit_sel, segs_n}, expected_display)
    end

    $display("End of simulation");
    $finish;
  end

endmodule
