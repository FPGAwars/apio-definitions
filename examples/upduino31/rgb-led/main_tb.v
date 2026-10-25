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

  // Clock. The design makes its own clock with the oscillator model in
  // hf_osc.v, which has a 10ns period.
  wire sys_clk = dut.sys_clk;

  // Number of sys_clk rising edges so far.
  integer clk_num = 0;
  always @(posedge sys_clk) clk_num <= clk_num + 1;

  // The RGB LED pins driven by the design, active low.
  wire [2:0] rgb_led;

  // A 4 bit counter, so the colors change every 4 clocks.
  main #(.N(4)) dut (.rgb_led(rgb_led));

  // Loop index for the LED checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // After i clocks the counter equals i, and its top 2 bits select red
    // (11), green (10), blue (01) or no color (00), past its wrap.
    for (i = 0; i <= 40; i = i + 1) begin
      if (i > 0) @(posedge sys_clk);
      #1;
      case ((i % 16) >> 2)
        3: `EXPECT_EQ(rgb_led, 3'b110)
        2: `EXPECT_EQ(rgb_led, 3'b101)
        1: `EXPECT_EQ(rgb_led, 3'b011)
        default: `EXPECT_EQ(rgb_led, 3'b111)
      endcase
    end

    $display("End of simulation");
    $finish;
  end


endmodule
