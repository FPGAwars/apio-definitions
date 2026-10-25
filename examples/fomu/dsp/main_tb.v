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

  // The serial data in, driven by the testbench.
  reg  user_1 = 0;

  // The signals driven by the design.
  wire user_2;
  wire usb_dp, usb_dn, usb_pu;

  main dut (
      .sys_clk(sys_clk),
      .user_1 (user_1),
      .user_2 (user_2),
      .usb_dp (usb_dp),
      .usb_dn (usb_dn),
      .usb_pu (usb_pu)
  );

  // A reference model of the design's registers.
  reg [31:0] reg1 = 0;
  reg [31:0] reg2 = 0;
  reg expected = 0;

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // Feed a changing bit pattern, and compare the output with the model
    // after every clock. The USB lines stay low.
    for (i = 0; i < 200; i = i + 1) begin
      user_1 = (i % 3 == 0) ^ (i % 7 == 0);
      @(posedge sys_clk);
      expected = ~^(reg1 * reg2);
      reg2 = {reg2[30:0], reg1[31]};
      reg1 = {reg1[30:0], user_1};
      #1;
      `EXPECT_EQ(user_2, expected)
      `EXPECT_EQ({usb_dp, usb_dn, usb_pu}, 3'b000)
    end

    $display("End of simulation");
    $finish;
  end

endmodule
