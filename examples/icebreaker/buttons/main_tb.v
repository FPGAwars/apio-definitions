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

  // Clock. The design has no clock, it only paces the checks.
  reg sys_clk = 0;
  always #5 sys_clk = ~sys_clk;

  // Number of sys_clk rising edges so far.
  integer clk_num = 0;
  always @(posedge sys_clk) clk_num <= clk_num + 1;

  // The buttons, driven by the testbench.
  reg btn_n = 1;
  reg [2:0] btns = 3'b000;

  // The LEDs driven by the design.
  wire [1:0] leds_n;
  wire [2:0] pmod_leds;

  main dut (
      .btn_n(btn_n),
      .btns(btns),
      .leds_n(leds_n),
      .pmod_leds(pmod_leds)
  );

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // Try every combination of the 4 buttons, one per clock.
    for (i = 0; i < 16; i = i + 1) begin
      @(posedge sys_clk);
      #1;
      btn_n = ~i[3];
      btns  = i[2:0];
      #1;
      // Pressed: red on (leds_n = 2'b10). Released: green on (2'b01).
      `EXPECT_EQ(leds_n, i[3] ? 2'b10 : 2'b01)
      `EXPECT_EQ(pmod_leds, i[2:0])
    end

    $display("End of simulation");
    $finish;
  end

endmodule
