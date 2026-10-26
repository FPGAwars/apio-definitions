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

  // The buzzers driven by the design.
  wire [1:0] buzzers;

  // Short notes and note periods, to run quickly. DUR = 4 makes each note
  // last 4 clocks.
  main #(
      .N0 (4),
      .N1 (3),
      .N2 (2),
      .DUR(4)
  ) dut (
      .sys_clk(sys_clk),
      .buzzers(buzzers)
  );

  // Loop index for the checks.
  integer i;

  // The expected note index. Compared through [5:0], to match the
  // signal's width.
  integer expected;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // The first voice moves to its next note every 4 clocks, the first
    // time at clock 3. Its first notes are DO, RE, MI, DO and a rest, played
    // by channels 0, 1, 2, 0 and none.
    for (i = 0; i <= 40; i = i + 1) begin
      if (i > 0) @(posedge sys_clk);
      #1;
      expected = ((i + 1) / 4) % 64;
      `EXPECT_EQ(dut.sel, expected[5:0])
      // The output logic first runs at the first clock, so skip clock 0.
      if (i > 0)
        case (dut.sel)
          0: `EXPECT_EQ(buzzers[0], dut.ch0)
          1: `EXPECT_EQ(buzzers[0], dut.ch1)
          2: `EXPECT_EQ(buzzers[0], dut.ch2)
          3: `EXPECT_EQ(buzzers[0], dut.ch0)
          4: `EXPECT_EQ(buzzers[0], 1'b0)
          default: ;
        endcase
    end

    $display("End of simulation");
    $finish;
  end

endmodule
