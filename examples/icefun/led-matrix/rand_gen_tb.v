// Testbench for rand_gen.v.
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

module rand_gen_tb;

  // Set to 1 when an assertion fails.
  reg assertion_err = 0;

  // Clock.
  reg sys_clk = 0;
  always #5 sys_clk = ~sys_clk;

  // Number of sys_clk rising edges so far.
  integer clk_num = 0;
  always @(posedge sys_clk) clk_num <= clk_num + 1;

  // The random values driven by the module.
  wire [31:0] rnd;

  rand_gen dut (
      .sys_clk(sys_clk),
      .rnd(rnd)
  );

  // A reference model of the same shift register.
  reg [31:0] expected = ~0;

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, rand_gen_tb);

    // Compare with the model after every clock. The value is never 0.
    for (i = 0; i <= 100; i = i + 1) begin
      if (i > 0) begin
        @(posedge sys_clk);
        expected = {expected[30:0], expected[31] ^ expected[21] ^ expected[1] ^ expected[0]};
      end
      #1;
      `EXPECT_EQ(rnd, expected)
      `EXPECT_EQ(rnd != 0, 1'b1)
    end

    $display("End of simulation");
    $finish;
  end

endmodule
